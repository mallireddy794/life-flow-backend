from flask import Flask, request, jsonify
from flask_mysqldb import MySQL
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# MySQL config (XAMPP)
app.config["MYSQL_HOST"] = "localhost"
app.config["MYSQL_USER"] = "root"
app.config["MYSQL_PASSWORD"] = ""
app.config["MYSQL_DB"] = "lifeflow_db"   # ✅ your DB name from screenshot
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)

def generate_chat_id(user1: int, user2: int) -> str:
    return f"{min(user1, user2)}_{max(user1, user2)}"

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
    try:
        user1 = request.args.get("user1")
        user2 = request.args.get("user2")

        if not user1 or not user2:
            return jsonify({"error": "Missing user1 or user2"}), 400

        user1 = int(user1)
        user2 = int(user2)
        chat_id = generate_chat_id(user1, user2)

        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT id, chat_id, sender_id, receiver_id, message, created_at
            FROM chat_messages
            WHERE chat_id=%s
            ORDER BY created_at ASC
        """, (chat_id,))
        rows = cur.fetchall()
        cur.close()

        # Convert tuples/rows to JSON-serializable dictionaries
        result = []
        for row in rows:
            # Ensure message_dict is always properly formatted for JSON
            message_dict = {
                "id": row[0] if isinstance(row, (tuple, list)) else row.get("id"),
                "chat_id": row[1] if isinstance(row, (tuple, list)) else row.get("chat_id"),
                "sender_id": row[2] if isinstance(row, (tuple, list)) else row.get("sender_id"),
                "receiver_id": row[3] if isinstance(row, (tuple, list)) else row.get("receiver_id"),
                "message": row[4] if isinstance(row, (tuple, list)) else row.get("message"),
                "created_at": (row[5].strftime("%a, %d %b %Y %H:%M:%S %Z") if hasattr(row[5], 'strftime') else str(row[5])) if isinstance(row, (tuple, list)) else row.get("created_at")
            }
            result.append(message_dict)

        return jsonify(result)

    except Exception as e:
        print("chat_history error:", e)
        return jsonify({"error": str(e)}), 500


        
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)