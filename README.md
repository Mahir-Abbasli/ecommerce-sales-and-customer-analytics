# E-Commerce Sales & Customer Analytics
### SQL | Microsoft Power BI | DAX

An end-to-end data analytics project using the Brazilian E-Commerce dataset by Olist. The project focuses on sales performance, customer behavior, and seller activity through SQL analysis and interactive Power BI dashboards.

## Dashboard Preview

### Executive Overview
![Executive Overview](screenshots/Executive%20Overview.png)

### Customer & Purchase Behavior
![Customer & Purchase Behavior](screenshots/Customer%20%26%20Purchase%20Behavior.png)

### Seller Performance
![Seller Performance](screenshots/Seller%20Performance.png)

## Project Overview

**Dataset:** [Brazilian E-Commerce Public Dataset – Olist (Kaggle)](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)

**Tools:** SQL, Microsoft Power BI, DAX, Power Query

The project includes three main dashboard pages:

- **Executive Overview** – Sales, revenue trends, orders, and product categories.
- **Customer & Purchase Behavior** – Customer retention, repeat purchases, and purchasing patterns.
- **Seller Performance** – Seller revenue, rankings, and performance comparisons.

## What I Did

- Explored and prepared the raw CSV datasets using SQL.
- Created raw and staging tables.
- Performed data quality and integrity checks.
- Analyzed sales, customer behavior, seller performance, and delivery metrics.
- Built the analytical data model in Power BI.
- Created DAX measures for business KPIs.
- Designed three interactive dashboard pages.

## Key Metrics

- Total Orders & Delivered Orders
- Delivered Revenue & Average Order Value
- Total Customers & Repeat Customer Rate
- One-Time Customers
- Seller Revenue & Top 10 Sellers Revenue Share
- Average Items per Delivered Order

## Repository Structure

```text
Ecommerce_Analytics_Project/
│
├── sql/
│   ├── setup/
│   ├── data_quality/
│   └── analysis/
│
├── power_bi/
│   ├── Ecommerce_Sales_Customer_Analytics.pbix
│   └── Ecommerce_Sales_Customer_Analytics.pdf
│
├── screenshots/
│   ├── Executive Overview.png
│   ├── Customer & Purchase Behavior.png
│   └── Seller Performance.png
│
└── README.md
```

## How to Run

1. Download the Olist dataset from Kaggle.
2. Place the CSV files in the local `data/raw/` folder.
3. Run the SQL scripts in order.
4. Open the Power BI file to explore the dashboards.

*Note: The original CSV files are not included in this repository. All monetary values are in Brazilian Real (BRL).*

## Author

**Mahir Abbasli**

SQL | Microsoft Power BI | DAX
