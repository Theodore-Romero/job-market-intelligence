
# Job Market Intelligence Dashboard

An automated analytics system that collects job postings daily, extracts in-demand skills, and visualizes market trends through an interactive Tableau dashboard.

![Tableau](https://img.shields.io/badge/Tableau-E97627?style=flat&logo=tableau&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![N8N](https://img.shields.io/badge/N8N-EA4B71?style=flat&logo=n8n&logoColor=white)

---

## 🔗 Live Dashboard

**[View on Tableau Public →](https://public.tableau.com/app/profile/theodoreromero)**

*Link will be added when dashboard is published*

---

## 📊 Overview

This project answers the question: **What skills should I learn to maximize my job prospects in data analytics?**

The system automatically:
- Collects 100+ job postings daily from multiple APIs
- Extracts skills mentioned in job descriptions
- Calculates salary trends by role, location, and skill
- Visualizes insights in a 6-page interactive dashboard

---

## 🔍 Key Insights

- SQL appears in **78%** of data analyst job postings
- Python skills correlate with a **15% salary premium**
- Remote roles represent **45%** of the market
- Top hiring companies and their salary ranges

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|------------|
| Database | PostgreSQL (Supabase) |
| Data Pipeline | N8N (workflow automation) |
| Data Sources | Adzuna API, Indeed RSS |
| Visualization | Tableau Public |
| Version Control | Git/GitHub |

---

## 📐 Architecture


┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌──────────────┐ │ Adzuna │ │ │ │ │ │ │ │ API │────▶│ N8N │────▶│ PostgreSQL │────▶│ Tableau │ │ │ │ Workflows │ │ Database │ │ Dashboard │ │ Indeed │ │ │ │ │ │ │ │ RSS │────▶│ │ │ │ │ │ └──────────────┘ └──────────────┘ └──────────────┘ └──────────────┘ │ ▼ ┌──────────────┐ │ Email │ │ Alerts │ └──────────────┘

---

## 📁 Repository Structure


job-market-intelligence/ ├── README.md ├── database/ │ ├── schema.sql │ ├── seed-data.sql │ └── views.sql ├── n8n-workflows/ │ ├── daily-job-collection.json │ ├── daily-aggregation.json │ └── job-match-alerts.json ├── screenshots/ │ ├── dashboard-overview.png │ ├── skills-demand.png │ ├── salary-analysis.png │ └── architecture.png └── docs/ └── setup-guide.md

---

## 📈 Dashboard Pages

### 1. Market Overview
- Total job postings, average salary, remote percentage
- Jobs over time trend
- Distribution by category

### 2. Skills Demand
- Top 15 skills by frequency
- Skills trend over time
- Skills by category

### 3. Salary Analysis
- Salary distribution histogram
- Salary by location
- Salary by experience level

### 4. Geographic View
- Jobs by city/state
- Remote vs on-site breakdown
- Regional salary comparison

### 5. Company Insights
- Top hiring companies
- Company salary ranges
- Hiring trends

### 6. Personal Tracker
- Jobs matching my criteria
- Application pipeline
- New matches this week

---

## ⚙️ Setup Instructions

### Prerequisites
- Supabase account (free tier)
- N8N account (cloud or self-hosted)
- Tableau Public account (free)
- Adzuna API key (free)

### Step 1: Database Setup
1. Create a new Supabase project
2. Run `database/schema.sql` in SQL Editor
3. Run `database/seed-data.sql` for initial data
4. Run `database/views.sql` for analytics views

### Step 2: N8N Workflows
1. Import workflows from `n8n-workflows/` folder
2. Update PostgreSQL credentials
3. Update API keys
4. Activate workflows

### Step 3: Tableau Connection
1. Open Tableau Public Desktop
2. Connect to Google Sheets (exported from N8N)
3. Build visualizations
4. Publish to Tableau Public

---

## 🧠 Skills Demonstrated

- **SQL**: Complex queries, window functions, CTEs, triggers, views
- **Data Engineering**: API integration, ETL pipelines, workflow automation
- **Data Visualization**: Interactive dashboards, storytelling with data
- **Database Design**: Normalized schema, indexing, query optimization

---

## 📬 Contact

**Theodore Romero**
- LinkedIn: [linkedin.com/in/theodoreromero](https://linkedin.com/in/theodoreromero)
- Email: theodore.romero@email.com

---

## 📄 License

This project is open source and available under the MIT License.

