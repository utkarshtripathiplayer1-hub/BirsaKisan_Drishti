from fastapi import APIRouter, Depends
from app.auth.dependencies import require_project
from app.controllers.rotation_controller import get_crop_rotation

router = APIRouter(prefix="/crop", tags=["Crop Rotation"])


@router.get("/rotation/{recommendation_id}")
async def crop_rotation(
    recommendation_id: str,
    current_user: dict = Depends(require_project("crop"))
):
    return await get_crop_rotation(
        recommendation_id,
        current_user["sub"]
    )
