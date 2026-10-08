from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.controllers.my_farm_controller import get_my_farm

router = APIRouter(
    prefix="/my-farm",
    tags=["My Farm"],
)


@router.get("/dashboard")
async def my_farm_dashboard(
    current_user: dict = Depends(get_current_user),
):
    return await get_my_farm(
        current_user["user_id"],
        current_user["token"],
    )
