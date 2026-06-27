from pydantic import BaseModel
from datetime import datetime
from typing import List



class RenameConversationRequest(BaseModel):
    title: str


class MessageResponseSchema(BaseModel):
    message: str

class ConversationResponse(BaseModel):

    conversation_id: str

    title: str

    domain: str

    language: str

    updated_at: datetime





class MessageResponse(BaseModel):

    role: str

    original_text: str

    language: str


class ConversationDetailResponse(BaseModel):

    conversation_id: str

    title: str

    domain: str

    language: str

    messages: List[MessageResponse]