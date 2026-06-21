from sarvamai import SarvamAI 
from core.config import SARVAM_API_KEY

client=SarvamAI(
    api_subscription_key=SARVAM_API_KEY
)

LANGUAGE_MAP = {

    "en": "en-IN",#english
    "hi": "hi-IN",#hindi
    "mr": "mr-IN",#marathi
    "ta": "ta-IN",#tamil
    "te": "te-IN",
    "kn": "kn-IN",
    "ml": "ml-IN",
    "gu": "gu-IN",
    "pa": "pa-IN",
    "bn": "bn-IN",
    "or": "or-IN"
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
    "or": "Odia"
}

def translate_text(
    text:str,
    source_language:str,
    target_language:str):

    """
    Translate text using sarvam AI
    """

    try:
        response = client.text.translate(
            input=text,
            source_language_code=LANGUAGE_MAP[source_language],
            target_language_code=LANGUAGE_MAP[target_language],
            speaker_gender="Male"
        )

        return response.translated_text
    
    except Exception as e:

        print("Sarvam Translation Error:", e)

        return text