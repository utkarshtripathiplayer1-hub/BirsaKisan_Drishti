from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.controllers.my_farm_controller import get_my_farm

router = APIRouter(
    prefix="/my-farm",
    tags=["My Farm"]
)


@router.get("/dashboard")
async def my_farm_dashboard(
    current_user=Depends(get_current_user)
):
    return await get_my_farm(
    current_user["sub"],
    current_user["token"]
    )