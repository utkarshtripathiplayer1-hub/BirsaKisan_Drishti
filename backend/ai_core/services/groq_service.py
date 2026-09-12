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
        - Voice-to-text-to-text
        - Conversation history
        - Hindi / English responses
        - Automatic language detection
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
        # LANGUAGE
        # ====================================================

        if language == "hi":
            language_instruction = "Hindi"

        elif language == "en":
            language_instruction = "English"

        else:
            language_instruction = (
                "the same language as the farmer's latest message"
            )

        # ====================================================
        # SYSTEM PROMPT
        # ====================================================

        system_prompt = f"""
You are Birsa Kisan Drishti, an AI-powered
agricultural assistant for Indian farmers.

Your job is to provide practical, simple and
safe agricultural guidance.

LANGUAGE RULES:

1. Respond in {language_instruction}.

2. If the requested language is Hindi,
   respond completely in Hindi.

3. If the requested language is English,
   respond completely in English.

4. Do not unnecessarily mix Hindi and English.

5. If language is not explicitly provided,
   detect the language of the farmer's latest message.

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

12. Use the previous conversation messages as context.

You are responding as a helpful agricultural assistant
for Indian farmers.
"""

        # ====================================================
        # BUILD MESSAGES
        # ====================================================

        messages = [
            {
                "role": "system",
                "content": system_prompt,
            }
        ]

        if conversation_history:

            messages.extend(
                conversation_history
            )

        else:

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