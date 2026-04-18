-- ============================================
-- TEST: SILVER LAYER VALIDATION
-- ============================================

PRINT '===== START TESTING SILVER LAYER =====';

---

## -- 1. Execute Load

EXEC silver.load_silver;

---

## -- 2. Row Count Check

PRINT 'Row Count Validation';

SELECT 'Customers' AS table_name,
(SELECT COUNT(*) FROM bronze.crm_cust_info) AS bronze,
(SELECT COUNT(*) FROM silver.crm_cust_info) AS silver;

SELECT 'Products' AS table_name,
(SELECT COUNT(*) FROM bronze.crm_prd_info),
(SELECT COUNT(*) FROM silver.crm_prd_info);

SELECT 'Sales' AS table_name,
(SELECT COUNT(*) FROM bronze.crm_sales_details),
(SELECT COUNT(*) FROM silver.crm_sales_details);

---

## -- 3. NULL Check

PRINT 'Null Check';

SELECT * FROM silver.crm_cust_info
WHERE cst_id IS NULL OR full_name IS NULL;

SELECT * FROM silver.crm_sales_details
WHERE order_date IS NULL;

---

## -- 4. Duplicate Check

PRINT 'Duplicate Check';

SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

---

## -- 5. Data Quality Check

PRINT 'Data Quality Check';

SELECT * FROM silver.crm_sales_details
WHERE sales_amount <= 0 OR price <= 0;

---

## -- 6. Sample Output

PRINT 'Sample Data';

SELECT TOP 5 * FROM silver.crm_cust_info;
SELECT TOP 5 * FROM silver.crm_prd_info;
SELECT TOP 5 * FROM silver.crm_sales_details;

PRINT '===== TESTING COMPLETED =====';
