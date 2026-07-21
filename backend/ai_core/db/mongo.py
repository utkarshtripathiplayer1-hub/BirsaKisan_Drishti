from motor.motor_asyncio import AsyncIOMotorClient
from core.config import MONGO_URL, DB_NAME
import pymongo
import logging
logger = logging.getLogger("ai_core")
client = AsyncIOMotorClient(
    MONGO_URL,
    maxPoolSize=100,        # cap concurrent connections (tune to Atlas tier)
    minPoolSize=10,         # keep warm connections ready
    serverSelectionTimeoutMS=5000,   # fail fast if Atlas unreachable
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
    # users
    await database["users"].create_index("google_id", unique=True)
    await database["users"].create_index("email", unique=True)

    # user_conversations
    await database["user_conversations"].create_index("conversation_id", unique=True)
    # compound: filter by user_id, sort by updated_at desc
    await database["user_conversations"].create_index(
        [("user_id", pymongo.ASCENDING), ("updated_at", pymongo.DESCENDING)]
    )
    logger.info("Indexes ensured")