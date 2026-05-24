-- All columns were checked for NULL values (only invoice_id currently shown here)
SELECT *
FROM purchases_valid_customers
WHERE invoice_id IS NULL;
------------------------------------------------------------------------------
-- Result: There are no NULL values left in any of the columns
------------------------------------------------------------------------------

-- How many rows have negative quantities?
SELECT
  COUNT(*) AS num_rows
FROM purchases_valid_customers
WHERE quantity < 0;
------------------------------------------------------------------------------
-- Result: 18,744 rows have negative quantities
------------------------------------------------------------------------------

-- Do these negative quantities have any connection to invoice_id?
SELECT
  invoice_id,
  quantity
FROM purchases_valid_customers
WHERE quantity < 0;
------------------------------------------------------------------------------
-- Result: It appears that these negative quantities are associated with an invoice_id beginning with "C".
-- -- These are cancellation invoices, so they will likely be filtered out.
------------------------------------------------------------------------------

-- How many negative quantity rows have an invoice_id beginning with "C"? (e.g., C492833)
SELECT
  COUNT(*) AS num_rows
FROM purchases_valid_customers
WHERE invoice_id LIKE 'C%'
AND quantity < 0;
------------------------------------------------------------------------------
-- Result: It is confirmed that 18,744 negative quantity rows have an invoice_id beginning with "C"
-- -- Therefore, these rows will be filtered out.
------------------------------------------------------------------------------

-- Filter out any negative quantity row with an invoice_id with a "C" at the beginning
CREATE OR REPLACE VIEW purchases_valid_customers_invoices AS
SELECT *
FROM purchases_valid_customers
WHERE invoice_id NOT LIKE 'C%'
AND quantity >= 0;

-- Check total rows after filter
SELECT COUNT(*) FROM purchases_valid_customers_invoices;
------------------------------------------------------------------------------
-- Result: 805,620 rows (805,620 line-item purchases)
------------------------------------------------------------------------------

-- How many unique orders (post-filter)?
SELECT
  COUNT(DISTINCT invoice_id) AS unique_orders
FROM purchases_valid_customers_invoices;
------------------------------------------------------------------------------
-- Result: 36,975 unique orders
------------------------------------------------------------------------------

-- How many orders per customer (post-filter)?
SELECT
  COUNT(DISTINCT invoice_id) / COUNT(DISTINCT customer_id) AS orders_per_customer
FROM purchases_valid_customers_invoices;
------------------------------------------------------------------------------
-- Result: ~6.29 orders per customer
------------------------------------------------------------------------------

------------------------------------------------------------------------------
-- SELECT * FROM purchases_valid_customers_invoices;
