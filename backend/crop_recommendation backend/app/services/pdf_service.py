from pathlib import Path
from datetime import datetime

from reportlab.lib.styles import getSampleStyleSheet
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
)

from app.repositories.report_repository import report_repository


class PDFService:

    async def generate_crop_report(self, recommendation: dict):

        reports_dir = Path("reports")
        reports_dir.mkdir(exist_ok=True)

        filename = (
            f"crop_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.pdf"
        )

        pdf_path = reports_dir / filename

        doc = SimpleDocTemplate(str(pdf_path))
        styles = getSampleStyleSheet()

        content = []

        # -----------------------------
        # Title
        # -----------------------------
        content.append(
            Paragraph(
                "Smart Crop Recommendation Report",
                styles["Title"]
            )
        )

        content.append(Spacer(1, 12))

        # -----------------------------
        # Recommendation Summary
        # -----------------------------
        content.append(
            Paragraph(
                f"Recommended Crop: {recommendation.get('recommended_crop', '-')}",
                styles["Heading2"]
            )
        )

        content.append(
            Paragraph(
                f"Confidence: {recommendation.get('confidence', '-')}%",
                styles["Normal"]
            )
        )

        content.append(Spacer(1, 12))

        # -----------------------------
        # Crop Details
        # -----------------------------
        crop_details = recommendation.get("crop_details", {})

        npk = crop_details.get("recommended_npk", {})

        content.append(
            Paragraph(
                "Nutrient Requirements",
                styles["Heading3"]
            )
        )

        content.append(
            Paragraph(
                f"Nitrogen (N): {npk.get('N', '-')}",
                styles["Normal"]
            )
        )

        content.append(
            Paragraph(
                f"Phosphorus (P): {npk.get('P', '-')}",
                styles["Normal"]
            )
        )

        content.append(
            Paragraph(
                f"Potassium (K): {npk.get('K', '-')}",
                styles["Normal"]
            )
        )

        content.append(Spacer(1, 10))

        # -----------------------------
        # Ideal Growing Conditions
        # -----------------------------
        content.append(
            Paragraph(
                "Ideal Growing Conditions",
                styles["Heading3"]
            )
        )

        fields = [
            ("Ideal pH", "ideal_ph"),
            ("Temperature", "ideal_temperature"),
            ("Humidity", "ideal_humidity"),
            ("Soil Moisture", "ideal_soil_moisture"),
            ("Water Requirement", "water_requirement"),
            ("Irrigation Frequency", "irrigation_frequency"),
            ("Seasonal Water Need", "seasonal_water_need"),
            ("Season", "season"),
            ("Duration", "duration"),
        ]

        for label, key in fields:
            content.append(
                Paragraph(
                    f"{label}: {crop_details.get(key, '-')}",
                    styles["Normal"]
                )
            )

        content.append(Spacer(1, 12))

        # -----------------------------
        # Soil Data
        # -----------------------------
        soil_data = recommendation.get("soil_data", {})

        if soil_data:
            content.append(
                Paragraph(
                    "Input Soil Data",
                    styles["Heading3"]
                )
            )

            for key, value in soil_data.items():
                content.append(
                    Paragraph(
                        f"{key}: {value}",
                        styles["Normal"]
                    )
                )

        doc.build(content)

        # -----------------------------
        # Save Report Metadata
        # -----------------------------
        report_data = {
            "report_type": "crop_recommendation",
            "file_name": filename,
            "file_path": str(pdf_path),
            "recommended_crop": recommendation.get("recommended_crop"),
            "generated_at": datetime.utcnow()
        }

        await report_repository.save(report_data)

        return str(pdf_path)


pdf_service = PDFService()