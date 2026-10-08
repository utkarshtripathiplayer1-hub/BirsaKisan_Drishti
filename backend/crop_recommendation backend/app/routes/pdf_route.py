from fastapi import APIRouter, Depends

from app.auth.dependencies import get_current_user
from app.controllers.pdf_controller import generate_pdf

router = APIRouter(
    prefix="/pdf",
    tags=["PDF"],
)


@router.get("/generate/{recommendation_id}")
async def generate_report(
    recommendation_id: str,
    current_user: dict = Depends(get_current_user),
):
    return await generate_pdf(
        recommendation_id,
        user_id=current_user["user_id"],
    )
