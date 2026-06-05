from fastapi import APIRouter

from app.controllers.crop_controller import (
    CropController
)

from app.schemas.crop_schema import (
    CropRecommendationRequest,
    CropRecommendationResponse
)


router = APIRouter(
    prefix="/crop",
    tags=["Crop Recommendation"]
)


@router.post(
    "/recommend",
    response_model=CropRecommendationResponse
)
async def recommend_crop(
    data: CropRecommendationRequest
):

    return await CropController.recommend_crop(
        data
    )

