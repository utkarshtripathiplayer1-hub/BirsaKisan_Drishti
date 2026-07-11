import tensorflow as tf

from tensorflow.keras.applications import MobileNetV2


def build_cashew_model():

    base_model = MobileNetV2(
        input_shape=(224, 224, 3),
        include_top=False,
        weights=None
    )

    base_model.trainable = True

    model = tf.keras.Sequential([
        tf.keras.layers.Rescaling(1.0 / 255),

        base_model,

        tf.keras.layers.GlobalAveragePooling2D(),

        tf.keras.layers.Dropout(0.2),

        tf.keras.layers.Dense(
            5,
            activation="softmax"
        )
    ])

    model.build(
        (None, 224, 224, 3)
    )

    return model