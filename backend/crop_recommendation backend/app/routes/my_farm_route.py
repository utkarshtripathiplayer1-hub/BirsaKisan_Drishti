
from fastapi import APIRouter, Depends

from app.auth.dependencies import require_project
from app.controllers.my_farm_controller import get_my_farm

router = APIRouter(
    prefix="/my-farm",
    tags=["My Farm"]
)


@router.get("/dashboard")
async def my_farm_dashboard(
    current_user: dict = Depends(require_project("crop")),
):
    return await get_my_farm(
        current_user["sub"],
        current_user["token"],
    )
