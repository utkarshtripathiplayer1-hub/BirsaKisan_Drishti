from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.controllers.rotation_controller import get_crop_rotation

router = APIRouter(
    prefix="/crop",
    tags=["Crop Rotation"],
)


@router.get("/rotation/{recommendation_id}")
async def crop_rotation(
    recommendation_id: str,
    current_user: dict = Depends(get_current_user),
):
    return await get_crop_rotation(
        recommendation_id,
        current_user["user_id"],
    )
