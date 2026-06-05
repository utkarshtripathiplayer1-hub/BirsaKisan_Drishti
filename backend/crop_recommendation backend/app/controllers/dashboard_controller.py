from app.services.dashboard_service import get_dashboard_data

async def get_dashboard_controller(
    lat: float,
    lon: float
):

    response = await get_dashboard_data(
        lat,
        lon
    )

    return response


