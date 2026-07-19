from fastapi import APIRouter

from app.controllers.rotation_controller import (
    get_crop_rotation
)

router = APIRouter(
    prefix="/crop",
    tags=["Crop Rotation"]
)


@router.get("/rotation/{recommendation_id}")
async def crop_rotation(
    recommendation_id: str
):
    return await get_crop_rotation(
        recommendation_id
    )