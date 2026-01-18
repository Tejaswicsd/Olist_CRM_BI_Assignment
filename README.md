"# Olist_CRM_BI_Assignment" 
Project Title:

Data Quality Assessment and Funnel Analysis – Olist Marketing Dataset

Objective of the Project

The main purpose of this project was to assess the quality of the Olist Marketing Funnel dataset, identify data issues, clean the data where required, and analyze the marketing funnel to provide meaningful business insights and recommendations.

This project focuses on:

Data cleaning

Deduplication

Data quality reporting

Funnel analysis

Business insights

CRM validation recommendations

Dataset Description

The dataset contains marketing funnel data with key fields such as:

mql_id

first_contact_date

landing_page_id

origin

Each record represents a marketing lead entering the funnel. The dataset was checked for duplicates, inconsistencies, and missing values before analysis.

Data Cleaning Steps Performed
1. Duplicate Check and Removal

Deduplication was done using mql_id as the unique identifier.

Total duplicates found: 45 records (0.56%)

These duplicates were removed to ensure accurate reporting.

2. Standardization of Source Labels

Inconsistent values like:

"Social" vs "social"
were standardized to maintain uniform reporting.

3. Handling Missing or Ambiguous Records

Records with:

Missing won_date

No clear lost status

were flagged for review and excluded from conversion calculations until clarified.

Funnel Analysis Summary

Two stages showed the highest drop-off:

Stage 1: Lead → Contact (15% drop-off)

Issue: Some leads were never contacted.

Recommendations:

Automatic lead assignment within 1 hour

Alerts for leads not contacted within 24 hours

Review lead qualification criteria

Stage 2: Contact → Conversion (85% drop-off)

Issue: Majority of contacted leads did not convert.

Recommendations:

Introduce lead scoring

Standard follow-up schedule (Day 1, 3, 7, 14, 30)

Sales training on objection handling

Add a “demo/trial” stage in funnel

Best Performing Channel

Organic Search performed best in overall balance of:

Lead volume

Conversion rate

Sustainability

Metrics:

3,456 leads (43% of total)

12.3% conversion rate

425 total deals

Runner-up: Paid Search

Highest conversion rate (15.2%)

Lower volume → suggests increasing budget

Worst Performer: Social

2,100 leads

Only 4.8% conversion

Needs better targeting and strategy

CRM Validation Rules Recommended

If this data were imported into a CRM, the following rules should be enforced:

mql_id must be a valid 32-character hexadecimal string

first_contact_date cannot be in the future or before 2017

won_date must be after or equal to first_contact_date

origin field must not be blank (default: ‘unknown’ if missing)

Combination of mql_id + seller_id must be unique

Outputs of This Project

The following files were created as part of the assignment:

Cleaned dataset

dedupe_log.csv

Data Quality Report (PDF)

Short_Questions_Answers.docx

Conclusion

This project ensured that the marketing data is:

Clean

Reliable

Consistent

Business-ready

The insights from the funnel analysis can help management improve lead handling, sales efficiency, and marketing strategy.

