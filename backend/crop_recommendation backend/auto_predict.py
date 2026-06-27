import tensorflow as tf
import numpy as np

from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing import image

# ==================================
# LOAD CROP CLASSIFIER
# ==================================

crop_model = load_model(
    "models/crop_classifier.keras"
)

crop_classes = [
    "cassava",
    "cashew",
    "maize",
    "tomato"
]

# ==================================
# DISEASE CLASS LISTS
# ==================================

disease_classes = {

    "maize": [
        "fall armyworm",
        "grasshoper",
        "healthy",
        "leaf beetle",
        "leaf blight",
        "leaf spot",
        "streak virus"
    ],

    "cassava": [
        "bacterial blight",
        "brown spot",
        "green mite",
        "healthy",
        "mosaic"
    ],

    "tomato": [
        "healthy",
        "leaf blight",
        "leaf curl",
        "septoria leaf spot",
        "verticulium wilt"
    ],

    "cashew": [
        "anthracnose",
        "gumosis",
        "healthy",
        "leaf miner",
        "red rust"
    ]
}

# ==================================
# MODEL PATHS
# ==================================

model_paths = {

    "maize":
    "models/maize_disease_model.keras",

    "cassava":
    "models/cassava_disease_model.keras",

    "tomato":
    "models/tomato_disease_model.keras",

    "cashew":
    "models/cashew_disease_model.keras"
}

# ==================================
# INPUT IMAGE
# ==================================

image_path = input(
    "Enter image path: "
)

# ==================================
# PREPROCESS IMAGE
# ==================================

img = image.load_img(
    image_path,
    target_size=(224,224)
)

img_array = image.img_to_array(img)

img_array = np.expand_dims(
    img_array,
    axis=0
)

# ==================================
# STEP 1
# CROP PREDICTION
# ==================================

crop_prediction = crop_model.predict(
    img_array,
    verbose=0
)

crop_index = np.argmax(
    crop_prediction
)

crop_name = crop_classes[
    crop_index
]

crop_confidence = (
    np.max(crop_prediction)
    * 100
)

if crop_confidence < 80:
    print("Unknown Crop")
    exit()

# ==================================
# STEP 2
# LOAD DISEASE MODEL
# ==================================

disease_model = load_model(
    model_paths[crop_name]
)

disease_prediction = disease_model.predict(
    img_array,
    verbose=0
)

disease_index = np.argmax(
    disease_prediction
)

disease_name = disease_classes[
    crop_name
][disease_index]

disease_confidence = (
    np.max(disease_prediction)
    * 100
)

# ==================================
# OUTPUT
# ==================================

print("\n====================")

print(
    f"Crop: {crop_name}"
)

print(
    f"Crop Confidence: "
    f"{crop_confidence:.2f}%"
)

print()

print(
    f"Disease: {disease_name}"
)

print(
    f"Disease Confidence: "
    f"{disease_confidence:.2f}%"
)

print("====================")