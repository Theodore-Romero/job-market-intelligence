-- ============================================
-- JOB MARKET INTELLIGENCE DASHBOARD
-- Seed Data
-- ============================================
-- Run this file AFTER schema.sql
-- ============================================

-- ============================================
-- SKILLS SEED DATA
-- ============================================

-- Technical Skills - Programming Languages
INSERT INTO skills (skill_name, skill_category) VALUES
('Python', 'Programming'),
('R', 'Programming'),
('SQL', 'Programming'),
('Java', 'Programming'),
('JavaScript', 'Programming'),
('Scala', 'Programming'),
('Julia', 'Programming'),
('SAS', 'Programming'),
('MATLAB', 'Programming'),
('C++', 'Programming'),
('Go', 'Programming'),
('Ruby', 'Programming'),
('PHP', 'Programming'),
('TypeScript', 'Programming'),
('Bash', 'Programming'),
('Shell', 'Programming'),
('VBA', 'Programming')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Data & Analytics
INSERT INTO skills (skill_name, skill_category) VALUES
('Data Analysis', 'Analytics'),
('Data Modeling', 'Analytics'),
('Data Mining', 'Analytics'),
('Data Warehousing', 'Analytics'),
('ETL', 'Analytics'),
('Data Pipeline', 'Analytics'),
('Data Engineering', 'Analytics'),
('Data Visualization', 'Analytics'),
('Business Intelligence', 'Analytics'),
('Statistical Analysis', 'Analytics'),
('Predictive Analytics', 'Analytics'),
('Descriptive Analytics', 'Analytics'),
('Prescriptive Analytics', 'Analytics'),
('Data Governance', 'Analytics'),
('Data Quality', 'Analytics'),
('Master Data Management', 'Analytics'),
('Data Catalog', 'Analytics'),
('Data Lineage', 'Analytics')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Databases
INSERT INTO skills (skill_name, skill_category) VALUES
('PostgreSQL', 'Database'),
('MySQL', 'Database'),
('SQL Server', 'Database'),
('Oracle', 'Database'),
('MongoDB', 'Database'),
('Redis', 'Database'),
('Elasticsearch', 'Database'),
('Cassandra', 'Database'),
('DynamoDB', 'Database'),
('SQLite', 'Database'),
('MariaDB', 'Database'),
('Snowflake', 'Database'),
('Redshift', 'Database'),
('BigQuery', 'Database'),
('Databricks', 'Database'),
('Teradata', 'Database'),
('Vertica', 'Database'),
('Presto', 'Database'),
('Hive', 'Database'),
('Spark SQL', 'Database')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Visualization Tools
INSERT INTO skills (skill_name, skill_category) VALUES
('Tableau', 'Visualization'),
('Power BI', 'Visualization'),
('Looker', 'Visualization'),
('Qlik', 'Visualization'),
('QlikView', 'Visualization'),
('Qlik Sense', 'Visualization'),
('Metabase', 'Visualization'),
('Superset', 'Visualization'),
('Grafana', 'Visualization'),
('D3.js', 'Visualization'),
('Plotly', 'Visualization'),
('Matplotlib', 'Visualization'),
('Seaborn', 'Visualization'),
('ggplot2', 'Visualization'),
('Streamlit', 'Visualization'),
('Dash', 'Visualization'),
('Shiny', 'Visualization'),
('Google Data Studio', 'Visualization'),
('Sisense', 'Visualization'),
('Domo', 'Visualization'),
('Mode', 'Visualization'),
('Sigma', 'Visualization'),
('ThoughtSpot', 'Visualization')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Cloud Platforms
INSERT INTO skills (skill_name, skill_category) VALUES
('AWS', 'Cloud'),
('Azure', 'Cloud'),
('GCP', 'Cloud'),
('Google Cloud', 'Cloud'),
('Amazon Web Services', 'Cloud'),
('Microsoft Azure', 'Cloud'),
('Heroku', 'Cloud'),
('DigitalOcean', 'Cloud'),
('Snowflake', 'Cloud'),
('Databricks', 'Cloud')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Big Data
INSERT INTO skills (skill_name, skill_category) VALUES
('Hadoop', 'Big Data'),
('Spark', 'Big Data'),
('Apache Spark', 'Big Data'),
('Kafka', 'Big Data'),
('Apache Kafka', 'Big Data'),
('Airflow', 'Big Data'),
('Apache Airflow', 'Big Data'),
('Flink', 'Big Data'),
('Storm', 'Big Data'),
('Beam', 'Big Data'),
('Pig', 'Big Data'),
('MapReduce', 'Big Data'),
('HDFS', 'Big Data'),
('Dask', 'Big Data'),
('Prefect', 'Big Data'),
('Dagster', 'Big Data'),
('Luigi', 'Big Data'),
('dbt', 'Big Data'),
('Fivetran', 'Big Data'),
('Stitch', 'Big Data'),
('Airbyte', 'Big Data')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Machine Learning & AI
INSERT INTO skills (skill_name, skill_category) VALUES
('Machine Learning', 'ML/AI'),
('Deep Learning', 'ML/AI'),
('TensorFlow', 'ML/AI'),
('PyTorch', 'ML/AI'),
('Keras', 'ML/AI'),
('Scikit-learn', 'ML/AI'),
('XGBoost', 'ML/AI'),
('LightGBM', 'ML/AI'),
('CatBoost', 'ML/AI'),
('NLP', 'ML/AI'),
('Natural Language Processing', 'ML/AI'),
('Computer Vision', 'ML/AI'),
('Neural Networks', 'ML/AI'),
('Random Forest', 'ML/AI'),
('Regression', 'ML/AI'),
('Classification', 'ML/AI'),
('Clustering', 'ML/AI'),
('Time Series', 'ML/AI'),
('Forecasting', 'ML/AI'),
('A/B Testing', 'ML/AI'),
('MLOps', 'ML/AI'),
('Feature Engineering', 'ML/AI'),
('Model Deployment', 'ML/AI'),
('LLM', 'ML/AI'),
('GPT', 'ML/AI'),
('Generative AI', 'ML/AI'),
('Prompt Engineering', 'ML/AI'),
('RAG', 'ML/AI'),
('Langchain', 'ML/AI'),
('Hugging Face', 'ML/AI')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Tools & Platforms
INSERT INTO skills (skill_name, skill_category) VALUES
('Excel', 'Tools'),
('Microsoft Excel', 'Tools'),
('Google Sheets', 'Tools'),
('Jupyter', 'Tools'),
('Jupyter Notebook', 'Tools'),
('Git', 'Tools'),
('GitHub', 'Tools'),
('GitLab', 'Tools'),
('Docker', 'Tools'),
('Kubernetes', 'Tools'),
('Jenkins', 'Tools'),
('JIRA', 'Tools'),
('Confluence', 'Tools'),
('Slack', 'Tools'),
('Notion', 'Tools'),
('Asana', 'Tools'),
('Monday', 'Tools'),
('Trello', 'Tools'),
('VS Code', 'Tools'),
('PyCharm', 'Tools'),
('RStudio', 'Tools'),
('Alteryx', 'Tools'),
('KNIME', 'Tools'),
('Informatica', 'Tools'),
('Talend', 'Tools'),
('SSIS', 'Tools'),
('Pentaho', 'Tools'),
('N8N', 'Tools'),
('Zapier', 'Tools'),
('Make', 'Tools')
ON CONFLICT (skill_name) DO NOTHING;

-- Technical Skills - Statistics
INSERT INTO skills (skill_name, skill_category) VALUES
('Statistics', 'Statistics'),
('Probability', 'Statistics'),
('Hypothesis Testing', 'Statistics'),
('Bayesian', 'Statistics'),
('Regression Analysis', 'Statistics'),
('ANOVA', 'Statistics'),
('Chi-Square', 'Statistics'),
('T-Test', 'Statistics'),
('Correlation', 'Statistics'),
('Causal Inference', 'Statistics'),
('Experimental Design', 'Statistics'),
('Sampling', 'Statistics'),
('Confidence Intervals', 'Statistics'),
('P-Value', 'Statistics'),
('Monte Carlo', 'Statistics')
ON CONFLICT (skill_name) DO NOTHING;

-- Soft Skills & Business
INSERT INTO skills (skill_name, skill_category) VALUES
('Communication', 'Soft Skills'),
('Presentation', 'Soft Skills'),
('Storytelling', 'Soft Skills'),
('Problem Solving', 'Soft Skills'),
('Critical Thinking', 'Soft Skills'),
('Collaboration', 'Soft Skills'),
('Teamwork', 'Soft Skills'),
('Leadership', 'Soft Skills'),
('Project Management', 'Soft Skills'),
('Stakeholder Management', 'Soft Skills'),
('Requirements Gathering', 'Soft Skills'),
('Agile', 'Soft Skills'),
('Scrum', 'Soft Skills'),
('Kanban', 'Soft Skills')
ON CONFLICT (skill_name) DO NOTHING;

-- Domain Knowledge
INSERT INTO skills (skill_name, skill_category) VALUES
('Finance', 'Domain'),
('Healthcare', 'Domain'),
('Marketing', 'Domain'),
('E-commerce', 'Domain'),
('Retail', 'Domain'),
('Manufacturing', 'Domain'),
('Supply Chain', 'Domain'),
('Logistics', 'Domain'),
('Insurance', 'Domain'),
('Banking', 'Domain'),
('Fintech', 'Domain'),
('SaaS', 'Domain'),
('Telecommunications', 'Domain'),
('Energy', 'Domain'),
('Pharma', 'Domain'),
('Biotech', 'Domain')
ON CONFLICT (skill_name) DO NOTHING;

-- ============================================
-- SAMPLE LOCATIONS
-- ============================================

INSERT INTO locations (city, state, country, is_remote) VALUES
('Remote', 'Remote', 'United States', TRUE),
('New York', 'New York', 'United States', FALSE),
('San Francisco', 'California', 'United States', FALSE),
('Los Angeles', 'California', 'United States', FALSE),
('Seattle', 'Washington', 'United States', FALSE),
('Austin', 'Texas', 'United States', FALSE),
('Boston', 'Massachusetts', 'United States', FALSE),
('Chicago', 'Illinois', 'United States', FALSE),
('Denver', 'Colorado', 'United States', FALSE),
('Atlanta', 'Georgia', 'United States', FALSE),
('Dallas', 'Texas', 'United States', FALSE),
('Houston', 'Texas', 'United States', FALSE),
('Miami', 'Florida', 'United States', FALSE),
('Phoenix', 'Arizona', 'United States', FALSE),
('San Diego', 'California', 'United States', FALSE),
('San Jose', 'California', 'United States', FALSE),
('Philadelphia', 'Pennsylvania', 'United States', FALSE),
('Washington', 'District of Columbia', 'United States', FALSE),
('Raleigh', 'North Carolina', 'United States', FALSE),
('Charlotte', 'North Carolina', 'United States', FALSE),
('Portland', 'Oregon', 'United States', FALSE),
('Minneapolis', 'Minnesota', 'United States', FALSE),
('Detroit', 'Michigan', 'United States', FALSE),
('Salt Lake City', 'Utah', 'United States', FALSE),
('Nashville', 'Tennessee', 'United States', FALSE)
ON CONFLICT (city, state, country) DO NOTHING;

-- ============================================
-- SAMPLE COMPANIES
-- ============================================

INSERT INTO companies (company_name, company_name_clean, industry, company_size) VALUES
('Google', 'google', 'Technology', '10000+'),
('Microsoft', 'microsoft', 'Technology', '10000+'),
('Amazon', 'amazon', 'Technology', '10000+'),
('Meta', 'meta', 'Technology', '10000+'),
('Apple', 'apple', 'Technology', '10000+'),
('Netflix', 'netflix', 'Technology', '1000-5000'),
('Salesforce', 'salesforce', 'Technology', '10000+'),
('Adobe', 'adobe', 'Technology', '10000+'),
('Uber', 'uber', 'Technology', '10000+'),
('Airbnb', 'airbnb', 'Technology', '1000-5000'),
('Stripe', 'stripe', 'Fintech', '1000-5000'),
('Spotify', 'spotify', 'Technology', '5000-10000'),
('Snowflake', 'snowflake', 'Technology', '1000-5000'),
('Databricks', 'databricks', 'Technology', '1000-5000'),
('Palantir', 'palantir', 'Technology', '1000-5000'),
('JPMorgan Chase', 'jpmorgan chase', 'Finance', '10000+'),
('Goldman Sachs', 'goldman sachs', 'Finance', '10000+'),
('Capital One', 'capital one', 'Finance', '10000+'),
('Bank of America', 'bank of america', 'Finance', '10000+'),
('Deloitte', 'deloitte', 'Consulting', '10000+'),
('McKinsey', 'mckinsey', 'Consulting', '10000+'),
('Accenture', 'accenture', 'Consulting', '10000+'),
('IBM', 'ibm', 'Technology', '10000+'),
('Oracle', 'oracle', 'Technology', '10000+'),
('Walmart', 'walmart', 'Retail', '10000+')
ON CONFLICT (company_name) DO NOTHING;

-- ============================================
-- SAMPLE SAVED SEARCHES
-- ============================================

INSERT INTO saved_searches (search_name, keywords, required_skills, locations, min_salary, remote_only) VALUES
(
    'Data Analyst - Remote',
    ARRAY['data analyst', 'business analyst', 'analytics'],
    ARRAY['SQL', 'Python', 'Tableau'],
    ARRAY['Remote'],
    70000,
    TRUE
),
(
    'Senior Data Analyst - Major Cities',
    ARRAY['senior data analyst', 'lead data analyst', 'data analyst ii'],
    ARRAY['SQL', 'Python', 'Power BI'],
    ARRAY['New York', 'San Francisco', 'Seattle', 'Austin'],
    100000,
    FALSE
),
(
    'Business Intelligence Analyst',
    ARRAY['business intelligence', 'bi analyst', 'bi developer'],
    ARRAY['SQL', 'Tableau', 'Power BI'],
    ARRAY['Remote', 'New York', 'Chicago'],
    80000,
    FALSE
)
ON CONFLICT DO NOTHING;

-- ============================================
-- VERIFY DATA
-- ============================================

-- Check skill counts by category
SELECT skill_category, COUNT(*) as count
FROM skills
GROUP BY skill_category
ORDER BY count DESC;

-- Check total skills
SELECT COUNT(*) as total_skills FROM skills;

-- Check locations
SELECT COUNT(*) as total_locations FROM locations;

-- Check companies
SELECT COUNT(*) as total_companies FROM companies;
