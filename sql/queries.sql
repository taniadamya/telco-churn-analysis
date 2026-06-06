-- TELCO CUSTOMER CHURN ANALYSIS
-- Author: Tania Damayanti
-- Tools: Google BigQuery
-- Dataset: IBM Telco Customer Churn (Extended)

-- STEP 1: EXPLORE RAW TABLES

-- Check total customers
SELECT COUNT(*) as total_customers
FROM `telco-churn-analysis-498613.telco_chrun.main`;

-- Check all column names across tables
SELECT column_name, table_name
FROM `telco-churn-analysis-498613.telco_chrun.INFORMATION_SCHEMA.COLUMNS`
ORDER BY table_name, ordinal_position;

-- Preview each raw table
SELECT * FROM `telco-churn-analysis-498613.telco_chrun.demographics` LIMIT 5;
SELECT * FROM `telco-churn-analysis-498613.telco_chrun.location` LIMIT 5;
SELECT * FROM `telco-churn-analysis-498613.telco_chrun.services` LIMIT 5;
SELECT * FROM `telco-churn-analysis-498613.telco_chrun.status` LIMIT 5;
SELECT * FROM `telco-churn-analysis-498613.telco_chrun.population` LIMIT 5;



-- STEP 2: JOIN ALL TABLES → CREATE MASTER TABLE


CREATE OR REPLACE TABLE `telco-churn-analysis-498613.telco_chrun.master_churn` AS
SELECT
  m.CustomerID,
  m.City,
  m.`Zip Code`                  AS Zip_Code,
  m.`Churn Label`               AS Churn_Label,
  m.`Churn Value`               AS Churn_Value,
  m.`Churn Score`               AS Churn_Score,
  m.`Monthly Charges`           AS Monthly_Charges,
  m.`Total Charges`             AS Total_Charges,
  m.Contract,
  m.`Internet Service`          AS Internet_Service,
  m.`Phone Service`             AS Phone_Service,
  m.`Tenure Months`             AS Tenure_Months,
  m.`Payment Method`            AS Payment_Method,
  m.`Paperless Billing`         AS Paperless_Billing,
  d.Gender,
  d.Age,
  d.`Senior Citizen`            AS Senior_Citizen,
  d.Married,
  d.Dependents,
  d.`Number of Dependents`      AS Number_of_Dependents,
  l.State,
  l.Latitude,
  l.Longitude,
  p.Population
FROM `telco-churn-analysis-498613.telco_chrun.main` m
LEFT JOIN `telco-churn-analysis-498613.telco_chrun.demographics` d 
  ON m.CustomerID = d.`Customer ID`
LEFT JOIN `telco-churn-analysis-498613.telco_chrun.location` l 
  ON m.CustomerID = l.`Customer ID`
LEFT JOIN `telco-churn-analysis-498613.telco_chrun.population` p 
  ON m.`Zip Code` = p.`Zip Code`;



-- STEP 3: ANALYSIS QUERIES

-- Query 1: Overall churn summary
SELECT
  COUNT(*)                                              AS total_customers,
  SUM(Churn_Value)                                      AS total_churned,
  ROUND(SUM(Churn_Value) * 100.0 / COUNT(*), 2)        AS churn_rate_pct
FROM `telco-churn-analysis-498613.telco_chrun.master_churn`;


-- Query 2: Churn rate by contract type
SELECT
  Contract,
  COUNT(*)                                              AS total_customers,
  SUM(Churn_Value)                                      AS churned,
  ROUND(SUM(Churn_Value) * 100.0 / COUNT(*), 2)        AS churn_rate_pct
FROM `telco-churn-analysis-498613.telco_chrun.master_churn`
GROUP BY Contract
ORDER BY churn_rate_pct DESC;


-- Query 3: Churn rate by age group & gender
SELECT
  Gender,
  CASE
    WHEN Age < 30              THEN 'Under 30'
    WHEN Age BETWEEN 30 AND 45 THEN '30-45'
    WHEN Age BETWEEN 46 AND 60 THEN '46-60'
    ELSE                            'Above 60'
  END                                                   AS Age_Group,
  COUNT(*)                                              AS total_customers,
  SUM(Churn_Value)                                      AS churned,
  ROUND(SUM(Churn_Value) * 100.0 / COUNT(*), 2)        AS churn_rate_pct
FROM `telco-churn-analysis-498613.telco_chrun.master_churn`
GROUP BY Gender, Age_Group
ORDER BY churn_rate_pct DESC;


-- Query 4: Top 10 cities with highest churn rate (min 10 customers)
SELECT
  City,
  State,
  COUNT(*)                                              AS total_customers,
  SUM(Churn_Value)                                      AS churned,
  ROUND(SUM(Churn_Value) * 100.0 / COUNT(*), 2)        AS churn_rate_pct
FROM `telco-churn-analysis-498613.telco_chrun.master_churn`
GROUP BY City, State
HAVING COUNT(*) >= 10
ORDER BY churn_rate_pct DESC
LIMIT 10;


-- Query 5: Churn by internet service & monthly charge segment
SELECT
  Internet_Service,
  CASE
    WHEN Monthly_Charges < 30                  THEN 'Low (<30)'
    WHEN Monthly_Charges BETWEEN 30 AND 60     THEN 'Medium (30-60)'
    WHEN Monthly_Charges BETWEEN 61 AND 90     THEN 'High (61-90)'
    ELSE                                            'Very High (>90)'
  END                                               AS Charge_Segment,
  COUNT(*)                                          AS total_customers,
  SUM(Churn_Value)                                  AS churned,
  ROUND(SUM(Churn_Value) * 100.0 / COUNT(*), 2)    AS churn_rate_pct,
  ROUND(AVG(Monthly_Charges), 2)                    AS avg_monthly_charges
FROM `telco-churn-analysis-498613.telco_chrun.master_churn`
GROUP BY Internet_Service, Charge_Segment
ORDER BY churn_rate_pct DESC;


-- Query 6: Churn by tenure segment
SELECT
  CASE
    WHEN Tenure_Months <= 12               THEN '0-12 months'
    WHEN Tenure_Months BETWEEN 13 AND 24   THEN '13-24 months'
    WHEN Tenure_Months BETWEEN 25 AND 36   THEN '25-36 months'
    WHEN Tenure_Months BETWEEN 37 AND 48   THEN '37-48 months'
    WHEN Tenure_Months BETWEEN 49 AND 60   THEN '49-60 months'
    ELSE                                        '61-72 months'
  END                                           AS Tenure_Group,
  COUNT(*)                                      AS total_customers,
  SUM(Churn_Value)                              AS churned,
  ROUND(SUM(Churn_Value) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `telco-churn-analysis-498613.telco_chrun.master_churn`
GROUP BY Tenure_Group
ORDER BY churn_rate_pct DESC;
