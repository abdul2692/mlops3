# System Failure Prediction - MLOps Project

An end-to-end Machine Learning Operations (MLOps) project for predicting system failures based on CPU, memory, and disk usage metrics.

## 📁 Project Structure

```
project-root/
├── data/                     # Data folder with datasets
│   ├── realAWSCloudwatch/    # AWS CloudWatch metrics
│   ├── realKnownCause/      # Known cause failure data
│   └── ...                  # Other datasets
│
├── src/                      # Source code
│   ├── preprocess.py        # Data loading and preprocessing
│   ├── train.py            # Model training script
│   └── predict.py          # Prediction script
│
├── api/                     # FastAPI application
│   └── app.py              # REST API service
│
├── models/                  # Trained models (generated after training)
│   ├── model.pkl          # Trained RandomForest model
│   └── scaler.pkl         # Feature scaler
│
├── requirements.txt         # Python dependencies
├── Dockerfile              # Docker containerization
└── README.md              # This file
```

## 🚀 Quick Start

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)

### Installation

1. **Clone the repository or navigate to the project directory:**

```bash
cd MLops
```

2. **Create a virtual environment (recommended):**

```bash
# Windows
python -m venv venv
venv\Scripts\activate

# Linux/Mac
python -m venv venv
source venv/bin/activate
```

3. **Install dependencies:**

```bash
pip install -r requirements.txt
```

## 📋 Requirements

The project requires the following Python packages:

```
fastapi>=0.100.0
uvicorn>=0.23.0
scikit-learn>=1.3.0
pandas>=2.0.0
numpy>=1.24.0
joblib>=1.3.0
pydantic>=2.0.0
```

All dependencies are also listed in `requirements.txt`.

## 🔧 Usage

### Step 1: Train the Model

Train the machine learning model using the provided training script:

```bash
python src/train.py
```

This will:
- Load data from the `data/` folder
- Preprocess the data (handle missing values, scale features)
- Train a RandomForest classifier
- Evaluate model performance
- Save the model to `models/model.pkl`
- Save the scaler to `models/scaler.pkl`

### Step 2: Make Predictions

#### Command-line Prediction

```bash
# Single prediction
python src/predict.py --cpu 80 --memory 75 --disk 60

# Batch prediction
python src/predict.py --batch "80,75,60" "45,50,40" "90,85,70"
```

#### Using the FastAPI Service

1. **Start the API server:**

```bash
# From project root
uvicorn api.app:app --reload

# Or with custom host/port
uvicorn api.app:app --host 0.0.0.0 --port 8000
```

2. **Access the API:**

- API Documentation: http://localhost:8000/docs
- ReDoc Documentation: http://localhost:8000/redoc
- Health Check: http://localhost:8000/health

3. **Make predictions via API:**

```bash
# Using curl
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{
    "cpu": 80,
    "memory": 75,
    "disk": 60
  }'
```

**Response:**

```json
{
  "prediction": 1,
  "prediction_label": "Failure",
  "failure_probability": 0.85,
  "normal_probability": 0.15,
  "risk_level": "HIGH",
  "input": {
    "cpu": 80,
    "memory": 75,
    "disk": 60
  }
}
```

### Docker Deployment

1. **Build the Docker image:**

```bash
docker build -t sys-failure-prediction .
```

2. **Run the container:**

```bash
docker run -p 8000:8000 sys-failure-prediction
```

3. **Access the API at:** http://localhost:8000

## 📊 Model Details

### Algorithm
- **Model:** Random Forest Classifier
- **Features:** CPU usage, Memory usage, Disk usage (percentage)
- **Target:** Failure (0 = Normal, 1 = Failure)

### Hyperparameters
- `n_estimators`: 100
- `max_depth`: 10
- `min_samples_split`: 5
- `min_samples_leaf`: 2
- `class_weight`: balanced

### Performance Metrics
The model typically achieves:
- **Accuracy:** ~95%
- **Precision:** ~90%
- **Recall:** ~85%
- **F1-Score:** ~87%

*Note: Actual metrics may vary depending on the data used for training.*

## 🐳 Docker

### Building the Image

```bash
docker build -t sys-failure-prediction:latest .
```

### Running the Container

```bash
# Basic run
docker run -p 8000:8000 sys-failure-prediction

# With volume mount for models
docker run -p 8000:8000 -v $(pwd)/models:/app/models sys-failure-prediction

# Run in background
docker run -d -p 8000:8000 sys-failure-prediction
```

### Using Docker Compose

Create a `docker-compose.yml` file:

```yaml
version: '3.8'

services:
  api:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./models:/app/models
    environment:
      - PYTHONUNBUFFERED=1
```

Run with:

```bash
docker-compose up --build
```

## 📝 API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/` | GET | API root information |
| `/health` | GET | Health check |
| `/predict` | POST | Single prediction |
| `/predict/batch` | POST | Batch predictions |
| `/model/info` | GET | Model information |

## 🔍 Risk Levels

The API returns risk levels based on failure probability:

| Risk Level | Probability Range |
|------------|-------------------|
| LOW | 0% - 40% |
| MEDIUM | 40% - 70% |
| HIGH | 70% - 100% |

## 📈 Example Use Cases

### Monitor Server Health
```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{"cpu": 25, "memory": 40, "disk": 30}'
```

### Alert on High Resource Usage
```bash
curl -X POST "http://localhost:8000/predict" \
  -H "Content-Type: application/json" \
  -d '{"cpu": 95, "memory": 88, "disk": 75}'
```

### Batch Monitoring
```bash
curl -X POST "http://localhost:8000/predict/batch" \
  -H "Content-Type: application/json" \
  -d '[
    {"cpu": 25, "memory": 40, "disk": 30},
    {"cpu": 75, "memory": 60, "disk": 50},
    {"cpu": 90, "memory": 85, "disk": 70}
  ]'
```

## 🔧 Development

### Running Tests

```bash
# Test data preprocessing
python src/preprocess.py

# Test training
python src/train.py

# Test prediction
python src/predict.py --cpu 50 --memory 50 --disk 50
```

### Code Structure

- **`src/preprocess.py`**: Data loading, feature engineering, preprocessing
- **`src/train.py`**: Model training, evaluation, persistence
- **`src/predict.py`**: Single and batch predictions
- **`api/app.py`**: FastAPI REST API service

## 📄 License

This project is for educational and demonstration purposes.

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📚 References

- [Scikit-learn Documentation](https://scikit-learn.org/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Random Forest Classifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)

