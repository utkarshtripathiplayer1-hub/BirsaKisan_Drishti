from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras import layers, models

base_model = MobileNetV2(
    input_shape=(224, 224, 3),
    include_top=False,
    weights=None
)

model = models.Sequential([
    layers.Rescaling(1./255),
    base_model,
    layers.GlobalAveragePooling2D(),
    layers.Dropout(0.2),
    layers.Dense(5, activation="softmax")
])

# IMPORTANT
model.build((None, 224, 224, 3))

model.load_weights(
    "app/ml_models/cashew_disease_model.keras/model.weights.h5"
)

print("Weights loaded successfully!")