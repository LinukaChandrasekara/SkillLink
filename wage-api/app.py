# app.py
import re
import joblib
import pandas as pd
from typing import Union
from fastapi import FastAPI, Request
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

# --- load pipeline once ---
pipe = joblib.load("hourly_wage_model.joblib")  # trained Pipeline

app = FastAPI(title="Hourly Wage Estimator")

# CORS: list explicit dev origins only; don't use "*" with credentials
app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:8084", "http://127.0.0.1:8084",  # your JSP on 8084
        "http://localhost:8080", "http://127.0.0.1:8080",
    ],
    allow_credentials=False,
    allow_methods=["*"],
    allow_headers=["*"],
)

class PredictRequest(BaseModel):
    job_title: str = ""
    role: str = ""
    skills: str = ""                   # comma-separated or free text
    work_type: str = "Full-time"       # Full-time/Contract/Part-time/Temporary
    location: str = ""                 # e.g., "Seattle, WA"
    company_size: str = "51-200"
    experience_years: Union[float, str] = 0.0  # accept float or "3-5 years"

class PredictResponse(BaseModel):
    predicted_hourly_wage: float
    suggested_range_low: float
    suggested_range_high: float

def parse_experience(val: Union[float, str]) -> float:
    if isinstance(val, (int, float)):
        return float(val)
    nums = re.findall(r'(\d+(?:\.\d+)?)', str(val))
    if not nums:
        return 0.0
    if len(nums) == 1:
        return float(nums[0])
    return (float(nums[0]) + float(nums[1])) / 2.0

@app.middleware("http")
async def log_requests(request: Request, call_next):
    if request.url.path == "/predict":
        body = await request.body()
        print("POST /predict payload:", body.decode("utf-8", "ignore"))
    response = await call_next(request)
    return response

@app.get("/health")
def health():
    return {"status": "ok"}

@app.post("/predict", response_model=PredictResponse)
def predict(req: PredictRequest):
    row = pd.DataFrame([{
        "Job Title": req.job_title or "",
        "Role": req.role or "",
        "skills": req.skills or "",
        "Work Type": req.work_type or "Full-time",
        "location": req.location or "",
        "Company Size": req.company_size or "51-200",
        "experience_years": parse_experience(req.experience_years),
    }])

    y = float(pipe.predict(row)[0])
    lo = float(round(y * 0.90, 2))
    hi = float(round(y * 1.10, 2))

    return PredictResponse(
        predicted_hourly_wage=float(round(y, 2)),
        suggested_range_low=lo,
        suggested_range_high=hi,
    )
