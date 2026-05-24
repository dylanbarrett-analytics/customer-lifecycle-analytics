-- Group by customer (customer_id)
-- Grain transition from order -> customer
CREATE OR REPLACE VIEW customer_grain AS
SELECT
  customer_id,
  MIN(invoice_date) AS first_order_date,
  MAX(invoice_date) AS last_order_date,
  COUNT(DISTINCT invoice_id) AS total_orders,
  SUM(order_quantity) AS total_quantity,
  SUM(order_revenue) AS total_revenue,
  SUM(estimated_cogs) AS total_cogs,
  SUM(estimated_profit) AS customer_ltv,
  MIN(country) AS country
FROM order_grain_profit
GROUP BY customer_id;

-- Extract "cohort month" from each customer's first_order_date.
-- -- For example, for "December 15, 2009" -> extract "December 2009"
CREATE OR REPLACE VIEW customer_grain_with_cohort AS
SELECT
  *,
  DATE_TRUNC('month', first_order_date) AS cohort_month
FROM customer_grain;


------------------------------------------------------------------------------
-- SELECT * FROM customer_grain_with_cohort;