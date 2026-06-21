from pydantic import BaseModel
from typing import Dict, Any


class PDFRequest(BaseModel):
    recommendation: dict