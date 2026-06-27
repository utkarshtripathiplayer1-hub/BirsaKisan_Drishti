import joblib

model = joblib.load("app/ml_models/crop_model.pkl")

print(model.feature_names_in_)