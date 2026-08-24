import logging
from typing import Any, Optional

from fastapi import APIRouter, Depends, HTTPException, status
from pydantic import BaseModel, Field

from core.dependencies import get_current_user

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


logger = logging.getLogger("ai_core.chat_api")


router = APIRouter(
    prefix="/chat",
    tags=["chat"],
)


# ============================================================
# Request Schema
# ============================================================

class ChatRequest(BaseModel):
    """
    Main chatbot request.

    The frontend sends:
    - message
    - preferred language
    - optional conversation ID
    - optional crop/disease context
    - optional location for weather
    """

    message: str = Field(
        ...,
        min_length=1,
        max_length=5000,
    )

    language: str = Field(
        default="en",
        min_length=2,
        max_length=10,
    )

    conversation_id: Optional[str] = None

    # --------------------------------------------------------
    # Application context
    # --------------------------------------------------------

    crop_recommendation: Optional[
        dict[str, Any]
    ] = None

    disease_detection: Optional[
        dict[str, Any]
    ] = None

    crop_profile: Optional[
        dict[str, Any]
    ] = None

    # --------------------------------------------------------
    # Location for current weather
    # --------------------------------------------------------

    latitude: Optional[float] = Field(
        default=None,
        ge=-90,
        le=90,
    )

    longitude: Optional[float] = Field(
        default=None,
        ge=-180,
        le=180,
    )


# ============================================================
# Response Schema
# ============================================================

class ChatResponse(BaseModel):

    response: str

    language: str

    domain: str

    intent: str

    provider: str

    context_used: list[str]

    conversation_id: str


# ============================================================
# Main Chat Endpoint
# ============================================================

@router.post(
    "",
    response_model=ChatResponse,
    status_code=status.HTTP_200_OK,
)
async def chat(
    request: ChatRequest,
    current_user: dict = Depends(
        get_current_user
    ),
):
    """
    Main chatbot endpoint.

    Flow:

        JWT authentication
                ↓
        Language processing
                ↓
        Domain + intent detection
                ↓
        Create/load conversation
                ↓
        Load previous messages
                ↓
        Context service
                ↓
        Groq / Qwen
                ↓
        Translate response
                ↓
        Save messages
                ↓
        Return response
    """

    # ========================================================
    # 1. Get authenticated user
    # ========================================================

    user_id = str(
        current_user["_id"]
    )

    # Keep the JWT available for the context service.
    # This will be used when communicating with the
    # authenticated crop backend.
    access_token = current_user.get(
        "_access_token"
    )

    try:

        # ====================================================
        # 2. Prepare message
        #
        # This performs:
        # - language normalization
        # - input translation
        # - domain detection
        # - intent detection
        # ====================================================

        prepared = await chat_service.prepare_chat(
            message=request.message,
            language=request.language,
        )

        domain = prepared["domain"]

        logger.info(
            "Chat request | user=%s | domain=%s | intent=%s",
            user_id,
            domain,
            prepared["intent"],
        )

        # ====================================================
        # 3. Load existing conversation OR create new one
        # ====================================================

        conversation = None

        if request.conversation_id:

            # ------------------------------------------------
            # Continue existing conversation
            # ------------------------------------------------

            conversation = await get_conversation_by_id(
                conversation_id=request.conversation_id,
                user_id=user_id,
            )

            if conversation is None:

                raise HTTPException(
                    status_code=status.HTTP_404_NOT_FOUND,
                    detail="Conversation not found.",
                )

            conversation_id = conversation[
                "conversation_id"
            ]

        else:

            # ------------------------------------------------
            # New conversation
            #
            # IMPORTANT:
            # Domain is now determined by the chatbot
            # instead of being hardcoded to agriculture.
            # ------------------------------------------------

            conversation = await create_conversation(
                user_id=user_id,
                domain=domain,
                language=prepared["language"],
                first_message=request.message,
            )

            conversation_id = conversation[
                "conversation_id"
            ]

        # ====================================================
        # 4. Load previous conversation messages
        # ====================================================

        previous_messages = await get_recent_messages(
            conversation_id=conversation_id,
            limit=10,
        )

        # ====================================================
        # 5. Generate chatbot response
        # ====================================================

        result = await chat_service.chat(

            message=request.message,

            language=request.language,

            user_id=user_id,
            access_token=access_token,
            conversation_history=previous_messages,

            prepared=prepared,

            crop_recommendation=(
                request.crop_recommendation
            ),

            disease_detection=(
                request.disease_detection
            ),

            crop_profile=(
                request.crop_profile
            ),

            latitude=request.latitude,

            longitude=request.longitude,
        )
        # ====================================================
        # 6. Save user's message
        # ====================================================

        await save_user_message(

            conversation_id=conversation_id,

            original_text=request.message,

            english_text=result[
                "english_message"
            ],

            language=result[
                "language"
            ],
        )

        # ====================================================
        # 7. Save AI response
        # ====================================================

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

        # ====================================================
        # 8. Update conversation timestamp
        # ====================================================

        await update_conversation_timestamp(
            conversation_id
        )

        # ====================================================
        # 9. Return response
        # ====================================================

        return ChatResponse(

            response=result[
                "response"
            ],

            language=result[
                "language"
            ],

            domain=result[
                "domain"
            ],

            intent=result[
                "intent"
            ],

            provider=result[
                "provider"
            ],

            context_used=result[
                "context_used"
            ],

            conversation_id=conversation_id,
        )

    # ========================================================
    # Expected chatbot errors
    # ========================================================

    except HTTPException:
        raise

    except ChatServiceError as exc:

        logger.warning(
            "Chat service error | user=%s | error=%s",
            user_id,
            exc,
        )

        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=str(exc),
        ) from exc

    # ========================================================
    # Unexpected errors
    # ========================================================

    except Exception as exc:

        logger.exception(
            "Unexpected chat error | user=%s | error=%s",
            user_id,
            exc,
        )

        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=(
                "Unable to process your message right now. "
                "Please try again."
            ),
        ) from exc