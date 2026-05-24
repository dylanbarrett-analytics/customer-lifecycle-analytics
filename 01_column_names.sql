-- Inspect structure of transactions table
SELECT * FROM purchases LIMIT 10;

-- Standardize column names
CREATE OR REPLACE VIEW purchases_standardized AS
SELECT
  Invoice AS invoice_id,
  StockCode AS stock_code,
  Description AS product_name,
  Quantity AS quantity,
  InvoiceDate AS invoice_date,
  Price AS unit_price,
  `Customer ID` AS customer_id,
  Country AS country
FROM purchases;