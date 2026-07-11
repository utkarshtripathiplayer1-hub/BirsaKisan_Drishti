from app.services.rotation_service import rotation_service


def get_crop_rotation(
    recommendation_id: str
):
    return rotation_service.get_rotation(
        recommendation_id
    )