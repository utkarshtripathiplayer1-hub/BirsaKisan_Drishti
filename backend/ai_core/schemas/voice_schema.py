from pydantic import BaseModel

class VoiceResponse(BaseModel):
    transcript: str

class VoiceChatResponse(BaseModel):
    conversation_id: str
    transcript: str
    response: str
class TTSResponse(BaseModel):
    message: str