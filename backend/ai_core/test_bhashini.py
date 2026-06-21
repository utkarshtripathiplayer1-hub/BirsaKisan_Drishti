from services.bhashini_service import (
    translate_to_english,
    translate_from_english
)

print(
    translate_to_english(
        "मेरी मक्का की फसल में रोग है",
        "hi"
    )
)

print(
    translate_from_english(
        "Your maize crop may be affected by common rust.",
        "hi"
    )
)