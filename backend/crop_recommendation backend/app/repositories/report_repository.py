from datetime import datetime
from app.database.mongodb import report_collection


class ReportRepository:

    def save(self, data: dict):

        data["created_at"] = datetime.utcnow()

        result = report_collection.insert_one(
            data
        )

        return str(result.inserted_id)


report_repository = ReportRepository()