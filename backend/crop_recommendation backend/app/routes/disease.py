from fastapi import APIRouter, UploadFile, File, HTTPException

from app.services.groq_service import analyze_plant
from app.schemas.disease import DiseaseResponse


router = APIRouter(
    prefix="/disease",
    tags=["Disease Detection"]
)


ALLOWED_TYPES = {
    "image/jpeg",
    "image/png",
    "image/webp",
}

MAX_SIZE = 8 * 1024 * 1024  # 8 MB


@router.post(
    "/predict",
    response_model=DiseaseResponse
)
async def predict(
    image: UploadFile = File(...)
):
    if image.content_type not in ALLOWED_TYPES:
        raise HTTPException(
            400,
            "Please upload a JPEG, PNG, or WEBP image."
        )

    image_bytes = await image.read()

    if not image_bytes:
        raise HTTPException(
            400,
            "Empty file uploaded."
        )

    if len(image_bytes) > MAX_SIZE:
        raise HTTPException(
            400,
            "Image too large. Please upload under 8 MB."
        )

    return await analyze_plant(
        image_bytes,
        image.content_type
    )
