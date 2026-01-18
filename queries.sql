-- ======================================================
-- QUERIES FOR leads_master DATA ANALYSIS & ANOMALY CHECKS
-- Prepared: January 18, 2026
-- ======================================================

-- ======================================================
-- QUERY 1 — Funnel Performance by Month
-- Counts leads created and converted per month
-- Export as: q1_funnel_by_month.csv
-- ======================================================
SELECT 
    substr(first_contact_date,7,4) || '-' || substr(first_contact_date,4,2) AS month,
    COUNT(DISTINCT mql_id) AS leads_created,
    COUNT(DISTINCT CASE WHEN won_date IS NOT NULL AND won_date <> '' THEN mql_id END) AS converted
FROM leads_master
GROUP BY month
ORDER BY month;


-- ======================================================
-- QUERY 2 — 7-day & 30-day Cohort Conversion
-- Cohort analysis: conversions within 7 and 30 days
-- Export as: q2_cohort_conversion.csv
-- ======================================================
SELECT 
    substr(first_contact_date,7,4) || '-' || substr(first_contact_date,4,2) AS cohort_month,
    COUNT(DISTINCT mql_id) AS total_leads,

    COUNT(DISTINCT CASE 
        WHEN won_date <> '' 
        AND julianday(substr(won_date,7,4)||'-'||substr(won_date,4,2)||'-'||substr(won_date,1,2)) 
            - julianday(substr(first_contact_date,7,4)||'-'||substr(first_contact_date,4,2)||'-'||substr(first_contact_date,1,2)) <= 7
        THEN mql_id END) AS converted_7_days,

    COUNT(DISTINCT CASE 
        WHEN won_date <> '' 
        AND julianday(substr(won_date,7,4)||'-'||substr(won_date,4,2)||'-'||substr(won_date,1,2)) 
            - julianday(substr(first_contact_date,7,4)||'-'||substr(first_contact_date,4,2)||'-'||substr(first_contact_date,1,2)) <= 30
        THEN mql_id END) AS converted_30_days

FROM leads_master
GROUP BY cohort_month
ORDER BY cohort_month;


-- ======================================================
-- QUERY 3 — Average Time to Convert by Origin
-- Calculates average days between first contact and won date
-- Export as: q3_time_to_convert.csv
-- ======================================================
SELECT 
    origin,
    COUNT(*) AS total_conversions,
    AVG(
      julianday(substr(won_date,7,4)||'-'||substr(won_date,4,2)||'-'||substr(won_date,1,2))
      -
      julianday(substr(first_contact_date,7,4)||'-'||substr(first_contact_date,4,2)||'-'||substr(first_contact_date,1,2))
    ) AS avg_days_to_convert
FROM leads_master
WHERE won_date <> ''
GROUP BY origin
ORDER BY avg_days_to_convert;


-- ======================================================
-- QUERY 4 — Top Channels by Conversion Rate
-- Conversion rate per origin (channels), minimum 10 leads
-- Export as: q4_top_channels.csv
-- ======================================================
SELECT 
    origin,
    COUNT(DISTINCT mql_id) AS total_leads,
    COUNT(DISTINCT CASE WHEN won_date <> '' THEN mql_id END) AS conversions,
    ROUND(
      COUNT(DISTINCT CASE WHEN won_date <> '' THEN mql_id END) * 100.0 
      / COUNT(DISTINCT mql_id), 2
    ) AS conversion_rate_pct
FROM leads_master
GROUP BY origin
HAVING COUNT(DISTINCT mql_id) >= 10
ORDER BY conversion_rate_pct DESC;


-- ======================================================
-- QUERY 5A — Won date before first contact (Run Alone)
-- Checks anomalies where won_date is earlier than first_contact_date
-- Export as: q5_anomaly_dates.csv
-- ======================================================
SELECT 
    mql_id,
    first_contact_date,
    won_date
FROM leads_master
WHERE won_date <> ''
AND julianday(substr(won_date,7,4)||'-'||substr(won_date,4,2)||'-'||substr(won_date,1,2))
 < julianday(substr(first_contact_date,7,4)||'-'||substr(first_contact_date,4,2)||'-'||substr(first_contact_date,1,2));


-- ======================================================
-- QUERY 5B — Missing critical fields (Run Alone)
-- Checks for missing first_contact_date or origin
-- Export as: q5_missing_fields.csv
-- ======================================================
SELECT 
 'Missing first_contact_date' AS issue,
 COUNT(*) AS count
FROM leads_master
WHERE first_contact_date = ''

UNION ALL

SELECT 
 'Missing origin',
 COUNT(*)
FROM leads_master
WHERE origin = '';


-- ======================================================
-- QUERY 5C — Duplicate mql_id (Run Alone)
-- Checks for duplicate MQL IDs
-- Export as: q5_duplicates.csv
-- ======================================================
SELECT 
 mql_id,
 COUNT(*) AS duplicate_count
FROM leads_master
GROUP BY mql_id
HAVING COUNT(*) > 1;
