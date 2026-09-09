from groq import AsyncGroq

from core.config import (
    GROQ_API_KEY,
    GROQ_MODEL,
)


class GroqService:
    """
    Groq + Qwen service for Birsa Kisan Drishti.

    Supports:
        - Text-to-text
        - Conversation history
        - Automatic language detection
        - Hindi / English responses
    """

    def __init__(self):
        self.client = AsyncGroq(
            api_key=GROQ_API_KEY
        )

        self.model = GROQ_MODEL

    # ========================================================
    # GENERATE RESPONSE
    # ========================================================

    async def generate_response(
        self,
        user_text: str,
        conversation_history: list | None = None,
        language: str | None = None,
    ) -> str:

        if not user_text or not user_text.strip():
            raise ValueError(
                "User text cannot be empty"
            )

        # ====================================================
        # SYSTEM PROMPT
        # ====================================================

        system_prompt = """
You are Birsa Kisan Drishti, an AI-powered
agricultural assistant for Indian farmers.

Your job is to provide practical, simple and
safe agricultural guidance.

LANGUAGE RULES:

1. Detect the language of the farmer's latest message
   automatically.

2. If the farmer speaks Hindi, respond in Hindi.

3. If the farmer speaks English, respond in English.

4. If the farmer explicitly asks for another supported
   language, follow that request.

5. Never require the frontend to provide a language
   parameter.

6. Do not mix languages unnecessarily.

IMPORTANT AGRICULTURAL RULES:

1. Keep the response simple and easy to understand.

2. Avoid unnecessary technical terminology.

3. Give practical steps the farmer can actually follow.

4. Never claim certainty when the information is uncertain.

5. If more information is required, ask a short
   follow-up question.

6. Do not invent crop diseases, weather conditions,
   soil values or sensor readings.

7. For serious crop disease or pesticide decisions,
   recommend confirmation from an agricultural expert
   when appropriate.

8. Do not use markdown tables.

9. Do not use emojis.

10. Keep responses concise enough to be spoken naturally.

11. Answer the farmer's actual agricultural question.

You are responding as a helpful agricultural assistant
for Indian farmers.
"""

        # ====================================================
        # BUILD MESSAGE HISTORY
        # ====================================================

        messages = [
            {
                "role": "system",
                "content": system_prompt,
            }
        ]

        # Previous conversation
        if conversation_history:

            messages.extend(
                conversation_history
            )

        # Make sure the current message exists
        if not conversation_history:

            messages.append(
                {
                    "role": "user",
                    "content": user_text.strip(),
                }
            )

        # ====================================================
        # GROQ / QWEN
        # ====================================================

        response = await self.client.chat.completions.create(
            model=self.model,

            messages=messages,

            temperature=0.3,

            max_tokens=500,
        )

        # ====================================================
        # EXTRACT RESPONSE
        # ====================================================

        answer = response.choices[0].message.content

        if not answer:
            raise RuntimeError(
                "Groq returned an empty response"
            )

        return answer.strip()