import logging
import re
from collections import Counter
from typing import Optional
from services.groq_service import (
    GroqServiceError,
    generate_response,
)


logger = logging.getLogger("ai_core.language_detection")


# ============================================================
# Supported languages
# ============================================================

SUPPORTED_LANGUAGES = {
    "en": "English",
    "hi": "Hindi",
    "mr": "Marathi",
    "ta": "Tamil",
    "te": "Telugu",
    "kn": "Kannada",
    "ml": "Malayalam",
    "gu": "Gujarati",
    "pa": "Punjabi",
    "bn": "Bengali",
    "or": "Odia",
}


class LanguageDetectionError(Exception):
    """Raised when language detection fails."""


# ============================================================
# Unicode script ranges
# ============================================================

SCRIPT_PATTERNS = {
    "gu": re.compile(r"[\u0A80-\u0AFF]"),
    "pa": re.compile(r"[\u0A00-\u0A7F]"),
    "bn": re.compile(r"[\u0980-\u09FF]"),
    "or": re.compile(r"[\u0B00-\u0B7F]"),
    "ta": re.compile(r"[\u0B80-\u0BFF]"),
    "te": re.compile(r"[\u0C00-\u0C7F]"),
    "kn": re.compile(r"[\u0C80-\u0CFF]"),
    "ml": re.compile(r"[\u0D00-\u0D7F]"),
    "devanagari": re.compile(r"[\u0900-\u097F]"),
}


# ============================================================
# Native-script language hints
# ============================================================

HINDI_HINTS = {
    "मुझे",
    "मेरा",
    "मेरी",
    "मेरे",
    "आप",
    "आपका",
    "आपकी",
    "क्या",
    "कैसे",
    "कैसी",
    "कौन",
    "किस",
    "किसान",
    "खेती",
    "फसल",
    "गेहूं",
    "धान",
    "बताओ",
    "बताइए",
    "करना",
    "करें",
    "चाहिए",
    "बारे",
    "लिए",
    "है",
    "हैं",
    "और",
    "यह",
    "वह",
}


MARATHI_HINTS = {
    "मला",
    "माझा",
    "माझी",
    "माझे",
    "माझ्या",
    "तुम्ही",
    "तुमचा",
    "तुमची",
    "काय",
    "कसे",
    "कशी",
    "कोण",
    "किसान",
    "शेती",
    "पीक",
    "पिक",
    "गहू",
    "सांगा",
    "सांगावे",
    "करावे",
    "करायचे",
    "पाहिजे",
    "बद्दल",
    "साठी",
    "आहे",
    "आहेत",
    "आणि",
    "हे",
    "ते",
}


# ============================================================
# Roman / Latin language keywords
# ============================================================

ROMAN_LANGUAGE_HINTS = {

    "hi": {
        "mujhe",
        "mujhko",
        "mera",
        "meri",
        "mere",
        "meri",
        "humara",
        "hamara",
        "aap",
        "aapka",
        "aapki",
        "aapke",
        "kya",
        "kaise",
        "kaisa",
        "kaisi",
        "kaun",
        "kis",
        "kisko",
        "kyun",
        "kyon",
        "batao",
        "bataiye",
        "bataye",
        "chahiye",
        "karna",
        "karo",
        "kare",
        "karen",
        "hai",
        "hain",
        "ke",
        "liye",
        "mein",
        "me",
        "se",
        "par",
        "aur",
        "fasal",
        "kheti",
        "gehu",
        "gehun",
        "dhaan",
        "rog",
        "bimari",
        "pani",
        "mitti",
        "khad",
        "khaad",
    },

    "mr": {
        "mala",
        "majha",
        "majhi",
        "majhe",
        "majhya",
        "tumhi",
        "tumcha",
        "tumchi",
        "tumche",
        "kay",
        "kase",
        "kashi",
        "kon",
        "ka",
        "kaay",
        "sanga",
        "sangaa",
        "sangave",
        "karave",
        "karayche",
        "pahije",
        "ahe",
        "aahe",
        "ahet",
        "aani",
        "ani",
        "baddal",
        "sathi",
        "sheti",
        "pik",
        "peeka",
        "gahu",
        "rog",
        "pani",
        "mati",
        "khata",
    },

    "gu": {
        "mane",
        "maru",
        "mari",
        "mara",
        "tamne",
        "tamaru",
        "shu",
        "su",
        "kem",
        "kevi",
        "kayu",
        "kaayu",
        "kaho",
        "kahesho",
        "joie",
        "karvu",
        "karvu",
        "che",
        "chhe",
        "chhu",
        "ane",
        "mate",
        "ma",
        "thi",
        "kheti",
        "pak",
        "paan",
        "gehu",
        "rog",
        "pani",
        "jamin",
        "khatar",
    },

    "ta": {
        "enakku",
        "enna",
        "eppadi",
        "eppothu",
        "yaar",
        "yen",
        "sollunga",
        "sollungal",
        "venum",
        "vendum",
        "seyyavendum",
        "irukku",
        "irukkirathu",
        "matrum",
        "patri",
        "kku",
        "la",
        "vivasayam",
        "payir",
        "nel",
        "godhumai",
        "noi",
        "thanneer",
        "mann",
    },

    "te": {
        "naaku",
        "naku",
        "na",
        "naa",
        "naadi",
        "mee",
        "meeku",
        "emi",
        "ela",
        "enduku",
        "evaru",
        "cheppandi",
        "cheppu",
        "kaavali",
        "kavali",
        "cheyyali",
        "undi",
        "unnadi",
        "mariyu",
        "gurinchi",
        "kosam",
        "vyavasayam",
        "panta",
        "vari",
        "godhuma",
        "roga",
        "neeru",
        "nel",
    },

    "kn": {
        "nanage",
        "nanna",
        "nanu",
        "nimge",
        "nimma",
        "enu",
        "yenu",
        "hege",
        "yaake",
        "yaaru",
        "heli",
        "heliri",
        "beku",
        "madabeku",
        "ide",
        "mattu",
        "bagge",
        "gagi",
        "krushi",
        "bele",
        "godi",
        "rog",
        "neeru",
        "mannu",
    },

    "ml": {
        "enikku",
        "enik",
        "ente",
        "ente",
        "ningalkku",
        "ningalude",
        "enthaanu",
        "entha",
        "engane",
        "enthukondu",
        "aaranu",
        "parayu",
        "parayuka",
        "venam",
        "cheyyanam",
        "undu",
        "anu",
        "kurichu",
        "vendhi",
        "krishi",
        "vilavu",
        "ari",
        "gothambu",
        "rogam",
        "vellam",
        "mannu",
    },

    "pa": {
        "mainu",
        "menu",
        "mera",
        "meri",
        "mere",
        "sanu",
        "tusi",
        "tuhada",
        "ki",
        "kiho",
        "kiven",
        "kaun",
        "kyon",
        "dasso",
        "dasna",
        "chahida",
        "karna",
        "hai",
        "han",
        "ate",
        "lai",
        "vich",
        "kheti",
        "fasal",
        "kanak",
        "rog",
        "pani",
        "mitti",
    },

    "bn": {
        "ami",
        "amake",
        "amar",
        "amar",
        "tumi",
        "tomar",
        "apni",
        "apnar",
        "ki",
        "kemon",
        "kivabe",
        "keno",
        "ke",
        "bolun",
        "bolo",
        "chai",
        "korte",
        "hobe",
        "ache",
        "ebong",
        "jonno",
        "krishi",
        "foshol",
        "dhan",
        "gom",
        "rog",
        "pani",
        "mati",
    },

    "or": {
        "mote",
        "mu",
        "mora",
        "mora",
        "ama",
        "tume",
        "apananka",
        "kana",
        "kemiti",
        "kahinki",
        "kie",
        "kahantu",
        "kahiba",
        "darkar",
        "kariba",
        "achhi",
        "ebam",
        "pain",
        "krushi",
        "fasala",
        "dhan",
        "gaham",
        "roga",
        "pani",
        "mati",
    },
}


# ============================================================
# Common English words
# ============================================================

COMMON_ENGLISH_WORDS = {
    "the",
    "a",
    "an",
    "is",
    "are",
    "am",
    "was",
    "were",
    "what",
    "which",
    "where",
    "when",
    "why",
    "how",
    "tell",
    "give",
    "about",
    "please",
    "can",
    "could",
    "should",
    "would",
    "help",
    "me",
    "my",
    "your",
    "you",
    "we",
    "i",
    "need",
    "want",
    "best",
    "good",
    "crop",
    "crops",
    "farming",
    "farm",
    "fertilizer",
    "fertilizers",
    "disease",
    "weather",
    "temperature",
    "rain",
    "soil",
    "water",
}


# ============================================================
# Tokenization
# ============================================================

def _tokenize(text: str) -> list[str]:
    """
    Extract Latin-script words.
    """

    return re.findall(
        r"[a-zA-Z]+",
        text.lower(),
    )


# ============================================================
# Native script detection
# ============================================================

def _detect_native_script(
    text: str,
) -> Optional[str]:
    """
    Detect languages written in their native scripts.
    """

    # --------------------------------------------------------
    # Gujarati
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["gu"].search(text):
        return "gu"

    # --------------------------------------------------------
    # Punjabi
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["pa"].search(text):
        return "pa"

    # --------------------------------------------------------
    # Bengali
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["bn"].search(text):
        return "bn"

    # --------------------------------------------------------
    # Odia
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["or"].search(text):
        return "or"

    # --------------------------------------------------------
    # Tamil
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["ta"].search(text):
        return "ta"

    # --------------------------------------------------------
    # Telugu
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["te"].search(text):
        return "te"

    # --------------------------------------------------------
    # Kannada
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["kn"].search(text):
        return "kn"

    # --------------------------------------------------------
    # Malayalam
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["ml"].search(text):
        return "ml"

    # --------------------------------------------------------
    # Hindi / Marathi
    # --------------------------------------------------------

    if SCRIPT_PATTERNS["devanagari"].search(text):

        words = set(
            re.findall(
                r"[\u0900-\u097F]+",
                text,
            )
        )

        hindi_score = len(
            words.intersection(
                HINDI_HINTS
            )
        )

        marathi_score = len(
            words.intersection(
                MARATHI_HINTS
            )
        )

        if marathi_score > hindi_score:
            return "mr"

        if hindi_score > marathi_score:
            return "hi"

        # Ambiguous Devanagari defaults to Hindi.
        return "hi"

    return None


# ============================================================
# Roman-language detection
# ============================================================

def _detect_roman_language(
    text: str,
) -> Optional[str]:
    """
    Detect Indian languages written using Latin/Roman script.

    This is useful for messages such as:

        Mujhe wheat ke liye fertilizer batao.

    which is Hindi but uses English characters.
    """

    tokens = set(
        _tokenize(text)
    )

    if not tokens:
        return None

    scores = Counter()

    for language, hints in ROMAN_LANGUAGE_HINTS.items():

        for token in tokens:

            if token in hints:
                scores[language] += 1

    if not scores:
        return None

    ranked = scores.most_common()

    best_language, best_score = ranked[0]

    if best_score <= 0:
        return None

    # --------------------------------------------------------
    # Require a reasonable signal.
    # --------------------------------------------------------

    if best_score >= 2:
        return best_language

    # A single highly distinctive word can still be useful.
    # Keep the list conservative to avoid false positives.
    distinctive_words = {
        "mujhe",
        "mujhko",
        "mala",
        "majhya",
        "mane",
        "tamne",
        "enakku",
        "naaku",
        "nanage",
        "enikku",
        "mainu",
        "amake",
    }

    if any(
        token in distinctive_words
        for token in tokens
    ):
        return best_language

    return None


# ============================================================
# English detection
# ============================================================

def _looks_like_english(
    text: str,
) -> bool:
    """
    Determine whether Latin-script text is likely English.
    """

    tokens = set(
        _tokenize(text)
    )

    if not tokens:
        return False

    english_matches = len(
        tokens.intersection(
            COMMON_ENGLISH_WORDS
        )
    )

    # A couple of common English words are a strong
    # indication for normal English sentences.
    if english_matches >= 2:
        return True

    # Very short Latin messages such as:
    #
    # hello
    # thanks
    # okay
    #
    # should remain English.
    common_short_english = {
        "hello",
        "hi",
        "hey",
        "thanks",
        "thank",
        "okay",
        "ok",
        "yes",
        "no",
        "please",
        "help",
    }

    if tokens.intersection(
        common_short_english
    ):
        return True

    return False


# ============================================================
# Qwen fallback
# ============================================================

async def _detect_with_model(
    text: str,
) -> Optional[str]:
    """
    Use Qwen only when deterministic detection cannot
    confidently classify the message.
    """

    prompt = f"""
Classify the language of this message.

Supported codes:

en
hi
mr
ta
te
kn
ml
gu
pa
bn
or

Return ONLY one code.

Do not explain.
Do not use markdown.
Do not provide reasoning.

Message:
{text}
"""

    try:

        result = await generate_response(
            messages=[
                {
                    "role": "system",
                    "content": (
                        "You are a language classifier. "
                        "Return only one supported "
                        "language code."
                    ),
                },
                {
                    "role": "user",
                    "content": prompt,
                },
            ],
            max_tokens=10,
            temperature=0.0,
        )

    except GroqServiceError as exc:

        logger.warning(
            "Qwen language detection failed: %s",
            exc,
        )

        return None

    if not result:
        return None

    # --------------------------------------------------------
    # Remove reasoning blocks.
    # --------------------------------------------------------

    cleaned = re.sub(
        r"<think>.*?</think>",
        "",
        result,
        flags=re.DOTALL | re.IGNORECASE,
    )

    cleaned = re.sub(
        r"<think>.*$",
        "",
        cleaned,
        flags=re.DOTALL | re.IGNORECASE,
    )

    cleaned = re.sub(
        r"</think>",
        "",
        cleaned,
        flags=re.IGNORECASE,
    )

    cleaned = (
        cleaned
        .replace("`", "")
        .replace("*", "")
        .strip()
        .lower()
    )

    # --------------------------------------------------------
    # Exact match.
    # --------------------------------------------------------

    if cleaned in SUPPORTED_LANGUAGES:
        return cleaned

    # --------------------------------------------------------
    # Search for a code inside the response.
    # --------------------------------------------------------

    pattern = r"\b(" + "|".join(
        re.escape(code)
        for code in SUPPORTED_LANGUAGES
    ) + r")\b"

    match = re.search(
        pattern,
        cleaned,
    )

    if match:
        return match.group(1)

    return None


# ============================================================
# Main language detector
# ============================================================

async def detect_language(
    text: str,
) -> str:
    """
    Reliable language detection for the chatbot.

    Detection order:

        1. Native Unicode script
        2. Roman/Latin Indian language hints
        3. English detection
        4. Qwen fallback
        5. Error
    """

    if not text or not text.strip():

        raise LanguageDetectionError(
            "Text cannot be empty."
        )

    text = text.strip()

    logger.info(
        "Detecting language for: %r",
        text[:200],
    )

    # ========================================================
    # 1. Native script
    # ========================================================

    native_language = _detect_native_script(
        text
    )

    if native_language:

        logger.info(
            "Language detected from native script: %s",
            native_language,
        )

        return native_language

    # ========================================================
    # 2. Roman Indian language
    # ========================================================

    roman_language = _detect_roman_language(
        text
    )

    if roman_language:

        logger.info(
            "Language detected from Roman-language hints: %s",
            roman_language,
        )

        return roman_language

    # ========================================================
    # 3. English
    # ========================================================

    if _looks_like_english(text):

        logger.info(
            "Language detected as English."
        )

        return "en"

    # ========================================================
    # 4. Qwen fallback
    # ========================================================

    model_language = await _detect_with_model(
        text
    )

    if model_language:

        logger.info(
            "Language detected using Qwen fallback: %s",
            model_language,
        )

        return model_language

    # ========================================================
    # 5. Final fallback
    # ========================================================

    logger.warning(
        "Unable to confidently detect language: %r",
        text[:200],
    )

    raise LanguageDetectionError(
        "Detected language is not supported."
    )