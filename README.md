# 🌱 Crop Recommendation System

A Machine Learning-based Crop Recommendation System that suggests the most suitable crop to grow based on environmental and soil parameters. This project helps farmers make informed decisions to improve crop yield and optimize agricultural productivity.

---

## 📌 Features

- Predicts the best crop based on input parameters.
- User-friendly interface.
- Machine Learning model trained on agricultural data.
- Fast and accurate crop recommendations.
- Easy to deploy and customize.

---

## 🛠️ Technologies Used

- Python
- Pandas
- NumPy
- Scikit-learn
- Flask / Streamlit (Choose whichever you used)
- HTML, CSS (if applicable)
- Jupyter Notebook

---

## 📊 Dataset

The dataset contains agricultural parameters such as:

- Nitrogen (N)
- Phosphorus (P)
- Potassium (K)
- Temperature (°C)
- Humidity (%)
- pH Value
- Rainfall (mm)

**Target Variable:**
- Crop Name

---

## 🚀 Installation

### Clone the repository

```bash
git clone https://github.com/your-username/crop-recommendation.git
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

