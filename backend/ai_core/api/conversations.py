from typing import List

from fastapi import APIRouter, HTTPException

from schemas.conversation import (
    ConversationResponse,
    ConversationDetailResponse,
    MessageResponse
)

from services.conversation_service import (
    get_user_conversations,
    get_conversation_by_id
)

from services.message_service import (
    get_all_messages
)

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


router = APIRouter(
    prefix="/conversations",
    tags=["Conversations"]
)


@router.get(
    "",
    response_model=List[ConversationResponse]
)
async def get_conversations(
    user_id: str,
    domain: str
):
    """
    Get all conversations for a user.
    """

    conversations = await get_user_conversations(
        user_id=user_id,
        domain=domain
    )

    return [
        ConversationResponse(
            conversation_id=conv["conversation_id"],
            title=conv["title"],
            domain=conv["domain"],
            language=conv["language"],
            updated_at=conv["updated_at"]
        )
        for conv in conversations
    ]


@router.get(
    "/{conversation_id}",
    response_model=ConversationDetailResponse
)
async def get_conversation(
    conversation_id: str
):
    """
    Get a conversation and all its messages.
    """

    conversation = await get_conversation_by_id(
        conversation_id
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
        language=conversation["language"],
        messages=[
            MessageResponse(
                role=msg["role"],
                original_text=msg["original_text"],
                language=msg["language"]
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
    request: RenameConversationRequest
):
    updated = await rename_conversation(
        conversation_id=conversation_id,
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
    conversation_id: str
):
    deleted = await delete_conversation(
        conversation_id
    )

    if not deleted:
        raise HTTPException(
            status_code=404,
            detail="Conversation not found"
        )

    return MessageResponseSchema(
        message="Conversation deleted successfully"
    )