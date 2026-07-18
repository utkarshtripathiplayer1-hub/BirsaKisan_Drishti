from dotenv import load_dotenv
import os

load_dotenv()
MONGODB_URL = os.getenv("MONGODB_URL")
AI_CORE_URL = os.getenv("AI_CORE_URL")