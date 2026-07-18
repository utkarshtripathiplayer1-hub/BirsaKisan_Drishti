from pymongo import MongoClient
from app.auth.config import MONGODB_URL

db = client["crop_recommendation_database"]

crop_collection = db["crop_recommendations"]
disease_collection = db["disease_detections"]
weather_collection = db["weather_history"]
report_collection = db["reports"]
rotation_collection = db["crop_rotations"]
feedback_collection = db["feedback"]
users_collection = db["users"]
active_crop_collection = db["active_crops"]
