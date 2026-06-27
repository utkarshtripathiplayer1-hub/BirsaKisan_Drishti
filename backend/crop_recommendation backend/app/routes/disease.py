from fastapi import APIRouter
from fastapi import UploadFile
from fastapi import File, Header

import os

from app.services.disease_service import predict_disease
from app.schemas.disease_response import DiseaseResponse


router = APIRouter(
    prefix="/disease",
    tags=["Disease Detection"]
)


@router.post(
    "/predict",
    response_model=DiseaseResponse
)
async def detect_disease(
    image: UploadFile = File(...),
    x_user_id: str = Header(...)
):

    upload_dir = "uploads"

    os.makedirs(
        upload_dir,
        exist_ok=True
    )

    file_path = os.path.join(
        upload_dir,
        image.filename
    )

    with open(
        file_path,
        "wb"
    ) as buffer:

        buffer.write(
            await image.read()
        )

    result = predict_disease(
        image_path=file_path
    )
    result["user_id"] = x_user_id

    return result