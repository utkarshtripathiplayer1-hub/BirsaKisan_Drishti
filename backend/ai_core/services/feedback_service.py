from db.feedback_repository import FeedbackRepository


class FeedbackService:

    @staticmethod
    async def submit_feedback(
        user_id: str,
        rating: int,
        comment: str | None = None,
    ):

        await FeedbackRepository.create_feedback(
            user_id=user_id,
            rating=rating,
            comment=comment,
        )

        return {
            "message": "Feedback submitted successfully"
        }