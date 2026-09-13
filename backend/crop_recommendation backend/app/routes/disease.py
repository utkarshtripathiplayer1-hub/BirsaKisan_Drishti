from fastapi import APIRouter, UploadFile, File, Form, HTTPException

from app.services.groq_service import analyze_plant
from app.schemas.disease_response import DiseaseResponse
from app.repositories.disease_repository import disease_repository


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

SUPPORTED_LANGUAGES = {
    "en",
    "hi",
}


@router.post(
    "/predict",
    response_model=DiseaseResponse
)
async def predict(
    image: UploadFile = File(...),
    language: str = Form("en")
):
    """
    Analyze a crop image for disease/pest/nutrient issues.

    The language selected by the farmer is passed forward
    to the AI service for generating the response.
    """

    # -----------------------------
    # Validate language
    # -----------------------------
    language = language.lower().strip()

    if language not in SUPPORTED_LANGUAGES:
        raise HTTPException(
            status_code=400,
            detail="Supported languages are English (en) and Hindi (hi)."
        )

    # -----------------------------
    # Validate image type
    # -----------------------------
    if image.content_type not in ALLOWED_TYPES:
        raise HTTPException(
            status_code=400,
            detail="Please upload a JPEG, PNG, or WEBP image."
        )

    # -----------------------------
    # Read image
    # -----------------------------
    image_bytes = await image.read()

    if not image_bytes:
        raise HTTPException(
            status_code=400,
            detail="Empty file uploaded."
        )

    # -----------------------------
    # Validate image size
    # -----------------------------
    if len(image_bytes) > MAX_SIZE:
        raise HTTPException(
            status_code=400,
            detail="Image too large. Please upload under 8 MB."
        )

    # -----------------------------
    # AI analysis
    # -----------------------------
    result = await analyze_plant(
        image_bytes=image_bytes,
        content_type=image.content_type,
        language=language
    )

    # -----------------------------
    # Validate AI response
    # -----------------------------
    disease_result = DiseaseResponse.model_validate(
        result
    )

    # -----------------------------
    # Save result to MongoDB
    # -----------------------------
    await disease_repository.save(
        disease_result.model_dump()
    )

    # -----------------------------
    # Return result to Flutter
    # -----------------------------
    return disease_result