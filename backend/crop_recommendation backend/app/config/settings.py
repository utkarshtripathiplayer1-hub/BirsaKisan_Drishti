from pydantic_settings import BaseSettings
import os
from dotenv import load_dotenv

load_dotenv()


def optional(key: str, default=None):
    return os.getenv(key, default)


ALLOWED_ORIGINS = [
    o.strip() for o in optional("ALLOWED_ORIGINS", "http://localhost:3000").split(",")
    if o.strip()
]

class Settings(BaseSettings):
    MONGODB_URL: str
    DATABASE_NAME: str
    OPENWEATHER_API_KEY: str
    GOOGLE_CLIENT_ID: str
    JWT_SECRET_KEY: str
    JWT_ALGORITHM: str = "HS256"



    model_config = {
        "env_file": ".env",
        "extra": "ignore"
    }


settings = Settings()