from pymongo import MongoClient

#MONGO_URI = "mongodb+srv://krishidrishti_user:krishidrishti_27@cluster0.xjjbqhd.mongodb.net/?appName=Cluster0"

client = MongoClient(MONGO_URI)

db = client["crop_recommendation_database"]

crop_collection = db["crop_recommendations"]
disease_collection = db["disease_detections"]
weather_collection = db["weather_history"]
report_collection = db["reports"]
