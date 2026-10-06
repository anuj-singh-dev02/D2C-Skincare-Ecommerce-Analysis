# D2C Skincare E-Commerce Analytics

An end-to-end data analytics project analyzing a D2C skincare e-commerce business using **Python, SQL, and Power BI**. 
This project focuses on sales performance, customer behavior, acquisition channels, product performance, returns, reviews, and estimated profitability.

---

## 📌 Project Overview

This project analyzes a skincare e-commerce dataset containing customer, order, product, order-item, return, and review data.

The objective is to turn raw transactional data into actionable business insights that can help understand:

- Overall sales and order performance
- Monthly revenue trends
- Product and category performance
- Customer purchase behavior and retention
- Acquisition channel performance
- Product returns and return reasons
- Customer ratings and product satisfaction
- Estimated product-level profitability

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Python** | Data cleaning, validation, EDA and analysis |
| **Pandas / NumPy** | Data manipulation and calculations |
| **Matplotlib / Seaborn** | Exploratory data visualization |
| **PostgreSQL** | SQL-based business analysis |
| **Power BI** | Interactive dashboard and visualization |
| **DAX** | KPI and business measures |
| **GitHub** | Project documentation and version control |

---

## 📂 Dataset

In this project I uses the **D2C Skincare E-Commerce Analytics Dataset** from Kaggle.

### Dataset Tables

| Table | Rows | Description |
|---|---:|---|
| Customers | 500 | Customer demographics and acquisition information |
| Orders | 1,250 | Order-level transaction information |
| Order Items | 2,042 | Product-level order details |
| Products | 28 | Product, category, pricing and cost information |
| Returns | 79 | Returned order/product information |
| Reviews | 494 | Customer product ratings |

---

## 🔄 Project Workflow

```text
Raw CSV Data
     ↓
Data Understanding & Cleaning
     ↓
Exploratory Data Analysis (Python)
     ↓
SQL Business Analysis
     ↓
Power BI Data Model & DAX
     ↓
Interactive Dashboard
     ↓
Business Insights & Recommendations
```

---

# 🔍 Analysis Performed

## 1. Data Cleaning & Quality Checks

The Python analysis included:

- Missing-value analysis
- Duplicate-value checks
- Primary-key uniqueness checks
- Date-format conversion
- Invalid/negative-value checks
- Order status validation
- Investigation of missing delivery dates
- Revenue reconciliation

A key data-quality finding was identified around the order-level `final_amount` field. The product-level `Order_Items[item_total]` reconciles with `Orders[gross_amount]`, while `final_amount` does not consistently reconcile with gross amount, discounts and shipping fees.

Therefore, **`Order_Items[item_total]` is used as the primary product revenue metric** throughout the analysis.

---

# 📊 Key Business KPIs

| KPI | Value |
|---|---:|
| Total Orders | **1,250** |
| Total Customers | **500** |
| Product Revenue | **₹1,175,350** |
| Average Order Value | **₹940.28** |
| Total Units Sold | **~3K** |
| Return Rate | **6.32%** |
| Repeat Customers | **352** |
| Repeat Customer Rate | **77.53%** |
| Estimated Gross Profit | **₹611.44K** |
| Estimated Gross Margin | **52.02%** |

> **Note:** Estimated gross profit/margin is based on product revenue and product cost only. It excludes expenses such as shipping, marketing, platform fees, salaries and other operating costs.

---

# 💡 Key Insights

### 🛍️ Product & Category Performance

- **Serum** is the strongest product category by revenue and units sold.
- Serum generated approximately **₹540K** in revenue.
- **Alpha Arbutin 2% Serum** is the highest-revenue product at approximately **₹97.4K**.
- Other strong serum products include Niacinamide, Vitamin C and Hyaluronic Acid serums.

### 👥 Customer Retention

- **352 customers are repeat customers**.
- The repeat customer rate is **77.53% among customers who placed at least one order**.
- **102 customers** are one-time purchasers.
- **46 registered customers** have not placed an order.

### 📣 Acquisition Channels

- **Google Search and Instagram** are major contributors to customer acquisition and revenue.
- **Referral** has the highest customer conversion rate.
- Acquisition performance differs depending on the metric used — customer conversion, order volume, revenue or AOV.

### 🔄 Returns

- Overall return rate is **6.32%**.
- **Skin irritation** is the most common return reason.
- Other major reasons include late delivery, damaged packaging and wrong item received.
- **Oat Extract Gentle Cleanser** has the highest product return rate among the analyzed products.

### ⭐ Reviews

- Most customer reviews are positive, with **4-star and 5-star ratings making up the majority of reviews**.
- Product ratings vary across categories and individual products.
- The analysis did not find a consistent pattern showing that lower ratings alone explain higher product return rates.

### 💰 Profitability

- Estimated gross profit is approximately **₹611.44K**.
- Estimated gross margin is **52.02%**.
- Alpha Arbutin 2% Serum is among the strongest contributors to estimated product profit.

---

# 📈 Power BI Dashboard

The project contains a **3-page interactive Power BI dashboard**.

## 1. Executive Overview

Provides a high-level view of:

- Total orders
- Revenue
- Units sold
- Customers
- Return rate
- AOV
- Monthly revenue trend
- Revenue by acquisition channel
- Customer type
- Category revenue
- Top products

![Executive Overview](https://github.com/anuj-singh-dev02/D2C-Skincare-Ecommerce-Analysis/blob/main/Screenshots/Executive%20Overview.png)

---

## 2. Customer & Marketing

Focuses on:

- Customers by acquisition channel
- Orders by acquisition channel
- Revenue by acquisition channel
- AOV by acquisition channel
- Repeat customer rate
- Repeat customers

![Customer & Marketing](https://github.com/anuj-singh-dev02/D2C-Skincare-Ecommerce-Analysis/blob/main/Screenshots/Customer%20%26%20Marketing.png) 

---

## 3. Product & Returns

Focuses on:

- Revenue by category
- Units sold by category
- Estimated gross profit
- Estimated gross margin
- Product return rate
- Average rating by category
- Return reasons

![Product & Returns](https://github.com/anuj-singh-dev02/D2C-Skincare-Ecommerce-Analysis/blob/main/Screenshots/Product%20%26%20Returns.png)

---

# 🧮 SQL Analysis

The SQL analysis was performed in **PostgreSQL** and covers:

- Customer analysis
- Order analysis
- Product analysis
- Order-item analysis
- Revenue analysis
- Monthly sales trends
- Acquisition channel analysis
- Return analysis
- Review and rating analysis
- Profitability analysis
- CTEs
- Window functions
- Product ranking
- Customer segmentation

Advanced SQL techniques include:

```sql
CTE
RANK()
PARTITION BY
CASE WHEN
GROUP BY
HAVING
Window Functions
JOINs
```
---


# 🎯 Business Recommendations

Based on the analysis:

1. **Strengthen the Serum category** because it is the strongest revenue contributor.
2. **Focus retention campaigns on one-time customers** to convert them into repeat purchasers.
3. **Investigate skin-irritation returns** and review product formulation, usage guidance and product descriptions.
4. **Continue investing in high-performing acquisition channels**, while evaluating channels using both conversion and revenue metrics.
5. **Monitor high-return products** and investigate the reasons behind their returns.
6. **Promote high-profit products** while maintaining healthy customer satisfaction.
7. **Improve delivery and packaging processes** to reduce late-delivery and damaged-package returns.

---

# 🚀 Skills Demonstrated

This project demonstrates practical experience with:

- Data Cleaning
- Exploratory Data Analysis
- Data Quality Validation
- Business Analytics
- SQL
- PostgreSQL
- Python
- Pandas
- Data Visualization
- Power BI
- DAX
- KPI Development
- Customer Segmentation
- Revenue Analysis
- Product Analytics
- Marketing Analytics
- Profitability Analysis
- Business Recommendations

---

## ⭐ Project Purpose

This project was created as a portfolio project to demonstrate an end-to-end analytics workflow — from raw data preparation and SQL analysis to interactive Power BI reporting and business recommendations.
