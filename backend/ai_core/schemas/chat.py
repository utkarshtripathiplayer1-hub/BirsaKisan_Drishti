from pydantic import BaseModel
from typing import Optional


class ChatRequest(BaseModel):

    user_id: str

    domain: str

    language: str

    query: str

    conversation_id: Optional[str] = None


class ChatResponse(BaseModel):

    conversation_id: str

    response: str