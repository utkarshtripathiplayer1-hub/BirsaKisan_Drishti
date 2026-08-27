import os
import uuid
import logging

from fastapi import (
    APIRouter,
    UploadFile,
    File,
    HTTPException,
    Depends,
)

from fastapi.responses import FileResponse

from core.dependencies import get_current_user

from schemas.voice_schema import (
    VoiceResponse,
    VoiceChatResponse,
)

from services.stt_service import speech_to_text
from services.chat_service import (
    ChatServiceError,
    chat_service,
)
from services.conversation_service import (
    create_conversation,
    get_conversation_by_id,
    update_conversation_timestamp,
)
from services.message_service import (
    get_recent_messages,
    save_user_message,
    save_ai_message,
)
from services.tts_service import text_to_speech


logger = logging.getLogger("ai_core.voice")


router = APIRouter(
    prefix="/voice",
    tags=["Voice"],
)


# ============================================================
# Speech To Text
# ============================================================

@router.post(
    "/stt",
    response_model=VoiceResponse,
)
async def transcribe_audio(
    audio: UploadFile = File(...),
    current_user=Depends(get_current_user),
):
    temp_path = f"/tmp/{uuid.uuid4().hex}_{audio.filename}"

    try:
        with open(temp_path, "wb") as buffer:
            buffer.write(await audio.read())

        stt_result = speech_to_text(temp_path)

        if not stt_result:
            raise HTTPException(
                status_code=500,
                detail="Speech transcription failed.",
            )

        return VoiceResponse(
            transcript=stt_result["transcript"]
        )

    except HTTPException:
        raise

    except Exception as exc:
        logger.exception(
            "STT failed: %s",
            exc,
        )

        raise HTTPException(
            status_code=500,
            detail="Speech transcription failed.",
        ) from exc

    finally:
        if os.path.exists(temp_path):
            os.remove(temp_path)


# ============================================================
# Voice Chat
# ============================================================

@router.post(
    "/chat",
    response_model=VoiceChatResponse,
)
async def voice_chat(
    audio: UploadFile = File(...),
    conversation_id: str | None = None,
    current_user=Depends(get_current_user),
):
    """
    Voice chatbot.

    Flow:

        Audio
          ↓
        STT
          ↓
        Existing chat_service.prepare_chat()
          ↓
        Language detection
          ↓
        Domain + intent
          ↓
        Existing chat_service.chat()
          ↓
        Bhashini translation
          ↓
        Save conversation
          ↓
        Return text response
    """

    user_id = str(
        current_user["_id"]
    )

    preferred_language = current_user.get(
        "preferred_language",
        "en",
    )

    temp_path = f"/tmp/{uuid.uuid4().hex}_{audio.filename}"

    try:

        # ----------------------------------------------------
        # 1. Save audio temporarily
        # ----------------------------------------------------

        with open(temp_path, "wb") as buffer:
            buffer.write(await audio.read())

        # ----------------------------------------------------
        # 2. Speech → Text
        # ----------------------------------------------------

        stt_result = speech_to_text(
            temp_path
        )

        if not stt_result:
            raise HTTPException(
                status_code=500,
                detail="Speech transcription failed.",
            )

        transcript = stt_result.get(
            "transcript",
            "",
        )

        if not transcript.strip():
            raise HTTPException(
                status_code=400,
                detail="Could not understand the audio.",
            )

        logger.info(
            "Voice transcript | user=%s | text=%s",
            user_id,
            transcript[:100],
        )

        # ----------------------------------------------------
        # 3. Prepare chatbot message
        #
        # This uses your existing language detection layer.
        # ----------------------------------------------------

        prepared = await chat_service.prepare_chat(
            message=transcript,
            language=preferred_language,
        )

        domain = prepared["domain"]
        intent = prepared["intent"]

        logger.info(
            "Voice routing | user=%s | domain=%s | intent=%s",
            user_id,
            domain,
            intent,
        )

        # ----------------------------------------------------
        # 4. Create/load conversation
        # ----------------------------------------------------

        if conversation_id:

            conversation = await get_conversation_by_id(
                conversation_id=conversation_id,
                user_id=user_id,
            )

            if conversation is None:
                raise HTTPException(
                    status_code=404,
                    detail="Conversation not found.",
                )

            conversation_id = conversation[
                "conversation_id"
            ]

        else:

            conversation = await create_conversation(
                user_id=user_id,
                domain=domain,
                language=prepared["language"],
                first_message=transcript,
            )

            conversation_id = conversation[
                "conversation_id"
            ]

        # ----------------------------------------------------
        # 5. Previous conversation
        # ----------------------------------------------------

        previous_messages = await get_recent_messages(
            conversation_id=conversation_id,
            limit=10,
        )

        # ----------------------------------------------------
        # 6. Generate chatbot response
        #
        # IMPORTANT:
        # Reuse the SAME chatbot pipeline as text chat.
        # ----------------------------------------------------

        result = await chat_service.chat(
            message=transcript,

            language=preferred_language,

            user_id=user_id,

            conversation_history=previous_messages,

            prepared=prepared,

            latitude=None,
            longitude=None,
        )

        # ----------------------------------------------------
        # 7. Save user message
        # ----------------------------------------------------

        await save_user_message(
            conversation_id=conversation_id,

            original_text=transcript,

            english_text=result[
                "english_message"
            ],

            language=result[
                "language"
            ],
        )

        # ----------------------------------------------------
        # 8. Save AI response
        # ----------------------------------------------------

        await save_ai_message(
            conversation_id=conversation_id,

            original_text=result[
                "response"
            ],

            english_text=result[
                "english_response"
            ],

            language=result[
                "language"
            ],
        )

        # ----------------------------------------------------
        # 9. Update conversation
        # ----------------------------------------------------

        await update_conversation_timestamp(
            conversation_id
        )

        # ----------------------------------------------------
        # 10. Return response
        # ----------------------------------------------------

        return VoiceChatResponse(
            conversation_id=conversation_id,

            transcript=transcript,

            response=result[
                "response"
            ],
        )

    except HTTPException:
        raise

    except ChatServiceError as exc:

        logger.warning(
            "Voice chat service error: %s",
            exc,
        )

        raise HTTPException(
            status_code=503,
            detail=str(exc),
        ) from exc

    except Exception as exc:

        logger.exception(
            "Voice chat failed: %s",
            exc,
        )

        raise HTTPException(
            status_code=500,
            detail="Unable to process voice message.",
        ) from exc

    finally:

        if os.path.exists(temp_path):
            os.remove(temp_path)


# ============================================================
# Text To Speech
# ============================================================

@router.post(
    "/tts"
)
async def generate_tts(
    text: str,
    current_user=Depends(get_current_user),
):
    """
    Convert chatbot response into speech.

    Uses the authenticated user's preferred language.
    """

    if not text.strip():
        raise HTTPException(
            status_code=400,
            detail="Text cannot be empty.",
        )

    language = current_user.get(
        "preferred_language",
        "en",
    )

    output_file = (
        f"/tmp/speech_{uuid.uuid4().hex}.wav"
    )

    try:

        text_to_speech(
            text=text,
            language=language,
            output_file=output_file,
        )

        if not os.path.exists(output_file):
            raise HTTPException(
                status_code=500,
                detail="Text-to-speech generation failed.",
            )

        return FileResponse(
            path=output_file,
            media_type="audio/wav",
            filename="response.wav",
        )

    except HTTPException:
        raise

    except Exception as exc:

        logger.exception(
            "TTS failed: %s",
            exc,
        )

        raise HTTPException(
            status_code=500,
            detail="Text-to-speech generation failed.",
        ) from exc