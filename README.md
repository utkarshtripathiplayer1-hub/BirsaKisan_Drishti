








# PROJECT TITLE
# 🌱  Smart Crop Recommendation System

## PROBLEM 
Agriculture is the backbone of many economies, yet farmers often struggle to select the most suitable crop for their land due to varying soil conditions, environmental factors, and limited access to expert guidance. Incorrect crop selection can lead to lower yields, inefficient use of resources, and financial losses.

Our project is an AI-powered Smart Crop Recommendation System that analyzes key agricultural parameters and recommends the most suitable crop for cultivation. By providing personalized recommendations based on data, the platform helps farmers improve productivity and make informed farming decisions.

---
# OBJECTIVE
## Target users
- Farmers
- researchers
- Agricultural organizations
## Pain point
- Difficulty in selecting the right crop
- Lack of personalized agricultural guidance
- Low productivity due to unsuitable crop choices
- Limited access to data-driven decision support.
## Value our solution provides
- AI-powered crop recommendations.
- Personalized farmer and crop profiles
- Data-driven farming decisions
- Improved crop productivity
- Better utilization of available resources.

# TEAM AND APPROACH
# Team Name: 
Krishi Drishti
# Team Members:
- Utkarsh Tripathi (Github = https://github.com/utkarshtripathiplayer1-hub , Linkedin = https://www.linkedin.com/in/utkarsh-tripathi-616788327 ,Role = Team leader , UI/UX Designer)
- Tanisha Bhatt (Github = https://github.com/tanishabhatt06 ,Linkedin = https://www.linkedin.com/in/tanisha-bhatt-685b273a9 ,Role =  Backend Developer)
- Samyak jain ( Github = https://github.com/SamyakJain0195, Linkedin = https://www.linkedin.com/in/samyak-jain0195/ , Role = Frontend Developer)

# Our Approach
We identified that many farmers still rely on traditional methods or generalized advice when choosing crops. Our goal was to develop a system that provides personalized recommendations using machine learning and agricultural data.

# Key Challenges
- Building an accurate recommendation model.
- Managing agricultural datasets.
- Designing a scalable backend architecture.
- Creating an easy-to-use interface for farmers.

## TECH STACK
# Frontend 
- Flutter
- Dart

# Backend
- Python
- FastAPI
# Machine Learning
- Pandas
- Numpy
- Scikit-learn
- tensorflow
# Database
- Mongodb

# API's
- openweather API
- groq API
- Sarvam API

## KEY FEATURES

- Predicts the best crop based on input parameters.
- User-friendly interface.
- Machine Learning model trained on agricultural data.
- Fast and accurate crop recommendations.
- Easy to deploy and customize.

## How to run the project

### Clone the repository

```bash
git clone https://github.com/utkarshtripathiplayer1/BirsaKisan_Drishti.git
cd crop-recommendation
```

### Create a virtual environment (Optional)

```bash
python -m venv venv
```

Activate the environment:

**Windows**

```bash
venv\Scripts\activate
```

**Linux/macOS**

```bash
source venv/bin/activate
```

### Install dependencies

```bash
pip install -r requirements.txt
```

---

## ▶️ Run the Project

### Flask

```bash
python app.py
```

Open your browser and visit:

```
http://127.0.0.1:5000
```

### Streamlit

```bash
streamlit run app.py
```

---

## 📂 Project Structure

```
Crop-Recommendation/
│
├── dataset/
│   └── Crop_recommendation.csv
│
├── model/
│   └── crop_model.pkl
│
├── templates/
│   └── index.html
│
├── static/
│   ├── css/
│   └── images/
│
├── app.py
├── train_model.py
├── requirements.txt
├── README.md
└── LICENSE
```

---

## 📈 Model Training

The model is trained using supervised machine learning algorithms such as:

- Random Forest Classifier
- Decision Tree
- Support Vector Machine
- Naive Bayes

The best-performing model is saved using `pickle` for future predictions.

---

## 💻 Input Parameters

| Parameter | Description |
|-----------|-------------|
| Nitrogen | Nitrogen content in soil |
| Phosphorus | Phosphorus content in soil |
| Potassium | Potassium content in soil |
| Temperature | Temperature in °C |
| Humidity | Relative humidity |
| pH | Soil pH level |
| Rainfall | Rainfall in mm |

---

## 🎯 Output

The system predicts the most suitable crop for the given environmental conditions.

Example:

```
Recommended Crop:
Rice 🌾
```

---

## 📸 Screenshots

Add screenshots of your application here.

Example:

```
screenshots/
├── home.png
├── prediction.png
```

---

## 🔮 Future Enhancements

- Fertilizer Recommendation
- Disease Detection
- Weather Forecast Integration
- Crop Yield Prediction
- Multi-language Support
- Mobile Application

