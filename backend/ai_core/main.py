from fastapi import FastAPI 

from api.chat import router as chat_router 
from db.mongo import ping_database
from api.conversations import (
    router as conversation_router
)
from api.conversations import router as conversation_router
from fastapi.middleware.cors import CORSMiddleware
app = FastAPI(
    title="Birsakisan AI Core"
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # replace with frontend URL in production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Chat route (basic)

app.include_router(chat_router)

app.include_router(
    chat_router
)


app.include_router(
    conversation_router
)


app.include_router(conversation_router)