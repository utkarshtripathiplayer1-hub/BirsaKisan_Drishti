from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer
)
from reportlab.lib.styles import getSampleStyleSheet
from pathlib import Path
from datetime import datetime
from app.repositories.report_repository import report_repository

class PDFService:

    def generate_crop_report(self, recommendation: dict):

        reports_dir = Path("reports")
        reports_dir.mkdir(exist_ok=True)

        filename = (
            f"crop_report_"
            f"{datetime.now().strftime('%Y%m%d_%H%M%S')}.pdf"
        )

        pdf_path = reports_dir / filename

        doc = SimpleDocTemplate(str(pdf_path))
        styles = getSampleStyleSheet()

        content = []

        content.append(
            Paragraph(
                "Smart Crop Recommendation Report",
                styles["Title"]
            )
        )

        content.append(Spacer(1, 12))
        crop_details = recommendation.get(

            "crop_details",
            {}
            )
        print(crop_details)
        print(crop_details.get("recommended_npk"))


        content.append(
            Paragraph(
                f"Recommended Crop: "
                f"{recommendation['recommended_crop']}",
                styles["Heading2"]
            )
        )

        content.append(
            Paragraph(
                f"Confidence: "
                f"{recommendation['confidence']}%",
                styles["Normal"]
            )
        )

        content.append(Spacer(1, 10))

        crop_details = recommendation.get("crop_details", {})
        npk = crop_details.get("recommended_npk", {})

        print("Crop Details:", crop_details)
        print("NPK:", npk)
        print("N:", npk.get("N"))
        print("P:", npk.get("P"))
        print("K:", npk.get("K"))

    

        content.append(
            Paragraph("Nutrient Requirements", styles["Heading3"])
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

        content.append(
            Paragraph("Ideal Conditions", styles["Heading3"])
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

        doc.build(content)

        report_data = {
            "report_type": "crop_recommendation",
            "file_name": filename,
            "file_path": str(pdf_path),
            "recommended_crop": recommendation.get(
            "recommended_crop"
            ),
            "generated_at": datetime.utcnow()
        }

        report_id = report_repository.save(
            report_data
        )

        return str(pdf_path)  
       

pdf_service = PDFService()