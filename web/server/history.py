import sqlite3
# Copyright Thierry CHEVASSUS — PolyForm Noncommercial 1.0.0 — voir LICENSE
from datetime import datetime
from pathlib import Path

DB_FILE = Path.home() / "DMP-FINAL" / "dmp-history.db"

def init_db():
    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.execute('''CREATE TABLE IF NOT EXISTS metrics (
        id INTEGER PRIMARY KEY,
        timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
        metric_name TEXT,
        value REAL,
        unit TEXT
    )''')
    conn.commit()
    conn.close()

def record_metric(name, value, unit="%"):
    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.execute('INSERT INTO metrics (metric_name, value, unit) VALUES (?, ?, ?)',
              (name, value, unit))
    conn.commit()
    conn.close()

def get_history(metric_name, hours=24):
    conn = sqlite3.connect(DB_FILE)
    c = conn.cursor()
    c.execute('''SELECT timestamp, value FROM metrics 
                 WHERE metric_name=? AND timestamp > datetime('now', '-' || ? || ' hours')
                 ORDER BY timestamp''', (metric_name, hours))
    data = c.fetchall()
    conn.close()
    return data

init_db()
