from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user

from app.schemas.active_crop_schema import (
    StartCropRequest
)

from app.controllers.active_crop_controller import (
    start_crop
)

router = APIRouter(
    prefix="/my-farm",
    tags=["Active Crop"]
)


@router.post("/start-crop")
async def start_crop_route(
    request: StartCropRequest,
    current_user=Depends(get_current_user)
):

    return await start_crop(
        request,
        current_user["sub"]
    )

@router.get("/current")
async def current_crop(

    current_user=Depends(
        get_current_user
    )

):

    return await get_current_crop(

        current_user["sub"]

    )