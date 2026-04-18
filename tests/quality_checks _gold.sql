-- ============================================
-- GOLD LAYER DATA QUALITY CHECKS
-- ============================================

PRINT '===== GOLD LAYER QUALITY CHECK START =====';

---

## -- 1. ROW COUNT CHECK

PRINT 'Row Count Check';

SELECT 'dim_customer' AS table_name, COUNT(*) AS total_rows
FROM gold.dim_customer
UNION ALL
SELECT 'dim_product', COUNT(*) FROM gold.dim_product
UNION ALL
SELECT 'fact_sales', COUNT(*) FROM gold.fact_sales;

---

## -- 2. NULL CHECK (CRITICAL FIELDS)

PRINT 'Null Check';

-- Customer Dimension
SELECT * FROM gold.dim_customer
WHERE customer_id IS NULL OR full_name IS NULL;

-- Product Dimension
SELECT * FROM gold.dim_product
WHERE product_id IS NULL OR product_name IS NULL;

-- Fact Table (Foreign Keys)
SELECT * FROM gold.fact_sales
WHERE customer_key IS NULL OR product_key IS NULL;

---

## -- 3. DUPLICATE CHECK

PRINT 'Duplicate Check';

-- Customer duplicates
SELECT customer_id, COUNT(*)
FROM gold.dim_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Product duplicates
SELECT product_id, COUNT(*)
FROM gold.dim_product
GROUP BY product_id
HAVING COUNT(*) > 1;

-- Order duplicates
SELECT order_number, COUNT(*)
FROM gold.fact_sales
GROUP BY order_number
HAVING COUNT(*) > 1;

---

## -- 4. REFERENTIAL INTEGRITY CHECK

PRINT 'Referential Integrity Check';

-- Invalid customer_key in fact
SELECT fs.*
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customer dc
ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;

-- Invalid product_key in fact
SELECT fs.*
FROM gold.fact_sales fs
LEFT JOIN gold.dim_product dp
ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;

---

## -- 5. BUSINESS RULE CHECKS

PRINT 'Business Rule Validation';

-- Negative or zero sales
SELECT * FROM gold.fact_sales
WHERE sales_amount <= 0;

-- Negative quantity
SELECT * FROM gold.fact_sales
WHERE quantity <= 0;

-- Price mismatch
SELECT * FROM gold.fact_sales
WHERE price <= 0;

---

## -- 6. DATA DISTRIBUTION CHECK

PRINT 'Data Distribution';

-- Sales by product
SELECT TOP 5 product_key, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY product_key
ORDER BY total_sales DESC;

-- Sales by customer
SELECT TOP 5 customer_key, SUM(sales_amount) AS total_sales
FROM gold.fact_sales
GROUP BY customer_key
ORDER BY total_sales DESC;

---

## -- 7. SAMPLE DATA CHECK

PRINT 'Sample Data';

SELECT TOP 5 * FROM gold.dim_customer;
SELECT TOP 5 * FROM gold.dim_product;
SELECT TOP 5 * FROM gold.fact_sales;

PRINT '===== GOLD LAYER QUALITY CHECK COMPLETE =====';
