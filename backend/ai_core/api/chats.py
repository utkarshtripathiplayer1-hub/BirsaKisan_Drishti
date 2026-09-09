from bson import ObjectId
from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

from core.dependencies import get_current_user
from services.chat_service import ChatService


router = APIRouter(
    prefix="/api/conversations",
    tags=["Conversations"],
)

chat_service = ChatService()


# ============================================================
# REQUEST MODELS
# ============================================================

class CreateConversationRequest(BaseModel):
    title: str = "New conversation"


class SendMessageRequest(BaseModel):
    message: str


# ============================================================
# CREATE CONVERSATION
# ============================================================

@router.post("")
async def create_conversation(
    request: CreateConversationRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Create a new conversation for the authenticated user.
    """

    try:

        user_id = str(current_user["_id"])

        conversation = await chat_service.create_conversation(
            user_id=user_id,
            title=request.title,
        )

        return {
            "success": True,
            "conversation": {
                "id": str(conversation["_id"]),
                "title": conversation["title"],
                "created_at": conversation["created_at"],
                "updated_at": conversation["updated_at"],
            },
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# GET USER CONVERSATIONS
# ============================================================

@router.get("")
async def get_conversations(
    current_user: dict = Depends(get_current_user),
):
    """
    Get all conversations belonging to the authenticated user.
    """

    try:

        user_id = str(current_user["_id"])

        conversations = (
            await chat_service.get_user_conversations(
                user_id=user_id
            )
        )

        return {
            "success": True,
            "conversations": [
                {
                    "id": str(conversation["_id"]),
                    "title": conversation.get(
                        "title",
                        "New conversation",
                    ),
                    "created_at": conversation.get(
                        "created_at"
                    ),
                    "updated_at": conversation.get(
                        "updated_at"
                    ),
                }
                for conversation in conversations
            ],
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# GET SINGLE CONVERSATION
# ============================================================

@router.get("/{conversation_id}")
async def get_conversation(
    conversation_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Get a conversation and all its messages.
    """

    try:

        user_id = str(current_user["_id"])

        result = await chat_service.get_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        if result is None:

            raise HTTPException(
                status_code=404,
                detail="Conversation not found",
            )

        conversation = result["conversation"]
        messages = result["messages"]

        return {
            "success": True,

            "conversation": {
                "id": str(conversation["_id"]),
                "title": conversation.get(
                    "title",
                    "New conversation",
                ),
                "created_at": conversation.get(
                    "created_at"
                ),
                "updated_at": conversation.get(
                    "updated_at"
                ),
            },

            "messages": [
                {
                    "id": str(message["_id"]),
                    "role": message["role"],
                    "content": message["content"],
                    "language": message.get("language"),
                    "message_type": message.get(
                        "message_type",
                        "text",
                    ),
                    "created_at": message.get(
                        "created_at"
                    ),
                }
                for message in messages
            ],
        }

    except HTTPException:
        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# SEND MESSAGE
# ============================================================

@router.post("/{conversation_id}/message")
async def send_message(
    conversation_id: str,
    request: SendMessageRequest,
    current_user: dict = Depends(get_current_user),
):
    """
    Send a text message to an existing conversation.

    The backend:
        1. Loads previous messages
        2. Sends conversation context to Qwen
        3. Generates response
        4. Saves user message
        5. Saves AI response
    """

    try:

        if not request.message.strip():

            raise HTTPException(
                status_code=400,
                detail="Message cannot be empty",
            )

        user_id = str(current_user["_id"])

        result = await chat_service.send_message(
            conversation_id=conversation_id,
            user_id=user_id,
            user_text=request.message.strip(),
        )

        return {
            "success": True,
            **result,
        }

    except HTTPException:
        raise

    except ValueError as e:

        raise HTTPException(
            status_code=404,
            detail=str(e),
        )

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# DELETE CONVERSATION
# ============================================================

@router.delete("/{conversation_id}")
async def delete_conversation(
    conversation_id: str,
    current_user: dict = Depends(get_current_user),
):
    """
    Delete a conversation and all its messages.
    """

    try:

        user_id = str(current_user["_id"])

        deleted = await chat_service.delete_conversation(
            conversation_id=conversation_id,
            user_id=user_id,
        )

        if not deleted:

            raise HTTPException(
                status_code=404,
                detail="Conversation not found",
            )

        return {
            "success": True,
            "message": "Conversation deleted successfully",
        }

    except HTTPException:
        raise

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )