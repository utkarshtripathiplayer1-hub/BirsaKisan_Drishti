import re 

STOP_WORDS = {
    "my",
    "the",
    "a",
    "an",
    "is",
    "are",
    "please",
    "help",
    "with",
    "about",
    "for",
    "me",
    "i",
    "need"
}

def generate_title(query: str) -> str:
    """
    Generate a rule-based conversation title from the user's first message.
    """

    words = query.lower().split()

    filtered_words = [
        word 
        for word in words if word not in STOP_WORDS
    ]

    filtered_words = filtered_words[:5]

    title = " ".join(filtered_words)

    title = re.sub(r"[^a-zA-Z0-9\s]","", title)

    title = title.title()

    if not title:
        return "New Agriculture chat"

    return title