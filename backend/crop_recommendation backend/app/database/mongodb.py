from motor.motor_asyncio import AsyncIOMotorClient

from app.config.settings import settings


client = None
database = None


async def connect_to_mongo():

    global client
    global database

    client = AsyncIOMotorClient(
        settings.MONGODB_URL
    )

    database = client[
        settings.DATABASE_NAME
    ]

    print("✅ MongoDB Atlas Connected")


async def close_mongo_connection():

    global client

    if client:
        client.close()

    print("❌ MongoDB Connection Closed")from motor.motor_asyncio import AsyncIOMotorClient

from app.config.settings import settings


client = None
database = None


async def connect_to_mongo():

    global client
    global database

    client = AsyncIOMotorClient(
        settings.MONGODB_URL
    )

    await client.admin.command("ping")
    
    database = client[
        settings.DATABASE_NAME
    ]

    print("✅ MongoDB Atlas Connected")


async def close_mongo_connection():

    global client

    if client:
        client.close()

    print("❌ MongoDB Connection Closed")