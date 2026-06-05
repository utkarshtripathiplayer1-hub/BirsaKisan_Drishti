from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    MONGODB_URL: str
    DATABASE_NAME: str
    OPENWEATHER_API_KEY: str

    model_config = {
        "env_file": ".env",
        "extra": "ignore"
    }


settings = Settings()