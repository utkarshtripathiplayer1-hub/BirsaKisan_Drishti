import tensorflow as tf
from tensorflow.keras import layers, models
from tensorflow.keras.applications import MobileNetV2
from tensorflow.keras.preprocessing import image_dataset_from_directory

import matplotlib.pyplot as plt
import os

# ==========================
# PATHS
# ==========================

DATASET_PATH = "crop_classifier"
MODEL_PATH = "models/crop_classifier.keras"

os.makedirs("models", exist_ok=True)
os.makedirs("plots", exist_ok=True)

# ==========================
# PARAMETERS
# ==========================

IMG_SIZE = (224, 224)
BATCH_SIZE = 32
EPOCHS = 10

# ==========================
# LOAD DATASET
# ==========================

train_ds = image_dataset_from_directory(
    DATASET_PATH,
    validation_split=0.2,
    subset="training",
    seed=123,
    image_size=IMG_SIZE,
    batch_size=BATCH_SIZE
)

val_ds = image_dataset_from_directory(
    DATASET_PATH,
    validation_split=0.2,
    subset="validation",
    seed=123,
    image_size=IMG_SIZE,
    batch_size=BATCH_SIZE
)

class_names = train_ds.class_names

print("\nCrop Classes:")
print(class_names)

# ==========================
# DATA AUGMENTATION
# ==========================

data_augmentation = tf.keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.1),
    layers.RandomZoom(0.1)
])

AUTOTUNE = tf.data.AUTOTUNE

train_ds = train_ds.prefetch(AUTOTUNE)
val_ds = val_ds.prefetch(AUTOTUNE)

# ==========================
# MOBILENETV2
# ==========================

base_model = MobileNetV2(
    input_shape=(224, 224, 3),
    include_top=False,
    weights="imagenet"
)

base_model.trainable = True

for layer in base_model.layers[:-80]:
    layer.trainable = False

# ==========================
# MODEL
# ==========================

inputs = tf.keras.Input(shape=(224, 224, 3))

x = data_augmentation(inputs)

x = layers.Rescaling(1./127.5, offset=-1)(x)

x = base_model(x, training=False)

x = layers.GlobalAveragePooling2D()(x)

x = layers.BatchNormalization()(x)

x = layers.Dropout(0.3)(x)

outputs = layers.Dense(
    len(class_names),
    activation="softmax"
)(x)

model = models.Model(inputs, outputs)

# ==========================
# COMPILE
# ==========================

model.compile(
    optimizer=tf.keras.optimizers.Adam(
        learning_rate=1e-4
    ),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"]
)

# ==========================
# CALLBACKS
# ==========================

callbacks = [

    tf.keras.callbacks.EarlyStopping(
        monitor="val_loss",
        patience=3,
        restore_best_weights=True
    ),

    tf.keras.callbacks.ReduceLROnPlateau(
        monitor="val_loss",
        factor=0.3,
        patience=2,
        min_lr=1e-6
    )
]

# ==========================
# TRAIN
# ==========================

history = model.fit(
    train_ds,
    validation_data=val_ds,
    epochs=EPOCHS,
    callbacks=callbacks
)

# ==========================
# SAVE MODEL
# ==========================

model.save(MODEL_PATH)

print(f"\nModel saved to {MODEL_PATH}")

# ==========================
# ACCURACY PLOT
# ==========================

plt.figure(figsize=(8,5))

plt.plot(
    history.history["accuracy"],
    label="Train Accuracy"
)

plt.plot(
    history.history["val_accuracy"],
    label="Validation Accuracy"
)

plt.title("Crop Classifier Accuracy")
plt.xlabel("Epoch")
plt.ylabel("Accuracy")
plt.legend()

plt.savefig(
    "plots/crop_classifier_accuracy.png"
)

plt.close()

# ==========================
# LOSS PLOT
# ==========================

plt.figure(figsize=(8,5))

plt.plot(
    history.history["loss"],
    label="Train Loss"
)

plt.plot(
    history.history["val_loss"],
    label="Validation Loss"
)

plt.title("Crop Classifier Loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.legend()

plt.savefig(
    "plots/crop_classifier_loss.png"
)

plt.close()

print("\nTraining Completed Successfully!")