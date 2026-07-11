import tensorflow as tf

from tensorflow.keras import layers
from tensorflow.keras import models
from tensorflow.keras.applications import MobileNetV2


def build_crop_classifier_model():

    data_augmentation = tf.keras.Sequential([
        layers.RandomFlip("horizontal"),
        layers.RandomRotation(0.2),
        layers.RandomZoom(0.2),
        layers.RandomContrast(0.2)
    ])

    base_model = MobileNetV2(
        input_shape=(224, 224, 3),
        include_top=False,
        weights=None
    )

    inputs = tf.keras.Input(
        shape=(224, 224, 3)
    )

    x = data_augmentation(inputs)

    x = layers.Rescaling(
        1.0 / 127.5,
        offset=-1
    )(x)

    x = base_model(
        x,
        training=False
    )

    x = layers.GlobalAveragePooling2D()(x)

    x = layers.BatchNormalization()(x)

    x = layers.Dropout(0.3)(x)

    outputs = layers.Dense(
        4,
        activation="softmax"
    )(x)

    model = models.Model(
        inputs,
        outputs
    )

    return model