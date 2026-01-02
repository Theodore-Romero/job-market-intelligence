-- ============================================
-- JOB MARKET INTELLIGENCE DASHBOARD
-- Analytics Views
-- ============================================
-- Run this file AFTER schema.sql and seed-data.sql
-- ============================================

-- ============================================
-- DAILY METRICS VIEW
-- Used for: Market Overview dashboard page
-- ============================================

CREATE OR REPLACE VIEW v_daily_metrics AS
SELECT
    dm.metric_date,
    dm.total_jobs,
    dm.new_jobs_today,
    dm.remote_jobs,
    dm.hybrid_jobs,
    dm.onsite_jobs,
    dm.avg_salary_min,
    dm.avg_salary_max,
    (dm.avg_salary_min + dm.avg_salary_max) / 2 as avg_salary_mid,
    dm.unique_companies,
    
    -- Calculated percentages
    ROUND(dm.remote_jobs::NUMERIC / NULLIF(dm.total_jobs, 0) * 100, 1) as remote_percentage,
    ROUND(dm.hybrid_jobs::NUMERIC / NULLIF(dm.total_jobs, 0) * 100, 1) as hybrid_percentage,
    ROUND(dm.onsite_jobs::NUMERIC / NULLIF(dm.total_jobs, 0) * 100, 1) as onsite_percentage,
    
    -- Week over week change
    dm.total_jobs - LAG(dm.total_jobs, 7) OVER (ORDER BY dm.metric_date) as wow_change,
    
    -- Day of week for filtering
    TO_CHAR(dm.metric_date, 'Day') as day_of_week,
    EXTRACT(DOW FROM dm.metric_date) as day_number,
    
    -- Month for grouping
    TO_CHAR(dm.metric_date, 'YYYY-MM') as year_month,
    TO_CHAR(dm.metric_date, 'Month YYYY') as month_name
    
FROM daily_metrics dm
ORDER BY dm.metric_date DESC;

-- ============================================
-- SKILLS FREQUENCY VIEW
-- Used for: Skills Demand dashboard page
-- ============================================

CREATE OR REPLACE VIEW v_skills_frequency AS
SELECT
    s.skill_id,
    s.skill_name,
    s.skill_category,
    COUNT(js.job_id) as job_count,
    ROUND(COUNT(js.job_id)::NUMERIC / NULLIF((SELECT COUNT(*) FROM job_postings), 0) * 100, 2) as percentage
FROM skills s
LEFT JOIN job_skills js ON s.skill_id = js.skill_id
GROUP BY s.skill_id, s.skill_name, s.skill_category
ORDER BY job_count DESC;

-- ============================================
-- SKILLS TREND OVER TIME VIEW
-- Used for: Skills Demand trend charts
-- ============================================

CREATE OR REPLACE VIEW v_skills_trend AS
SELECT
    s.skill_name,
    s.skill_category,
    DATE_TRUNC('week', jp.posted_date)::DATE as week_start,
    COUNT(DISTINCT jp.job_id) as job_count
FROM skills s
JOIN job_skills js ON s.skill_id = js.skill_id
JOIN job_postings jp ON js.job_id = jp.job_id
WHERE jp.posted_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY s.skill_name, s.skill_category, DATE_TRUNC('week', jp.posted_date)
ORDER BY week_start, job_count DESC;

-- ============================================
-- TOP SKILLS VIEW (Top 20)
-- Used for: Skills bar chart
-- ============================================

CREATE OR REPLACE VIEW v_top_skills AS
SELECT
    s.skill_name,
    s.skill_category,
    COUNT(js.job_id) as job_count,
    ROUND(COUNT(js.job_id)::NUMERIC / NULLIF((SELECT COUNT(*) FROM job_postings), 0) * 100, 1) as percentage,
    ROW_NUMBER() OVER (ORDER BY COUNT(js.job_id) DESC) as rank
FROM skills s
JOIN job_skills js ON s.skill_id = js.skill_id
GROUP BY s.skill_id, s.skill_name, s.skill_category
ORDER BY job_count DESC
LIMIT 20;

-- ============================================
-- SALARY BY LOCATION VIEW
-- Used for: Salary Analysis dashboard page
-- ============================================

CREATE OR REPLACE VIEW v_salary_by_location AS
SELECT
    l.city,
    l.state,
    l.is_remote,
    COUNT(jp.job_id) as job_count,
    ROUND(AVG(jp.salary_min), 0) as avg_salary_min,
    ROUND(AVG(jp.salary_max), 0) as avg_salary_max,
    ROUND((AVG(jp.salary_min) + AVG(jp.salary_max)) / 2, 0) as avg_salary_mid,
    ROUND(MIN(jp.salary_min), 0) as min_salary,
    ROUND(MAX(jp.salary_max), 0) as max_salary,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY (jp.salary_min + jp.salary_max) / 2) as median_salary
FROM job_postings jp
JOIN locations l ON jp.location_id = l.location_id
WHERE jp.salary_min IS NOT NULL
  AND jp.salary_max IS NOT NULL
  AND jp.salary_min > 0
  AND jp.salary_max > 0
GROUP BY l.city, l.state, l.is_remote
HAVING COUNT(jp.job_id) >= 5
ORDER BY avg_salary_mid DESC;

-- ============================================
-- SALARY BY SKILL VIEW
-- Used for: Salary premium analysis
-- ============================================

CREATE OR REPLACE VIEW v_salary_by_skill AS
SELECT
    s.skill_name,
    s.skill_category,
    COUNT(DISTINCT jp.job_id) as job_count,
    ROUND(AVG((jp.salary_min + jp.salary_max) / 2), 0) as avg_salary,
    ROUND(AVG((jp.salary_min + jp.salary_max) / 2) - (
        SELECT AVG((salary_min + salary_max) / 2)
        FROM job_postings
        WHERE salary_min > 0 AND salary_max > 0
    ), 0) as salary_premium
FROM skills s
JOIN job_skills js ON s.skill_id = js.skill_id
JOIN job_postings jp ON js.job_id = jp.job_id
WHERE jp.salary_min > 0 AND jp.salary_max > 0
GROUP BY s.skill_id, s.skill_name, s.skill_category
HAVING COUNT(DISTINCT jp.job_id) >= 10
ORDER BY avg_salary DESC;

-- ============================================
-- COMPANY HIRING VIEW
-- Used for: Company Insights dashboard page
-- ============================================

CREATE OR REPLACE VIEW v_company_hiring AS
SELECT
    c.company_id,
    c.company_name,
    c.industry,
    c.company_size,
    COUNT(jp.job_id) as total_postings,
    COUNT(jp.job_id) FILTER (WHERE jp.posted_date >= CURRENT_DATE - INTERVAL '7 days') as postings_last_7_days,
    COUNT(jp.job_id) FILTER (WHERE jp.posted_date >= CURRENT_DATE - INTERVAL '30 days') as postings_last_30_days,
    ROUND(AVG(jp.salary_min) FILTER (WHERE jp.salary_min > 0), 0) as avg_salary_min,
    ROUND(AVG(jp.salary_max) FILTER (WHERE jp.salary_max > 0), 0) as avg_salary_max,
    ROUND(AVG((jp.salary_min + jp.salary_max) / 2) FILTER (WHERE jp.salary_min > 0), 0) as avg_salary_mid,
    COUNT(jp.job_id) FILTER (WHERE jp.is_remote = TRUE) as remote_positions,
    ROUND(COUNT(jp.job_id) FILTER (WHERE jp.is_remote = TRUE)::NUMERIC / NULLIF(COUNT(jp.job_id), 0) * 100, 1) as remote_percentage
FROM companies c
JOIN job_postings jp ON c.company_id = jp.company_id
GROUP BY c.company_id, c.company_name, c.industry, c.company_size
HAVING COUNT(jp.job_id) >= 1
ORDER BY total_postings DESC;

-- ============================================
-- JOBS BY TITLE CATEGORY VIEW
-- Used for: Job type breakdown
-- ============================================

CREATE OR REPLACE VIEW v_jobs_by_title AS
SELECT
    CASE
        WHEN title_clean LIKE '%senior%' OR title_clean LIKE '%sr %' OR title_clean LIKE '%lead%' THEN 'Senior'
        WHEN title_clean LIKE '%junior%' OR title_clean LIKE '%jr %' OR title_clean LIKE '%entry%' THEN 'Entry Level'
        WHEN title_clean LIKE '%manager%' OR title_clean LIKE '%director%' OR title_clean LIKE '%head%' THEN 'Management'
        WHEN title_clean LIKE '%principal%' OR title_clean LIKE '%staff%' THEN 'Principal/Staff'
        ELSE 'Mid Level'
    END as experience_level,
    CASE
        WHEN title_clean LIKE '%data analyst%' THEN 'Data Analyst'
        WHEN title_clean LIKE '%business analyst%' THEN 'Business Analyst'
        WHEN title_clean LIKE '%data scientist%' THEN 'Data Scientist'
        WHEN title_clean LIKE '%data engineer%' THEN 'Data Engineer'
        WHEN title_clean LIKE '%business intelligence%' OR title_clean LIKE '% bi %' THEN 'BI Analyst'
        WHEN title_clean LIKE '%analytics%' THEN 'Analytics'
        WHEN title_clean LIKE '%machine learning%' OR title_clean LIKE '% ml %' THEN 'ML Engineer'
        ELSE 'Other'
    END as job_category,
    COUNT(*) as job_count,
    ROUND(AVG(salary_min) FILTER (WHERE salary_min > 0), 0) as avg_salary_min,
    ROUND(AVG(salary_max) FILTER (WHERE salary_max > 0), 0) as avg_salary_max
FROM job_postings
GROUP BY 
    CASE
        WHEN title_clean LIKE '%senior%' OR title_clean LIKE '%sr %' OR title_clean LIKE '%lead%' THEN 'Senior'
        WHEN title_clean LIKE '%junior%' OR title_clean LIKE '%jr %' OR title_clean LIKE '%entry%' THEN 'Entry Level'
        WHEN title_clean LIKE '%manager%' OR title_clean LIKE '%director%' OR title_clean LIKE '%head%' THEN 'Management'
        WHEN title_clean LIKE '%principal%' OR title_clean LIKE '%staff%' THEN 'Principal/Staff'
        ELSE 'Mid Level'
    END,
    CASE
        WHEN title_clean LIKE '%data analyst%' THEN 'Data Analyst'
        WHEN title_clean LIKE '%business analyst%' THEN 'Business Analyst'
        WHEN title_clean LIKE '%data scientist%' THEN 'Data Scientist'
        WHEN title_clean LIKE '%data engineer%' THEN 'Data Engineer'
        WHEN title_clean LIKE '%business intelligence%' OR title_clean LIKE '% bi %' THEN 'BI Analyst'
        WHEN title_clean LIKE '%analytics%' THEN 'Analytics'
        WHEN title_clean LIKE '%machine learning%' OR title_clean LIKE '% ml %' THEN 'ML Engineer'
        ELSE 'Other'
    END
ORDER BY job_count DESC;

-- ============================================
-- REMOTE WORK TREND VIEW
-- Used for: Remote vs On-site analysis
-- ============================================

CREATE OR REPLACE VIEW v_remote_trend AS
SELECT
    DATE_TRUNC('week', posted_date)::DATE as week_start,
    COUNT(*) as total_jobs,
    COUNT(*) FILTER (WHERE is_remote = TRUE OR remote_type = 'remote') as remote_jobs,
    COUNT(*) FILTER (WHERE remote_type = 'hybrid') as hybrid_jobs,
    COUNT(*) FILTER (WHERE is_remote = FALSE AND (remote_type IS NULL OR remote_type = 'onsite')) as onsite_jobs,
    ROUND(COUNT(*) FILTER (WHERE is_remote = TRUE OR remote_type = 'remote')::NUMERIC / NULLIF(COUNT(*), 0) * 100, 1) as remote_percentage
FROM job_postings
WHERE posted_date >= CURRENT_DATE - INTERVAL '90 days'
GROUP BY DATE_TRUNC('week', posted_date)
ORDER BY week_start;

-- ============================================
-- GEOGRAPHIC DISTRIBUTION VIEW
-- Used for: Geographic View dashboard page
-- ============================================

CREATE OR REPLACE VIEW v_geographic_distribution AS
SELECT
    l.state,
    l.city,
    l.is_remote,
    COUNT(jp.job_id) as job_count,
    ROUND(AVG((jp.salary_min + jp.salary_max) / 2) FILTER (WHERE jp.salary_min > 0), 0) as avg_salary,
    COUNT(DISTINCT jp.company_id) as unique_companies
FROM locations l
JOIN job_postings jp ON l.location_id = jp.location_id
GROUP BY l.state, l.city, l.is_remote
ORDER BY job_count DESC;

-- ============================================
-- STATE SUMMARY VIEW
-- Used for: Map visualization
-- ============================================

CREATE OR REPLACE VIEW v_state_summary AS
SELECT
    l.state,
    COUNT(jp.job_id) as job_count,
    ROUND(AVG((jp.salary_min + jp.salary_max) / 2) FILTER (WHERE jp.salary_min > 0), 0) as avg_salary,
    COUNT(DISTINCT jp.company_id) as unique_companies,
    ROUND(COUNT(*) FILTER (WHERE jp.is_remote = TRUE)::NUMERIC / NULLIF(COUNT(*), 0) * 100, 1) as remote_percentage
FROM locations l
JOIN job_postings jp ON l.location_id = jp.location_id
WHERE l.state != 'Remote'
GROUP BY l.state
HAVING COUNT(jp.job_id) >= 3
ORDER BY job_count DESC;

-- ============================================
-- MATCHING JOBS VIEW (for Personal Tracker)
-- Used for: Personal Tracker dashboard page
-- ============================================

CREATE OR REPLACE VIEW v_matching_jobs AS
SELECT
    jp.job_id,
    jp.title,
    jp.company_name,
    l.city,
    l.state,
    jp.is_remote,
    jp.salary_min,
    jp.salary_max,
    jp.posted_date,
    jp.source_url,
    jp.source,
    ja.status as application_status,
    ja.applied_date,
    ARRAY_AGG(DISTINCT s.skill_name) FILTER (WHERE s.skill_name IS NOT NULL) as skills
FROM job_postings jp
LEFT JOIN locations l ON jp.location_id = l.location_id
LEFT JOIN job_applications ja ON jp.job_id = ja.job_id
LEFT JOIN job_skills js ON jp.job_id = js.job_id
LEFT JOIN skills s ON js.skill_id = s.skill_id
GROUP BY 
    jp.job_id, jp.title, jp.company_name, 
    l.city, l.state, jp.is_remote,
    jp.salary_min, jp.salary_max, jp.posted_date,
    jp.source_url, jp.source,
    ja.status, ja.applied_date
ORDER BY jp.posted_date DESC;

-- ============================================
-- NEW JOBS THIS WEEK VIEW
-- Used for: Weekly summary and alerts
-- ============================================

CREATE OR REPLACE VIEW v_new_jobs_this_week AS
SELECT
    jp.job_id,
    jp.title,
    jp.company_name,
    l.city,
    l.state,
    jp.is_remote,
    jp.salary_min,
    jp.salary_max,
    jp.posted_date,
    jp.source_url,
    jp.collected_at
FROM job_postings jp
LEFT JOIN locations l ON jp.location_id = l.location_id
WHERE jp.posted_date >= CURRENT_DATE - INTERVAL '7 days'
ORDER BY jp.posted_date DESC;

-- ============================================
-- SKILL CO-OCCURRENCE VIEW
-- Used for: Skills that appear together
-- ============================================

CREATE OR REPLACE VIEW v_skill_cooccurrence AS
SELECT
    s1.skill_name as skill_1,
    s2.skill_name as skill_2,
    COUNT(*) as co_occurrence_count
FROM job_skills js1
JOIN job_skills js2 ON js1.job_id = js2.job_id AND js1.skill_id < js2.skill_id
JOIN skills s1 ON js1.skill_id = s1.skill_id
JOIN skills s2 ON js2.skill_id = s2.skill_id
GROUP BY s1.skill_name, s2.skill_name
HAVING COUNT(*) >= 10
ORDER BY co_occurrence_count DESC
LIMIT 50;

-- ============================================
-- SOURCE BREAKDOWN VIEW
-- Used for: Understanding data sources
-- ============================================

CREATE OR REPLACE VIEW v_source_breakdown AS
SELECT
    source,
    COUNT(*) as total_jobs,
    COUNT(*) FILTER (WHERE posted_date >= CURRENT_DATE - INTERVAL '7 days') as jobs_last_7_days,
    MIN(collected_at) as first_collection,
    MAX(collected_at) as last_collection
FROM job_postings
GROUP BY source
ORDER BY total_jobs DESC;

-- ============================================
-- VERIFY VIEWS
-- ============================================

-- List all views
SELECT table_name as view_name
FROM information_schema.views
WHERE table_schema = 'public'
ORDER BY table_name;
