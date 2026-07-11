from fastapi import APIRouter
from app.schemas.feedback_Schemas import FeedbackCreate
from app.services.feedback_service import FeedbackService

router = APIRouter(prefix="/feedback", tags=["Feedback"])

@router.post("/")
async def submit_feedback(feedback: FeedbackCreate):
    return await FeedbackService.submit_feedback(feedback)