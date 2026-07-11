from fastapi import APIRouter, Depends

from core.dependencies import get_current_user
from services.account_service import delete_account

router = APIRouter(
    prefix="/account",
    tags=["Account"]
)

@router.delete("")
async def remove_account(
    current_user=Depends(get_current_user)
):
    print("DELETE endpoint reached")

    user_id = str(current_user["_id"])

    return await delete_account(user_id)