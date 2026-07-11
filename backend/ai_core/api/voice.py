import os

from fastapi import (
    APIRouter,
    UploadFile,
    File,
    HTTPException,
    Depends
)

from fastapi.responses import FileResponse

from core.dependencies import get_current_user

from schemas.voice_schema import (
    VoiceResponse,
    VoiceChatResponse
)

from services.stt_service import speech_to_text
from services.chat_service import process_chat
from fastapi import Depends
from fastapi.responses import FileResponse

from services.tts_service import text_to_speech
from fastapi.responses import FileResponse

router = APIRouter(
    prefix="/voice",
    tags=["Voice"],
    dependencies=[Depends(get_current_user)]
)


@router.post(
    "/stt",
    response_model=VoiceResponse
)
async def transcribe_audio(
    audio: UploadFile = File(...),
    current_user=Depends(get_current_user)
):
    try:
        temp_path = f"temp_{audio.filename}"

        with open(temp_path, "wb") as buffer:
            buffer.write(await audio.read())

        transcript = speech_to_text(temp_path)

        if os.path.exists(temp_path):
            os.remove(temp_path)

        if transcript is None:
            raise HTTPException(
                status_code=500,
                detail="Speech transcription failed"
            )

        return VoiceResponse(
            transcript=transcript
        )

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )


@router.post(
    "/chat",
    response_model=VoiceChatResponse
)
async def voice_chat(
    audio: UploadFile = File(...),
    domain: str = "crop",
    conversation_id: str | None = None,
    current_user=Depends(get_current_user)
):
    try:
        user_id = str(current_user["_id"])
        language = current_user["preferred_language"]

        temp_path = f"temp_{audio.filename}"

        with open(temp_path, "wb") as buffer:
            buffer.write(await audio.read())

        transcript = speech_to_text(temp_path)

        if os.path.exists(temp_path):
            os.remove(temp_path)

        if transcript is None:
            raise HTTPException(
                status_code=500,
                detail="Speech transcription failed"
            )

        result = await process_chat(
            user_id=user_id,
            domain=domain,
            language=language,
            query=transcript,
            conversation_id=conversation_id
        )

        return VoiceChatResponse(
            conversation_id=result["conversation_id"],
            transcript=transcript,
            response=result["response"]
        )

    except Exception as e:
        raise HTTPException(
            status_code=500,
            detail=str(e)
        )




@router.post("/tts")
async def generate_tts(
    text: str,
    current_user=Depends(get_current_user)
):
    try:

        language = current_user.get(
            "preferred_language",
            "en"
        )

        output_file = f"speech_{language}.wav"

        text_to_speech(
            text=text,
            language=language,
            output_file=output_file
        )

        return FileResponse(
            path=output_file,
            media_type="audio/wav",
            filename="response.wav"
        )

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e)
        )