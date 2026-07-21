import os
from dotenv import load_dotenv

load_dotenv()


def require(key: str) -> str:
    value = os.getenv(key)
    if value is None or value.strip() == "":
        raise RuntimeError(
            f"Missing required environment variable: {key}. "
            f"Set it in your .env (local) or Render dashboard (production)."
        )
    return value


def optional(key: str, default=None):
    return os.getenv(key, default)


MONGODB_URL = require("MONGODB_URL")
AI_CORE_URL = require("AI_CORE_URL")   # crop backend calls ai_core — required

# You also reference GROQ_API_KEY in groq_service.py — make it fail-fast too:
GROQ_API_KEY = require("GROQ_API_KEY")

# CORS origins (comma-separated in env)
ALLOWED_ORIGINS = [
    o.strip() for o in optional("ALLOWED_ORIGINS", "http://localhost:3000").split(",")
    if o.strip()
]