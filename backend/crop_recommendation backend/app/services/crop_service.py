import joblib
import pandas as pd
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent

MODEL_DIR = BASE_DIR / "ml_models"
DATA_DIR = BASE_DIR / "data"



crop_dataset = pd.read_csv(
    DATA_DIR / "synthetic_crop_dataset_10k.csv"
)

model = joblib.load(
    MODEL_DIR / "crop_model.pkl"
)


irrigation_encoder = joblib.load(
    MODEL_DIR / "irrigation_encoder.pkl"
)

previous_crop_encoder = joblib.load(
    MODEL_DIR / "previous_crop_encoder.pkl"
)

crop_encoder = joblib.load(
    MODEL_DIR / "crop_label_encoder.pkl"
)



class CropRecommendationService:

    @staticmethod
    def predict(data):



        irrigation_encoded = (
            irrigation_encoder.transform(
                [data.irrigation]
            )[0]
        )

        previous_crop_encoded = (
            previous_crop_encoder.transform(
                [data.previous_crop]
            )[0]
        )

        features = pd.DataFrame(
            [[
                data.N,
                data.P,
                data.K,
                data.pH,
                data.soil_moisture,
                data.temperature,
                data.humidity,
                data.rainfall,
                data.solar_radiation,
                data.elevation,
                irrigation_encoded,
                previous_crop_encoded
            ]],
            columns=[
                "N",
                "P",
                "K",
                "pH",
                "soil_moisture",
                "temperature",
                "humidity",
                "rainfall",
                "solar_radiation",
                "elevation",
                "irrigation",
                "previous_crop"
            ]
        )

        prediction = model.predict(features)

        probabilities = model.predict_proba(
            features
        )

        confidence = round(
            float(probabilities.max()) * 100,
            2
        )


        crop_name = (
            crop_encoder.inverse_transform(
                prediction
            )[0]
        )

        crop_rows = crop_dataset[
            crop_dataset["crop_label"] == crop_name
        ]

        recommended_conditions = {
            "N": round(
                crop_rows["N"].mean(),
                2
            ),
            "P": round(
                crop_rows["P"].mean(),
                2
            ),
            "K": round(
                crop_rows["K"].mean(),
                2
            ),
            "pH": round(
                crop_rows["pH"].mean(),
                2
            ),
            "soil_moisture": round(
                crop_rows["soil_moisture"].mean(),
                2
            ),
            "temperature": round(
                crop_rows["temperature"].mean(),
                2
            ),
            "humidity": round(
                crop_rows["humidity"].mean(),
                2
            ),
            "rainfall": round(
                crop_rows["rainfall"].mean(),
                2
            ),
            "solar_radiation": round(
                crop_rows["solar_radiation"].mean(),
                2
            ),
            "elevation": round(
                crop_rows["elevation"].mean(),
                2
            )
        }

        return {
            "recommended_crop": crop_name,
            "confidence": confidence,
            "recommended_conditions": recommended_conditions
        }