# Setup Guide — Job Market Intelligence Dashboard

This guide explains how the Job Market Intelligence Dashboard system is structured and how its components work together.

This project is intended as a **portfolio demonstration** of analytics engineering, data pipelines, and visualization — not as a one-click deployable application.

## 🧱 System Overview

The system is composed of four layers:

1. **Data Sources**
   - Job postings collected from public APIs and RSS feeds

2. **Data Pipeline (n8n)**
   - Scheduled workflows ingest, transform, and store job data
   - Daily aggregation workflows compute summary metrics
   - Export workflows publish analytics-ready data to Google Sheets

3. **Database (PostgreSQL / Supabase)**
   - Normalized tables store raw job data
   - SQL views expose metrics for dashboards

4. **Visualization (Tableau Public)**
   - Dashboards connect to Google Sheets
   - Visuals update automatically as new data is exported
  
     
## ✅ Prerequisites

To reproduce the system, you would need:

- Supabase account (PostgreSQL)
- n8n (cloud or self-hosted)
- Google Sheets
- Tableau Public Desktop
- API access (e.g., Adzuna API, Indeed RSS)

> API keys and credentials are not included in this repository.


## 🗄️ Step 1: Database Setup (Supabase)

1. Create a new Supabase project  
2. Open the SQL Editor  
3. Run the following files **in order**:
   
database/schema.sql  
database/seed-data.sql  
database/views.sql  

This will:

- Create all database tables
- Seed reference data (skills, locations, companies)
- Create analytics-ready SQL views used by dashboards

## 🔄 Step 2: n8n Workflows

1. Open n8n  
2. Import workflows from the `n8n-workflows/` directory:

daily-job-collection.json  
indeed-rss-collection.json  
daily-aggregation.json  
sheets-export.json  
job-match-alerts.json  

3. Configure credentials:
   - PostgreSQL (Supabase)
   - API keys
   - Google Sheets access

4. Activate workflows:
   - Job collection runs daily
   - Aggregation runs after ingestion
   - Export publishes data to Google Sheets
  
   
## 📤 Step 3: Google Sheets Export

The export workflow:

- Clears existing data rows while preserving headers
- Writes fresh data from SQL views into separate sheets
- Ensures Tableau connections remain stable as data grows

Each sheet corresponds to an analytics view, such as:

- Daily metrics
- Skills frequency
- Salary by location
- Company hiring trends

## 📁 Repository Notes

- SQL files represent the logical data model
- n8n workflow exports exclude credentials by design
- Dashboards shown in screenshots reflect live data at time of capture

This repository emphasizes **architecture, automation, and analytics design** rather than production deployment.

## 🧠 Intended Use

This project demonstrates:

- Analytics engineering practices
- Automated ETL pipelines
- Dashboard-driven insights
- Real-world data modeling tradeoffs

It is not intended as a turnkey application.

## 📌 Troubleshooting Notes

- Tableau Public requires Google Sheets to retain a consistent structure
- Date formatting is handled upstream for compatibility
- Workflows are designed to be idempotent and re-runnable

## 📬 Questions

If you have questions about the design or implementation, feel free to reach out via GitHub or LinkedIn.
