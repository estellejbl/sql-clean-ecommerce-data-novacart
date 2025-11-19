
<h1 align="center"> 🧹 E-commerce Dataset Cleaning </h1>

<p align="center">
  <a href="#"><img alt="Made with PostgreSQL" src="https://img.shields.io/badge/Made%20with-PostgreSQL-6e3931?style=for-the-badge"></a>
  <a href="#"><img alt="Analytics" src="https://img.shields.io/badge/Focus-Data%20Cleaning-6e3931?style=for-the-badge"></a>
    <a href="#"><img alt="Status" src="https://img.shields.io/badge/Status-Ready%20to%20Review-success?style=for-the-badge"></a>

</p>

## 📘 Project Overview

This project showcases a complete **data cleaning workflow in SQL** on an AI-generated e-commerce dataset for a fictional online retailer called **Nova Cart**.

The goal is to transform a messy tracking dataset into a **clean, reliable base table** that can be used for **funnel analysis, acquisition performance**, and **customer behavior insights**.


The original dataset is **AI-generated** and contains:
- Duplicates in key identifiers  
- Inconsistent casing and spelling  
- Empty or null values  
- Inconsistent date formats  
- Non-standardized performance metrics  


## 🎯 Business Objectives

1. Ensure uniqueness & integrity of key identifiers
2. Standardize acquisition fields
3. Standardize user attributes & dates 
4. Standardize performance metrics 
5. Final cleaned dataset
   

## 📊 Dataset Overview

- **Rows:** 50  
- **Columns:** 20  
  - `user_id`
  - `email`
  - `country`
  - `city`
  - `age`
  - `gender`
  - `loyalty_status`
  - `session_id`
  - `page_views`
  - `session_duration`
  - `bounce_rate`
  - `source`
  - `medium`
  - `campaign`
  - `date`
  - `signup_date`
  - `last_purchase_date`
  - `conversions`
  - `revenue`



>### Sample of the dataset

| user_id  | session_id   | email              | source     | medium      | campaign     | device    | date        | country | city            | age | gender | loyalty_status | page_views | session_duration | bounce_rate | conversions | revenue | signup_date | last_purchase_date |
|----------|---------------|--------------------|------------|-------------|--------------|-----------|-------------|---------|------------------|-----|--------|----------------|------------|-------------------|-------------|-------------|---------|-------------|---------------------|
| user_64  | session_16895 | brenda167@outlook.com | instagram | cpc         |              | Mobile    | 2025-04-20 | FR      | South Carlburgh  | 41  | Other  | New            | 1          | 160.22           | 67%         |             | 18.92   | 2024-06-05  | 2026-02-22          |
| user_408 | session_59834 | james139@gmail.com | EMAIL      | organic     | retargeting  | Tablet    | 07/01/2025 | UK      |                  | 54  |        |                | 2          | 194.94           | 60%         | 0.0         | 24.8    | 2023-05-04  | 2023-08-18          |
| user_217 | session_26551 | anne200@example    | Google     | DISPLAY     | newsletter   | Desktop   | 2025/??/-- | ES      | Edwardmouth      | 46  |        | New            | 3          | 587.84           | 24%         | 0.0         | 96.02   | 2024-08-12  | 2026-02-16          |
| user_72  | session_13390 | mark43@gmail.com   | email      | organic     | spring_sale  | Mobile    | 2025-04-07 | IT      |                  | 52  | Male   | Returning      | 6          | 266.77           | 26%         | 1.0         | 11.09   | 2022-05-09  | 2023-10-01          |
| user_235 | session_95097 | melissa69@gmail.com | LinkedIn   | PAID_SOCIAL |              | Desktop   | 2025-10-11 | CA      | Thomasfurt       | 43  |        | New            | 3          | 2.9              | 31%         | 2.0         | 24.92   | 2024-08-09  |                     |
| user_208 | session_22249 | angela52@yahoo.com | REFERRAL   | cpc         | black_friday | mobile    | 2024-12-31 |         | West Kristy      | 46  |        | Returning      | 12         | 347.99           | 60%         | 0.0         | 43.59   | 2023-09-06  | 2025-04-10          |
| user_65  | session_29476 | ian179@example     | linkedin   | referral    | newsletter   | Desktop   | 2025-05-14 | FR      | Freemanstad      | 51  | Female | VIP            | 1          | 140.9            | 65%         | 0.0         | 66.29   | 2024-10-31  | 2026-02-07          |
| user_283 | session_57453 | cody76@example     | LinkedIn   | DISPLAY     | summer_sale  | Desktop   | 2025-01-12 | ES      | Robertside       | 58  | Other  | Returning      | 3          | 556.01           | 30%         | 0.0         | 5.98    | 2022-07-01  | 2023-09-21          |



---

## 🧪 Data Cleaning  Roadmap

The SQL script is structured into clear, documented steps:

### ✅ STEP 1 — Remove duplicates

- Check duplicates on:
  - `user_id`
  - `session_id`
  - `email`
- Identify **duplicate `user_id` values** (`user_300`, `user_36`).
- Reassign these duplicates to **available IDs** (e.g. `user_301`, `user_37`) by:
  - Updating specific rows using their **email** as an identifier.

Result:
- All `user_id`, `session_id`, and `email` values are **unique**.

---

### ✅ STEP 2 — Clean acquisition fields  
**Fields:** `source`, `medium`, `campaign`, `email`

- **`source`**
  - Fix misspellings:  
    - `"Gooogle"` → `Google`  
    - `"Facebok"` → `Facebook`
  - Standardize casing with `initcap(source)`.
  - Group social platforms into a single label:
    - `Instagram`, `Facebook`, `Linkedin` → `Social media`
  - Replace empty values with `Unknown`.

- **`email`**
  - Replace `"@example"` with `"@gmail.com"`.
  - Keep `"Unknown"` when the email field is empty.

- **`medium`**
**Important decision:**  
    The relationship between `source` and `medium` is inconsistent, and there is no safe way to fix it without losing data.  
    👉 For this reason, **`medium` is excluded from the final cleaned dataset.**

- **`campaign`**
  - Replace empty values with `'Unknown'`.

---

### ✅ STEP 3 — Standardize user attributes & dates  
**Fields:** `device`, `country`, `city`, `gender`, `loyalty_status`, `date`

- **`device`**
  - `trim()` + `initcap()` for consistent casing.
  - Empty values → `Unknown`.

- **`country`**
  - Convert `france` → `FR`.
  - Empty values → `Unknown`.

- **`city`** - Empty values → `Unknown`.

- **`gender`**  -  Empty values → `Unknown`.

- **`loyalty_status`**  - Empty values → `Unknown`.

- **`date`**
  - Normalize multiple date formats into a single standard:
    - Replace `/` by `-`.
    - Handle ambiguous value `'2025-??---'` by replacing it with a default date: `2025-01-01`.
    - Detect patterns:
      - `YYYY-MM-DD` → kept as is.
      - `DD-MM-YYYY` → converted to `YYYY-MM-DD` 

---

### ✅ STEP 4 — Clean performance metrics  
**Fields:** `bounce_rate`, `session_duration`, `conversions`

- **`conversions`**
  - `NULL` values → `0`.

- **`bounce_rate`**
  - Ensure a `%` sign is always present.
  - If missing, add `%` via `concat(bounce_rate, '%')`.

- **`session_duration`**
  - Standardize format by appending `' sec'` to all values.

---
### ✅ STEP 5 — Final cleaned dataset

This final step brings together all previous cleaning operations to generate a fully standardized and analysis-ready dataset (see ecommerce_clean.csv).
- Unique identifiers (`user_id`, `session_id`, `email`)  
- Standardized acquisition fields (`source`, `campaign`)  
- Normalized user attributes (`device`, `country`, `city`, `gender`, `loyalty_status`)  
- Cleaned engagement metrics (`page_views`, `session_duration`, `bounce_rate`, `conversions`, `revenue`)  
- Standardized date formats (`date`, `signup_date`, `last_purchase_date`)  


>### Sample of the clean dataset

| user_id  | session_id  | email                   | source       | campaign     | device  | date        | country | city          | age | gender | loyalty_status | page_views | session_duration | bounce_rate | conversions | revenue | signup_date | last_purchase_date |
|----------|-------------|--------------------------|--------------|--------------|---------|-------------|---------|---------------|-----|--------|----------------|------------|-------------------|-------------|-------------|---------|-------------|---------------------|
| user_64  | session_16895 | brenda167@outlook.com  | Social media | Unknown      | Mobile | 2025-04-20 | FR      | South Carlburgh | 41  | Other  | New            | 1          | 160.22 sec        | 67%         | 0.0         | 18.92   | 2024-06-05  | 2026-02-22          |
| user_408 | session_59834 | james139@gmail.com     | Email        | retargeting  | Tablet | 2025-01-07 | UK      | Unknown        | 54  | Unknown | Unknown        | 2          | 194.94 sec        | 60%         | 0.0         | 24.8    | 2023-05-04  | 2023-08-18          |
| user_217 | session_26551 | anne200@gmail.com      | Google       | newsletter   | Desktop | 2025-01-01 | ES      | Edwardmouth    | 46  | Unknown | New            | 3          | 587.84 sec        | 24%         | 0.0         | 96.02   | 2024-08-12  | 2026-02-16          |
| user_72  | session_13390 | mark43@gmail.com       | Email        | spring_sale  | Mobile | 2025-04-07 | IT      | Unknown        | 52  | Male   | Returning      | 6          | 266.77 sec        | 26%         | 1.0         | 11.09   | 2022-05-09  | 2023-10-01          |
| user_235 | session_95097 | melissa69@gmail.com    | Social media | Unknown      | Desktop | 2025-10-11 | CA      | Thomasfurt     | 43  | Unknown | New            | 3          | 2.9 sec           | 31%         | 2.0         | 24.92   | 2024-08-09  |                     |
| user_208 | session_22249 | angela52@yahoo.com     | Referral     | black_friday | Mobile | 2024-12-31 | Unknown | West Kristy    | 46  | Unknown | Returning      | 12         | 347.99 sec        | 60%         | 0.0         | 43.59   | 2023-09-06  | 2025-04-10          |
| user_65  | session_29476 | ian179@gmail.com       | Social media | newsletter   | Desktop | 2025-05-14 | FR      | Freemanstad    | 51  | Female | VIP            | 1          | 140.9 sec         | 65%         | 0.0         | 66.29
