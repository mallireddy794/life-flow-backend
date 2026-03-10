from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from database import SessionLocal, engine
import models
import random
import smtplib
from email.mime.text import MIMEText
from datetime import datetime, timedelta

# Create tables
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# ---------------- DATABASE ----------------
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# ---------------- EMAIL CONFIG ----------------
EMAIL_ADDRESS = "mallireddy794@gmail.com"
EMAIL_PASSWORD = "bcsgzjdemtalxdax"

def send_otp_email(to_email, otp):
    subject = "LifeFlow Password Reset OTP"
    body = f"Your OTP for password reset is: {otp}"

    msg = MIMEText(body)
    msg["Subject"] = subject
    msg["From"] = EMAIL_ADDRESS
    msg["To"] = to_email

    with smtplib.SMTP_SSL("smtp.gmail.com", 465) as server:
        server.login(EMAIL_ADDRESS, EMAIL_PASSWORD)
        server.sendmail(EMAIL_ADDRESS, to_email, msg.as_string())

# ---------------- REGISTER ----------------
@app.post("/register")
def register(
    full_name: str,
    email: str,
    phone: str,
    blood_group: str,
    password: str,
    db: Session = Depends(get_db)
):
    existing_user = db.query(models.User).filter(models.User.email == email).first()
    if existing_user:
        raise HTTPException(status_code=400, detail="Email already registered")

    new_user = models.User(
        full_name=full_name,
        email=email,
        phone=phone,
        blood_group=blood_group,
        password=password
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return {"message": "User registered successfully"}

# ---------------- LOGIN ----------------
@app.post("/login")
def login(email: str, password: str, db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        raise HTTPException(status_code=400, detail="Invalid email")

    if user.password != password:
        raise HTTPException(status_code=400, detail="Invalid password")

    return {
        "message": "Login successful",
        "user": {
            "id": user.id,
            "full_name": user.full_name,
            "email": user.email,
            "blood_group": user.blood_group
        }
    }

# ---------------- FORGOT PASSWORD ----------------
@app.post("/forgot-password")
def forgot_password(email: str, db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        raise HTTPException(status_code=400, detail="Email not registered")

    otp = str(random.randint(100000, 999999))
    expiry_time = datetime.utcnow() + timedelta(minutes=5)

    user.otp = otp
    user.otp_expiry = expiry_time
    db.commit()

    send_otp_email(email, otp)

    return {"message": "OTP sent to your email"}

# ---------------- VERIFY OTP ----------------
@app.post("/verify-otp")
def verify_otp(email: str, otp: str, db: Session = Depends(get_db)):

    user = db.query(models.User).filter(models.User.email == email).first()

    if not user:
        raise HTTPException(status_code=400, detail="User not found")

    if user.otp != otp:
        raise HTTPException(status_code=400, detail="Invalid OTP")

    if datetime.utcnow() > user.otp_expiry:
        raise HTTPException(status_code=400, detail="OTP expired")

    return {"message": "OTP verified successfully"}