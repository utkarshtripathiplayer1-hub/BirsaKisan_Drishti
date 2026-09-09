from fastapi import APIRouter, HTTPException

from services.bhashini_service import BhashiniService


# ============================================================
# Router
# ============================================================

router = APIRouter(
    prefix="/api/bhashini",
    tags=["Bhashini"],
)


# ============================================================
# Service
# ============================================================

bhashini_service = BhashiniService()


# ============================================================
# Pipeline Configuration
# ============================================================

@router.get("/config")
async def get_bhashini_config(
    language: str = "hi",
):
    """
    Get Bhashini pipeline configuration
    for a specific language.

    Example:
        /api/bhashini/config?language=hi
    """

    try:

        result = await bhashini_service.get_pipeline_config(
            source_language=language,
        )

        return result

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# Pipeline / Model Search
# ============================================================

@router.get("/search")
async def search_bhashini_pipelines(
    task_type: str | None = None,
    source_language: str | None = None,
    target_language: str | None = None,
):
    """
    Search Bhashini models.

    Examples:

        ASR Hindi:
        /api/bhashini/search?task_type=asr&source_language=hi

        TTS Hindi:
        /api/bhashini/search?task_type=tts&source_language=hi
    """

    try:

        result = await bhashini_service.search_pipelines(
            task_type=task_type,
            source_language=source_language,
            target_language=target_language,
        )

        return result

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )


# ============================================================
# Search ASR Models for All 10 Languages
# ============================================================

@router.get("/asr/languages")
async def search_all_asr_languages():
    """
    Search Bhashini for ASR models for all
    10 languages supported by the project.
    """

    try:

        result = await (
            bhashini_service.search_all_asr_languages()
        )

        return result

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )
# ============================================================
# Search TTS Models for All 10 Languages
# ============================================================

@router.get("/tts/languages")
async def search_all_tts_languages():
    """
    Search Bhashini for TTS models for all
    10 languages supported by the project.
    """

    try:

        result = await (
            bhashini_service.search_all_tts_languages()
        )

        return result

    except Exception as e:

        raise HTTPException(
            status_code=500,
            detail=str(e),
        )