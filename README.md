# **📌 Data Quality Assessment and Funnel Analysis – Olist Marketing Dataset**

---

## ** Objective of the Project**

The goal of this project was to evaluate the quality of the **Olist Marketing Funnel dataset**, clean inconsistencies, remove duplicates, and analyze the marketing funnel to generate actionable business insights.

This project covers:

- **Data cleaning**
- **Deduplication**
- **Data quality reporting**
- **Funnel analysis**
- **Business recommendations**
- **CRM validation rules**

---

## **📊 Dataset Description**

The dataset contains marketing funnel data with key fields such as:

- **mql_id**
- **first_contact_date**
- **landing_page_id**
- **origin**

Each row represents a marketing lead entering the funnel. The dataset was validated for duplicates, inconsistencies, and missing values before analysis.

---

## ** Data Cleaning Steps Performed**

### **1️⃣ Duplicate Check and Removal**

- Deduplication was performed using **mql_id** as the unique identifier.  
- **45 duplicate records (0.56%)** were identified and removed to ensure accuracy.

### **2️⃣ Standardization of Source Labels**

Inconsistent values such as:

- `"Social"` vs `"social"`

were standardized to maintain uniform reporting.

### **3️⃣ Handling Missing or Ambiguous Records**

Records with:

- Missing **won_date**, or  
- No clear lost status  

were flagged for review and excluded from conversion calculations until clarified.

---

## **📈 Funnel Analysis Summary**

### **Stage 1: Lead → Contact (15% drop-off)**  

**Issue:** Some leads were never contacted.

**Recommendations:**
- Automatic lead assignment within **1 hour**
- Alerts for uncontacted leads older than **24 hours**
- Review lead qualification criteria

---

### **Stage 2: Contact → Conversion (85% drop-off)**  

**Issue:** Most contacted leads did not convert.

**Recommendations:**
- Implement lead scoring  
- Standard follow-up schedule: **Day 1, 3, 7, 14, 30**
- Sales training on objection handling  
- Add a **“demo/trial” stage** in the funnel  

---

## ** Best Performing Channels**

### ** Organic Search — Best Overall**
- **3,456 leads (43%)**
- **12.3% conversion rate**
- **425 total deals**

**Why best?**
- Sustainable  
- Cost-effective  
- High user intent  

---

### **🥈 Paid Search — Runner-up**
- **15.2% conversion rate (highest)**
- Lower volume → **recommend increasing budget**

---

### **❌ Social — Worst Performer**
- **2,100 leads**
- **4.8% conversion rate**
- Needs better targeting and strategy

---

## **🛡️ Recommended CRM Validation Rules**

If this data were imported into a CRM, the following rules should be enforced:

- **mql_id** must be a valid **32-character hexadecimal string**
- **first_contact_date** cannot be in the future or before **2017**
- **won_date ≥ first_contact_date**
- **origin** cannot be blank (default = **‘unknown’** if missing)
- **(mql_id, seller_id)** must be unique to prevent duplicate deals

---

## **📁 Project Outputs**

The following deliverables were created:

- **Cleaned dataset**
- **dedupe_log.csv**
- **Data Quality Report (PDF)**
- **Short_Questions_Answers.docx**

---

## **✅ Conclusion**

This project ensured that the marketing data is:

- **Clean**
- **Reliable**
- **Consistent**
- **Business-ready**

The insights help management improve lead handling, sales efficiency, and overall marketing performance.

---

## **👤 Author**
**Tejaswi Guttula**  
Data Analytics & CRM Enthusiast  

