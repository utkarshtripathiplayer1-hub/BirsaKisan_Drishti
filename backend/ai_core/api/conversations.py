from typing import List

from fastapi import (
    APIRouter,
    HTTPException,
    Depends
)

from core.dependencies import get_current_user

from schemas.conversation import (
    ConversationResponse,
    ConversationDetailResponse,
    MessageResponse,
    RenameConversationRequest,
    MessageResponseSchema
)

from services.conversation_service import (
    get_user_conversations,
    get_conversation_by_id,
    rename_conversation,
    delete_conversation
)

from services.message_service import (
    get_all_messages
)

router = APIRouter(
    prefix="/conversations",
    tags=["Conversations"],
    dependencies=[Depends(get_current_user)]
)


@router.get(
    "",
    response_model=List[ConversationResponse]
)
async def get_conversations(
    domain: str,
    current_user=Depends(get_current_user)
):
    """
    Get all conversations for the logged-in user.
    """

    user_id = str(current_user["_id"])

    conversations = await get_user_conversations(
        user_id=user_id,
        domain=domain
    )

    return [
        ConversationResponse(
            conversation_id=conv["conversation_id"],
            title=conv["title"],
            domain=conv["domain"],
            language=conv.get("language", "en"),
            updated_at=conv["updated_at"]
        )
        for conv in conversations
    ]


@router.get(
    "/{conversation_id}",
    response_model=ConversationDetailResponse
)
async def get_conversation(
    conversation_id: str,
    current_user=Depends(get_current_user)
):
    """
    Get a conversation and all its messages.
    """

    user_id = str(current_user["_id"])

    conversation = await get_conversation_by_id(
        conversation_id=conversation_id,
        user_id=user_id
    )

    if not conversation:
        raise HTTPException(
            status_code=404,
            detail="Conversation not found"
        )

    messages = await get_all_messages(
        conversation_id
    )

    return ConversationDetailResponse(
    conversation_id=conversation["conversation_id"],
    title=conversation["title"],
    domain=conversation["domain"],
    language=conversation.get("language", "en"),
    messages=[
        MessageResponse(
            role=msg["role"],
            original_text=msg["original_text"],
            language=msg.get("language", "en")
        )
        for msg in messages
    ]
)

@router.patch(
    "/{conversation_id}",
    response_model=MessageResponseSchema
)
async def rename_chat(
    conversation_id: str,
    request: RenameConversationRequest,
    current_user=Depends(get_current_user)
):
    """
    Rename a conversation.
    """

    user_id = str(current_user["_id"])

    updated = await rename_conversation(
        conversation_id=conversation_id,
        user_id=user_id,
        title=request.title
    )

    if not updated:
        raise HTTPException(
            status_code=404,
            detail="Conversation not found"
        )

    return MessageResponseSchema(
        message="Conversation renamed successfully"
    )


@router.delete(
    "/{conversation_id}",
    response_model=MessageResponseSchema
)
async def delete_chat(
    conversation_id: str,
    current_user=Depends(get_current_user)
):
    """
    Delete a conversation.
    """

    user_id = str(current_user["_id"])

    deleted = await delete_conversation(
        conversation_id=conversation_id,
        user_id=user_id
    )

    if not deleted:
        raise HTTPException(
            status_code=404,
            detail="Conversation not found"
        )

    return MessageResponseSchema(
        message="Conversation deleted successfully"
    )