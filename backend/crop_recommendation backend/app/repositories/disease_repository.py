from datetime import datetime
from app.database.mongodb import disease_collection


class DiseaseRepository:

    async def save(self, data: dict):

        data["created_at"] = datetime.utcnow()

        result = await disease_collection.insert_one(data)

        return str(result.inserted_id)


disease_repository = DiseaseRepository()