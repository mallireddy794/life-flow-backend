import MySQLdb
f = open("users_ids.txt", "w")
try:
    db = MySQLdb.connect(host="localhost", user="root", passwd="", db="lifeflow_db")
    cur = db.cursor()
    cur.execute("SELECT id, name, role FROM users")
    f.write("USERS:\n")
    for r in cur.fetchall():
        f.write(str(r) + "\n")
    cur.execute("SELECT id, user_id, phone FROM donors")
    f.write("\nDONORS:\n")
    for r in cur.fetchall():
        f.write(str(r) + "\n")
    cur.execute("SELECT id, user_id, phone FROM patients")
    f.write("\nPATIENTS:\n")
    for r in cur.fetchall():
        f.write(str(r) + "\n")
    db.close()
except Exception as e:
    f.write(str(e))
f.close()
