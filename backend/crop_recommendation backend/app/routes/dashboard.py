from fastapi import APIRouter, Depends

from app.auth.dependencies import require_project
from app.controllers.dashboard_controller import get_dashboard_controller

router = APIRouter()


@router.get("/home")
async def dashboard_home(
    lat: float,
    lon: float,
    current_user: dict = Depends(require_project("crop"))
):
    return await get_dashboard_controller(
        lat,
        lon,
        current_user["sub"]
    )

    