from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

from services.chat_service import ChatService
from core.dependencies import get_current_user


router = APIRouter(
    prefix="/api/chat",
    tags=["Chat"],
)

chat_service = ChatService()


# ============================================================
# REQUEST MODEL
# ============================================================

class ContinueChatRequest(BaseModel):

    conversation_id: str
    text: str


# ============================================================
# CREATE CONVERSATION
# ============================================================

@router.post("/conversations")
async def create_conversation(
    current_user: dict = Depends(get_current_user),
):

    try:

        user_id = str(current_user["_id"])

        conversation = (
            await chat_service.create_conversation(
                user_id=user_id
            )
        )

        return {
            "success": True,
            "conversation_id": str(
                conversation["_id"]
            ),
            "title": conversation["title"],
        }

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# GET CONVERSATIONS
# ============================================================

@router.get("/conversations")
async def get_conversations(
    current_user: dict = Depends(get_current_user),
):

    try:

        user_id = str(current_user["_id"])

        conversations = (
            await chat_service.get_user_conversations(
                user_id
            )
        )

        return {
            "success": True,
            "conversations": [
                {
                    "conversation_id": str(
                        conversation["_id"]
                    ),
                    "title": conversation.get(
                        "title",
                        "New conversation"
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
# GET ONE CONVERSATION
# ============================================================

@router.get("/conversations/{conversation_id}")
async def get_conversation(
    conversation_id: str,
    current_user: dict = Depends(get_current_user),
):

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

        return {
            "success": True,

            "conversation": {
                "conversation_id": str(
                    conversation["_id"]
                ),
                "title": conversation.get(
                    "title",
                    "New conversation"
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
                    "role": message.get("role"),
                    "content": message.get("content"),
                    "language": message.get("language"),
                    "message_type": message.get(
                        "message_type",
                        "text"
                    ),
                    "created_at": message.get(
                        "created_at"
                    ),
                }
                for message in result["messages"]
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
# TEXT CHAT
# ============================================================

@router.post("/text")
async def text_chat(
    request: ContinueChatRequest,
    current_user: dict = Depends(get_current_user),
):

    try:

        if not request.text.strip():

            raise HTTPException(
                status_code=400,
                detail="Text cannot be empty",
            )

        user_id = str(
            current_user["_id"]
        )

        result = await chat_service.send_message(
            conversation_id=request.conversation_id,
            user_id=user_id,
            user_text=request.text,
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

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# DELETE CONVERSATION
# ============================================================

@router.delete("/conversations/{conversation_id}")
async def delete_conversation(
    conversation_id: str,
    current_user: dict = Depends(get_current_user),
):

    try:

        user_id = str(
            current_user["_id"]
        )

        deleted = (
            await chat_service.delete_conversation(
                conversation_id=conversation_id,
                user_id=user_id,
            )
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