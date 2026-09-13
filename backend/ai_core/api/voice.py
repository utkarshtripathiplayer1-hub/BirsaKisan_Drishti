import base64

from fastapi import (
    APIRouter,
    Depends,
    File,
    HTTPException,
    UploadFile,
)

from core.dependencies import get_current_user
from services.voice_service import VoiceService


router = APIRouter(
    prefix="/api/voice",
    tags=["Voice"],
)

voice_service = VoiceService()


@router.post("/chat")
async def voice_chat(
    audio: UploadFile = File(...),
    conversation_id: str | None = None,
    current_user: dict = Depends(get_current_user),
):

    try:

        user_id = str(current_user["_id"])

        audio_bytes = await audio.read()

        if not audio_bytes:
            raise HTTPException(
                status_code=400,
                detail="Audio file is empty",
            )

        print(
            f"Voice upload: "
            f"filename={audio.filename}, "
            f"type={audio.content_type}, "
            f"size={len(audio_bytes)}"
        )

        audio_base64 = base64.b64encode(
            audio_bytes
        ).decode("utf-8")

        result = await voice_service.process_voice(
            audio_base64=audio_base64,
            conversation_id=conversation_id,
            user_id=user_id,
        )

        return {
            "success": True,
            **result,
        }

    except HTTPException:
        raise

    except ValueError as e:
        raise HTTPException(
            status_code=400,
            detail=str(e),
        )

    except Exception as e:

        print(f"VOICE ERROR: {e}")

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )