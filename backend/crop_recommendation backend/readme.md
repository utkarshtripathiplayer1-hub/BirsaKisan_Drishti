# 🌾 Crop Recommendation Backend

A FastAPI-based backend for a smart agriculture platform that helps farmers manage farms, monitor weather conditions, and receive crop recommendations using a Machine Learning model.

---

## 🚀 Features

### 🌱 Crop Recommendation

* Predicts the most suitable crop based on:

  * Nitrogen (N)
  * Phosphorus (P)
  * Potassium (K)
  * pH
  * Soil Moisture
  * Temperature
  * Humidity
  * Rainfall
  * Solar Radiation
  * Elevation
  * Irrigation Type
  * Previous Crop

* Uses a trained Random Forest Classifier.

* Returns:

  * Recommended Crop
  * Prediction Confidence
  * Recommended Growing Conditions

---

### 🌦 Weather Monitoring

* Integrated with OpenWeather API.
* Provides:

  * Current Temperature
  * Humidity
  * Wind Speed
  * Pressure
  * Weather Condition
  * Feels Like Temperature

---

### 🚜 Farm Management

* Create and manage farms.
* Store farm information and location.
* Foundation for linking farms with weather and crop recommendations.

---

### 📊 Dashboard

Aggregated dashboard data including:

* Farm Information
* Weather Information
* Crop Recommendation Results

---

## 🛠 Tech Stack

### Backend

* FastAPI
* Python 3.12
* Pydantic
* Uvicorn

### Database

* MongoDB Atlas
* Motor (Async MongoDB Driver)
* PyMongo

### Machine Learning

* Scikit-Learn
* Random Forest Classifier
* Pandas
* NumPy
* Joblib

### External APIs

* OpenWeather API

---

## 📂 Project Structure

```text
app/
│
├── config/
│   ├── settings.py
│
├── controllers/
│   ├── crop_controller.py
│   ├── dashboard_controller.py
│   ├── farm_controller.py
│
├── database/
│   └── mongodb.py
│
├── data/
│   └── synthetic_crop_dataset_10k.csv
│
├── ml_models/
│   ├── crop_model.pkl
│   ├── crop_label_encoder.pkl
│   ├── irrigation_encoder.pkl
│   └── previous_crop_encoder.pkl
│
├── repositories/
│
├── routes/
│   ├── crop.py
│   ├── dashboard.py
│   ├── farm.py
│
├── schemas/
│   ├── crop_schema.py
│   ├── farm_schema.py
│
├── services/
│   ├── crop_service.py
│   ├── dashboard_service.py
│   ├── weather_service.py
│
└── main.py
```

---

## 🤖 Machine Learning Model

### Algorithm

Random Forest Classifier

### Dataset Features

| Feature         | Description                |
| --------------- | -------------------------- |
| N               | Nitrogen                   |
| P               | Phosphorus                 |
| K               | Potassium                  |
| pH              | Soil pH                    |
| soil_moisture   | Soil Moisture              |
| temperature     | Temperature                |
| humidity        | Humidity                   |
| rainfall        | Rainfall                   |
| solar_radiation | Solar Radiation            |
| elevation       | Elevation                  |
| irrigation      | Irrigation Method          |
| previous_crop   | Previously Cultivated Crop |

### Target

* crop_label

### Supported Crops

* Rice
* Wheat
* Maize
* Barley
* Millet
* Potato
* Soybean
* Lentil
* Mustard
* Sugarcane

---

## ⚙️ Environment Variables

Create a `.env` file:

```env
MONGODB_URL=your_mongodb_atlas_connection_string
DATABASE_NAME=crop_recommendation_db
OPENWEATHER_API_KEY=your_openweather_api_key
```

---

## 📦 Installation

### Clone Repository

```bash
git clone <repository_url>
cd crop-recommendation-backend
```

### Create Virtual Environment

```bash
python -m venv venv
```

### Activate Virtual Environment

Linux / macOS

```bash
source venv/bin/activate
```

Windows

```bash
venv\Scripts\activate
```

### Install Dependencies

```bash
pip install -r requirements.txt
```

---

## ▶️ Run Application

```bash
uvicorn app.main:app --reload
```

Swagger Documentation:

```text
http://127.0.0.1:8000/docs
```

---

## 📌 Crop Recommendation API

### Endpoint

```http
POST /crop/recommend
```

### Request

```json
{
  "N": 0.194,
  "P": 37.26,
  "K": 45.5,
  "pH": 6.5,
  "soil_moisture": 55,
  "temperature": 28,
  "humidity": 75,
  "rainfall": 150,
  "solar_radiation": 18,
  "elevation": 600,
  "irrigation": "rainfed",
  "previous_crop": "rice"
}
```

### Response

```json
{
  "recommended_crop": "maize",
  "confidence": 68.42,
  "recommended_conditions": {
    "N": 0.38,
    "P": 40.21,
    "K": 48.33,
    "pH": 6.72,
    "soil_moisture": 58.61,
    "temperature": 27.82,
    "humidity": 74.15,
    "rainfall": 165.42,
    "solar_radiation": 18.94,
    "elevation": 612.33
  }
}
```

---

## 🔮 Future Enhancements

* Recommendation History Storage
* Farm-wise Recommendation Tracking
* Weather Forecast Integration
* Crop Yield Prediction
* Disease Detection Module
* IoT Sensor Integration
* Smart Irrigation Recommendations
* Advanced Machine Learning Models

---

## 👨‍💻 Author

Developed as part of a Smart Agriculture and Crop Recommendation Platform aimed at helping farmers make data-driven decisions using weather data and machine learning.
