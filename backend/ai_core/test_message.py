from services.language_service import LanguageService


language_service = LanguageService()


# Hindi
hindi_text = "मेरी फसल में बीमारी है"

language = language_service.detect_language(
    hindi_text
)

print("Hindi test:")
print("Text:", hindi_text)
print("Detected:", language)
print(
    "Language:",
    language_service.get_language_name(language)
)


print()


# English
english_text = "My crop has a disease"

language = language_service.detect_language(
    english_text
)

print("English test:")
print("Text:", english_text)
print("Detected:", language)
print(
    "Language:",
    language_service.get_language_name(language)
)