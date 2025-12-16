# User Behaviour Conversion Analysis

This project analyses how users of an AI content generation web app move from signing up to becoming paid customers.  
It follows the assignment brief in `Data-analyst-assignment-1.pdf` using three CSV files: users, events, and payments.

---

## 1. Folder structure

 ```
.
├── .venv/                      \# Python virtual environment
├── Data/
│   ├── events_v2 (1).csv
│   ├── payments_v2 (1).csv
│   └── users_v2 (1).csv
├── NoteBook/
│   └── analysisNB.ipynb        \# Main Python notebook
├── Reports/                    \# Final report / slides (to be added)
├── SQL/
│   ├── 30_Days_Upgrade.sql     \# Upgrade within 30 days
│   ├── Conversion_Signals.sql  \# Behaviour metrics
│   ├── Create_DB.sql           \# Database \& tables
│   ├── Funnel.sql              \# Product funnel
│   ├── Retention.sql           \# Weekly retention
│   └── Segmentation.sql        \# Funnel by country/device/source
└── README.md

 ```
---

## 2. Prerequisites

- Python 3.x  
- VS Code with Jupyter and Python extensions  
- PostgreSQL 18 with pgAdmin 4  
- CSV files placed in the `Data/` folder as shown above. 

---

## 3. Python setup (notebook)

1. **Create and activate virtual environment**
python -m venv .venv
.venv\Scripts\activate

2. **Install dependencies**
pip install pandas jupyter

3. **Open the notebook**

- Open the project folder in VS Code.  
- Open `NoteBook/analysisNB.ipynb`.  
- Select the `.venv` interpreter at the top of the notebook.

4. **Load the data in the notebook**

import pandas as pd
from pathlib import Path

data_dir = Path("../Data")

users    = pd.read_csv(data_dir / "users_v2 (1).csv")
events   = pd.read_csv(data_dir / "events_v2 (1).csv")
payments = pd.read_csv(data_dir / "payments_v2 (1).csv")

users["signup_date"]     = pd.to_datetime(users["signup_date"], dayfirst=True, errors="coerce")
events["event_time"]     = pd.to_datetime(events["event_time"], dayfirst=True, errors="coerce")
payments["payment_date"] = pd.to_datetime(payments["payment_date"], dayfirst=True, errors="coerce")

5. **Run the analysis cells**

The notebook:

- Builds a 4‑step funnel: Signed up → Viewed feature → Returned in 7 days → Upgraded. 
- Segments the funnel by country, device, and source.  
- Calculates user‑level behaviour metrics (events, active days, time to first feature, etc.). 
- Computes weekly retention and upgrade‑within‑30‑days metrics. 

---

## 4. PostgreSQL setup (SQL)

1. **Create database**

- Open pgAdmin 4.  
- Create database `webapp_analytics`.

2. **Create tables**

- Open `SQL/Create_DB.sql` in pgAdmin’s Query Tool.  
- Run the script to create `users`, `events`, and `payments` tables.

3. **Import CSV data**

For each table (`users`, `events`, `payments`):

- Right‑click the table → **Import/Export Data…**  
- Choose the matching CSV from the `Data/` folder.  
- Set Format = CSV, Encoding = UTF8, Header = checked, Delimiter = `,`.  
- Click **OK**.  
- Verify with:

  SELECT * FROM users    LIMIT 5;
  SELECT * FROM events   LIMIT 5;
  SELECT * FROM payments LIMIT 5;

---

## 5. SQL scripts

Run these scripts in pgAdmin against `webapp_analytics`:

- **`Funnel.sql`**  
- Computes the 4‑step product funnel and conversion rates between steps. 

- **`Segmentation.sql`**  
- Calculates funnel metrics and signup→upgrade rate by country, device, and source. 

- **`Conversion_Signals.sql`**  
- Builds per‑user metrics (total events, distinct events, active days, time to first feature, time to upgrade) and labels users as upgraded vs non‑upgraded. 

- **`Retention.sql`**  
- Computes weekly retention: percentage of users active in week 0, 1, 2, etc. after signup. 

- **`30_Days_Upgrade.sql`**  
- Counts users who upgrade within 30 days of signup and the corresponding upgrade rate. 

---

## 6. How everything fits together

1. **Python notebook**  
- Used for exploratory analysis and for validating that funnel, segmentation, and retention calculations make sense.

2. **PostgreSQL scripts**  
- Provide clean, reproducible queries that generate the key metrics required in the assignment:
  - Funnel analysis  
  - Segment comparison  
  - Conversion signals  
  - Cohort retention  
  - 30‑day upgrade rate 

3. **Reports folder**  
- Contains the final written report or slides based on the outputs from the notebook and SQL scripts (funnel tables, segment tables, behavioural insights, and recommendations). 

Anyone following this README can set up the environment, load the data, run the notebook and SQL scripts, and reproduce the full analysis from raw CSVs to final insights.

**Note**
> The code and SQL in this project are meant to show the overall analysis approach (funnel, segments, retention, etc.).
> You do not need to copy the variable names or table aliases exactly.

> Feel free to rename variables or reorganize queries as long as the logic remains the same.

