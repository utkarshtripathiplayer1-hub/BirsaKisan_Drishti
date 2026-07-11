from datetime import datetime


def feedback_document(user_id: str, rating: int, feedback: str):
    return {
        "user_id": user_id,
        "rating": rating,
        "feedback": feedback,
        "created_at": datetime.utcnow(),
        "status": "new"
    }