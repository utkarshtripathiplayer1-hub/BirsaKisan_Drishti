import json
from pathlib import Path


BASE_DIR = Path(__file__).resolve().parent.parent
KNOWLEDGE_PATH = BASE_DIR / "data" / "crop_knowledge.json"


class CropKnowledgeService:

    def __init__(self):
        with open(KNOWLEDGE_PATH, "r") as f:
            self.data = json.load(f)

    def get_crop_info(self, crop_name: str):
        return self.data.get(crop_name.lower())


crop_knowledge_service = CropKnowledgeService()