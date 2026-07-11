import os

from app.ml_models.cashew_model import build_cashew_model
from app.ml_models.cassava_model import build_cassava_model
from app.ml_models.maize_model import build_maize_model
from app.ml_models.tomato_model import build_tomato_model
from app.ml_models.crop_classifier_model import (
    build_crop_classifier_model
)


BASE_DIR = os.path.dirname(
    os.path.dirname(
        os.path.dirname(__file__)
    )
)

CROP_CLASSIFIER_WEIGHTS = os.path.join(
    BASE_DIR,
    "app",
    "ml_models",
    "crop_classifier.keras",
    "model.weights.h5"
)

CASHEW_WEIGHTS = os.path.join(
    BASE_DIR,
    "app",
    "ml_models",
    "cashew_disease_model.keras",
    "model.weights.h5"
)

CASSAVA_WEIGHTS = os.path.join(
    BASE_DIR,
    "app",
    "ml_models",
    "cassava_disease_model.keras",
    "model.weights.h5"
)

MAIZE_WEIGHTS = os.path.join(
    BASE_DIR,
    "app",
    "ml_models",
    "maize_disease_model.keras",
    "model.weights.h5"
)

TOMATO_WEIGHTS = os.path.join(
    BASE_DIR,
    "app",
    "ml_models",
    "tomato_disease_model.keras",
    "model.weights.h5"
)


# Cashew
cashew_model = build_cashew_model()
cashew_model.load_weights(CASHEW_WEIGHTS)

# Cassava
cassava_model = build_cassava_model()
cassava_model.load_weights(CASSAVA_WEIGHTS)

# Maize
maize_model = build_maize_model()
maize_model.load_weights(MAIZE_WEIGHTS)


# Tomato
tomato_model = build_tomato_model()
tomato_model.load_weights(TOMATO_WEIGHTS)

#Crop Classifier

crop_classifier_model = (
    build_crop_classifier_model()
)

crop_classifier_model.load_weights(
    CROP_CLASSIFIER_WEIGHTS
)

print("All disease models loaded successfully")
print("Crop classifier loaded successfully")
