from groq import Groq

from core.config import GROQ_API_KEY
from core.prompts import AGRICULTURE_SYSTEM_PROMPT


client = Groq(
    api_key=GROQ_API_KEY
)


def ask_groq(messages: list):

    groq_messages = [
        {
            "role": "system",
            "content": AGRICULTURE_SYSTEM_PROMPT
        }
    ]

    groq_messages.extend(messages)

    response = client.chat.completions.create(
        model="llama-3.3-70b-versatile",
        messages=groq_messages
    )

    return response.choices[0].message.content