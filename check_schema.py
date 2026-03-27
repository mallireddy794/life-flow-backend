import MySQLdb
import sys
f = open("schema_output.txt", "w")
try:
    db = MySQLdb.connect(host="localhost", user="root", passwd="", db="lifeflow_db")
    cur = db.cursor()
    cur.execute("SHOW CREATE TABLE donor_requests")
    row = cur.fetchone()
    f.write(row[1])
    f.write("\n\n")
    cur.execute("DESCRIBE donor_requests")
    rows = cur.fetchall()
    for r in rows:
        f.write(str(r) + "\n")
    db.close()
except Exception as e:
    f.write(str(e))
f.close()
