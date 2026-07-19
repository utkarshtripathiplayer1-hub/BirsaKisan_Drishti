from fastapi import APIRouter

from app.controllers.pdf_controller import generate_pdf

router = APIRouter(
    prefix="/pdf",
    tags=["PDF"]
)


@router.get("/generate/{recommendation_id}")
async def generate_report(recommendation_id: str):
    return await generate_pdf(recommendation_id)