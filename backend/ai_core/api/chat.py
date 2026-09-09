from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

from services.groq_service import GroqService
from services.language_service import LanguageService


router = APIRouter(
    prefix="/api/chat",
    tags=["Chat"],
)


groq_service = GroqService()
language_service = LanguageService()


# ============================================================
# REQUEST MODEL
# ============================================================


class TextChatRequest(BaseModel):
    text: str


# ============================================================
# TEXT → TEXT
# ============================================================


@router.post("/text")
async def text_chat(
    request: TextChatRequest,
):
    """
    Text → Text

    Language is detected automatically.

    Request:

    {
        "text": "मेरी फसल में बीमारी है"
    }

    Response:

    {
        "success": true,
        "detected_language": "hi",
        "user_text": "मेरी फसल में बीमारी है",
        "ai_response": "..."
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
        # Detect language
        # ----------------------------------------------------

        detected_language = (
            language_service.detect_language(
                request.text
            )
        )

        # ----------------------------------------------------
        # Generate AI response
        # ----------------------------------------------------

        ai_response = await groq_service.generate_response(
            user_text=request.text,
            response_language=detected_language,
        )

        # ----------------------------------------------------
        # Return response
        # ----------------------------------------------------

        return {
            "success": True,
            "detected_language": detected_language,
            "user_text": request.text,
            "ai_response": ai_response,
        }

    except HTTPException:
        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )