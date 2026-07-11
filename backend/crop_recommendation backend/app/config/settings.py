from pydantic_settings import BaseSettings


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