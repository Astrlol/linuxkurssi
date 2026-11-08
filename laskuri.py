import os
import pymysql
from flask import Flask, render_template

app = Flask(__name__)


def db():
    return pymysql.connect(
        unix_socket="/run/mysqld/mysqld.sock",
        user=os.environ["DB_USER"],
        password=os.environ["DB_PASSWORD"],
        database=os.environ["DB_NAME"],
        autocommit=True,
    )


@app.get("/")
def index():
    conn = db()
    try:
        with conn.cursor() as cur:
            cur.execute("INSERT INTO visits () VALUES ()")
            cur.execute("SELECT COUNT(*) FROM visits")
            count = cur.fetchone()[0]
    finally:
        conn.close()
    return render_template("index.html", count=count)