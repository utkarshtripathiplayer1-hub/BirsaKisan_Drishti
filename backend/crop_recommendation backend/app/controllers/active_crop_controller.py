from app.services.active_crop_service import (
    active_crop_service
)


async def start_crop(
    request,
    user_id: str
):

    return active_crop_service.start_crop(
        request.recommendation_id,
        user_id
    )

async def get_current_crop(
    user_id: str
):

    return active_crop_service.get_current_crop(
        user_id
    )