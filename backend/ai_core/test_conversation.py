import asyncio

from services.conversation_service import create_conversation


async def main():
    result = await create_conversation(
        user_id="123",
        domain="agriculture",
        language="English",
        first_message="My maize crop has Common Rust disease"
    )

    print(result)


if __name__ == "__main__":
    asyncio.run(main())