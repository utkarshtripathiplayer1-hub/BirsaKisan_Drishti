from datetime import datetime

from db.collections import feedback


class FeedbackRepository:

    @staticmethod
    async def create_feedback(
        user_id: str,
        rating: int,
        comment: str | None,
    ):

        document = {
            "user_id": user_id,
            "rating": rating,
            "comment": comment,
            "created_at": datetime.utcnow(),
        }

        await feedback.insert_one(document)