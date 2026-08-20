import os
from dotenv import load_dotenv

load_dotenv()


def require(key: str) -> str:
    """Fetch a required env var, or fail loudly at startup."""
    value = os.getenv(key)
    if value is None or value.strip() == "":
        raise RuntimeError(
            f"Missing required environment variable: {key}. "
            f"Set it in your .env (local) or Render dashboard (production)."
        )
    return value


def optional(key: str, default=None):
    """Fetch an optional env var with a default."""
    return os.getenv(key, default)


# ---- Required: app cannot run without these ----
GROQ_API_KEY   = require("GROQ_API_KEY")
GROQ_MODEL = optional("GROQ_MODEL", "qwen/qwen3.6-27b")
MONGO_URL      = require("MONGO_URL")
DB_NAME        = require("DB_NAME")
SARVAM_API_KEY = require("SARVAM_API_KEY")
SARVAM_CHAT_MODEL = os.getenv("SARVAM_CHAT_MODEL", "sarvam-m")
JWT_SECRET_KEY = require("JWT_SECRET_KEY")
GOOGLE_CLIENT_ID = require("GOOGLE_CLIENT_ID")

# ---- Required with sensible fallbacks ----
JWT_ALGORITHM     = optional("JWT_ALGORITHM", "HS256")
JWT_EXPIRE_MINUTES = int(optional("JWT_EXPIRE_MINUTES", 1440))
CROP_BACKEND_URL  = require("CROP_BACKEND_URL")  # ai_core calls crop backend — required

# ---- CORS ----
# Comma-separated in env: "https://app.vercel.app,http://localhost:3000"
ALLOWED_ORIGINS = [
    o.strip() for o in optional("ALLOWED_ORIGINS", "http://localhost:3000").split(",")
    if o.strip()
]

# ---- Optional: Bhashini (not used yet — switching from Sarvam later) ----
BHASHINI_INFERENCE_KEY = optional("BHASHINI_INFERENCE_KEY")
BHASHINI_USER_ID       = optional("BHASHINI_USER_ID")
BHASHINI_UDYAT_API_KEY = optional("BHASHINI_UDYAT_API_KEY")

