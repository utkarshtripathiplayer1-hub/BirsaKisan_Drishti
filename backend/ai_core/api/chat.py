from fastapi import APIRouter

from schemas.chat import (
    ChatRequest,
    ChatResponse
)

from services.chat_service import process_chat


router = APIRouter(
    prefix="/chat",
    tags=["Chat"]
)


@router.post(
    "",
    response_model=ChatResponse
)
async def chat(
    request: ChatRequest
):

    result = await process_chat(
        user_id=request.user_id,
        domain=request.domain,
        language=request.language,
        query=request.query,
        conversation_id=request.conversation_id
    )

    return ChatResponse(
        conversation_id=result["conversation_id"],
        response=result["response"]
    )