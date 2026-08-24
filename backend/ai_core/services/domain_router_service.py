import logging
import re
from enum import Enum


logger = logging.getLogger("ai_core.domain_router")


class ChatDomain(str, Enum):
    """
    Main knowledge domains supported by the chatbot.
    """

    AGRICULTURE = "agriculture"
    APICULTURE = "apiculture"
    GENERAL = "general"


class ChatIntent(str, Enum):
    """
    More specific intent inside a domain.
    """

    # Agriculture
    CROP_RECOMMENDATION = "crop_recommendation"
    DISEASE_DETECTION = "disease_detection"
    AGRICULTURE_KNOWLEDGE = "agriculture_knowledge"
    WEATHER = "weather"

    # Apiculture
    BEEKEEPING = "beekeeping"
    BEE_HEALTH = "bee_health"
    BEE_EQUIPMENT = "bee_equipment"
    APICULTURE_KNOWLEDGE = "apiculture_knowledge"

    # General
    GENERAL = "general"


class DomainRoute:
    """
    Result returned by the domain router.
    """

    def __init__(
        self,
        domain: ChatDomain,
        intent: ChatIntent,
        confidence: float,
    ):
        self.domain = domain
        self.intent = intent
        self.confidence = confidence

    def to_dict(self) -> dict:
        return {
            "domain": self.domain.value,
            "intent": self.intent.value,
            "confidence": self.confidence,
        }


# ============================================================
# Keyword groups
# ============================================================

AGRICULTURE_KEYWORDS = {
    "crop",
    "crops",
    "farming",
    "farmer",
    "agriculture",
    "agricultural",
    "soil",
    "seed",
    "seeds",
    "sowing",
    "harvest",
    "harvesting",
    "irrigation",
    "fertilizer",
    "fertilizers",
    "fertiliser",
    "fertilisers",
    "pesticide",
    "pesticides",
    "insecticide",
    "weed",
    "weeds",
    "farm",
    "farming",
    "cultivation",
    "cultivate",
    "plant",
    "plants",
    "leaf",
    "leaves",
    "root",
    "roots",
    "stem",
    "fruit",
    "vegetable",
    "vegetables",
    "rice",
    "wheat",
    "maize",
    "corn",
    "cotton",
    "tomato",
    "potato",
    "sugarcane",
    "groundnut",
    "mustard",
}


DISEASE_KEYWORDS = {
    "disease",
    "diseases",
    "infection",
    "infected",
    "symptom",
    "symptoms",
    "fungus",
    "fungal",
    "bacterial",
    "bacteria",
    "virus",
    "viral",
    "blight",
    "rust",
    "mildew",
    "rot",
    "spot",
    "spots",
    "wilting",
    "yellowing",
    "lesion",
    "lesions",
}


CROP_RECOMMENDATION_KEYWORDS = {
    "recommend",
    "recommendation",
    "recommendations",
    "recommended",
    "which crop",
    "what crop",
    "best crop",
    "suitable crop",
    "crop selection",
    "crop choice",
    "what should i grow",
    "what can i grow",
    "which crop should",
}


WEATHER_KEYWORDS = {
    "weather",
    "temperature",
    "rain",
    "rainfall",
    "humidity",
    "forecast",
    "climate",
    "wind",
    "wind speed",
    "precipitation",
    "heat",
    "cold",
}


APICULTURE_KEYWORDS = {
    "bee",
    "bees",
    "hive",
    "hives",
    "beekeeper",
    "beekeeping",
    "apiary",
    "apiculture",
    "colony",
    "colonies",
    "queen bee",
    "worker bee",
    "drone bee",
    "brood",
    "honey",
    "honeybee",
    "honeybees",
    "wax",
    "beeswax",
    "pollen",
    "propolis",
    "royal jelly",
    "swarm",
    "swarming",
    "honeycomb",
    "honeycomb",
}


BEE_HEALTH_KEYWORDS = {
    "bee disease",
    "bee diseases",
    "bee health",
    "colony disease",
    "colony health",
    "mite",
    "mites",
    "varroa",
    "nosema",
    "brood disease",
    "dead bees",
    "dying bees",
    "sick bees",
    "bee infection",
}


BEE_EQUIPMENT_KEYWORDS = {
    "bee equipment",
    "beekeeping equipment",
    "hive equipment",
    "hive tool",
    "hive tools",
    "bee smoker",
    "smoker",
    "protective suit",
    "bee suit",
    "veil",
    "frame",
    "frames",
    "extractor",
    "honey extractor",
    "queen excluder",
    "feeder",
    "bee feeder",
    "equipment price",
}


# ============================================================
# Text normalization
# ============================================================

def normalize_text(text: str) -> str:
    """
    Normalize incoming text before classification.
    """

    if not text:
        return ""

    text = text.lower().strip()

    text = re.sub(
        r"\s+",
        " ",
        text,
    )

    return text


# ============================================================
# Keyword matching
# ============================================================

def _contains_keyword(
    text: str,
    keywords: set[str],
) -> bool:
    """
    Check whether any keyword/phrase exists in the text.
    """

    for keyword in keywords:

        if " " in keyword:

            if keyword in text:
                return True

        else:

            if re.search(
                rf"\b{re.escape(keyword)}\b",
                text,
            ):
                return True

    return False


def _count_matches(
    text: str,
    keywords: set[str],
) -> int:
    """
    Count keyword matches.
    """

    count = 0

    for keyword in keywords:

        if " " in keyword:

            if keyword in text:
                count += 1

        elif re.search(
            rf"\b{re.escape(keyword)}\b",
            text,
        ):
            count += 1

    return count


# ============================================================
# Main routing function
# ============================================================

def classify_message(
    text: str,
) -> DomainRoute:
    """
    Classify a user message into a domain and intent.

    This is intentionally deterministic.

    We do NOT ask Qwen to decide the domain because routing
    determines which application data/services are allowed
    to enter the prompt.
    """

    text = normalize_text(text)

    if not text:

        return DomainRoute(
            domain=ChatDomain.GENERAL,
            intent=ChatIntent.GENERAL,
            confidence=0.0,
        )

    # --------------------------------------------------------
    # 1. Crop recommendation
    # --------------------------------------------------------

    if _contains_keyword(
        text,
        CROP_RECOMMENDATION_KEYWORDS,
    ):

        return DomainRoute(
            domain=ChatDomain.AGRICULTURE,
            intent=ChatIntent.CROP_RECOMMENDATION,
            confidence=0.95,
        )

    # --------------------------------------------------------
    # 2. Weather
    # --------------------------------------------------------

    if _contains_keyword(
        text,
        WEATHER_KEYWORDS,
    ):

        return DomainRoute(
            domain=ChatDomain.AGRICULTURE,
            intent=ChatIntent.WEATHER,
            confidence=0.95,
        )

    # --------------------------------------------------------
    # 3. Bee health
    #
    # Check this before generic agriculture/disease because
    # "bee disease" must remain apiculture.
    # --------------------------------------------------------

    if _contains_keyword(
        text,
        BEE_HEALTH_KEYWORDS,
    ):

        return DomainRoute(
            domain=ChatDomain.APICULTURE,
            intent=ChatIntent.BEE_HEALTH,
            confidence=0.95,
        )

    # --------------------------------------------------------
    # 4. Bee equipment
    # --------------------------------------------------------

    if _contains_keyword(
        text,
        BEE_EQUIPMENT_KEYWORDS,
    ):

        return DomainRoute(
            domain=ChatDomain.APICULTURE,
            intent=ChatIntent.BEE_EQUIPMENT,
            confidence=0.95,
        )

    # --------------------------------------------------------
    # 5. General apiculture
    # --------------------------------------------------------

    apiculture_matches = _count_matches(
        text,
        APICULTURE_KEYWORDS,
    )

    if apiculture_matches > 0:

        confidence = min(
            0.65 + (apura := apiculture_matches) * 0.08,
            0.95,
        )

        return DomainRoute(
            domain=ChatDomain.APICULTURE,
            intent=ChatIntent.BEEKEEPING,
            confidence=confidence,
        )

    # --------------------------------------------------------
    # 6. Agriculture disease
    # --------------------------------------------------------

    if _contains_keyword(
        text,
        DISEASE_KEYWORDS,
    ):

        return DomainRoute(
            domain=ChatDomain.AGRICULTURE,
            intent=ChatIntent.DISEASE_DETECTION,
            confidence=0.90,
        )

    # --------------------------------------------------------
    # 7. General agriculture
    # --------------------------------------------------------

    agriculture_matches = _count_matches(
        text,
        AGRICULTURE_KEYWORDS,
    )

    if agriculture_matches > 0:

        confidence = min(
            0.60 + agriculture_matches * 0.08,
            0.95,
        )

        return DomainRoute(
            domain=ChatDomain.AGRICULTURE,
            intent=ChatIntent.AGRICULTURE_KNOWLEDGE,
            confidence=confidence,
        )

    # --------------------------------------------------------
    # 8. General
    # --------------------------------------------------------

    logger.info(
        "Message classified as general: %s",
        text[:100],
    )

    return DomainRoute(
        domain=ChatDomain.GENERAL,
        intent=ChatIntent.GENERAL,
        confidence=0.50,
    )