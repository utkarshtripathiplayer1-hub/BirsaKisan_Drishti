import base64

from fastapi import (
    APIRouter,
    HTTPException,
    UploadFile,
    File,
    Depends,
)

from fastapi.responses import StreamingResponse
from pydantic import BaseModel

from core.dependencies import get_current_user

from services.bhashini_service import BhashiniService
from services.voice_service import VoiceService


router = APIRouter(
    prefix="/api/voice",
    tags=["Voice"],
)

bhashini_service = BhashiniService()
voice_service = VoiceService()


# ============================================================
# REQUEST MODEL — TEXT TO VOICE
# ============================================================


class TextToVoiceRequest(BaseModel):
    text: str
    language: str = "hi"
    gender: str = "female"
    speed: float = 1.0
    sampling_rate: int = 22050


# ============================================================
# TEXT → VOICE
# ============================================================


@router.post("/text-to-voice")
async def text_to_voice(
    request: TextToVoiceRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Authenticated Text → Voice

    Authorization:
        Bearer <JWT>

    Request:
    {
        "text": "आपकी फसल में कौन सी बीमारी है?",
        "language": "hi",
        "gender": "female",
        "speed": 1.0,
        "sampling_rate": 22050
    }
    """

    try:

        # ----------------------------------------------------
        # Validate text
        # ----------------------------------------------------

        if not request.text.strip():
            raise HTTPException(
                status_code=400,
                detail="Text cannot be empty",
            )

        # ----------------------------------------------------
        # Bhashini TTS
        # ----------------------------------------------------

        result = await bhashini_service.text_to_speech(
            text=request.text,
            language=request.language,
            gender=request.gender,
            speed=request.speed,
            sampling_rate=request.sampling_rate,
        )

        # ----------------------------------------------------
        # Extract audio
        # ----------------------------------------------------

        audio_bytes = (
            bhashini_service.extract_tts_audio(
                result
            )
        )

        if not audio_bytes:
            raise RuntimeError(
                "Bhashini returned empty audio"
            )

        # ----------------------------------------------------
        # Base64
        # ----------------------------------------------------

        audio_base64 = base64.b64encode(
            audio_bytes
        ).decode("utf-8")

        return {
            "success": True,
            "user_id": str(current_user["_id"]),
            "question": request.text,
            "language": request.language,
            "gender": request.gender,
            "speed": request.speed,
            "sampling_rate": request.sampling_rate,
            "audio_base64": audio_base64,
        }

    except HTTPException:
        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# VOICE → VOICE
# ============================================================


@router.post("/chat")
async def voice_chat(
    audio: UploadFile = File(...),
    current_user: dict = Depends(get_current_user),
):
    """
    Authenticated Voice → Voice

    Flow:

        Farmer Voice
             ↓
        Bhashini ASR
             ↓
        Language Detection
             ↓
        Qwen / Groq
             ↓
        Bhashini TTS
             ↓
        Audio

    Flutter sends:

        Authorization: Bearer <JWT>

        audio = WAV file

    No language parameter is required.
    """

    try:

        # ====================================================
        # VALIDATE FILE
        # ====================================================

        if not audio:
            raise HTTPException(
                status_code=400,
                detail="Audio file is required",
            )

        # ====================================================
        # READ AUDIO
        # ====================================================

        audio_bytes = await audio.read()

        if not audio_bytes:
            raise HTTPException(
                status_code=400,
                detail="Audio file is empty",
            )

        # ====================================================
        # AUDIO → BASE64
        # ====================================================

        audio_base64 = base64.b64encode(
            audio_bytes
        ).decode("utf-8")

        # ====================================================
        # COMPLETE VOICE PIPELINE
        # ====================================================

        result = await voice_service.process_voice(
            audio_base64=audio_base64,
        )

        # ====================================================
        # RESPONSE AUDIO
        # ====================================================

        response_audio = result.get("audio")

        if not response_audio:
            raise RuntimeError(
                "Voice service returned empty audio"
            )

        # ====================================================
        # RETURN WAV
        # ====================================================

        return StreamingResponse(
            iter([response_audio]),
            media_type="audio/wav",
            headers={
                "Content-Disposition": (
                    "inline; "
                    "filename=birsa_kisan_response.wav"
                )
            },
        )

    except HTTPException:
        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )