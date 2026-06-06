# telco-churn-analysis
# 📊 Customer Churn Analysis & Prediction

## 📌 Project Overview
End-to-end data analytics project analyzing customer churn patterns for a telecommunications company. This project covers the full data pipeline from raw data ingestion, SQL transformation, exploratory data analysis, machine learning prediction, to business dashboard visualization.

**Business Question:** *What factors drive customer churn, and can we predict which customers are at risk of leaving?*

---

## 🛠️ Tools & Technologies
| Tool | Purpose |
|------|---------|
| Google BigQuery | Data warehouse, SQL transformation |
| Python (Google Colab) | Data cleaning, EDA, ML modeling |
| Looker Studio | Interactive dashboard |
| Pandas, Matplotlib, Seaborn | Data manipulation & visualization |
| Scikit-learn | Machine learning |

---

## 📂 Dataset
**Source:** IBM Telco Customer Churn (Extended Version)
- 7,043 customers
- 6 raw tables: `main`, `demographics`, `location`, `services`, `status`, `population`
- Raw data challenges: inconsistent column names, missing values, multi-table joins required

---

## 🔄 Project Workflow

```
6 Raw CSV Files
      ↓
BigQuery (JOIN 6 tables → master_churn)
      ↓
Python (Cleaning → EDA → ML Model)
      ↓
Looker Studio (Interactive Dashboard)
```

---

## 🗄️ SQL — Data Transformation (BigQuery)
Key SQL operations performed:
- JOIN 6 tables using `CustomerID` and `Zip Code`
- Aggregation queries for churn rate by contract, region, age group
- Window analysis for tenure segmentation
- Created `master_churn` table with 24 columns

**Sample Query — Churn Rate by Contract Type:**
```sql
SELECT
  Contract,
  COUNT(*) AS total_customers,
  COUNTIF(Churn_Label = true) AS churned,
  ROUND(COUNTIF(Churn_Label = true) * 100.0 / COUNT(*), 2) AS churn_rate_pct
FROM `telco_chrun.master_churn`
GROUP BY Contract
ORDER BY churn_rate_pct DESC
```

---

## 🐍 Python — EDA & Machine Learning

### Data Cleaning
- Converted `Total_Charges` from string to numeric
- Handled 11 missing values using median imputation
- Engineered new features: `Age_Group`, `Tenure_Group`

### EDA Key Findings
- Overall churn rate: **26.54%**
- Month-to-month contracts: **42.71%** churn rate
- First 12 months: most critical retention period
- Fiber optic users account for **69.4%** of all churners

### Machine Learning Model
| Metric | Score |
|--------|-------|
| Algorithm | Random Forest Classifier |
| ROC-AUC | **0.8743** |
| Accuracy | **80%** |
| F1-Score (Churn) | 0.67 |

**Top Churn Predictors:**
1. Contract type (0.20)
2. Tenure months (0.16)
3. Monthly charges (0.13)
4. Total charges (0.12)

---

## 📈 Dashboard (Looker Studio)
**[🔗 View Live Dashboard](#)** ← ganti dengan link Looker Studio kamu

Key visualizations:
- KPI Scorecards: Total Customers, Total Churned, Churn Rate
- Churn by Contract Type (Bar Chart)
- Churn by Internet Service (Pie Chart)
- Churn Trend by Tenure (Line Chart)
- Top Cities by Churn Rate (Table)

---

## 💡 Business Recommendations
1. **Offer annual contract incentives** — reduce churn from 42% to <11%
2. **Implement 12-month onboarding program** — most critical retention period
3. **Review Fiber optic pricing** — 69% of churners are Fiber optic users
4. **Senior loyalty program** — customers 60+ have highest churn rate (~36%)

---

## 📁 Repository Structure
```
├── notebook/
│   └── churn_analysis.ipynb
├── images/
│   ├── eda_churn.png
│   └── model_results.png
├── sql/
│   └── queries.sql
└── README.md
```

---

## 👩‍💻 Author
**Tania Damayanti**  
Data Analyst | Python • SQL • Looker Studio • Tableau • Power BI  
[LinkedIn](#) • [GitHub](#)
