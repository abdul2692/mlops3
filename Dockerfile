# System Failure Prediction - Dockerfile
# This Dockerfile builds a containerized environment for the ML model and FastAPI service

FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY src/ ./src/
COPY api/ ./api/
# Models/data mounted as persistent disk on Render
# No COPY - preprocess.py generates sample data at runtime if needed
RUN mkdir -p /app/models

# Expose port for FastAPI
EXPOSE 8000

# Run the FastAPI application
CMD ["uvicorn", "api.app:app", "--host", "0.0.0.0", "--port", "8000"]

