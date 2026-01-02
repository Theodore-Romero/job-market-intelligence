-- ============================================
-- JOB MARKET INTELLIGENCE DASHBOARD
-- Database Schema
-- ============================================
-- Run this file first in Supabase SQL Editor
-- ============================================

-- ============================================
-- DIMENSION TABLES
-- ============================================

-- Skills dimension table
CREATE TABLE skills (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL UNIQUE,
    skill_category VARCHAR(50),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for faster lookups
CREATE INDEX idx_skills_name ON skills(skill_name);
CREATE INDEX idx_skills_category ON skills(skill_category);

-- Companies dimension table
CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    company_name_clean VARCHAR(255),
    industry VARCHAR(100),
    company_size VARCHAR(50),
    headquarters_location VARCHAR(255),
    website_url VARCHAR(500),
    first_seen_date DATE DEFAULT CURRENT_DATE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(company_name)
);

CREATE INDEX idx_companies_name ON companies(company_name);
CREATE INDEX idx_companies_industry ON companies(industry);

-- Locations dimension table
CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100) DEFAULT 'United States',
    metro_area VARCHAR(100),
    is_remote BOOLEAN DEFAULT FALSE,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(city, state, country)
);

CREATE INDEX idx_locations_city ON locations(city);
CREATE INDEX idx_locations_state ON locations(state);
CREATE INDEX idx_locations_remote ON locations(is_remote);

-- ============================================
-- FACT TABLES
-- ============================================

-- Job postings fact table
CREATE TABLE job_postings (
    job_id SERIAL PRIMARY KEY,
    external_id VARCHAR(255) UNIQUE,
    title VARCHAR(500) NOT NULL,
    title_clean VARCHAR(255),
    description TEXT,
    description_clean TEXT,
    
    -- Foreign keys
    company_id INTEGER REFERENCES companies(company_id),
    location_id INTEGER REFERENCES locations(location_id),
    
    -- Denormalized for convenience
    company_name VARCHAR(255),
    location_raw VARCHAR(255),
    
    -- Job details
    job_type VARCHAR(50),
    experience_level VARCHAR(50),
    is_remote BOOLEAN DEFAULT FALSE,
    remote_type VARCHAR(50),
    
    -- Salary information
    salary_min DECIMAL(12, 2),
    salary_max DECIMAL(12, 2),
    salary_currency VARCHAR(10) DEFAULT 'USD',
    salary_period VARCHAR(20) DEFAULT 'yearly',
    
    -- Source information
    source VARCHAR(50),
    source_url VARCHAR(1000),
    
    -- Dates
    posted_date DATE,
    expires_date DATE,
    collected_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    
    -- Processing flags
    is_processed BOOLEAN DEFAULT FALSE,
    skills_extracted BOOLEAN DEFAULT FALSE
);

CREATE INDEX idx_jobs_posted_date ON job_postings(posted_date);
CREATE INDEX idx_jobs_company ON job_postings(company_id);
CREATE INDEX idx_jobs_location ON job_postings(location_id);
CREATE INDEX idx_jobs_remote ON job_postings(is_remote);
CREATE INDEX idx_jobs_source ON job_postings(source);
CREATE INDEX idx_jobs_collected ON job_postings(collected_at);
CREATE INDEX idx_jobs_title ON job_postings(title_clean);

-- Job skills junction table (many-to-many)
CREATE TABLE job_skills (
    job_skill_id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES job_postings(job_id) ON DELETE CASCADE,
    skill_id INTEGER REFERENCES skills(skill_id),
    mention_count INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(job_id, skill_id)
);

CREATE INDEX idx_job_skills_job ON job_skills(job_id);
CREATE INDEX idx_job_skills_skill ON job_skills(skill_id);

-- ============================================
-- AGGREGATION TABLES
-- ============================================

-- Daily metrics summary table
CREATE TABLE daily_metrics (
    metric_id SERIAL PRIMARY KEY,
    metric_date DATE NOT NULL UNIQUE,
    
    -- Job counts
    total_jobs INTEGER DEFAULT 0,
    new_jobs_today INTEGER DEFAULT 0,
    remote_jobs INTEGER DEFAULT 0,
    hybrid_jobs INTEGER DEFAULT 0,
    onsite_jobs INTEGER DEFAULT 0,
    
    -- Salary metrics
    avg_salary_min DECIMAL(12, 2),
    avg_salary_max DECIMAL(12, 2),
    median_salary DECIMAL(12, 2),
    
    -- Experience level counts
    entry_level_jobs INTEGER DEFAULT 0,
    mid_level_jobs INTEGER DEFAULT 0,
    senior_level_jobs INTEGER DEFAULT 0,
    
    -- Source counts
    jobs_from_adzuna INTEGER DEFAULT 0,
    jobs_from_indeed INTEGER DEFAULT 0,
    jobs_from_linkedin INTEGER DEFAULT 0,
    
    -- Company metrics
    unique_companies INTEGER DEFAULT 0,
    top_hiring_company VARCHAR(255),
    
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_daily_metrics_date ON daily_metrics(metric_date);

-- Skills frequency tracking
CREATE TABLE skill_daily_counts (
    id SERIAL PRIMARY KEY,
    skill_id INTEGER REFERENCES skills(skill_id),
    count_date DATE NOT NULL,
    job_count INTEGER DEFAULT 0,
    percentage DECIMAL(5, 2),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(skill_id, count_date)
);

CREATE INDEX idx_skill_counts_date ON skill_daily_counts(count_date);
CREATE INDEX idx_skill_counts_skill ON skill_daily_counts(skill_id);

-- ============================================
-- USER TRACKING TABLES
-- ============================================

-- Saved job searches / alerts
CREATE TABLE saved_searches (
    search_id SERIAL PRIMARY KEY,
    search_name VARCHAR(255),
    keywords TEXT[],
    required_skills TEXT[],
    locations TEXT[],
    min_salary DECIMAL(12, 2),
    remote_only BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    last_run_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Job application tracking
CREATE TABLE job_applications (
    application_id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES job_postings(job_id),
    status VARCHAR(50) DEFAULT 'saved',
    applied_date DATE,
    response_date DATE,
    notes TEXT,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_applications_status ON job_applications(status);
CREATE INDEX idx_applications_job ON job_applications(job_id);

-- ============================================
-- FUNCTIONS
-- ============================================

-- Function to clean and normalize job titles
CREATE OR REPLACE FUNCTION clean_job_title(raw_title TEXT)
RETURNS TEXT AS $$
DECLARE
    cleaned TEXT;
BEGIN
    cleaned := LOWER(raw_title);
    cleaned := REGEXP_REPLACE(cleaned, '\s+', ' ', 'g');
    cleaned := TRIM(cleaned);
    
    -- Normalize common variations
    cleaned := REPLACE(cleaned, 'sr.', 'senior');
    cleaned := REPLACE(cleaned, 'sr ', 'senior ');
    cleaned := REPLACE(cleaned, 'jr.', 'junior');
    cleaned := REPLACE(cleaned, 'jr ', 'junior ');
    cleaned := REPLACE(cleaned, 'bi ', 'business intelligence ');
    
    RETURN cleaned;
END;
$$ LANGUAGE plpgsql;

-- Function to extract skills from job description
CREATE OR REPLACE FUNCTION extract_skills_from_job(p_job_id INTEGER)
RETURNS INTEGER AS $$
DECLARE
    job_desc TEXT;
    skill_rec RECORD;
    skills_found INTEGER := 0;
BEGIN
    -- Get the job description
    SELECT LOWER(COALESCE(description, '') || ' ' || COALESCE(title, ''))
    INTO job_desc
    FROM job_postings
    WHERE job_id = p_job_id;
    
    -- Loop through all skills and check if they exist in description
    FOR skill_rec IN SELECT skill_id, LOWER(skill_name) as skill_name FROM skills LOOP
        IF job_desc LIKE '%' || skill_rec.skill_name || '%' THEN
            INSERT INTO job_skills (job_id, skill_id)
            VALUES (p_job_id, skill_rec.skill_id)
            ON CONFLICT (job_id, skill_id) DO NOTHING;
            
            skills_found := skills_found + 1;
        END IF;
    END LOOP;
    
    -- Mark job as processed
    UPDATE job_postings
    SET skills_extracted = TRUE
    WHERE job_id = p_job_id;
    
    RETURN skills_found;
END;
$$ LANGUAGE plpgsql;

-- Function to get or create company
CREATE OR REPLACE FUNCTION get_or_create_company(p_company_name TEXT)
RETURNS INTEGER AS $$
DECLARE
    v_company_id INTEGER;
BEGIN
    SELECT company_id INTO v_company_id
    FROM companies
    WHERE company_name = p_company_name;
    
    IF v_company_id IS NULL THEN
        INSERT INTO companies (company_name, company_name_clean)
        VALUES (p_company_name, LOWER(TRIM(p_company_name)))
        RETURNING company_id INTO v_company_id;
    END IF;
    
    RETURN v_company_id;
END;
$$ LANGUAGE plpgsql;

-- Function to get or create location
CREATE OR REPLACE FUNCTION get_or_create_location(
    p_city TEXT,
    p_state TEXT,
    p_country TEXT DEFAULT 'United States',
    p_is_remote BOOLEAN DEFAULT FALSE
)
RETURNS INTEGER AS $$
DECLARE
    v_location_id INTEGER;
BEGIN
    SELECT location_id INTO v_location_id
    FROM locations
    WHERE city = p_city AND state = p_state AND country = p_country;
    
    IF v_location_id IS NULL THEN
        INSERT INTO locations (city, state, country, is_remote)
        VALUES (p_city, p_state, p_country, p_is_remote)
        RETURNING location_id INTO v_location_id;
    END IF;
    
    RETURN v_location_id;
END;
$$ LANGUAGE plpgsql;

-- Function to calculate daily metrics
CREATE OR REPLACE FUNCTION calculate_daily_metrics(p_date DATE DEFAULT CURRENT_DATE)
RETURNS VOID AS $$
BEGIN
    INSERT INTO daily_metrics (
        metric_date,
        total_jobs,
        new_jobs_today,
        remote_jobs,
        hybrid_jobs,
        onsite_jobs,
        avg_salary_min,
        avg_salary_max,
        unique_companies
    )
    SELECT
        p_date,
        COUNT(*) as total_jobs,
        COUNT(*) FILTER (WHERE DATE(collected_at) = p_date) as new_jobs_today,
        COUNT(*) FILTER (WHERE is_remote = TRUE OR remote_type = 'remote') as remote_jobs,
        COUNT(*) FILTER (WHERE remote_type = 'hybrid') as hybrid_jobs,
        COUNT(*) FILTER (WHERE is_remote = FALSE AND (remote_type IS NULL OR remote_type = 'onsite')) as onsite_jobs,
        AVG(salary_min) FILTER (WHERE salary_min > 0) as avg_salary_min,
        AVG(salary_max) FILTER (WHERE salary_max > 0) as avg_salary_max,
        COUNT(DISTINCT company_id) as unique_companies
    FROM job_postings
    WHERE posted_date <= p_date
      AND (expires_date IS NULL OR expires_date >= p_date)
    ON CONFLICT (metric_date) DO UPDATE SET
        total_jobs = EXCLUDED.total_jobs,
        new_jobs_today = EXCLUDED.new_jobs_today,
        remote_jobs = EXCLUDED.remote_jobs,
        hybrid_jobs = EXCLUDED.hybrid_jobs,
        onsite_jobs = EXCLUDED.onsite_jobs,
        avg_salary_min = EXCLUDED.avg_salary_min,
        avg_salary_max = EXCLUDED.avg_salary_max,
        unique_companies = EXCLUDED.unique_companies,
        updated_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- TRIGGERS
-- ============================================

-- Trigger to auto-extract skills when job is inserted
CREATE OR REPLACE FUNCTION trigger_extract_skills()
RETURNS TRIGGER AS $$
BEGIN
    PERFORM extract_skills_from_job(NEW.job_id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_extract_skills
AFTER INSERT ON job_postings
FOR EACH ROW
EXECUTE FUNCTION trigger_extract_skills();

-- Trigger to clean job title on insert
CREATE OR REPLACE FUNCTION trigger_clean_job_title()
RETURNS TRIGGER AS $$
BEGIN
    NEW.title_clean := clean_job_title(NEW.title);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_clean_title
BEFORE INSERT ON job_postings
FOR EACH ROW
EXECUTE FUNCTION trigger_clean_job_title();

-- Trigger to update timestamps
CREATE OR REPLACE FUNCTION trigger_update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at := NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_update_daily_metrics
BEFORE UPDATE ON daily_metrics
FOR EACH ROW
EXECUTE FUNCTION trigger_update_timestamp();

CREATE TRIGGER trg_update_applications
BEFORE UPDATE ON job_applications
FOR EACH ROW
EXECUTE FUNCTION trigger_update_timestamp();

-- ============================================
-- ROW LEVEL SECURITY (Optional)
-- ============================================

-- Enable RLS on tables if needed
-- ALTER TABLE job_postings ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE job_applications ENABLE ROW LEVEL SECURITY;

-- ============================================
-- GRANTS (for Supabase)
-- ============================================

-- Grant access to anon and authenticated roles
GRANT SELECT ON ALL TABLES IN SCHEMA public TO anon;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO authenticated;
GRANT INSERT, UPDATE, DELETE ON job_applications TO authenticated;
GRANT INSERT, UPDATE, DELETE ON saved_searches TO authenticated;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO authenticated;
