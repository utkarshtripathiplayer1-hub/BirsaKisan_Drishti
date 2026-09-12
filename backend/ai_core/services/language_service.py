from langdetect import detect, DetectorFactory, LangDetectException


# Make language detection deterministic
DetectorFactory.seed = 0


class LanguageService:

    SUPPORTED_LANGUAGES = {
        "hi": "Hindi",
        "en": "English",
    }

    @classmethod
    def detect_language(
        cls,
        text: str,
    ) -> str:

        if not text or not text.strip():
            return "en"

        hindi_count = 0
        english_count = 0

        for char in text:

            # Devanagari
            if "\u0900" <= char <= "\u097F":
                hindi_count += 1

            # English alphabet
            elif char.isascii() and char.isalpha():
                english_count += 1

        if hindi_count > english_count:
            return "hi"

        return "en"