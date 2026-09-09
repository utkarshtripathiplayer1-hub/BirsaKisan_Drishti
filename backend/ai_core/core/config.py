import os
from pathlib import Path
from dotenv import load_dotenv

load_dotenv()


def get_env(name: str, required: bool = True) -> str | None:
    value = os.getenv(name)

    if required and not value:
        raise RuntimeError(f"{name} is missing")

    return value
BASE_DIR = Path(__file__).resolve().parent.parent

ENV_FILE = BASE_DIR / ".env"

load_dotenv(ENV_FILE)

# =========================
# MongoDB
# =========================

MONGO_URL = os.getenv("MONGO_URL")
DB_NAME = os.getenv("DB_NAME")


# =========================
# Groq
# =========================

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
GROQ_MODEL = os.getenv("GROQ_MODEL")


# =========================
# Bhashini
# =========================

BHASHINI_USER_ID = os.getenv("BHASHINI_USER_ID")
BHASHINI_ULCA_API_KEY = os.getenv("BHASHINI_ULCA_API_KEY")
BHASHINI_INFERENCE_KEY = os.getenv("BHASHINI_INFERENCE_KEY")
BHASHINI_INFERENCE_URL = (
    os.getenv(
        "BHASHINI_INFERENCE_URL",
        "https://dhruva-api.bhashini.gov.in/services/inference/pipeline",
    )
)

BHASHINI_ASR_SERVICE_ID = get_env(
    "BHASHINI_ASR_SERVICE_ID"
)

BHASHINI_TTS_SERVICE_ID = get_env(
    "BHASHINI_TTS_SERVICE_ID"
)


# =========================
# Sarvam
# =========================

SARVAM_API_KEY = os.getenv("SARVAM_API_KEY")
SARVAM_CHAT_MODEL = os.getenv("SARVAM_CHAT_MODEL")


# =========================
# Other services
# =========================

CROP_BACKEND_URL = os.getenv("CROP_BACKEND_URL")
ALLOWED_ORIGINS = os.getenv("ALLOWED_ORIGINS")


# =========================
# JWT
# =========================

JWT_ALGORITHM = os.getenv("JWT_ALGORITHM", "HS256")

JWT_EXPIRE_MINUTES = int(
    os.getenv("JWT_EXPIRE_MINUTES", "1440")
)


# =========================
# Google Auth
# =========================

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")

JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
# =========================
# OpenWeather
# =========================

OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")