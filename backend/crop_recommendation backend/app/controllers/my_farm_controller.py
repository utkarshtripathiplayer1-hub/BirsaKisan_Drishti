from app.services.my_farm_service import my_farm_service


async def get_my_farm(
    user_id: str,
    token: str
):
    return await my_farm_service.get_dashboard(
        user_id,
        token
    )