import MySQLdb
f = open("full_users.txt", "w")
try:
    db = MySQLdb.connect(host="localhost", user="root", passwd="", db="lifeflow_db")
    cur = db.cursor()
    cur.execute("SELECT id FROM users")
    f.write("USERS IDs:\n")
    ids = [str(r[0]) for r in cur.fetchall()]
    f.write(", ".join(ids) + "\n")
    db.close()
except Exception as e:
    f.write(str(e))
f.close()
