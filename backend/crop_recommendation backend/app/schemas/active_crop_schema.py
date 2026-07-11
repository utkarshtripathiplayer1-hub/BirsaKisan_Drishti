from pydantic import BaseModel

class StartCropRequest(BaseModel):
    recommendation_id: str 