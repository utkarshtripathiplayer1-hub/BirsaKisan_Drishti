import asyncio
from sarvamai import SarvamAI
from core.config import SARVAM_API_KEY

client = SarvamAI(api_subscription_key=SARVAM_API_KEY)

LANGUAGE_MAP = {
    "en": "en-IN",
    "hi": "hi-IN",
    "mr": "mr-IN",
    "ta": "ta-IN",
    "te": "te-IN",
    "kn": "kn-IN",
    "ml": "ml-IN",
    "gu": "gu-IN",
    "pa": "pa-IN",
    "bn": "bn-IN",
    "or": "or-IN",
}

LANGUAGE_NAMES = {
    "en": "English",
    "hi": "Hindi",
    "mr": "Marathi",
    "ta": "Tamil",
    "te": "Telugu",
    "kn": "Kannada",
    "ml": "Malayalam",
    "gu": "Gujarati",
    "pa": "Punjabi",
    "bn": "Bengali",
    "or": "Odia",
}


async def translate_text(text: str, source_language: str, target_language: str) -> str:
    """Translate text using Sarvam AI (offloaded to threadpool since SDK is sync)."""
    if source_language == target_language:
        return text
    try:
        response = await asyncio.to_thread(
            client.text.translate,
            input=text,
            source_language_code=LANGUAGE_MAP[source_language],
            target_language_code=LANGUAGE_MAP[target_language],
            speaker_gender="Male",
        )
        return response.translated_text
    except KeyError:
        logger.warning(f"Unsupported language: {source_language} or {target_language}")
        return text
    except Exception as e:
        logger.error(f"Sarvam translation failed: {e}")
        return text