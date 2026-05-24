-- Group by order (invoice_id) and customer (customer_id)
-- Grain transition from line-item -> order
CREATE OR REPLACE VIEW order_grain AS
SELECT
  invoice_id,
  customer_id,
  MIN(invoice_date) AS invoice_date,  -- MIN used to preserve a single order grain value
  SUM(quantity) AS order_quantity,    -- total quantity at order grain
  SUM(unit_price * quantity) AS order_revenue, -- calculated at line-item grain so the unit prices are accurate
  MIN(country) AS country             -- MIN used to preserve a single order grain value
FROM purchases_valid_customers_invoices
GROUP BY invoice_id, customer_id;

-- Simulate COGS (cost of goods sold) and profit
-- These columns were not included in the original dataset
-- -- Assume COGS = 60% of revenue to approximate product + fulfillment costs
-- -- -- 60% was chosen as a middle-ground assumption
CREATE OR REPLACE VIEW order_grain_profit AS
SELECT
  *,
  order_revenue * 0.60 AS estimated_cogs,
  order_revenue - (order_revenue * 0.60) AS estimated_profit
FROM order_grain;


------------------------------------------------------------------------------
-- SELECT * FROM order_grain_profit;
