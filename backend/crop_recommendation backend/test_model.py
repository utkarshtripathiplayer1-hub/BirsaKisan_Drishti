import joblib

encoder = joblib.load("app/ml_models/soil_encoder.pkl")
print(encoder.classes_)
