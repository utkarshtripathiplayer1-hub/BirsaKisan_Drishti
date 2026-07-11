from pydantic import BaseModel


class CropRotationResponse(BaseModel):
    current_crop: str
    next_crop: str
    reason: str
    benefits: list[str]
    avoid: list[str]
    