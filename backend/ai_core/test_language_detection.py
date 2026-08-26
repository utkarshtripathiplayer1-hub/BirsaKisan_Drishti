import asyncio

from services.language_detection_service import detect_language


async def main():
    test_messages = [
        "Tell me about wheat farming.",
        "मुझे गेहूं की खेती के बारे में बताओ।",
        "मला गव्हाच्या शेतीबद्दल माहिती द्या.",
        "મને ઘઉંની ખેતી વિશે માહિતી આપો.",
        "எனக்கு கோதுமை சாகுபடி பற்றி சொல்லுங்கள்.",
        "Mujhe wheat ke liye fertilizer batao.",
    ]

    for message in test_messages:
        try:
            language = await detect_language(message)

            print("-" * 60)
            print("Message :", message)
            print("Detected:", language)

        except Exception as exc:
            print("-" * 60)
            print("Message :", message)
            print("ERROR   :", exc)


if __name__ == "__main__":
    asyncio.run(main())