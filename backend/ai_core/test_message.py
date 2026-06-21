import asyncio

from services.message_service import (
    save_user_message,
    get_recent_messages
)


async def main():

    await save_user_message(
        conversation_id="conv_test",
        original_text="My maize crop has rust",
        english_text="My maize crop has rust",
        language="English"
    )

    messages = await get_recent_messages(
        "conv_test"
    )

    print(messages)


if __name__ == "__main__":
    asyncio.run(main())