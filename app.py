from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash
import random
from datetime import datetime, timedelta
import smtplib
from email.mime.text import MIMEText
from MySQLdb.cursors import DictCursor
import joblib
import math

from database import engine
from models import Base
import re

Base.metadata.create_all(bind=engine)
# SQLAlchemy imports
from database import SessionLocal
from models import DonorDonation


app = Flask(__name__)
CORS(app)

# ================= DATABASE CONFIG =================
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'lifeflow_db'

mysql = MySQL(app)

# ================= SIGNUP =================
@app.route('/signup', methods=['POST'])
def signup():
    data = request.json

    name = data.get('name')
    email = data.get('email')
    password = data.get('password')
    role = data.get('role')

    if not all([name, email, password, role]):
        return jsonify({"error": "All fields required"}), 400

    hashed_password = generate_password_hash(password)

    cursor = mysql.connection.cursor()
    try:
        cursor.execute(
            "INSERT INTO users (name,email,password,role) VALUES (%s,%s,%s,%s)",
            (name, email, hashed_password, role)
        )
        mysql.connection.commit()

        user_id = cursor.lastrowid

        # Auto create role table entry
        if role == "donor":
            cursor.execute("INSERT INTO donors (user_id) VALUES (%s)", (user_id,))
        elif role == "patient":
            cursor.execute("INSERT INTO patients (user_id) VALUES (%s)", (user_id,))
        
        mysql.connection.commit()

    except Exception as e:
        return jsonify({"error": "Email already exists"}), 400

    cursor.close()
    return jsonify({"message": "User registered successfully"}), 201


# ================= LOGIN =================
@app.route('/login', methods=['POST'])
def login():
    data = request.json
    email = data.get('email')
    password = data.get('password')

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT id,name,password,role FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()
    cursor.close()

    if not user:
        return jsonify({"error": "User not found"}), 404

    if not check_password_hash(user[2], password):
        return jsonify({"error": "Invalid password"}), 401

    return jsonify({
        "message": "Login successful",
        "user": {
            "id": user[0],
            "name": user[1],
            "role": user[3]
        }
    })


# ================= FORGOT PASSWORD =================
@app.route('/forgot-password', methods=['POST', 'PUT'])
def forgot_password():
    data = request.json
    email = data.get("email")
    new_password = data.get("new_password")

    if not email or not new_password:
        return jsonify({"error": "Email and new password required"}), 400

    cursor = mysql.connection.cursor()

    # Check if user exists
    cursor.execute("SELECT id FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    if not user:
        cursor.close()
        return jsonify({"error": "Email not registered"}), 404

    hashed_password = generate_password_hash(new_password)
    cursor.execute(
        "UPDATE users SET password=%s WHERE email=%s",
        (hashed_password, email)
    )
    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Password updated successfully"})


# ================= SEND OTP (ROLE BASED) =================
@app.route('/send-otp', methods=['POST'])
def send_otp():
    data = request.json
    email = data.get("email")
    role = data.get("role")

    if not email or not role:
        return jsonify({"error": "Email and role required"}), 400

    cursor = mysql.connection.cursor()
    # First try with role
    cursor.execute("SELECT id, role FROM users WHERE email=%s AND role=%s", (email, role))
    user = cursor.fetchone()

    if not user:
        # If not found, check if the email exists at all with any role
        cursor.execute("SELECT id, role FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()
        if not user:
            cursor.close()
            return jsonify({"error": "Email not registered"}), 404
        
        # If email exists but role matches something else, we allow it for OTP purposes
        actual_role = user[1]
    else:
        actual_role = role

    # Generate OTP
    otp = str(random.randint(100000, 999999))
    expiry_time = datetime.now() + timedelta(minutes=5)

    cursor.execute(
        "UPDATE users SET otp=%s, otp_expiry=%s WHERE email=%s",
        (otp, expiry_time, email)
    )
    mysql.connection.commit()
    cursor.close()

    # ========== SEND EMAIL ==========
    sender_email = "mallireddy794@gmail.com"
    sender_password = "weub tnaz snjf voqj"

    msg = MIMEText(f"""
Hello from LifeFlow,

Your OTP for password reset is: {otp}

This OTP is valid for 5 minutes.
Account Role: {actual_role}

Do not share this with anyone.
""")

    msg["Subject"] = "LifeFlow Password Reset OTP"
    msg["From"] = sender_email
    msg["To"] = email

    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.starttls()
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, email, msg.as_string())
        server.quit()
    except Exception as e:
        return jsonify({"error": "Email sending failed", "details": str(e)}), 500

    return jsonify({"message": "OTP sent successfully"})



# ================= VERIFY OTP =================
@app.route('/verify-otp', methods=['POST'])
def verify_otp():
    data = request.json
    email = data.get("email")
    otp = data.get("otp")

    cursor = mysql.connection.cursor()
    cursor.execute("SELECT otp, otp_expiry FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    if not user:
        cursor.close()
        return jsonify({"error": "User not found"}), 404

    stored_otp, expiry_time = user

    if str(stored_otp) != str(otp):
        cursor.close()
        return jsonify({"error": "Invalid OTP"}), 400

    if datetime.now() > expiry_time:
        cursor.close()
        return jsonify({"error": "OTP expired"}), 400

    cursor.close()
    return jsonify({"message": "OTP verified successfully"})


# ================= SENTIMENT ANALYSIS =================
def analyze_sentiment(text):
    if not text: return 0.5
    text = text.lower()
    positive_words = ['good', 'great', 'excellent', 'helpful', 'kind', 'polite', 'fast', 'smooth', 'saved', 'thanks', 'wonderful']
    negative_words = ['bad', 'slow', 'rude', 'late', 'painful', 'poor', 'unprofessional', 'worst', 'angry', 'terrible']
    
    pos_count = sum(1 for word in positive_words if word in text)
    neg_count = sum(1 for word in negative_words if word in text)
    
    total = pos_count + neg_count
    if total == 0: return 0.5
    
    score = pos_count / total
    return round(score, 2)


# ================= RATE DONOR =================
@app.route('/donor/rate', methods=['POST'])
def rate_donor():
    data = request.get_json(force=True)
    donor_id = data.get("donor_id")
    patient_id = data.get("patient_id")
    rating = data.get("rating")
    review_text = data.get("review_text", "")

    if not all([donor_id, patient_id, rating]):
        return jsonify({"error": "Missing donor_id, patient_id or rating"}), 400

    sentiment_score = analyze_sentiment(review_text)

    cur = mysql.connection.cursor()
    try:
        # 1. Insert review
        cur.execute("""
            INSERT INTO donor_reviews (donor_id, patient_id, rating, review_text, sentiment_score)
            VALUES (%s, %s, %s, %s, %s)
        """, (donor_id, patient_id, rating, review_text, sentiment_score))

        # 2. Update donor aggregates
        cur.execute("""
            SELECT AVG(rating), AVG(sentiment_score), COUNT(*) 
            FROM donor_reviews WHERE donor_id = %s
        """, (donor_id,))
        avg_r, avg_s, count = cur.fetchone()

        cur.execute("""
            UPDATE donors 
            SET avg_rating = %s, sentiment_score = %s, total_reviews = %s
            WHERE user_id = %s
        """, (avg_r, avg_s, count, donor_id))

        mysql.connection.commit()
        cur.close()
        return jsonify({
            "message": "Rating submitted",
            "sentiment_score": sentiment_score,
            "new_avg_rating": float(avg_r)
        }), 201
    except Exception as e:
        mysql.connection.rollback()
        if cur: cur.close()
        return jsonify({"error": str(e)}), 500


# ================= RESET PASSWORD =================
@app.route('/reset-password', methods=['POST', 'PUT'])
def reset_password():
    data = request.json
    email = data.get("email")
    new_password = data.get("new_password")

    if not email or not new_password:
        return jsonify({"error": "Email and new password required"}), 400

    cursor = mysql.connection.cursor()

    hashed_password = generate_password_hash(new_password)
    cursor.execute(
        "UPDATE users SET password=%s, otp=NULL, otp_expiry=NULL WHERE email=%s",
        (hashed_password, email)
    )

    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Password reset successful"})


# ================= DONOR PROFILE =================
@app.route('/donor/profile/<int:user_id>', methods=['PUT'])
def update_donor_profile(user_id):
    data = request.json

    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE donors
        SET phone=%s, blood_group=%s, age=%s, city=%s
        WHERE user_id=%s
    """, (
        data.get("phone"),
        data.get("blood_group"),
        data.get("age"),
        data.get("city"),
        user_id
    ))

    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Donor profile updated"})


# ================= DONOR AVAILABILITY =================
from datetime import datetime
from flask import request, jsonify

@app.route('/donor/availability/<int:user_id>', methods=['PUT'])
def toggle_availability(user_id):
    data = request.get_json(force=True)

    if "is_available" not in data:
        return jsonify({"error": "Missing is_available"}), 400

    # Convert True/False → 1/0
    is_available = 1 if bool(data["is_available"]) else 0

    cursor = mysql.connection.cursor()

    # Check donor eligibility
    cursor.execute("SELECT is_eligible FROM donors WHERE user_id=%s", (user_id,))
    donor = cursor.fetchone()

    if not donor:
        cursor.close()
        return jsonify({"error": "Donor not found"}), 404

    # If donor is not eligible and trying to turn ON
    if donor[0] == 0 and is_available == 1:
        cursor.close()
        return jsonify({"error": "Not eligible to donate"}), 403

    # Update availability + timestamp
    cursor.execute("""
        UPDATE donors 
        SET is_available=%s,
            last_status_update=%s
        WHERE user_id=%s
    """, (is_available, datetime.utcnow(), user_id))

    mysql.connection.commit()
    cursor.close()

    return jsonify({
        "message": "Availability updated successfully",
        "is_available": is_available
    }), 200

    

# ================= DONOR DONATIONS ADD =================
@app.route('/donor/donations/add', methods=['POST'])
def add_donation():
    data = request.get_json(force=True)
    for k in ["donor_id", "donation_date", "units", "blood_group"]:
        if k not in data:
            return jsonify({"error": f"Missing {k}"}), 400

    # donation_date format example: "2026-02-27 10:30:00"
    try:
        dt = datetime.strptime(data["donation_date"], "%Y-%m-%d %H:%M:%S")
    except Exception:
        return jsonify({"error": "donation_date must be 'YYYY-MM-DD HH:MM:SS'"}), 400

    cursor = mysql.connection.cursor()
    cursor.execute("""
        INSERT INTO donor_donations (donor_id, donation_date, units, blood_group, location, notes)
        VALUES (%s,%s,%s,%s,%s,%s)
    """, (
        int(data["donor_id"]),
        dt,
        int(data["units"]),
        data["blood_group"],
        data.get("location"),
        data.get("notes")
    ))
    mysql.connection.commit()
    donation_id = cursor.lastrowid
    cursor.close()

    return jsonify({"message": "Donation history added", "donation_id": donation_id})


# ================= DONOR DONATION HISTORY =================
@app.route('/donor/donations/history', methods=['GET'])
def donation_history():
    # callers were already passing `donor_id` which corresponds to the
    # _users.id_ value.  treat it as a user identifier and query the
    # donor_donations table directly; there is no association table or
    # separate donors row required for history lookups.
    user_id = request.args.get("donor_id")  # yes: this is actually users.id

    if not user_id:
        return jsonify({"error": "Missing donor_id (user_id)"}), 400

    cursor = mysql.connection.cursor(DictCursor)

    cursor.execute("""
        SELECT id, donation_date, units, blood_group, location, notes
        FROM donor_donations
        WHERE donor_id = %s
        ORDER BY donation_date DESC
    """, (user_id,))

    history = cursor.fetchall()
    cursor.close()

    for h in history:
        if h.get("donation_date"):
            h["donation_date"] = h["donation_date"].strftime("%Y-%m-%d %H:%M:%S")

    return jsonify({
        "user_id": int(user_id),
        "count": len(history),
        "history": history
    }), 200


# ================= PATIENT PROFILE =================
@app.route('/patient/profile/<int:user_id>', methods=['PUT'])
def update_patient_profile(user_id):
    data = request.json

    cursor = mysql.connection.cursor()
    cursor.execute("""
        UPDATE patients
        SET phone=%s, blood_group=%s, hospital_name=%s, city=%s
        WHERE user_id=%s
    """, (
        data.get("phone"),
        data.get("blood_group"),
        data.get("hospital_name"),
        data.get("city"),
        user_id
    ))

    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Patient profile updated"})


# ================= CREATE BLOOD REQUEST =================
@app.route('/patient/request/<int:user_id>', methods=['POST'])
def create_request(user_id):
    data = request.json

    cursor = mysql.connection.cursor()

    cursor.execute("SELECT id FROM patients WHERE user_id=%s", (user_id,))
    patient = cursor.fetchone()

    if not patient:
        return jsonify({"error": "Patient profile not found"}), 404

    patient_id = patient[0]

    cursor.execute("""
        INSERT INTO blood_requests
        (patient_id, patient_name, hospital_name, contact_number, blood_group, units_required, urgency_level, city)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
    """, (
        patient_id,
        data.get("patient_name"),
        data.get("hospital_name"),
        data.get("contact_number"),
        data.get("blood_group"),
        data.get("units_required"),
        data.get("urgency_level"),
        data.get("city")
    ))

    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Blood request created"})


# ================= VIEW PATIENT REQUESTS =================
@app.route('/patient/requests/<int:user_id>', methods=['GET'])
def view_requests(user_id):

    cursor = mysql.connection.cursor()

    cursor.execute("SELECT id FROM patients WHERE user_id=%s", (user_id,))
    patient = cursor.fetchone()

    if not patient:
        return jsonify({"error": "Patient not found"}), 404

    patient_id = patient[0]

    cursor.execute("""
        SELECT id, blood_group, units_required, urgency_level, status, city
        FROM blood_requests
        WHERE patient_id=%s
    """, (patient_id,))

    requests = cursor.fetchall()
    cursor.close()

    result = []
    for r in requests:
        result.append({
            "request_id": r[0],
            "blood_group": r[1],
            "units_required": r[2],
            "urgency_level": r[3],
            "status": r[4],
            "city": r[5]
        })

    return jsonify(result)


# ================= ADMIN APPROVE =================
@app.route('/admin/approve/<int:request_id>', methods=['PUT'])
def approve_request(request_id):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE blood_requests SET status='Approved' WHERE id=%s", (request_id,))
    mysql.connection.commit()
    cursor.close()
    return jsonify({"message": "Request approved"})


# ================= ADMIN REJECT =================
@app.route('/admin/reject/<int:request_id>', methods=['PUT'])
def reject_request(request_id):
    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE blood_requests SET status='Rejected' WHERE id=%s", (request_id,))
    mysql.connection.commit()
    cursor.close()
    return jsonify({"message": "Request rejected"})


# ================= HOSPITAL PROFILE UPDATE =================
@app.route('/hospital/profile/<int:user_id>', methods=['PUT'])
def update_hospital_profile(user_id):
    data = request.json
    hospital_name = data.get("hospital_name")
    phone = data.get("phone")
    city = data.get("city")
    address = data.get("address")

    cursor = mysql.connection.cursor()

    cursor.execute("SELECT id FROM hospitals WHERE user_id=%s", (user_id,))
    hospital = cursor.fetchone()

    if hospital:
        cursor.execute("""
            UPDATE hospitals
            SET hospital_name=%s, phone=%s, city=%s, address=%s
            WHERE user_id=%s
        """, (hospital_name, phone, city, address, user_id))
    else:
        cursor.execute("""
            INSERT INTO hospitals (user_id, hospital_name, phone, city, address)
            VALUES (%s,%s,%s,%s,%s)
        """, (user_id, hospital_name, phone, city, address))

    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Hospital profile saved successfully"})


# ================= VIEW REQUESTS FOR HOSPITAL =================
@app.route('/hospital/requests/<int:user_id>', methods=['GET'])
def view_hospital_requests(user_id):
    cursor = mysql.connection.cursor()

    # Get hospital city
    cursor.execute("SELECT city FROM hospitals WHERE user_id=%s", (user_id,))
    hospital = cursor.fetchone()

    if not hospital:
        return jsonify({"error": "Hospital not found"}), 404

    city = hospital[0]

    cursor.execute("""
        SELECT id, blood_group, units_required, urgency_level, status, city, created_at
        FROM blood_requests
        WHERE city=%s
        ORDER BY created_at DESC
    """, (city,))

    requests = cursor.fetchall()
    cursor.close()

    request_list = []
    for r in requests:
        request_list.append({
            "request_id": r[0],
            "blood_group": r[1],
            "units_required": r[2],
            "urgency_level": r[3],
            "status": r[4],
            "city": r[5],
            "created_at": r[6]
        })

    return jsonify(request_list)



def generate_chat_id(user1: int, user2: int) -> str:
    return f"{min(user1, user2)}_{max(user1, user2)}"

@app.route("/chat/send", methods=["POST"])
def send_message():
    data = request.get_json(force=True)
    sender_id = int(data["sender_id"])
    receiver_id = int(data["receiver_id"])
    message = str(data["message"]).strip()

    if not message:
        return jsonify({"error": "Message cannot be empty"}), 400

    chat_id = generate_chat_id(sender_id, receiver_id)

    cur = mysql.connection.cursor()
    cur.execute(
        "INSERT INTO chat_messages (chat_id, sender_id, receiver_id, message) VALUES (%s,%s,%s,%s)",
        (chat_id, sender_id, receiver_id, message)
    )
    mysql.connection.commit()
    cur.close()

    return jsonify({"status": "Message sent", "chat_id": chat_id})

@app.route("/chat/history", methods=["GET"])
def chat_history():
    user1 = request.args.get("user1")
    user2 = request.args.get("user2")
    if not user1 or not user2:
        return jsonify({"error": "Missing user1 or user2"}), 400

    user1 = int(user1)
    user2 = int(user2)
    chat_id = generate_chat_id(user1, user2)

    # use DictCursor so results are dictionaries rather than tuples
    cur = mysql.connection.cursor(DictCursor)
    cur.execute(
        "SELECT id, chat_id, sender_id, receiver_id, message, created_at FROM chat_messages WHERE chat_id=%s ORDER BY created_at ASC",
        (chat_id,)
    )
    rows = cur.fetchall()
    cur.close()

    # ensure created_at is serialized to string
    for r in rows:
        dt = r.get("created_at")
        if hasattr(dt, "strftime"):
            r["created_at"] = dt.strftime("%a, %d %b %Y %H:%M:%S %Z")

    return jsonify(rows)


@app.route("/users/donors", methods=["GET"])
def donors_list():
    cur = mysql.connection.cursor(DictCursor)
    cur.execute("SELECT id, name, email, role, created_at FROM users WHERE role='donor' ORDER BY id DESC")
    rows = cur.fetchall()
    cur.close()
    return jsonify(rows)


@app.route("/users/patients", methods=["GET"])
def patients_list():
    cur = mysql.connection.cursor(DictCursor)
    cur.execute("SELECT id, name, email, role, created_at FROM users WHERE role='patient' ORDER BY id DESC")
    rows = cur.fetchall()
    cur.close()
    return jsonify(rows)


@app.route("/chat/inbox", methods=["GET"])
def chat_inbox():
    user_id = int(request.args.get("user_id", 0))
    if user_id <= 0:
        return jsonify({"error": "user_id required"}), 400

    cur = mysql.connection.cursor(DictCursor)

    cur.execute("""
        SELECT m.*
        FROM chat_messages m
        JOIN (
            SELECT chat_id, MAX(created_at) AS last_time
            FROM chat_messages
            WHERE sender_id=%s OR receiver_id=%s
            GROUP BY chat_id
        ) t
        ON m.chat_id=t.chat_id AND m.created_at=t.last_time
        ORDER BY m.created_at DESC
    """, (user_id, user_id))

    last_rows = cur.fetchall()
    result = []

    for r in last_rows:
        other_id = r["receiver_id"] if r["sender_id"] == user_id else r["sender_id"]

        cur.execute("SELECT id, name, email, role FROM users WHERE id=%s", (other_id,))
        other = cur.fetchone()

        cur.execute("""
            SELECT COUNT(*) AS unread
            FROM chat_messages
            WHERE receiver_id=%s AND sender_id=%s AND is_read=0
        """, (user_id, other_id))
        unread = cur.fetchone()["unread"]

        result.append({
            "chat_id": r["chat_id"],
            "last_message": r["message"],
            "last_time": str(r["created_at"]),
            "unread_count": unread,
            "other_user": other
        })

    cur.close()
    return jsonify(result)


@app.route("/chat/mark_read", methods=["POST"])
def mark_read():
    data = request.get_json(force=True)
    sender_id = int(data.get("sender_id", 0))
    receiver_id = int(data.get("receiver_id", 0))

    if sender_id <= 0 or receiver_id <= 0:
        return jsonify({"error": "sender_id and receiver_id required"}), 400

    chat_id = generate_chat_id(sender_id, receiver_id)

    cur = mysql.connection.cursor(DictCursor)
    cur.execute("""
        UPDATE chat_messages
        SET is_read=1
        WHERE chat_id=%s AND sender_id=%s AND receiver_id=%s AND is_read=0
    """, (chat_id, sender_id, receiver_id))
    mysql.connection.commit()
    updated = cur.rowcount
    cur.close()

    return jsonify({"status": "ok", "updated": updated})





@app.route("/donors/nearby", methods=["GET"])
def donors_nearby():
    blood_group = request.args.get("blood_group", "").strip()
    lat = request.args.get("lat")
    lng = request.args.get("lng")
    radius = float(request.args.get("radius_km", 5))

    if not blood_group or not lat or not lng:
        return jsonify({"error": "Missing blood_group/lat/lng"}), 400

    lat = float(lat)
    lng = float(lng)

    cur = mysql.connection.cursor()
    if blood_group.upper() == "ALL":
        query = """
            SELECT
              u.id, u.name, d.phone, d.blood_group, d.city, u.latitude, u.longitude,
              (6371 * 2 * ASIN(SQRT(POWER(SIN((RADIANS(u.latitude - %s)) / 2), 2) + COS(RADIANS(%s)) * COS(RADIANS(u.latitude)) * POWER(SIN((RADIANS(u.longitude - %s)) / 2), 2)))) AS distance_km
            FROM users u
            JOIN donors d ON d.user_id = u.id
            WHERE u.role = 'donor'
              AND d.is_available = 1
              AND d.is_eligible = 1
              AND u.latitude IS NOT NULL
              AND u.latitude != 0
            HAVING distance_km <= %s
            ORDER BY distance_km ASC
            LIMIT 50
        """
        cur.execute(query, (lat, lat, lng, radius))
    else:
        query = """
            SELECT
              u.id, u.name, d.phone, d.blood_group, d.city, u.latitude, u.longitude,
              (6371 * 2 * ASIN(SQRT(POWER(SIN((RADIANS(u.latitude - %s)) / 2), 2) + COS(RADIANS(%s)) * COS(RADIANS(u.latitude)) * POWER(SIN((RADIANS(u.longitude - %s)) / 2), 2)))) AS distance_km
            FROM users u
            JOIN donors d ON d.user_id = u.id
            WHERE u.role = 'donor'
              AND LOWER(d.blood_group) = LOWER(%s)
              AND d.is_available = 1
              AND d.is_eligible = 1
              AND u.latitude IS NOT NULL
              AND u.latitude != 0
            HAVING distance_km <= %s
            ORDER BY distance_km ASC
            LIMIT 50
        """
        cur.execute(query, (lat, lat, lng, blood_group, radius))

    rows = cur.fetchall()
    cur.close()

    donors = []
    for r in rows:
        donors.append({
            "donor_user_id": r[0],
            "name": r[1],
            "phone": r[2],
            "blood_group": r[3],
            "city": r[4],
            "latitude": r[5],
            "longitude": r[6],
            "distance_km": float(r[7]) if r[7] else None
        })

    return jsonify(donors)

@app.route("/patient/send_request", methods=["POST"])
def patient_send_request():
    data = request.get_json(force=True)
    print("Patient request body received (ACTIVE):", data)

    required = ["patient_id", "donor_id", "blood_group", "units_needed", "urgency"]
    for k in required:
        if k not in data or data[k] in [None, ""]:
            return jsonify({"error": f"Missing or empty field: {k}"}), 400

    try:
        patient_id = int(data["patient_id"])
        donor_id = int(data["donor_id"])
        units_needed = int(data["units_needed"])
    except Exception as e:
        return jsonify({"error": f"Numeric conversion error: {str(e)}"}), 400

    blood_group = str(data["blood_group"]).strip().upper()
    urgency = str(data["urgency"]).strip().upper()
    message = data.get("message", "Emergency need blood")

    cur = mysql.connection.cursor()
    try:
        cur.execute("SELECT role FROM users WHERE id=%s", (patient_id,))
        p_user = cur.fetchone()
        if not p_user or (p_user['role'] if isinstance(p_user, dict) else p_user[0]).lower() != 'patient':
            return jsonify({"error": "Invalid patient_id"}), 400

        cur.execute("SELECT role FROM users WHERE id=%s", (donor_id,))
        d_user = cur.fetchone()
        if not d_user or (d_user['role'] if isinstance(d_user, dict) else d_user[0]).lower() != 'donor':
            return jsonify({"error": "Invalid donor_id"}), 400

        cur.execute("""
            INSERT INTO donor_requests (patient_id, donor_id, blood_group, units_needed, urgency, message, status)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (patient_id, donor_id, blood_group, units_needed, urgency, message, "PENDING"))
        mysql.connection.commit()
        request_id = cur.lastrowid
        cur.close()

        return jsonify({
            "message": "Request sent to donor",
            "status": "PENDING",
            "request_id": request_id
        }), 201
    except Exception as e:
        mysql.connection.rollback()
        if cur: cur.close()
        return jsonify({"error": str(e)}), 500

    except Exception as e:
        mysql.connection.rollback()
        if cur: cur.close()
        return jsonify({"error": str(e)}), 500


@app.route("/donor/requests", methods=["GET"])
def donor_requests_list():
    donor_id = request.args.get("donor_id")
    if not donor_id:
        return jsonify({"error": "Missing donor_id"}), 400
    donor_id = int(donor_id)

    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT id, patient_id, donor_id, blood_group, units_needed, urgency, message, status, created_at
        FROM donor_requests
        WHERE donor_id=%s
        ORDER BY created_at DESC
    """, (donor_id,))
    rows = cur.fetchall()
    cur.close()

    result = []
    for r in rows:
        result.append({
            "id": r[0],
            "patient_id": r[1],
            "donor_id": r[2],
            "blood_group": r[3],
            "units_needed": r[4],
            "urgency": r[5],
            "message": r[6],
            "status": r[7],
            "created_at": r[8].strftime("%Y-%m-%d %H:%M:%S") if r[8] else None
        })

    return jsonify(result), 200



@app.route("/donor/requests/nearby", methods=["GET"])
def donor_requests_nearby():
    donor_id = request.args.get("donor_id")
    print("Nearby requests donor_id:", donor_id)

    if not donor_id:
        return jsonify({"error": "Missing donor_id"}), 400

    try:
        donor_id = int(donor_id)
    except Exception:
        return jsonify({"error": "donor_id must be a number"}), 400

    cur = mysql.connection.cursor()
    # 1. Fetch donor location & blood group
    cur.execute("""
        SELECT u.latitude, u.longitude, d.blood_group
        FROM users u 
        JOIN donors d ON u.id = d.user_id 
        WHERE u.id = %s
    """, (donor_id,))
    donor = cur.fetchone()
    
    if not donor:
        cur.close()
        return jsonify({"error": f"Donor {donor_id} not found"}), 400

    # Handle both tuple and dict cursor just in case
    if isinstance(donor, tuple):
        d_lat, d_lng, d_bg = donor
    else:
        d_lat, d_lng, d_bg = donor['latitude'], donor['longitude'], donor['blood_group']

    print(f"Donor location: {d_lat}, {d_lng}, BG: {d_bg}")

    if d_lat is None or d_lng is None:
        cur.close()
        return jsonify({"error": "Donor location not available"}), 400

    # 2. Fetch nearby requests (blood_requests table)
    # distance check: 20 km. Uses Haversine
    cur.execute("""
        SELECT 
            br.id, br.patient_name, br.hospital_name, br.contact_number, 
            br.blood_group, br.units_required, br.urgency_level, br.city, br.status,
            br.created_at, u.id as user_id, u.latitude, u.longitude,
            (
                6371 * 2 * ASIN(
                    SQRT(
                        POWER(SIN((RADIANS(u.latitude - %s)) / 2), 2) +
                        COS(RADIANS(%s)) *
                        COS(RADIANS(u.latitude)) *
                        POWER(SIN((RADIANS(u.longitude - %s)) / 2), 2)
                    )
                )
            ) AS distance_km
        FROM blood_requests br
        JOIN patients p ON br.patient_id = p.id
        JOIN users u ON p.user_id = u.id
        WHERE LOWER(br.status) = 'pending'
          AND LOWER(br.blood_group) = LOWER(%s)
          AND u.latitude IS NOT NULL
        HAVING distance_km <= 20
        ORDER BY distance_km ASC, br.created_at DESC
    """, (d_lat, d_lat, d_lng, d_bg))
    
    rows = cur.fetchall()
    cur.close()
    
    results = []
    for r in rows:
        # Handle tuple/dict for the results too
        if isinstance(r, tuple):
            rid, p_name, hosp, cont, bg, units, urg, city, stat, created, uid, lat, lng, dist = r
        else:
            rid, p_name, hosp, cont, bg, units, urg = r['id'], r['patient_name'], r['hospital_name'], r['contact_number'], r['blood_group'], r['units_required'], r['urgency_level']
            city, stat, created, uid, lat, lng, dist = r['city'], r['status'], r['created_at'], r['user_id'], r['latitude'], r['longitude'], r['distance_km']

        results.append({
            "id": rid,
            "patient_id": uid,
            "blood_group": bg,
            "units_needed": units,
            "urgency": urg,
            "message": f"Patient: {p_name} - {cont}",
            "status": stat,
            "hospital_name": hosp,
            "city": f"{city} ({round(float(dist), 1)} km)",
            "created_at": str(created)
        })
        
    return jsonify({
        "message": "Nearby requests fetched successfully",
        "count": len(results),
        "requests": results
    }), 200

@app.route("/donor/request/update", methods=["PUT"])
def donor_request_update():
    data = request.get_json(force=True)
    if "request_id" not in data or "status" not in data:
        return jsonify({"error": "Missing request_id/status"}), 400

    request_id = int(data["request_id"])
    status = data["status"].upper().strip()

    if status not in ["ACCEPTED", "REJECTED"]:
        return jsonify({"error": "status must be ACCEPTED or REJECTED"}), 400

    cur = mysql.connection.cursor()
    cur.execute("UPDATE donor_requests SET status=%s WHERE id=%s", (status, request_id))
    mysql.connection.commit()
    cur.close()

    return jsonify({"message": "Request updated", "status": status}), 200


# ================= UPDATE LOCATION =================
@app.route('/update_location', methods=['POST'])
def update_location():
    data = request.get_json(force=True)
    user_id = data.get('user_id')
    lat = data.get('latitude')
    lng = data.get('longitude')

    if not all([user_id is not None, lat is not None, lng is not None]):
        return jsonify({"error": "user_id, latitude, longitude required"}), 400

    cursor = mysql.connection.cursor()
    cursor.execute(
        "UPDATE users SET latitude=%s, longitude=%s WHERE id=%s",
        (lat, lng, user_id)
    )
    mysql.connection.commit()
    cursor.close()

    return jsonify({"message": "Location updated successfully"}), 200

# ✅ THIS ROUTE FIXES YOUR 404
@app.route("/", methods=["GET"])
def root():
    return jsonify({
        "status": "LifeFlow Chat API is running",
        "routes": {
            "POST": ["/chat/send"],
            "GET": ["/chat/history?user1=1&user2=2"]
        }
    })

# ================= LOAD AI MODEL =================
try:
    model = joblib.load("lifeflow_best_donor_model (1).pkl")
except Exception as e:
    print(f"Failed to load model: {e}")
    model = None

# ================= BLOOD COMPATIBILITY =================
COMPATIBLE = {
    "A+": ["A+", "A-", "O+", "O-"],
    "A-": ["A-", "O-"],
    "B+": ["B+", "B-", "O+", "O-"],
    "B-": ["B-", "O-"],
    "AB+": ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"],
    "AB-": ["A-", "B-", "AB-", "O-"],
    "O+": ["O+", "O-"],
    "O-": ["O-"]
}

# ================= DISTANCE FUNCTION =================
def haversine_km(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    r = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)

    a = (
        math.sin(dlat / 2) ** 2
        + math.cos(math.radians(lat1))
        * math.cos(math.radians(lat2))
        * math.sin(dlon / 2) ** 2
    )
    c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))
    return r * c

# ================= BLOOD MATCH SCORE =================
def get_blood_match_score(patient_bg: str, donor_bg: str) -> float:
    patient_bg = (patient_bg or "").strip().upper()
    donor_bg = (donor_bg or "").strip().upper()

    if donor_bg == patient_bg:
        return 1.0
    if donor_bg in COMPATIBLE.get(patient_bg, []):
        return 0.7
    return 0.0

# ================= SAFE VALUE HELPERS =================
def to_int(value, default=0):
    try:
        return int(value)
    except Exception:
        return default

def to_float(value, default=0.0):
    try:
        return float(value)
    except Exception:
        return default

# ================= AI SCORE FUNCTION =================
def predict_ai_score(donor_features: dict) -> float:
    if not model:
        return 0.0
    feature_row = [[
        donor_features["blood_match_score"],
        donor_features["distance_km"],
        donor_features["is_available"],
        donor_features["is_eligible"],
        donor_features["days_since_last_donation"],
        donor_features["urgency_level"],
        donor_features["past_acceptance_rate"],
        donor_features["response_time_avg"],
        donor_features["donor_active_status"]
    ]]
    score = model.predict_proba(feature_row)[0][1]
    return round(float(score), 4)

# ================= GET NEARBY DONORS =================
def fetch_all_donors():
    """
    Gets donor data from users + donors table.
    You can add extra fields later if available in your DB.
    """
    cursor = mysql.connection.cursor(DictCursor)
    query = """
        SELECT
            u.id,
            u.name,
            u.email,
            u.latitude,
            u.longitude,
            d.phone,
            d.blood_group,
            d.age,
            d.city,
            d.is_available,
            d.is_eligible,
            d.last_status_update,
            d.past_acceptance_rate,
            d.response_time_avg,
            d.donor_active_status,
            d.last_donation_date,
            d.avg_rating,
            d.sentiment_score,
            d.total_reviews
        FROM users u
        INNER JOIN donors d ON u.id = d.user_id
        WHERE u.role = 'donor'
          AND u.latitude IS NOT NULL
          AND u.longitude IS NOT NULL
    """
    cursor.execute(query)
    donors = cursor.fetchall()
    cursor.close()
    return donors

# ================= MAIN API =================
@app.route('/emergency-donors', methods=['POST'])
def emergency_donors():
    try:
        data = request.get_json(force=True)

        patient_id = data.get("patient_id")
        patient_blood_group = str(data.get("blood_group", "")).strip().upper()
        patient_lat = to_float(data.get("lat"))
        patient_lng = to_float(data.get("lng"))
        units_required = to_int(data.get("units_required", 1), 1)
        radius_km = to_float(data.get("radius_km", 5), 5.0)

        print(f"DEBUG: Emergency Search - BG: {patient_blood_group}, Lat: {patient_lat}, Lng: {patient_lng}, Radius: {radius_km}")

        if not patient_blood_group or (patient_lat == 0.0 and patient_lng == 0.0):
            return jsonify({
                "error": "blood_group, lat, lng are required"
            }), 400

        all_donors = fetch_all_donors()
        ranked_donors = []

        for donor in all_donors:
            donor_lat = to_float(donor.get("latitude"))
            donor_lng = to_float(donor.get("longitude"))

            if donor_lat == 0.0 and donor_lng == 0.0:
                continue

            distance_km = haversine_km(patient_lat, patient_lng, donor_lat, donor_lng)

            if distance_km > radius_km:
                continue

            donor_blood_group = str(donor.get("blood_group", "")).strip().upper()
            
            if patient_blood_group == "ALL":
                blood_match_score = 1.0
            else:
                blood_match_score = get_blood_match_score(patient_blood_group, donor_blood_group)

            if blood_match_score == 0.0:
                continue

            is_available = to_int(donor.get("is_available"), 0)
            is_eligible = to_int(donor.get("is_eligible"), 0)

            if is_available != 1 or is_eligible != 1:
                continue

            # --- REAL AI VALUES FROM DB ---
            # Calculate days since last donation
            last_don = donor.get("last_donation_date")
            if last_don:
                # If it's a string, convert to date. Usually MySQLdb returns date objects.
                if isinstance(last_don, str):
                    last_don = datetime.strptime(last_don, "%Y-%m-%d").date()
                days_since_last_donation = (datetime.now().date() - last_don).days
            else:
                days_since_last_donation = 180 # Default to 6 months if never donated

            # Acceptance Rate (0.0 to 1.0)
            past_acceptance_rate = to_float(donor.get("past_acceptance_rate"), 0.80)
            # Response Time (minutes)
            response_time_avg = to_int(donor.get("response_time_avg"), 5)
            # Active status
            donor_active_status = to_int(donor.get("donor_active_status"), 1)
            
            urgency_level = 2  # emergency mode

            donor_features = {
                "blood_match_score": blood_match_score,
                "distance_km": round(distance_km, 2),
                "is_available": is_available,
                "is_eligible": is_eligible,
                "days_since_last_donation": days_since_last_donation,
                "urgency_level": urgency_level,
                "past_acceptance_rate": past_acceptance_rate,
                "response_time_avg": response_time_avg,
                "donor_active_status": donor_active_status
            }

            ai_score = predict_ai_score(donor_features)

            ranked_donors.append({
                "donor_id": donor["id"],
                "name": donor.get("name"),
                "email": donor.get("email"),
                "phone": donor.get("phone"),
                "blood_group": donor_blood_group,
                "age": donor.get("age"),
                "city": donor.get("city"),
                "latitude": donor_lat,
                "longitude": donor_lng,
                "distance_km": round(distance_km, 2),
                "blood_match_score": blood_match_score,
                "is_available": is_available,
                "is_eligible": is_eligible,
                "days_since_last_donation": days_since_last_donation,
                "past_acceptance_rate": past_acceptance_rate,
                "response_time_avg": response_time_avg,
                "donor_active_status": donor_active_status,
                "urgency_level": urgency_level,
                "ai_score": ai_score,
                "avg_rating": to_float(donor.get("avg_rating"), 0.0),
                "sentiment_score": to_float(donor.get("sentiment_score"), 0.0),
                "total_reviews": to_int(donor.get("total_reviews"), 0)
            })

        ranked_donors.sort(key=lambda x: (x["ai_score"], -x["distance_km"]), reverse=True)

        best_donor = ranked_donors[0] if ranked_donors else None

        return jsonify({
            "message": "Emergency donor search completed",
            "patient_id": patient_id,
            "patient_blood_group": patient_blood_group,
            "units_required": units_required,
            "radius_km": radius_km,
            "best_donor": best_donor,
            "nearby_donors": ranked_donors,
            "total_donors_found": len(ranked_donors)
        }), 200

    except Exception as e:
        return jsonify({
            "error": "Failed to fetch emergency donors",
            "details": str(e)
        }), 500

# ================= RUN =================
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8006, debug=True)
