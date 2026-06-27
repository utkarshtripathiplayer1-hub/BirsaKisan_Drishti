import numpy as np

from PIL import Image
from app.ml_models.model_loader import (
    crop_classifier_model,
    cashew_model,
    cassava_model,
    maize_model,
    tomato_model
)


from app.repositories.disease_repository import disease_repository
from app.data.disease_metadata import DISEASE_DATA


CASHEW_CLASSES = [
    "anthracnose",
    "gumosis",
    "healthy",
    "leaf miner",
    "red rust"
]

CASSAVA_CLASSES = [
    "bacterial_blight",
    "brown_spot",
    "green_mite",
    "healthy",
    "mosaic"
]

MAIZE_CLASSES = [
    "fall_armyworm",
    "grasshoper",
    "healthy",
    "leaf_beetle",
    "leaf_blight",
    "leaf_spot",
    "streak_virus"
]

TOMATO_CLASSES = [
    "healthy",
    "leaf_blight",
    "leaf_curl",
    "septoria_leaf_spot",
    "verticillium_wilt"
]

CROP_CLASSES = [
    "cassava",
    "cashew",
    "maize",
    "tomato"
]

def predict_crop(image):

    prediction = crop_classifier_model.predict(
        image,
        verbose=0
    )

    crop_index = np.argmax(
        prediction
    )

    crop_name = CROP_CLASSES[
        crop_index
    ]

    return crop_name


def preprocess_image(image_path: str):

    image = Image.open(image_path)

    image = image.convert("RGB")

    image = image.resize((224, 224))

    image_array = np.array(
        image,
        dtype=np.float32
    )

    image_array = np.expand_dims(
        image_array,
        axis=0
    )

    return image_array


def get_model_and_classes(crop_type: str):

    crop_type = crop_type.lower()

    if crop_type == "cashew":
        return cashew_model, CASHEW_CLASSES

    elif crop_type == "cassava":
        return cassava_model, CASSAVA_CLASSES

    elif crop_type == "maize":
        return maize_model, MAIZE_CLASSES

    elif crop_type == "tomato":
        return tomato_model, TOMATO_CLASSES

    raise ValueError(
        f"Unsupported crop: {crop_type}"
    )


def predict_disease(
    image_path: str
):

    image = preprocess_image(
        image_path
    )

    crop_type = predict_crop(
        image
    )

    model, classes = get_model_and_classes(
        crop_type
    )

    prediction = model.predict(
        image,
        verbose=0
    )
    print("Prediction vector:")
    print(prediction)

    print("Classes:")
    print(classes)

    predicted_index = np.argmax(
        prediction
    )

    confidence = float(
        np.max(prediction) * 100
    )

    disease_name = classes[
        predicted_index
    ]

    if confidence < 40:
        disease_stage = "Early"

    elif confidence < 75:
        disease_stage = "Moderate"

    else:
        disease_stage = "Severe"

    disease_info = DISEASE_DATA[
        crop_type
    ][
        disease_name
    ]

    result = {
    


        "crop_type": crop_type,

        "disease_name": disease_name,

        "severity": round(

            confidence,
            2
        ),


        "disease_stage": disease_stage,

        "mortality_rate": disease_info[
            "mortality_rate"
        ],

         "overview": disease_info[
            "overview"
        ],

        "weather_conditions": disease_info[
            "weather_conditions"
        ],

        "precautions": disease_info[
            "precautions"
        ],

        "organic_cure": disease_info[
            "organic_cure"
        ],

        "chemical_cure": disease_info[
            "chemical_cure"

        ]
    }

    disease_id = disease_repository.save(
        result.copy()
    )

    result["disease_id"] = disease_id

    return result