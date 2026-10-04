
from fastapi import APIRouter, Depends

from app.auth.dependencies import require_project
from app.schemas.active_crop_schema import StartCropRequest
from app.services.active_crop_service import active_crop_service


router = APIRouter(
    prefix="/my-farm",
    tags=["Active Crop"]
)


@router.post("/start-crop")
async def start_crop(
    request: StartCropRequest,
    current_user: dict = Depends(require_project("crop")),
):
    result = await active_crop_service.start_crop(
        request.recommendation_id,
        current_user["sub"],
    )

    return result


@router.get("/current")
async def current_crop(
    current_user: dict = Depends(require_project("crop")),
):
    return await active_crop_service.get_current_crop(
        current_user["sub"]
    )
