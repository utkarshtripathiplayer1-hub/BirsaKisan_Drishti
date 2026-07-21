from fastapi import APIRouter, UploadFile, File, HTTPException
from app.services.groq_service import analyze_leaf

router = APIRouter(
    prefix="/disease",
    tags=["Disease Detection"]
)

ALLOWED_TYPES = {"image/jpeg", "image/png", "image/webp"}
MAX_SIZE = 8 * 1024 * 1024  # 8 MB


@router.post("/predict")
async def predict(image: UploadFile = File(...)):
    # validate type
    if image.content_type not in ALLOWED_TYPES:
        raise HTTPException(400, "Please upload a JPEG, PNG, or WEBP image.")

    # read bytes into memory (no disk write)
    image_bytes = await image.read()

    # validate size
    if len(image_bytes) > MAX_SIZE:
        raise HTTPException(400, "Image too large. Please upload under 8 MB.")
    if not image_bytes:
        raise HTTPException(400, "Empty file uploaded.")

    # analyze in-memory
    return await analyze_leaf(image_bytes)