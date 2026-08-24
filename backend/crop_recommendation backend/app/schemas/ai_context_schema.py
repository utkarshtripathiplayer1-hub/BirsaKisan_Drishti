from typing import Optional

from pydantic import BaseModel


class AIContextResponse(BaseModel):

    user_id: str

    last_detection: Optional[dict] = None

    last_recommendation: Optional[dict] = None
