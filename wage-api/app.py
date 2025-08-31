# app.py
import re
import joblib
import pandas as pd
from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

# --- load pipeline once ---
pipe = joblib.load("hourly_wage_model.joblib")  # your trained Pipeline

app = FastAPI(title="Hourly Wage Estimator")

# Allow your JSP origin during development (adjust to your domain in prod)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["http://localhost:8080", "http://127.0.0.1:8080", "*"],  # tighten in prod
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PredictRequest(BaseModel):
    job_title: str = ""
    role: str = ""
    skills: str = ""                 # comma-separated or free text
    work_type: str = "Full-time"     # e.g., Full-time/Contract/Part-time/Temporary
    location: str = ""               # e.g., "New York, NY"
    company_size: str = "51-200"     # must match categories seen in training
    experience_years: float = 0.0    # numeric years; you can parse from text on client

class PredictResponse(BaseModel):
    predicted_hourly_wage: float
    suggested_range_low: float
    suggested_range_high: float

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict", response_model=PredictResponse)
def predict(req: PredictRequest):
    # Build a single-row DataFrame with the exact column names expected by your pipeline
    row = pd.DataFrame([{
        "Job Title": req.job_title or "",
        "Role": req.role or "",
        "skills": req.skills or "",
        "Work Type": req.work_type or "Full-time",
        "location": req.location or "",
        "Company Size": req.company_size or "51-200",
        "experience_years": float(req.experience_years or 0.0)
    }])

    # Predict
    y = float(pipe.predict(row)[0])

    # Simple display range (+/- 10%) for UI
    lo = round(y * 0.90, 2)
    hi = round(y * 1.10, 2)
    return PredictResponse(
        predicted_hourly_wage=round(y, 2),
        suggested_range_low=lo,
        suggested_range_high=hi
    )
