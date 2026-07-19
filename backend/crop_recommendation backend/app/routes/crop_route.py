from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.schemas.crop_schema import CropRecommendationRequest
from app.controllers.crop_controller import recommend_crop

router = APIRouter(
    prefix="/crop",
    tags=["Crop Recommendation"]
)

@router.post("/recommend")
async def crop_recommendation(
    request: CropRecommendationRequest,
    current_user=Depends(get_current_user)
):
    return await recommend_crop(
        request,
        user_id=current_user["sub"]
    )