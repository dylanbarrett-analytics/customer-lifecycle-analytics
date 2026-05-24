-- Inspect structure of standardized purchases table
SELECT * FROM purchases_standardized LIMIT 100;

-- Check total rows
SELECT COUNT(*) FROM purchases_standardized;
------------------------------------------------------------------------------
-- Result: 1,067,371 rows
-- -- This table is at line-item purchase grain (1 row = 1 line-item purchase)
-- -- -- Therefore, there are 1,067,371 total line-item purchases.
------------------------------------------------------------------------------

-- There appear to be a lot of NULL values for customer_id
-- How many rows with NULL values for customer_id?
SELECT
  COUNT(*) AS num_rows
FROM purchases_standardized
WHERE customer_id IS NULL;
------------------------------------------------------------------------------
-- Result: 243,007 rows
-- -- These rows will be filtered out because customer identifiers are needed for reliable LTV/retention analysis.
------------------------------------------------------------------------------

-- Filter out rows where customer_id is NULL
CREATE OR REPLACE VIEW purchases_valid_customers AS
SELECT *
FROM purchases_standardized
WHERE customer_id IS NOT NULL;

-- Confirm total rows
SELECT COUNT(*) FROM purchases_valid_customers;
------------------------------------------------------------------------------
-- Result: 824,364 rows
------------------------------------------------------------------------------

-- How many unique customers?
SELECT
  COUNT(DISTINCT customer_id) AS unique_customers,
  COUNT(*) AS num_purchases
FROM purchases_valid_customers;
------------------------------------------------------------------------------
-- Result: 5,942 unique customers (across 824,364 line-item purchases)
------------------------------------------------------------------------------

-- How many unique orders?
SELECT
  COUNT(DISTINCT invoice_id) AS unique_orders
FROM purchases_valid_customers;
------------------------------------------------------------------------------
-- Result: 44,876 unique orders
------------------------------------------------------------------------------

-- How many orders per customer?
SELECT
  COUNT(DISTINCT invoice_id) / COUNT(DISTINCT customer_id) AS orders_per_customer
FROM purchases_valid_customers;
------------------------------------------------------------------------------
-- Result: ~7.55 orders per customer
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SELECT * FROM purchases_valid_customers;
