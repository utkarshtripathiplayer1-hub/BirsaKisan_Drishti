from app.services.rotation_service import rotation_service


async def get_crop_rotation(
    recommendation_id: str
):
    return await rotation_service.get_rotation(
        recommendation_id
    )