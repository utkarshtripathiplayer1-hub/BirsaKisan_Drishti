from datetime import datetime, timezone

from fastapi import HTTPException

from app.database.mongodb import feedback_collection


class FeedbackService:

    @staticmethod
    async def submit_feedback(
        user_id: str,
        feedback_data,
    ):
        if not user_id:
            raise HTTPException(
                status_code=401,
                detail="Authenticated user required.",
            )

        feedback_doc = {
            "user_id": user_id,
            "rating": feedback_data.rating,
            "feedback": feedback_data.feedback.strip(),
            "created_at": datetime.now(timezone.utc),
        }

        result = await feedback_collection.insert_one(
            feedback_doc
        )

        return {
            "message": "Feedback submitted successfully.",
            "feedback_id": str(result.inserted_id),
        }


FeedbackService = FeedbackService