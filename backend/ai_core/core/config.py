from dotenv import load_dotenv
import os

load_dotenv()

GROQ_API_KEY = os.getenv("GROQ_API_KEY")
MONGO_URL = os.getenv("MONGO_URL")
DB_NAME=os.getenv("DB_NAME")
SARVAM_API_KEY=os.getenv("SARVAM_API_KEY")

GOOGLE_CLIENT_ID = os.getenv("GOOGLE_CLIENT_ID")
JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY")
JWT_ALGORITHM = os.getenv("JWT_ALGORITHM")
JWT_EXPIRE_MINUTES = int(os.getenv("JWT_EXPIRE_MINUTES", 1440))
BHASHINI_INFERENCE_KEY = os.getenv(
    "BHASHINI_INFERENCE_KEY"
)

BHASHINI_USER_ID = os.getenv(
    "BHASHINI_USER_ID"
)

BHASHINI_UDYAT_API_KEY = os.getenv(
    "BHASHINI_UDYAT_API_KEY"
)

