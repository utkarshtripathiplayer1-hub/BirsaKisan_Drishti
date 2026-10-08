from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.controllers.dashboard_controller import get_dashboard_controller

router = APIRouter()


@router.get("/home")
async def dashboard_home(
    lat: float,
    lon: float,
    current_user: dict = Depends(get_current_user),
):
    return await get_dashboard_controller(
        lat,
        lon,
        current_user["user_id"],
    )
    