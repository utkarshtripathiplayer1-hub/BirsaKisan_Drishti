from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

from core.dependencies import get_current_user
from services.chat_service import ChatService


router = APIRouter(
    prefix="/api/chat",
    tags=["Chat"],
)

chat_service = ChatService()


class ChatMessageRequest(BaseModel):
    conversation_id: str | None = None
    text: str


class ChatResponse(BaseModel):
    success: bool
    conversation_id: str
    user_text: str
    ai_response: str
    language: str | None = None
    audio_base64: str | None = None


class RenameConversationRequest(BaseModel):
    title: str


class RenameConversationResponse(BaseModel):
    success: bool
    conversation_id: str
    title: str


@router.post(
    "/text",
    response_model=ChatResponse,
)
async def text_chat(
    request: ChatMessageRequest,
    current_user: dict = Depends(get_current_user),
):
    if not request.text.strip():
        raise HTTPException(
            status_code=400,
            detail="Text cannot be empty",
        )

    try:
        result = await chat_service.send_message(
            conversation_id=request.conversation_id,
            user_id=str(current_user["_id"]),
            user_text=request.text.strip(),
            generate_audio=False,
        )

        return {
            "success": True,
            **result,
        }

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


@router.post(
    "/text-voice",
    response_model=ChatResponse,
)
async def text_to_voice(
    request: ChatMessageRequest,
    current_user: dict = Depends(get_current_user),
):
    if not request.text.strip():
        raise HTTPException(
            status_code=400,
            detail="Text cannot be empty",
        )

    try:
        result = await chat_service.send_message(
            conversation_id=request.conversation_id,
            user_id=str(current_user["_id"]),
            user_text=request.text.strip(),
            generate_audio=True,
        )

        return {
            "success": True,
            **result,
        }

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


@router.patch(
    "/conversations/{conversation_id}",
    response_model=RenameConversationResponse,
)
async def rename_conversation(
    conversation_id: str,
    request: RenameConversationRequest,
    current_user: dict = Depends(get_current_user),
):
    if not request.title.strip():
        raise HTTPException(
            status_code=400,
            detail="Conversation title cannot be empty",
        )

    try:
        conversation = await chat_service.rename_conversation(
            conversation_id=conversation_id,
            user_id=str(current_user["_id"]),
            title=request.title.strip(),
        )

        if conversation is None:
            raise HTTPException(
                status_code=404,
                detail="Conversation not found",
            )

        return {
            "success": True,
            "conversation_id": str(conversation["_id"]),
            "title": conversation["title"],
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