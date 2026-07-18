from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from db.mongo import ping_database

from api.chat import router as chat_router
from api.auth import router as auth_router
from api.conversations import router as conversation_router
from api.voice import router as voice_router
from api.crop_profile import router as crop_profile_router
from api.account import router as account_router
from api.feedback import router as feedback_router

app = FastAPI(
    title="Birsakisan AI Core"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(auth_router)
app.include_router(chat_router)
app.include_router(conversation_router)
app.include_router(voice_router)
app.include_router(crop_profile_router)
app.include_router(account_router)
app.include_router(feedback_router)
