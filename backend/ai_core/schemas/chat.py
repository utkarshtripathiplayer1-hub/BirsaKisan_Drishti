from pydantic import BaseModel
from typing import Optional
from datetime import datetime

class ChatRequest(BaseModel):
    domain: str
    query: str
    conversation_id:Optional[str] | None = None


class ChatResponse(BaseModel):

    conversation_id: str

    response: str

class ConversationResponse(BaseModel):
    conversation_id: str
    title: str
    domain: str
    language: str
    updated_at: datetime
   


class ConversationListResponse(BaseModel):
    conversations: list[ConversationResponse]