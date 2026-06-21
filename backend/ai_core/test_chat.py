import asyncio

from services.chat_service import process_chat


async def main():

    result = await process_chat(
        user_id="123",
        domain="agriculture",
        language="English",
        query="My maize crop has rust disease"
    )

    print(result)


if __name__ == "__main__":
    asyncio.run(main())