import os
import shutil


print("Current Working Directory:")
print(os.getcwd())

SOURCE_DATASETS = {
    "maize": "data/maize",
    "cassava": "data/cassava",
    "tomato": "data/tomato",
    "cashew": "data/cashew"
}

DESTINATION_ROOT = "data/crop_classifier"

VALID_EXTENSIONS = (
    ".jpg",
    ".jpeg",
    ".png",
    ".bmp",
    ".webp"
)

for crop_name, source_path in SOURCE_DATASETS.items():

    destination_path = os.path.join(
        DESTINATION_ROOT,
        crop_name
    )

    os.makedirs(
        destination_path,
        exist_ok=True
    )

    copied_count = 0

    for root, dirs, files in os.walk(source_path):

        for file in files:

            if file.lower().endswith(
                VALID_EXTENSIONS
            ):

                source_file = os.path.join(
                    root,
                    file
                )

                destination_file = os.path.join(
                    destination_path,
                    f"{copied_count}_{file}"
                )

                shutil.copy2(
                    source_file,
                    destination_file
                )

                copied_count += 1

    print(
        f"{crop_name}: "
        f"{copied_count} images copied"
    )

print("\nCrop classifier dataset created successfully!")