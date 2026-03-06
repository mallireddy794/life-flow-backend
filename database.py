# database.py

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base

# Use ONLY ONE database
DATABASE_URL = "mysql+pymysql://root:@localhost/lifeflow_db"

engine = create_engine(
    DATABASE_URL,
    echo=True  # Optional: shows SQL queries in terminal
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()