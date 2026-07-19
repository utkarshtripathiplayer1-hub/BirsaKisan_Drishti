from fastapi import APIRouter, UploadFile, File

import os

from app.services.groq_service import analyze_leaf


router = APIRouter(
    prefix="/disease",
    tags=["Disease Detection"]
)


@router.post("/predict")
async def predict(
    image: UploadFile = File(...)
):

    os.makedirs(
        "uploads",
        exist_ok=True
    )


    path = os.path.join(
        "uploads",
        image.filename
    )


    with open(path, "wb") as f:
        f.write(await image.read())


    return await analyze_leaf(path)