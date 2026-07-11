from fastapi import APIRouter, Depends

from core.dependencies import get_current_user

from schemas.chat import (
    ChatRequest,
    ChatResponse
)

from services.chat_service import process_chat
from schemas.chat import ConversationListResponse
from services.chat_service import get_conversations

router = APIRouter(
    prefix="/chat",
    tags=["Chat"]
)


@router.post(
    "",
    response_model=ChatResponse
)
async def chat(
    request: ChatRequest,
    current_user=Depends(get_current_user)
):

    result = await process_chat(
        user_id=str(current_user["_id"]),
        domain=request.domain,
        language=current_user["preferred_language"],
        query=request.query,
        conversation_id=request.conversation_id
    )

    return ChatResponse(
        conversation_id=result["conversation_id"],
        response=result["response"]
    )

@router.get(
    "/conversations",
    response_model=ConversationListResponse
)
async def conversations(
    current_user=Depends(get_current_user)
):

    return await get_conversations(
        str(current_user["_id"])
    )