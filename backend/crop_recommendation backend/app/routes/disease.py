from fastapi import APIRouter, UploadFile, File, Form, HTTPException, Depends

from app.auth.dependencies import get_current_user
from app.services.groq_service import analyze_plant
from app.schemas.disease_response import DiseaseResponse
from app.repositories.disease_repository import disease_repository


router = APIRouter(
    prefix="/disease",
    tags=["Disease Detection"],
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
    response_model=DiseaseResponse,
)
async def predict(
    image: UploadFile = File(...),
    language: str = Form("en"),
    current_user: dict = Depends(get_current_user),
):
    """
    Analyze a crop image for disease/pest/nutrient issues.
    """

    language = language.lower().strip()

    if language not in SUPPORTED_LANGUAGES:
        raise HTTPException(
            status_code=400,
            detail="Supported languages are English (en) and Hindi (hi).",
        )

    if image.content_type not in ALLOWED_TYPES:
        raise HTTPException(
            status_code=400,
            detail="Please upload a JPEG, PNG, or WEBP image.",
        )

    image_bytes = await image.read()

    if not image_bytes:
        raise HTTPException(
            status_code=400,
            detail="Empty file uploaded.",
        )

    if len(image_bytes) > MAX_SIZE:
        raise HTTPException(
            status_code=400,
            detail="Image too large. Please upload under 8 MB.",
        )

    result = await analyze_plant(
        image_bytes=image_bytes,
        content_type=image.content_type,
        language=language,
    )

    disease_result = DiseaseResponse.model_validate(result)

    # Associate the result with the authenticated user.
    saved_result = disease_result.model_dump()
    saved_result["user_id"] = current_user["user_id"]

    await disease_repository.save(saved_result)

    return disease_result
