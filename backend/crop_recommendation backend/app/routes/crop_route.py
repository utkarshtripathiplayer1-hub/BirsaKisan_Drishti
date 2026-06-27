from fastapi import APIRouter, Header 

from app.schemas.crop_schema import CropRecommendationRequest
from app.controllers.crop_controller import recommend_crop

router = APIRouter(
    prefix="/crop",
    tags=["Crop Recommendation"]
)


@router.post("/recommend")
async def crop_recommendation(
    request: CropRecommendationRequest,
    x_user_id: str = Header(...)


):
    return await recommend_crop(

        request,
        x_user_id
        )