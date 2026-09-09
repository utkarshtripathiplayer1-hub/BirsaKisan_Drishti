from langdetect import detect, DetectorFactory, LangDetectException


# Make language detection deterministic
DetectorFactory.seed = 0


class LanguageService:
    """
    Automatic language detection service for
    Birsa Kisan Drishti.

    Currently supports:
        hi -> Hindi
        en -> English

    The service detects the language of user-provided text
    and returns the language code used by the rest of
    the backend.
    """

    # Languages supported by our application
    SUPPORTED_LANGUAGES = {
        "hi": "Hindi",
        "en": "English",
    }

    def detect_language(
        self,
        text: str,
    ) -> str:
        """
        Detect the language of the supplied text.

        Returns:
            "hi" -> Hindi
            "en" -> English
        """

        if not text or not text.strip():
            raise ValueError(
                "Text cannot be empty"
            )

        text = text.strip()

        try:
            detected_language = detect(text)

        except LangDetectException as e:
            raise RuntimeError(
                f"Language detection failed: {e}"
            )

        # ----------------------------------------------------
        # Check whether detected language is supported
        # ----------------------------------------------------

        if detected_language not in self.SUPPORTED_LANGUAGES:
            raise ValueError(
                f"Detected language '{detected_language}' "
                "is not currently supported."
            )

        return detected_language

    def get_language_name(
        self,
        language_code: str,
    ) -> str:
        """
        Convert language code into human-readable name.

        Example:
            hi -> Hindi
            en -> English
        """

        language_code = language_code.lower().strip()

        return self.SUPPORTED_LANGUAGES.get(
            language_code,
            language_code,
        )

    def is_supported(
        self,
        language_code: str,
    ) -> bool:
        """
        Check whether a language is supported.
        """

        if not language_code:
            return False

        return (
            language_code.lower().strip()
            in self.SUPPORTED_LANGUAGES
        )