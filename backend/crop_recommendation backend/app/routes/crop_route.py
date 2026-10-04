
from fastapi import APIRouter, Depends

from app.auth.dependencies import require_project
from app.schemas.crop_schema import CropRecommendationRequest
from app.controllers.crop_controller import recommend_crop

router = APIRouter(
    prefix="/crop",
    tags=["Crop Recommendation"]
)


@router.post("/recommend")
async def crop_recommendation(
    request: CropRecommendationRequest,
    current_user: dict = Depends(require_project("crop")),
):
    return await recommend_crop(
        request,
        user_id=current_user["sub"],
    )
