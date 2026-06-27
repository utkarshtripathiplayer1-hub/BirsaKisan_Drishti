from app.services.crop_service import crop_service


async def recommend_crop(
    request,
    user_id: str
):

    return crop_service.predict(
        request,
        user_id
        )