# Customer Lifecycle Analytics

---

## **Introduction**

For a business, growth is not just about acquiring new customers. It's about understanding how customer value evolves over time and how effectively customers are retained. Two of the most important metrics for evaluating long-term customer health are **Customer Lifetime Value (LTV)** and **Retention Rate**.

**Customer Lifetime Value (LTV)** measures the cumulative value a customer generates. A higher LTV indicates that customers continue purchasing over time.

**Retention Rate** measures the percentage of customers who remain *active* after their first purchase. Strong retention often signals customer satisfaction while poor retention can indicate friction in the customer experience.

---

## **Table of Contents**

1. [Introduction](#introduction)
2. [About the Data](#about-the-data)
3. [Project Goals](#project-goals)
4. [Tools Used](#tools-used)
5. [Project Files](#project-files)
6. [Step 1: Cleaning, Counts, and Filters](#step-1-cleaning-counts-and-filters)
7. [Step 2: Aggregations and Cohorts](#step-2-aggregations-and-cohorts)
8. [Step 3: Lifecycle Analysis](#step-3-lifecycle-analysis)
9. [Final Results](#final-results)
10. [Recommendations](#recommendations)
11. [Tableau Dashboard Link](#tableau-dashboard-link)

---

## **About the Data**

This analysis uses the **Online Retail II** dataset, a real-world e-commerce transaction dataset containing purchases from a UK-based online retailer.

Dataset Source: [Kaggle - Online Retail II](https://www.kaggle.com/datasets/mashlyn/online-retail-ii-uci)

> Each row represents a product purchased within an invoice (order).

---

## **Project Goals**

1. **Measure how customer lifetime value evolves** across lifecycle months for different acquisition cohorts.
2. **Compare retention patterns** across cohorts to identify differences in long-term customer engagement.

---

## **Tools Used**

- ![SQL](https://img.shields.io/badge/SQL-blue) (via **DataBricks**): Data loading, cleaning, merging, and analysis
- ![Tableau](https://img.shields.io/badge/Tableau-blue): Dashboard design and final visualizations

---

## **Project Files**

### **DataBricks**
- [`01_column_names.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/01_column_names.sql)
Standardized raw column names
- [`02_customer_filter.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/02_customer_filter.sql)
Filtered out records that were missing customer identifiers
- [`03_invoice_quantity_filter.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/03_invoice_quantity_filter.sql)
Filtered out records with negative quantities
- [`04_order_grain.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/04_order_grain.sql)
Aggregated line-item purchases to order grain
- [`05_customer_grain.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/05_customer_grain.sql)
Aggregated orders to customer grain
- [`06_order_join_customer.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/06_order_join_customer.sql)
Joined order grain table with customer grain table on customer_id
- [`07_lifecycle.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/07_lifecycle.sql)
Calculated lifecycle month for each order
- [`08_customer_retention.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/08_customer_retention.sql)
Calculated cohort retention rates by lifecycle month
- [`09_LTV_curve.sql`](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/SQL/09_LTV_curve.sql)
Calculated cohort lifetime value across lifecycle months

### **Documentation**
- `README.md`: Project documentation

---

## **Step 1: Cleaning, Counts, and Filters**

The raw transaction table's column names were standardized so that each field had a clean, consistent name. This original dataset was at **line-item grain**, meaning each row represented *one product purchased within an invoice*. There were **1,067,371 total line-item purchases** (rows).

It turns out there were 243,007 rows where the `customer_id` was NULL. These rows were filtered out because customer identifiers would be required for tracking customers' purchases over time.

Next, it was discovered that 18,744 rows had negative quantities (i.e., quantity < 0). It turned out these particular rows were associated with an `invoice_id` beginning with a "C" (e.g., C492833). As per the dataset creator on Kaggle, these referred to *cancelled invoices*. Therefore, these rows were filtered out. 

> Across 805,620 line-item purchases, there were **5,881 unique customers** and **36,975 unique orders** (~6.3 orders per customer).

---

## **Step 2: Aggregations and Cohorts**

With cleaning complete, the data was aggregated from line-item grain to order grain, creating one row per invoice per customer. Product cost information was not available, so COGS (cost of goods sold) was estimated to be 60% of revenue, simulating a simplified profit model. 

> For example, if an order generated $100 in revenue, estimated COGS would be $60, and therefore, estimated profit would be $40.

Then the data was aggregated from order grain to customer grain, creating one row per customer. The total estimated profit for each customer was referred to as **lifetime value (LTV)**.

Each customer was assigned to an *acquisition cohort* based on the *month of their first purchase*. Acquisition cohorts are important because they align customers by when they entered the business, making it possible to compare trends across groups that began their customer journey at different times.

> For example, a customer whose first purchase occurred on January 25, 2010 would be part of the "January 2010" cohort.

---

## **Step 3: Lifecycle Analysis**

Next, the order grain table was joined with the customer grain table (on `customer_id`) to get customer-level details for each order, allowing each order to be placed within a **customer's lifecycle**. Lifecycle month was calculated as the number of months between a customer's first purchase and each subsequent order/purchase. 

![Unique Customers by Lifecycle Month](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/images/unique_customers_by_lifecycle_month.png)

As seen here, the number of unique customers dropped sharply after month 0, and then declined gradually. This was the expected trend.

Using this lifecycle framework, customer retention rates were calculated (by cohort and lifecycle month) to measure the percentage of customers who remained *active* over time.

> For example, if a cohort began with 100 customers, and 15 of those customers placed an order in lifecycle month 12, the retention rate for month 12 would be 15%.

Then customer lifetime value (LTV) was calculated (by cohort and lifecycle month) to measure how much value (estimated profit) was generated over time. LTV reveals how customer value accumulates throughout the lifecycle.

> For example, if a cohort (with 100 customers) generated $800 by lifecycle month 12, the LTV for month 12 would simply be $800 (or $8 per customer).

---

### **Final Results**

![Dashboard Screenshot](https://github.com/dylanbarrett-analytics/customer-lifecycle-analytics/blob/main/images/LTV_retention_dashboard.png)

As expected, customer LTV increased steadily throughout the customer lifecycle until it flattened in later lifecycle months as fewer and fewer customers remain active. However, the curve did not flatten as quickly as expected, suggesting there are a good number of long-term customers.

As for customer retention, there is a clear (expected) decline as cohorts progressed through their lifecycle. Some cohorts took longer than others to drop, as other cohorts continued to retain a meaningful portion of customers throughout the first 12 months. This indicates that a subset of customers develop longer-term purchasing habits as they remain active as time passes.

The December 2009 cohort obviously stood out as the strongest-performing cohort, with a 12-month LTV of $2,229 and a 12-month retention rate of 30.9%.

Overall, **LTV accumulation doesn't slow down as quickly as expected**, while **retention dropoff also does not occur as quickly as expected**. Therefore, there is a large portion of **long-term customers** with **long-term purchasing habits**.

---

### **Recommendations**

1. Invest in existing customer relationships as opposed to new customer acquisition
- Since there are so many established long-term customers who continue generating value long after their initial purchase, **prioritizing retention efforts is suggested**. While acquiring new customers is always important, this existing customer base is very loyal, so there should be more efforts to maximize this ongoing value.

2. Reward and encourage repeat purchasing behavior with existing customers
- With this level of existing loyalty, a **targeted incentive** would logically lead to a higher probability of more purchases.
> Ex: A customer receives early access to new products as a reward for their loyalty.

3. Investigate the December 2009 cohort
- This cohort showed stronger retention and LTV than any other cohort, by far. Further analysis could explore whether these customers differ by geography, purchasing behavior, product preferences, or other characteristics. **Understanding what made this cohort successful** may help the business identify and attract more high-value customers like this in the future.

---

## **Tableau Dashboard Link**

🔗 [View the Dashboard on Tableau Public](https://public.tableau.com/app/profile/dylan.barrett1539/viz/LTVRetention_17785332961200/Dashboard?publish=yes)
