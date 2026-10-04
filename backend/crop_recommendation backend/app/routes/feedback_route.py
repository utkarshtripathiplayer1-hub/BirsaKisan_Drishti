
from fastapi import APIRouter, Depends

from app.auth.dependencies import require_project
from app.schemas.feedback_Schemas import FeedbackCreate
from app.services.feedback_service import FeedbackService

router = APIRouter(
    prefix="/feedback",
    tags=["Feedback"]
)


@router.post("/")
async def submit_feedback(
    feedback: FeedbackCreate,
    current_user: dict = Depends(require_project("crop"))
):
    return await FeedbackService.submit_feedback(
        user_id=current_user["sub"],
        feedback_data=feedback
    )
