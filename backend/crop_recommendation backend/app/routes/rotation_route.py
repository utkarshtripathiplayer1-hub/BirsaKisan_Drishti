from fastapi import APIRouter

from app.controllers.rotation_controller import (
    get_crop_rotation
)

router = APIRouter(
    prefix="/crop",
    tags=["Crop Rotation"]
)


@router.get("/rotation/{recommendation_id}")
def crop_rotation(
    recommendation_id: str
):
    return get_crop_rotation(
        recommendation_id
    )