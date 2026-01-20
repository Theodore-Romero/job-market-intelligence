# Job Market Intelligence Dashboard

An automated analytics system that collects job postings daily, aggregates market metrics, extracts in-demand skills, and visualizes trends through interactive Tableau dashboards.

![Tableau](https://img.shields.io/badge/Tableau-E97627?style=flat&logo=tableau&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-336791?style=flat&logo=postgresql&logoColor=white)
![N8N](https://img.shields.io/badge/N8N-EA4B71?style=flat&logo=n8n&logoColor=white)

---

## 🔗 Live Dashboards

**Job Market Overview Dashboard**  
👉 **[View on Tableau Public →](https://public.tableau.com/app/profile/theodore.romero8696/viz/Job-Market-Metrics/MarketOverview).**

**Skill Demand Dashboard**  
👉 **[View on Tableau Public →](https://public.tableau.com/app/profile/theodore.romero8696/viz/SkillsDemand/SkillDemand?publish=yes)**

**Salary Insights Dashboard**  
👉 **[View on Tableau Public →](https://public.tableau.com/app/profile/theodore.romero8696/viz/Salary-Insights/SalaryInsights?publish=yes)**

---

## 📊 Overview

This project answers the question:

**What skills, salary ranges, and work arrangements define the current data & analytics job market?**

The system automatically:
- Collects job postings daily from multiple sources
- Aggregates job counts, salary metrics, and work-type breakdowns
- Extracts and categorizes skills from job descriptions
- Publishes live dashboards that update as new data arrives

Rather than a static report, this project functions as a **continuously updating job market intelligence platform**.

---

## 🔍 Key Insights

Insights below are drawn directly from the live dashboards:

- **Job postings are steadily increasing over time**, indicating sustained hiring demand
- **Remote roles dominate the dataset**, accounting for over **96%** of tracked positions
- **Programming, tools, and soft skills** are the most frequently mentioned skill categories
- **R, Go, and communication skills** rank among the most in-demand individual skills
- **Salary distribution is right-skewed**, with most roles clustered in lower-to-mid ranges and fewer high-paying outliers
- **Significant salary variation exists by location**, with several cities exceeding the overall average salary benchmark

---

## 🛠️ Tech Stack

| Component | Technology |
|---------|------------|
| Database | PostgreSQL (Supabase) |
| Data Pipeline | N8N (workflow automation) |
| Data Sources | Adzuna API, Indeed RSS |
| Visualization | Tableau Public |
| Version Control | Git/GitHub |

---

## 📐 Architecture
'
Adzuna API ─┐

                 ├──▶ N8N Workflows ───▶ PostgreSQL (Supabase) ───▶ Google Sheets ───▶ Tableau Public
            
Indeed RSS ─┘                       └──▶ Email Alerts (Job Match Notifications)
                    


---

## 📁 Repository Structure

job-market-intelligence/

├── README.md


├── database/

│ ├── schema.sql

│ ├── seed-data.sql

│ └── views.sql


├── n8n-workflows/

│ ├── daily-job-collection.json

│ ├── daily-aggregation.json

│ └── job-match-alerts.json

│ └── sheets-export.json

│ └── wework-rss-collection.json


├── screenshots/

│ ├── job-market-overview.png

│ ├── skills-demand.png

│ ├── salary-insights.png

│ └── architecture.png

│ └── daily-job-collection.png

│ └── job-market-overview.png


└── docs/

└── setup-guide.md


---

## 📈 Dashboard Pages

### 1. Market Overview
- Total job postings KPI
- New jobs added today
- Remote vs on-site percentage breakdown
- Jobs over time with growth trend reference

### 2. Skills Demand
- Top skills by job mention frequency
- Skill demand grouped by category
- Comparison of technical vs soft skills

### 3. Salary Insights
- Salary distribution histogram
- Average salary by location
- Average salary reference line for comparison

---

## ⚙️ Setup Instructions

### Prerequisites
- Supabase account (free tier)
- N8N account (cloud or self-hosted)
- Tableau Public account
- Adzuna API key

### Step 1: Database Setup
1. Create a new Supabase project
2. Run `database/schema.sql` in the SQL editor
3. Run `database/seed-data.sql`
4. Run `database/views.sql`

### Step 2: N8N Workflows
1. Import workflows from the `n8n-workflows/` folder
2. Configure PostgreSQL credentials
3. Add API keys
4. Activate scheduled workflows

### Step 3: Tableau Connection
1. Open Tableau Public Desktop
2. Connect to Google Sheets (exported from N8N)
3. Build visualizations
4. Publish dashboards to Tableau Public

---

## 🧠 Skills Demonstrated

- **SQL**: Aggregations, views, joins, and analytical queries
- **Data Engineering**: Automated ETL pipelines and scheduled workflows
- **Analytics Engineering**: Metric definition, daily snapshots, trend analysis
- **Data Visualization**: KPI design, distributions, comparative analysis
- **System Design**: End-to-end data flow from ingestion to visualization

---

## 📬 Contact

**Theodore Romero**  
- LinkedIn: https://linkedin.com/in/theodoreromero  
- Email: p.theodore.romero@gmail.com

---

## 📄 License

This project is open source and available under the MIT License.
