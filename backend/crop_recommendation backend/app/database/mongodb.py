from pymongo import MongoClient
#ADD MONNGODBURL

client = MongoClient(MONGO_URI)

db = client["crop_recommendation_database"]

crop_collection = db["crop_recommendations"]
disease_collection = db["disease_detections"]
weather_collection = db["weather_history"]
report_collection = db["reports"]
