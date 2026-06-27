from datetime import datetime
from app.database.mongodb import weather_collection


class WeatherRepository:

    def save(self, data: dict):

        data["created_at"] = datetime.utcnow()

        result = weather_collection.insert_one(data)

        return str(result.inserted_id)


weather_repository = WeatherRepository()