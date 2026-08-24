import os

from dotenv import load_dotenv


load_dotenv()


def require(key: str) -> str:
    """
    Fetch a required environment variable.

    Raises:
        RuntimeError: If the variable is missing or empty.
    """
    value = os.getenv(key)

    if value is None or value.strip() == "":
        raise RuntimeError(
            f"Missing required environment variable: {key}. "
            "Set it in your .env file locally or in the Render dashboard."
        )

    return value


def optional(key: str, default=None):
    """
    Fetch an optional environment variable.
    """
    return os.getenv(key, default)


# ============================================================
# LLM — Groq / Qwen
# ============================================================

GROQ_API_KEY = require("GROQ_API_KEY")

GROQ_MODEL = optional(
    "GROQ_MODEL",
    "qwen/qwen3.6-27b",
)


# ============================================================
# DATABASE — MongoDB
# ============================================================

MONGO_URL = require("MONGO_URL")

DB_NAME = require("DB_NAME")


# ============================================================
# SARVAM — Fallback Language Provider
# ============================================================

SARVAM_API_KEY = require("SARVAM_API_KEY")

SARVAM_CHAT_MODEL = optional(
    "SARVAM_CHAT_MODEL",
    "sarvam-m",
)


# ============================================================
# BHASHINI — Primary Language Provider
#
# Bhashini is optional so the application can still start
# and use Sarvam when Bhashini is unavailable.
# ============================================================

BHASHINI_INFERENCE_KEY = optional(
    "BHASHINI_INFERENCE_KEY"
)

BHASHINI_USER_ID = optional(
    "BHASHINI_USER_ID"
)

BHASHINI_UDYAT_API_KEY = optional(
    "BHASHINI_UDYAT_API_KEY"
)


# ============================================================
# CROP BACKEND
#
# Used by AI Core to retrieve:
# - Crop recommendation results
# - Disease detection results
# ============================================================

CROP_BACKEND_URL = require(
    "CROP_BACKEND_URL"
)


# ============================================================
# WEATHER — OpenWeather
#
# Optional because the chatbot should still work for
# non-weather questions if the weather service is unavailable.
# ============================================================

OPENWEATHER_API_KEY = optional(
    "OPENWEATHER_API_KEY"
)


# ============================================================
# AUTHENTICATION
# ============================================================

JWT_SECRET_KEY = require(
    "JWT_SECRET_KEY"
)

JWT_ALGORITHM = optional(
    "JWT_ALGORITHM",
    "HS256",
)

JWT_EXPIRE_MINUTES = int(
    optional(
        "JWT_EXPIRE_MINUTES",
        1440,
    )
)

GOOGLE_CLIENT_ID = require(
    "GOOGLE_CLIENT_ID"
)


# ============================================================
# CORS
# ============================================================

ALLOWED_ORIGINS = [
    origin.strip()
    for origin in optional(
        "ALLOWED_ORIGINS",
        "http://localhost:3000",
    ).split(",")
    if origin.strip()
]