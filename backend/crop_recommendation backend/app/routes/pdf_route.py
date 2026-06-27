from fastapi import APIRouter

from app.schemas.pdf_schema import PDFRequest
from app.controllers.pdf_controller import generate_pdf

router = APIRouter(
    prefix="/pdf",
    tags=["PDF"]
)

@router.get("/generate/{recommendation_id}")
def generate_report(
    recommendation_id: str
):
    return generate_pdf(
        recommendation_id
    )