from app.ml_models.feedback_model import feedback_document
from app.database.mongodb import feedback_collection


class FeedbackService:

    @staticmethod
    async def submit_feedback(user_id: str, feedback_data):
        document = feedback_document(
            user_id=user_id,
            rating=feedback_data.rating,
            feedback=feedback_data.feedback
        )

        result = await feedback_collection.insert_one(document)

        return {
            "message": "Feedback submitted successfully",
            "feedback_id": str(result.inserted_id)
        }