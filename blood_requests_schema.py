import MySQLdb
f = open("blood_requests_schema.txt", "w")
try:
    db = MySQLdb.connect(host="localhost", user="root", passwd="", db="lifeflow_db")
    cur = db.cursor()
    cur.execute("SHOW CREATE TABLE blood_requests")
    row = cur.fetchone()
    f.write(row[1])
    db.close()
except Exception as e:
    f.write(str(e))
f.close()
