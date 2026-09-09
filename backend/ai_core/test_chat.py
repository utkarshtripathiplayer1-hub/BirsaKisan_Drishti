import asyncio

from services.groq_service import GroqService


async def main():

    service = GroqService()

    response = await service.generate_response(
        "मेरी फसल में बीमारी है"
    )

    print("\nAI RESPONSE:")
    print(response)


if __name__ == "__main__":
    asyncio.run(main())