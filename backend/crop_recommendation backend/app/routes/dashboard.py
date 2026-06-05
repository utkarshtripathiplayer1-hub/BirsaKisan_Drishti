from fastapi import APIRouter
from app.controllers.dashboard_controller import get_dashboard_controller

router = APIRouter()

@router.get("/home")
async def dashboard_home(
    lat: float,
    lon: float
):

    return await get_dashboard_controller(
        lat,
        lon
    )

    