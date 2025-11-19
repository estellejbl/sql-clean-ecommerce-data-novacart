# 🧹 E-commerce Dataset Cleaning (PostgreSQL)


## 📘 Project Overview

This project focuses on **cleaning and standardizing a simulated e-commerce dataset** to ensure its reliability and readiness for further analysis.  
It was designed as a practical exercise in **SQL data wrangling**, involving detection and correction of inconsistencies, removal of duplicates, and normalization of key variables.



## 🎯 Objectives

1. **Rename and structure** the dataset for clarity and usability.  
2. **Identify and remove duplicates** in key fields (`user_id`, `session_id`, `email`).  
3. **Standardize categorical values** across key columns such as `source`, `medium`, `device`, and `country`.  
4. **Clean and reformat dates** to a consistent `YYYY-MM-DD` format.  
5. **Handle missing or null values** by applying replacement rules.  
6. **Ensure overall data consistency** to support analytical queries and marketing insights.



## 🧠 Key Cleaning Operations

### 1. Table Structuring
- The raw dataset (`jeu_de_donn_es_e_commerce_r_aliste`) was renamed to a cleaner, standardized table name:  
  **`ecommerce`**

### 2. Duplicate Removal
- Duplicates were detected using `GROUP BY` on `user_id`.
- Manual adjustments were made to specific user IDs to correct duplication (e.g., replacing `user_300` → `user_301`, `user_36` → `user_37`).
- Post-cleaning checks confirmed **zero duplicate records**.

### 3. Categorical Standardization
- **`source`**: Corrected typos (`Gooogle` → `Google`, `Facebok` → `Facebook`) and applied proper capitalization.  
- **`medium`**: Trimmed whitespace and normalized case using `INITCAP()` and regex replacements.  
- **`device`**: Trimmed and standardized device names for consistent labeling.  
- **`country`**: Normalized to ISO country codes (e.g., `france` → `FR`).

### 4. String & Format Cleaning
- **Emails**: Replaced dummy domains (e.g., `@example`) with realistic ones (`@gmail.com`).  
- **Bounce Rate**: Ensured all values include a `%` symbol for consistency.  
- **Campaigns**: Cleaned empty and inconsistent campaign labels.

### 5. Date Normalization
- Standardized inconsistent formats:
  - Converted `DD-MM-YYYY` → `YYYY-MM-DD`.
  - Replaced invalid or placeholder dates (`2025-??---`) with default value `2025-01-01`.

### 6. Missing Values Handling
- **`conversions`**: Replaced `NULL` values with `0`.  
- **`source`**: Replaced missing entries with `"Unknown"`.  


## ✅ Project Outcome

The **final cleaned dataset** is:
- **Free of duplicates**
- **Standardized across all categorical and date fields**
- **Null-safe** for analytical use
- **Ready for marketing, performance, and dashboard reporting**




## 🧩 Tools & Techniques

- **Database:** PostgreSQL  
- **Techniques Used:**  
  - Regex replacements  
  - Case normalization (`INITCAP`, `TRIM`)  
  - Conditional logic (`CASE WHEN`)  
  - Data validation via aggregation (`GROUP BY`, `HAVING`)  
  - Manual record correction via `UPDATE`  


---
