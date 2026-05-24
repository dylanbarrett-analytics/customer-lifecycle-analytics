-- Group by cohort (cohort_month) and lifecycle_month
-- -- This will show customer LTV (lifetime value) by cohort + lifecycle_month
CREATE OR REPLACE VIEW customer_ltv AS
WITH cohort_monthly_profit AS (
SELECT
  cohort_month AS cohort,
  lifecycle_month,
  SUM(estimated_profit) AS monthly_profit,
  MAX(
    CASE 
      WHEN lifecycle_month = 0 THEN COUNT(DISTINCT customer_id)
    END
  ) OVER (PARTITION BY cohort_month) AS cohort_size
FROM order_grain_with_lifecycle
GROUP BY cohort_month, lifecycle_month
ORDER BY cohort_month, lifecycle_month
)
SELECT
  cohort,
  lifecycle_month,
  monthly_profit,
  cohort_size,
  monthly_profit * 1.0 / cohort_size AS monthly_profit_per_customer,
  SUM(monthly_profit * 1.0 / cohort_size) OVER (PARTITION BY cohort ORDER BY lifecycle_month) AS cumulative_ltv
FROM cohort_monthly_profit
ORDER BY cohort, lifecycle_month;


------------------------------------------------------------------------------
-- SELECT * FROM customer_ltv;
