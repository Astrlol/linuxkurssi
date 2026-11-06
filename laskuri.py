import os
import sqlite3
from flask import Flask, jsonify

DB = os.path.join(os.path.dirname(os.path.abspath(__file__)), "visits.db")
app = Flask(__name__)

def db():
    conn = sqlite3.connect(DB)
    conn.execute("""CREATE TABLE IF NOT EXISTS visits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        visited_at TEXT DEFAULT CURRENT_TIMESTAMP
        )""")
    return conn

@app.post("/api/visit")
def visit():
    with db() as conn:
        conn.execute("INSERT INTO visits DEFAULT VALUES")
        count = conn.execute("SELECT COUNT(*) FROM visits").fetchone()[0]
    return jsonify(count=count)