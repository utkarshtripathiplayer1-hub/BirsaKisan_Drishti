from groq import APIError, RateLimitError

async def ask_groq(messages: list):
    groq_messages = [{"role": "system", "content": AGRICULTURE_SYSTEM_PROMPT}]
    groq_messages.extend(messages)
    try:
        response = await client.chat.completions.create(
            model="llama-3.3-70b-versatile",
            messages=groq_messages,
            timeout=30,
            max_tokens=1024,
        )
        return response.choices[0].message.content
    except RateLimitError:
        raise HTTPException(503, "AI service busy, please retry in a moment.")
    except APIError as e:
        logger.error(f"Groq API error: {e}")
        raise HTTPException(502, "AI service temporarily unavailable.")