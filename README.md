# SQL Project Description

The goal of this project is to collect and analyze data that helps track the **dynamics of account creation**, **user activity through emails** (sent, opened, clicked), and evaluate behavior in categories such as **sending interval, account verification, and subscription status**.  
This data enables comparison of user activity across countries, identification of **key markets**, and **segmentation of users** by various parameters.

## Metrics to Calculate

### Core Metrics
- **account_cnt** — number of created accounts  
- **sent_msg** — number of sent emails  
- **open_msg** — number of opened emails  
- **visit_msg** — number of clicks from emails  

### Additional Metrics
- **total_country_account_cnt** — total number of accounts created in a country  
- **total_country_sent_cnt** — total number of emails sent in a country  
- **rank_total_country_account_cnt** — ranking of countries by number of created accounts  
- **rank_total_country_sent_cnt** — ranking of countries by number of sent emails  

---

## Implementation Details

- Metrics for **accounts** and **emails**  calculated separately to preserve unique dimensions and avoid conflicts (due to different logic of the `date` field).  
- Used  **`UNION`** to combine results.  
- In the final output, keep only records where:  
  - `rank_total_country_account_cnt <= 10` **or**  
  - `rank_total_country_sent_cnt <= 10`.

---

## Skills Gained

- Writing **complex SQL queries** with grouping, aggregations, and ranking  
- Analyzing **user activity and engagement** across multiple dimensions  
- Applying **data segmentation and country-level comparison**  
- Working with **business-oriented metrics** and extracting insights from raw data
