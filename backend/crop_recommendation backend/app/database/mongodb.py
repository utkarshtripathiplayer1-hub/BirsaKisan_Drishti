import logging
import pymongo
from motor.motor_asyncio import AsyncIOMotorClient
from app.auth.config import MONGODB_URL

logger = logging.getLogger("crop_backend")

client = AsyncIOMotorClient(
    MONGODB_URL,
    maxPoolSize=100,
    minPoolSize=10,
    serverSelectionTimeoutMS=5000,
    connectTimeoutMS=5000,
)

db = client["crop_recommendation_database"]

crop_collection = db["crop_recommendations"]
disease_collection = db["disease_detections"]
weather_collection = db["weather_history"]
report_collection = db["reports"]
rotation_collection = db["crop_rotations"]
feedback_collection = db["feedback"]
users_collection = db["users"]
active_crop_collection = db["active_crops"]


async def ping_database():
    try:
        await client.admin.command("ping")
        logger.info("MongoDB connected")
    except Exception as e:
        logger.error(f"MongoDB connection failed: {e}")
        raise


async def create_indexes():
    # Most collections are queried by user_id, often sorted by recency.
    # Compound (user_id + created_at desc) covers both filter and sort.
    await crop_collection.create_index(
        [("user_id", pymongo.ASCENDING), ("created_at", pymongo.DESCENDING)]
    )
    await disease_collection.create_index(
        [("user_id", pymongo.ASCENDING), ("created_at", pymongo.DESCENDING)]
    )
    await weather_collection.create_index(
        [("user_id", pymongo.ASCENDING), ("created_at", pymongo.DESCENDING)]
    )
    await rotation_collection.create_index(
        [("user_id", pymongo.ASCENDING), ("created_at", pymongo.DESCENDING)]
    )
    await active_crop_collection.create_index(
        [("user_id", pymongo.ASCENDING), ("created_at", pymongo.DESCENDING)]
    )
    await feedback_collection.create_index("user_id")
    await report_collection.create_index("user_id")
    await users_collection.create_index("email", unique=True)
    logger.info("Indexes ensured")
