from pydantic import BaseModel
from typing import Optional
from datetime import datetime


class ChatRequest(BaseModel):
    conversation_id: Optional[str] = None
    text: str


class ChatResponse(BaseModel):
    success: bool
    conversation_id: str
    user_text: str
    ai_response: str
    language: Optional[str] = None
    audio_base64: Optional[str] = None


class ConversationResponse(BaseModel):
    conversation_id: str
    title: str
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None


class ConversationListResponse(BaseModel):
    success: bool
    conversations: list[ConversationResponse]


class RenameConversationRequest(BaseModel):
    title: str


class RenameConversationResponse(BaseModel):
    success: bool
    conversation_id: str
    title: str