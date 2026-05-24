-- Calculate the time (in months) between first_order_date and current order_date (invoice_date)
CREATE OR REPLACE VIEW order_grain_with_lifecycle AS
SELECT
  *,
  DATEDIFF(month, first_order_date, invoice_date) AS lifecycle_month
FROM order_grain_with_customer_details;

-- Check the distribution of lifecycle_month
SELECT
  MIN(lifecycle_month) AS min_lifecycle_month,
  MAX(lifecycle_month) AS max_lifecycle_month,
  AVG(lifecycle_month) AS avg_lifecycle_month,
  MEDIAN(lifecycle_month) AS median_lifecycle_month
FROM order_grain_with_lifecycle;
------------------------------------------------------------------------------
-- Result: Min: 0, Max: 24, Avg: 7.86, Median: 6
-- -- Slightly right-skewed
------------------------------------------------------------------------------

-- Check unique customers by lifecycle month
SELECT
  lifecycle_month,
  COUNT(DISTINCT customer_id) AS unique_customers
FROM order_grain_with_lifecycle
GROUP BY lifecycle_month
ORDER BY lifecycle_month;
------------------------------------------------------------------------------
-- Result: Customer activity drops sharply after month 0 (as expected), then declines gradually
------------------------------------------------------------------------------


------------------------------------------------------------------------------
-- SELECT * FROM order_grain_with_lifecycle;
