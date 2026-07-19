from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user

from app.schemas.active_crop_schema import (
    StartCropRequest
)

from app.services.active_crop_service import active_crop_service


router = APIRouter(
    prefix="/my-farm",
    tags=["Active Crop"]
)


@router.post("/start-crop")
async def start_crop(
    request: StartCropRequest,
    current_user=Depends(get_current_user)
):

    result = await active_crop_service.start_crop(
        request.recommendation_id,
        current_user["sub"]
    )

    return result



@router.get("/current")
async def current_crop(
    current_user=Depends(get_current_user)
):

    return await active_crop_service.get_current_crop(
        current_user["sub"]
    )