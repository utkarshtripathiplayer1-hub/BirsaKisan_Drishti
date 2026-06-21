from pydantic import BaseModel
from typing import Optional


class AIContextResponse(BaseModel):
    user_id: str
    last_detection: Optional[dict] = None
    last_recommendation: Optional[dict] = None
