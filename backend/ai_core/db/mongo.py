from motor.motor_asyncio import AsyncIOMotorClient
from core.config import MONGO_URL, DB_NAME
import pymongo
import logging

logger = logging.getLogger("ai_core")

client = AsyncIOMotorClient(
    MONGO_URL,
    maxPoolSize=100,
    minPoolSize=10,
    serverSelectionTimeoutMS=5000,
    connectTimeoutMS=5000,
)

database = client[DB_NAME]


async def ping_database():
    try:
        await client.admin.command("ping")
        logger.info("MongoDB Atlas connected")
    except Exception as e:
        logger.error(f"MongoDB connection failed: {e}")
        raise


async def create_indexes():

    await database["users"].create_index(
        "google_id",
        unique=True,
    )

    await database["users"].create_index(
        "email",
        unique=True,
    )

    await database["user_conversations"].create_index(
        [
            ("user_id", pymongo.ASCENDING),
            ("updated_at", pymongo.DESCENDING),
        ]
    )

    await database["messages"].create_index(
        [
            ("conversation_id", pymongo.ASCENDING),
            ("created_at", pymongo.ASCENDING),
        ]
    )

    logger.info("Indexes ensured")