-- Group by cohort (cohort_month) and lifecycle_month
-- -- This will show customer retention by cohort + lifecycle_month
CREATE OR REPLACE VIEW customer_retention AS
WITH active_customers AS (
SELECT
  cohort_month AS cohort,
  lifecycle_month,
  COUNT(DISTINCT customer_id) AS active_customers,
  MAX(    -- use MAX to ignore NULLs and always return the active customer count from lifecycle_month = 0 ...
    CASE
      WHEN lifecycle_month = 0 THEN COUNT(DISTINCT customer_id)
    END
  ) OVER (PARTITION BY cohort_month) AS cohort_size  -- ... within each cohort
FROM order_grain_with_lifecycle
GROUP BY cohort_month, lifecycle_month
ORDER BY cohort_month, lifecycle_month
)
SELECT
  cohort,
  lifecycle_month,
  active_customers,
  cohort_size,
  active_customers * 1.0 / cohort_size AS retention_rate
FROM active_customers
ORDER BY cohort, lifecycle_month;


------------------------------------------------------------------------------
-- SELECT * FROM customer_retention;