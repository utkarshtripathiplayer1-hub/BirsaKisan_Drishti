from datetime import datetime
from app.database.mongodb import report_collection


class ReportRepository:

    async def save(self, data: dict):

        data["created_at"] = datetime.utcnow()

        result = await report_collection.insert_one(data)

        return str(result.inserted_id)


report_repository = ReportRepository()