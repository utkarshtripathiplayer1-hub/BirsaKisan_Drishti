# 🌾 Birsa Kisan Drishti — AI-Powered Smart Agriculture Platform

> A production-grade decision-support system that helps farmers choose the right crop, detect crop diseases from a photo, and receive advice in their own language — turning data into better harvests.

---

## 🎯 The Problem

Millions of farmers make one of the most important decisions of their year — *what to plant* — based on tradition and guesswork rather than data. A wrong choice means wasted seed, water, and fertilizer, degraded soil, and a lost season of income. When crops fall sick, farmers often can't identify the disease in time to act.

**BirsaKisan** bridges this gap with an AI-driven platform that gives farmers practical, explainable, data-backed guidance — accessible in their own language, on a low-end phone.

---

## ✨ Key Features

| Feature | What it does |
|---|---|
| 🌱 **Crop Recommendation** | Recommends the most suitable crop from soil nutrients (N, P, K), pH, temperature, humidity, rainfall, soil moisture & soil type — with a confidence score and the reasoning behind it. |
| 🔬 **Disease Detection** | Farmer uploads a leaf photo; a vision AI model identifies the disease, severity, and stage, then returns organic & chemical treatment plans. |
| 💬 **Multilingual AI Assistant** | A conversational agriculture chatbot that answers farming questions in 11 Indian languages. |
| 🔄 **Crop Rotation Advisory** | Suggests healthy rotation cycles to preserve soil fertility. |
| 🌦️ **Weather Integration** | Location-based weather data feeds into recommendations and advisories. |
| 📊 **Farm Dashboard** | Tracks a farmer's active crops, history, and personalized insights. |
| 📄 **PDF Reports** | Generates downloadable crop recommendation reports. |

---

## 🧠 How the Recommendation Works

The crop recommendation engine is a trained **machine-learning model** (scikit-learn) served in real time:

1. Farmer submits soil and environmental parameters.
2. Categorical inputs (soil type) are encoded; features are assembled into a model-ready vector.
3. The model predicts the best-fit crop **and** a probability distribution across all crops.
4. The system returns the recommended crop, a **confidence percentage**, and detailed crop knowledge (growing conditions, tips) so the advice is **explainable**, not a black box.

Disease detection uses a **vision-language model** (via Groq) that analyzes the uploaded leaf image against a structured diagnostic schema and returns a consistent JSON result the app can act on.

---

## 🏗️ Architecture

BirsaKisan is built as **two cooperating backend services**, sharing common concerns cleanly:

```
┌─────────────────────────┐        ┌──────────────────────────┐
│      AI Core Service     │        │  Crop Recommendation      │
│  • Auth (Google + JWT)   │◄──────►│  Service                  │
│  • Multilingual Chatbot  │  HTTP  │  • ML Crop Model          │
│  • Voice / Translation   │        │  • Disease Detection      │
│  • Conversation History  │        │  • Weather / Rotation     │
│                          │        │  • Dashboard / Reports    │
└───────────┬──────────────┘        └───────────┬──────────────┘
            │                                    │
            └──────────────┬─────────────────────┘
                           ▼
                    ┌─────────────┐
                    │  MongoDB     │
                    │  (Atlas)     │
                    └─────────────┘
```

This separation lets the AI/language layer and the agriculture/ML layer scale and evolve independently, while sharing authentication and data.

### Tech Stack

- **Framework:** FastAPI (async) on Uvicorn/Gunicorn
- **ML:** scikit-learn (crop model), Groq vision model (disease detection)
- **Language AI:** Groq LLM (chatbot), Sarvam AI (translation, 11 languages)
- **Database:** MongoDB Atlas (async via Motor)
- **Auth:** Google OAuth + JWT
- **Reports:** ReportLab (PDF generation)
- **Deployment:** Render

### Design Principles

- **Fully asynchronous** — external AI calls never block the server, so the platform stays responsive under concurrent load.
- **Fail-fast configuration** — required secrets are validated at startup.
- **Resilient by default** — every external API call has timeouts and graceful fallbacks.
- **Production-ready** — health checks, structured logging, connection pooling, and database indexing.

---

## 🗂️ Project Structure

```
crop_recommendation_backend/
├── app/
│   ├── main.py              # App entry, lifespan, health check
│   ├── auth/                # Google OAuth + JWT
│   ├── config/              # Settings & environment
│   ├── controllers/         # Request orchestration
│   ├── database/            # MongoDB connection & indexes
│   ├── ml_models/           # Trained .pkl models & encoders
│   ├── data/                # Crop knowledge & datasets
│   ├── routes/              # API endpoints
│   ├── schemas/             # Pydantic request/response models
│   ├── services/            # Business logic (ML, Groq, weather…)
│   └── repositories/        # Data-access layer
├── requirements.txt
├── runtime.txt
└── README.md
```

---

## 🚀 Getting Started

### Prerequisites
- Python 3.12
- MongoDB Atlas account
- API keys: Groq, Sarvam AI, Google OAuth

### Installation

```bash
# Clone the repository
git clone <your-repo-url>
cd crop_recommendation_backend

# Create & activate a virtual environment
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt
```

### Environment Variables

Create a `.env` file in the project root:

```env
MONGODB_URL=your_mongodb_atlas_connection_string
AI_CORE_URL=http://localhost:8000        # URL of the AI Core service
GROQ_API_KEY=your_groq_api_key
ALLOWED_ORIGINS=http://localhost:3000
```

### Run the server

```bash
uvicorn app.main:app --reload
```

The API will be available at `http://127.0.0.1:8000`.
Interactive API docs: `http://127.0.0.1:8000/docs`

---

## 📡 Core API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| `POST` | `/crop/predict` | Get a crop recommendation from soil & climate data |
| `POST` | `/disease/predict` | Detect disease from an uploaded leaf image |
| `GET`  | `/weather` | Fetch location-based weather |
| `POST` | `/rotation` | Get crop rotation advice |
| `GET`  | `/dashboard` | Farmer's crop dashboard |
| `POST` | `/pdf` | Generate a PDF crop report |
| `GET`  | `/health` | Service & database health check |

> Full request/response schemas are available in the interactive `/docs`.

---

## 🌍 Impact & Vision

BirsaKisan is designed to **increase crop yield, reduce resource wastage, and promote sustainable farming** through accessible, data-driven guidance.

**Roadmap:**
- 🧪 Fertilizer recommendations based on soil-nutrient gaps
- 📈 Yield prediction from historical & real-time data
- 💧 Smart irrigation guidance
- 🛰️ Satellite & IoT sensor integration
- 💹 Market price insights for profitability-aware recommendations
- 🗣️ Full voice-first experience for low-literacy users

---

## 👥 Team

#Team name = Birsa kisan Drishti
<table>
<tr>
<th>Name</th>
<th>Role</th>
</tr>

<tr>
<td><b>Utkarsh Tripathi</b></td>
<td>Team Lead ( Hardware Developer,Frontend Developer )</td>
</tr>

<tr>
<td>Tanisha Bhatt</td>
<td>Team Member (Backend  Developer , ML Developer) </td>
</tr>



</table>



*Built with the goal of putting the power of AI into the hands of the farmers who feed us.* 🌾
