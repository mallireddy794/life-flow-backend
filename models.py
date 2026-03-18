from sqlalchemy import Column, Integer, String, DateTime, Boolean, ForeignKey
from database import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100))
    email = Column(String(100), unique=True, index=True)
    phone = Column(String(15))
    blood_group = Column(String(10))
    password = Column(String(100))

    otp = Column(String(6), nullable=True)
    otp_expiry = Column(DateTime, nullable=True)

    available_to_donate = Column(Boolean, default=False)


class DonorDonation(Base):
    __tablename__ = "donor_donations"

    id = Column(Integer, primary_key=True, index=True)
    donor_id = Column(Integer, ForeignKey("users.id"))
    donation_date = Column(DateTime)
    units = Column(Integer)
    blood_group = Column(String(5))
    location = Column(String(150))
    notes = Column(String(255))
    created_at = Column(DateTime, default=datetime.utcnow)


class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id = Column(Integer, primary_key=True, index=True)
    chat_id = Column(String(50), index=True)
    sender_id = Column(Integer, ForeignKey("users.id"))
    receiver_id = Column(Integer, ForeignKey("users.id"))
    message = Column(String(1000))
    created_at = Column(DateTime, default=datetime.utcnow)



    