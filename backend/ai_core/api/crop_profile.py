from fastapi import APIRouter, Depends, HTTPException

from core.dependencies import get_current_user

from schemas.crop_profile import (
    CreateCropProfileRequest,
    UpdateCropProfileRequest,
)

from services.crop_profile_service import (
    create_profile,
    get_profile,
    update_profile,
    delete_profile,
)

router = APIRouter(
    prefix="/profile/crop",
    tags=["Crop Profile"],
)


# CREATE PROFILE
@router.post("")
async def create_crop_profile(
    request: CreateCropProfileRequest,
    current_user=Depends(get_current_user)
):
    print(current_user)
    try:
        user_id = str(current_user["_id"])

        return await create_profile(
            user_id=user_id,
            profile_data=request.model_dump()
        )

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))


# GET PROFILE
@router.get("")
async def get_crop_profile(
    current_user=Depends(get_current_user)
):
    try:
        user_id = str(current_user["_id"])

        return await get_profile(user_id)

    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))


# UPDATE PROFILE
@router.patch("")
async def update_crop_profile(
    request: UpdateCropProfileRequest,
    current_user=Depends(get_current_user)
):
    try:
        user_id = str(current_user["_id"])

        return await update_profile(
            user_id=user_id,
            update_data=request.model_dump(exclude_none=True)
        )

    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))


# DELETE PROFILE
@router.delete("")
async def delete_crop_profile(
    current_user=Depends(get_current_user)
):
    try:
        user_id = str(current_user["_id"])

        return await delete_profile(user_id)

    except ValueError as e:
        raise HTTPException(status_code=404, detail=str(e))