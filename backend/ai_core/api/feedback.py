from fastapi import APIRouter, Depends

from core.dependencies import get_current_user

from schemas.feedback import (
    FeedbackRequest,
    FeedbackResponse,
)

from services.feedback_service import FeedbackService


router = APIRouter(
    prefix="/feedback",
    tags=["Feedback"],
)


@router.post(
    "",
    response_model=FeedbackResponse,
)
async def submit_feedback(
    request: FeedbackRequest,
    current_user=Depends(get_current_user),
):

    return await FeedbackService.submit_feedback(
        user_id=str(current_user["_id"]),
        rating=request.rating,
        comment=request.comment,
    )