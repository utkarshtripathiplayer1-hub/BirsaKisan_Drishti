# 🌾 Birsa Kisan Drishti — Edge AI Smart Agriculture Platform

> An **Edge AI-powered smart agriculture platform** that brings crop intelligence directly to the farm — enabling crop recommendation, disease detection, environmental monitoring, and multilingual assistance with minimal dependence on cloud connectivity.

---

## 🎯 The Problem

Farmers often make critical decisions about **what to plant, when to irrigate, and how to respond to crop diseases** using limited information, traditional practices, and delayed expert support.

Cloud-dependent agricultural AI introduces additional challenges:

* 🌐 Requires reliable internet connectivity
* ⏳ Creates latency during AI inference
* 💰 Increases cloud/API dependency
* 🔐 Requires farm data to leave the field
* 📡 Becomes difficult to use in remote/rural areas

**Birsa Kisan Drishti** addresses this through an **Edge AI architecture**, where critical AI inference happens directly on or near the farm.

Instead of continuously sending raw sensor and image data to the cloud:

**Sensors & Cameras → Edge Device → AI Inference → Local Decision → Farmer**

This enables faster, more private, and more resilient agricultural intelligence.

---

# ✨ Key Features

| Feature                               | What it does                                                                                                           |
| ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| 🌱 **Edge Crop Recommendation**       | Uses soil NPK, pH, moisture, temperature, humidity, rainfall and soil type to recommend suitable crops locally.        |
| 🔬 **Edge Disease Detection**         | Processes crop/leaf images using an optimized computer-vision model on the edge device.                                |
| 🌡️ **Environmental Monitoring**      | Continuously collects temperature, humidity, soil moisture and other farm parameters through IoT sensors.              |
| 🧠 **Edge AI Decision Engine**        | Combines sensor and visual information to generate local agricultural decisions without requiring continuous internet. |
| 🌦️ **Weather Integration**           | Uses weather information when connectivity is available and combines it with local farm observations.                  |
| 💧 **Farm Risk & Disaster Detection** | Uses rainfall, soil moisture and environmental conditions to identify potential crop-risk situations.                  |
| 🔄 **Crop Rotation Advisory**         | Provides rotation recommendations based on previous crops and soil conditions.                                         |
| 💬 **Multilingual AI Assistant**      | Provides agricultural guidance in regional Indian languages, with cloud assistance when connectivity is available.     |
| 📊 **Farm Dashboard**                 | Displays sensor readings, crop status, recommendations and historical farm data.                                       |
| 📄 **PDF Reports**                    | Generates crop recommendation and farm analysis reports.                                                               |
| 📡 **Offline-First Operation**        | Core AI functionality continues working even when internet connectivity is unavailable.                                |

---

# 🧠 Edge AI Architecture

The central idea of Birsa Kisan Drishti is to move **time-sensitive intelligence closer to the farmer**.

```text
                  ┌─────────────────────────────┐
                  │       FARM ENVIRONMENT      │
                  │                             │
                  │  NPK • pH • Moisture        │
                  │  Temperature • Humidity     │
                  │  Camera • Rainfall          │
                  └──────────────┬──────────────┘
                                 │
                                 ▼
                  ┌─────────────────────────────┐
                  │       EDGE DEVICE           │
                  │   Raspberry Pi / Edge AI    │
                  │                             │
                  │  • Data Preprocessing       │
                  │  • Sensor Fusion            │
                  │  • ML Inference             │
                  │  • Computer Vision           │
                  │  • Risk Detection           │
                  └──────────────┬──────────────┘
                                 │
                     ┌───────────┴───────────┐
                     ▼                       ▼
             ┌──────────────┐        ┌──────────────┐
             │ LOCAL AI     │        │ LOCAL DATA   │
             │ DECISIONS    │        │ STORAGE      │
             │              │        │              │
             │ Crop         │        │ Sensor Data  │
             │ Disease      │        │ Farm History │
             │ Risk         │        │ Predictions  │
             │ Irrigation   │        │              │
             └──────┬───────┘        └──────────────┘
                    │
                    ▼
             ┌──────────────┐
             │ FARMER APP  │
             │   Flutter   │
             │             │
             │ Alerts      │
             │ Advice      │
             │ Dashboard   │
             └──────┬───────┘
                    │
             Internet Available
                    │
                    ▼
             ┌──────────────┐
             │ CLOUD LAYER  │
             │              │
             │ Weather      │
             │ Model Update │
             │ Analytics    │
             │ AI Assistant │
             │ Sync         │
             └──────────────┘
```

### Core Principle

> **Cloud provides additional intelligence; Edge provides essential intelligence.**

The system does not require continuous cloud connectivity for its critical farm-level AI functions.

---

# ⚡ Edge AI Pipeline

### 1. Data Acquisition

Farm data is collected using:

* NPK sensor
* Soil moisture sensor
* Temperature & humidity sensors
* pH sensor
* Rain sensor
* Camera
* Weather data when available

```text
Sensors + Camera
       ↓
Edge Gateway
```

### 2. Preprocessing

The edge device performs:

* Sensor validation
* Noise filtering
* Missing-value handling
* Normalization
* Image preprocessing
* Feature extraction

```text
Raw Data
   ↓
Cleaning
   ↓
Normalization
   ↓
AI-ready Data
```

### 3. Edge AI Inference

Optimized machine-learning models run locally.

```text
             ┌─────────────────┐
             │   Edge Device   │
             └────────┬────────┘
                      │
       ┌──────────────┼──────────────┐
       ▼              ▼              ▼
 Crop Model     Vision Model    Risk Model
       │              │              │
       ▼              ▼              ▼
Crop Advice     Disease       Farm Risk
               Detection      Assessment
```

### 4. Decision Generation

The AI converts predictions into understandable agricultural advice.

For example:

```text
N = 82
P = 42
K = 38
pH = 6.4
Temperature = 27°C
Humidity = 71%
Soil Moisture = 42%

             ↓

        Edge AI Model

             ↓

Recommended Crop:
        🌾 Rice

Confidence:
        91%

Reason:
Suitable temperature,
pH and nutrient conditions.
```

### 5. Farmer Notification

The result is immediately delivered to the farmer's application.

```text
Edge AI
   ↓
Decision
   ↓
Flutter App
   ↓
Farmer
```

---

# 🌱 Edge Crop Recommendation

The crop recommendation engine uses multiple agricultural parameters:

* Nitrogen (N)
* Phosphorus (P)
* Potassium (K)
* Soil pH
* Temperature
* Humidity
* Rainfall
* Soil moisture
* Soil type

The trained ML model is optimized for deployment on the edge device.

### Pipeline

```text
NPK Sensor ──────┐
pH Sensor ───────┤
Moisture ────────┤
Temperature ─────┤
Humidity ────────┤
Rainfall ────────┤
Soil Type ───────┘
                  ↓
          Data Preprocessing
                  ↓
          Edge ML Model
                  ↓
          Probability Scores
                  ↓
       Crop Recommendation
                  ↓
          Farmer Application
```

The system can return:

* Recommended crop
* Confidence percentage
* Alternative crops
* Environmental suitability
* Crop-growing information

---

# 🔬 Edge Disease Detection

Instead of uploading every image to a remote server, the system is designed to perform crop-disease inference directly on the edge device.

### Pipeline

```text
Crop Leaf
   ↓
Edge Camera
   ↓
Image Preprocessing
   ↓
Optimized Vision Model
   ↓
Disease Classification
   ↓
Severity Assessment
   ↓
Treatment Recommendation
```

The model can be optimized using techniques such as:

* Quantization
* Model pruning
* ONNX/TFLite deployment
* Reduced input resolution
* Lightweight CNN architectures

This reduces:

* Network dependency
* Inference latency
* Data transfer
* Cloud processing requirements

---

# 🌦️ Farm Risk & Disaster Intelligence

Birsa Kisan Drishti combines **local sensor observations with weather information** to identify potential agricultural risks.

Important parameters include:

* Rainfall
* Rainfall intensity
* Soil moisture
* Temperature
* Humidity
* Wind speed
* Weather forecast
* Water accumulation indicators
* Historical farm conditions

### Example

```text
Heavy Rainfall
      +
High Soil Moisture
      +
Poor Drainage
      ↓
  Edge Risk Model
      ↓
Potential Waterlogging
      ↓
Farmer Alert
```

The system can provide early warnings for conditions such as:

* Excess rainfall
* Waterlogging
* Drought stress
* Extreme temperature
* High crop stress
* Potential storm-related risk

---

# 🧠 Sensor Fusion

A major component of the system is **sensor fusion**.

Instead of making decisions from a single parameter, the edge AI engine combines multiple observations.

```text
              NPK
               │
               ▼
Temperature → SENSOR ← Humidity
               │
               ▼
        Soil Moisture
               │
               ▼
            Rainfall
               │
               ▼
          Camera Data
               │
               ▼
        ┌─────────────┐
        │ SENSOR      │
        │ FUSION      │
        │ ENGINE      │
        └──────┬──────┘
               ▼
          Edge AI Model
               ▼
        Farm Intelligence
```

This allows the system to understand the **overall condition of the farm rather than isolated sensor values**.

---

# 📡 Offline-First Architecture

Connectivity should not determine whether a farmer can access critical intelligence.

### Online Mode

```text
Farm
 ↓
Edge Device
 ↓
Local AI
 ↓
Farmer App
 ↓
Cloud Sync
 ↓
Weather / Model Updates / Analytics
```

### Offline Mode

```text
Farm
 ↓
Edge Device
 ↓
Local AI
 ↓
Local Database
 ↓
Farmer App
```

Core functions continue operating locally.

When connectivity returns:

```text
Offline Data
     ↓
Automatic Sync
     ↓
Cloud Database
```

---

# 🏗️ System Architecture

Birsa Kisan Drishti consists of four major layers:

```text
┌───────────────────────────────────────────────┐
│                 FARM LAYER                    │
│                                               │
│ Sensors • Camera • NPK • Soil • Weather       │
└───────────────────────┬───────────────────────┘
                        ↓
┌───────────────────────────────────────────────┐
│                 EDGE LAYER                    │
│                                               │
│ Raspberry Pi / Edge Gateway                   │
│ Preprocessing • Sensor Fusion • AI Inference  │
│ Local Storage • Decision Engine               │
└───────────────────────┬───────────────────────┘
                        ↓
┌───────────────────────────────────────────────┐
│              APPLICATION LAYER                │
│                                               │
│ Flutter Farmer Application                   │
│ Dashboard • Alerts • Recommendations          │
└───────────────────────┬───────────────────────┘
                        ↓
┌───────────────────────────────────────────────┐
│                 CLOUD LAYER                   │
│                                               │
│ MongoDB • Weather APIs • AI Assistant         │
│ Analytics • Model Updates • Data Sync         │
└───────────────────────────────────────────────┘
```

---

# 🛠️ Technology Stack

### Edge Hardware

* Raspberry Pi 5
* ESP32
* NPK Sensor
* Soil Moisture Sensor
* Temperature & Humidity Sensors
* pH Sensor
* Camera Module

### Edge AI / ML

* Python
* PyTorch
* TensorFlow
* TensorFlow Lite / ONNX
* NumPy
* Pandas
* Scikit-learn
* Lightweight CNN architectures

### Backend

* FastAPI
* REST APIs
* MongoDB
* MQTT

### Frontend

* Flutter
* Figma

### Cloud / External Services

* MongoDB Atlas
* Open-Meteo / Weather APIs
* Bhashini / multilingual services
* Groq for cloud-based conversational AI when connectivity is available

---

# 🔐 Edge-First Data Flow

The platform follows a **local-first data strategy**.

```text
                FARM DATA
                    ↓
            ┌───────────────┐
            │ EDGE DEVICE   │
            └───────┬───────┘
                    ↓
            Is local inference
                 possible?
               /           \
             YES            NO
              ↓              ↓
        Local AI        Cloud Service
              ↓              ↓
              └──────┬───────┘
                     ↓
               Final Decision
                     ↓
                Farmer App
```

Sensitive farm data can remain local whenever cloud processing is unnecessary.

---

# 🗂️ Project Structure

```text
birsa-kisan-drishit/
│
├── edge_ai/
│   ├── models/
│   │   ├── crop_model/
│   │   ├── disease_model/
│   │   └── risk_model/
│   │
│   ├── inference/
│   ├── preprocessing/
│   ├── sensor_fusion/
│   ├── optimization/
│   └── edge_runtime/
│
├── backend/
│   ├── app/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── schemas/
│   │   ├── database/
│   │   └── auth/
│   └── requirements.txt
│
├── frontend/
│   └── flutter_app/
│
├── hardware/
│   ├── sensors/
│   ├── raspberry_pi/
│   └── esp32/
│
├── datasets/
│   ├── crop/
│   ├── disease/
│   └── farm_risk/
│
└── README.md
```

---

# 🚀 Edge AI Development Pipeline

The AI models follow an end-to-end deployment pipeline:

```text
Data Collection
      ↓
Data Cleaning
      ↓
Feature Engineering
      ↓
Model Training
      ↓
Model Evaluation
      ↓
Model Optimization
      ↓
Quantization
      ↓
Edge Deployment
      ↓
Real-World Testing
      ↓
Model Updates
```

The important difference is that **training can happen on a development/cloud machine, while inference happens on the edge device**.

---

# 📊 Why Edge AI?

| Traditional Cloud AI            | Birsa Kisan Drishti             |
| ------------------------------- | ------------------------------- |
| Internet required for inference | Local inference                 |
| Higher network dependency       | Low connectivity dependency     |
| Data continuously uploaded      | Data processed locally          |
| Network latency                 | Low-latency decisions           |
| Cloud processing cost           | Reduced cloud inference         |
| Difficult in remote areas       | Designed for rural environments |
| Centralized processing          | Distributed intelligence        |

---

# 🌍 Impact & Vision

Birsa Kisan Drishti aims to make agricultural intelligence available **where the farming actually happens — in the field**.

### Expected benefits

* ⚡ Faster AI decisions
* 📡 Reduced dependence on internet connectivity
* 🔐 Greater local data privacy
* 💰 Reduced cloud inference dependency
* 🌾 More data-driven farming decisions
* ♻️ Better resource utilization
* 🚜 Suitable for rural and remote environments

---

# 🔮 Roadmap

### Phase 1 — Edge Intelligence

* Edge crop recommendation
* Edge disease detection
* Sensor integration
* Offline inference

### Phase 2 — Farm Intelligence

* Fertilizer recommendation
* Yield prediction
* Irrigation advisory
* Farm-risk prediction

### Phase 3 — Connected Agriculture

* Weather integration
* Satellite imagery
* IoT sensor networks
* Market-price intelligence

### Phase 4 — Autonomous Agriculture

* Agricultural rover
* Drone-based crop monitoring
* Multi-camera field analysis
* Autonomous farm inspection
* Edge AI sensor fusion

---

# 👥 Team

| Name                 | Role                            |
| -------------------- | ------------------------------- |
| **Utkarsh Tripathi** | Team Lead — Hardware & Frontend |
| **Tanisha Bhatt**    | Backend & ML Developer          |
| **Agampreet Singh**  | Hardware Developer              |
| **Bhumika Manral**   | UI/UX & ML Developer            |
| **Samyak Jain**      | Frontend Developer              |
| **Anushka Singh**    | Team Member                     |

---

## 🌾 Our Vision

> **“Bring intelligence to the field, not just the cloud.”**

Birsa Kisan Drishti combines **IoT, Edge AI, computer vision, machine learning and agricultural intelligence** to create a resilient decision-support system for farmers.

The goal is simple:

**Sense → Understand → Decide → Act — directly at the farm.**
