-- Join order grain table (left) with customer grain table (right)
-- -- This is done to get customer-level details for each order (invoice_id)
CREATE OR REPLACE VIEW order_grain_with_customer_details AS
SELECT
  o.invoice_id,
  o.customer_id,
  o.invoice_date,
  o.order_quantity,
  o.order_revenue,
  o.estimated_cogs,
  o.estimated_profit,
  o.country,
  c.first_order_date,
  c.last_order_date,
  c.cohort_month
FROM order_grain_profit o  
INNER JOIN customer_grain_with_cohort c
  ON o.customer_id = c.customer_id;


------------------------------------------------------------------------------
-- SELECT * FROM order_grain_with_customer_details;