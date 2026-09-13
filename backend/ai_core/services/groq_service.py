from groq import AsyncGroq

from core.config import (
    GROQ_API_KEY,
    GROQ_MODEL,
)


class GroqService:

    def __init__(self):
        self.client = AsyncGroq(
            api_key=GROQ_API_KEY
        )
        self.model = GROQ_MODEL

    async def generate_response(
        self,
        user_text: str,
        conversation_history: list | None = None,
        language: str | None = None,
    ) -> str:

        if not user_text or not user_text.strip():
            raise ValueError("User text cannot be empty")

        if language == "hi":
            language_instruction = "Hindi"
        elif language == "en":
            language_instruction = "English"
        else:
            language_instruction = (
                "the same language as the farmer's latest message"
            )

        system_prompt = f"""
You are Birsa Kisan Drishti, an AI-powered
agricultural assistant for Indian farmers.

Provide practical, simple and safe agricultural guidance.

LANGUAGE:
- Respond in {language_instruction}.
- If no language is provided, detect the language
  from the farmer's latest message.
- Do not unnecessarily mix languages.

RULES:
1. Keep responses simple and easy to understand.
2. Avoid unnecessary technical terminology.
3. Give practical steps the farmer can follow.
4. Do not invent diseases, weather, soil values,
   sensor readings or other information.
5. If information is uncertain, say so.
6. Ask a short follow-up question when necessary.
7. For serious disease or pesticide decisions,
   recommend agricultural expert confirmation.
8. Do not use markdown tables.
9. Do not use emojis.
10. Keep responses concise and suitable for speech.
11. Answer the farmer's actual question.
12. Use previous conversation messages as context.
"""

        messages = [
            {
                "role": "system",
                "content": system_prompt,
            }
        ]

        if conversation_history:
            messages.extend(conversation_history)

        else:
            messages.append(
                {
                    "role": "user",
                    "content": user_text.strip(),
                }
            )

        response = await self.client.chat.completions.create(
            model=self.model,
            messages=messages,
            temperature=0.3,
            max_tokens=500,
        )

        answer = response.choices[0].message.content

        if not answer:
            raise RuntimeError(
                "Groq returned an empty response"
            )

        return answer.strip()