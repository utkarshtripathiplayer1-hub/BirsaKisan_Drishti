from fastapi import HTTPException
from fastapi.responses import FileResponse

from app.services.pdf_service import pdf_service
from app.repositories.crop_repository import crop_repository


async def generate_pdf(recommendation_id: str):

    recommendation = await crop_repository.get_by_id(
        recommendation_id
    )

    print("Recommendation from MongoDB")
    print(recommendation)

    if recommendation is None:
        raise HTTPException(
            status_code=404,
            detail="Recommendation not found"
        )

    recommendation.pop("_id", None)

    pdf_path = await pdf_service.generate_crop_report(
        recommendation
    )

    return FileResponse(
        path=pdf_path,
        media_type="application/pdf",
        filename="crop_report.pdf"
    )