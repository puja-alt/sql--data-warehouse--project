# /*

# Stored Procedure: Load Silver Layer (Bronze -> Silver)

Script Purpose:
This stored procedure transforms and loads data from the 'bronze'
schema into the 'silver' schema.

It performs:

* Data cleaning & standardization
* Type conversions
* Basic transformations
* Truncates silver tables before load
* Tracks execution time
* Error handling using TRY...CATCH

Usage:
EXEC silver.load_silver;
========================

*/

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

```
DECLARE 
    @start_time DATETIME,
    @end_time DATETIME,
    @batch_start_time DATETIME,
    @batch_end_time DATETIME;

BEGIN TRY

    SET @batch_start_time = GETDATE();

    PRINT '===========================================';
    PRINT 'Loading Silver Layer Started';
    PRINT '===========================================';


    ------------------------------------------------------
    -- 1️⃣ Load Customer Info
    ------------------------------------------------------

    SET @start_time = GETDATE();

    PRINT '>> Truncating Table: silver.crm_cust_info';
    TRUNCATE TABLE silver.crm_cust_info;

    PRINT '>> Transforming & Loading: silver.crm_cust_info';
    INSERT INTO silver.crm_cust_info
    SELECT
        cst_id,
        cst_key,
        CONCAT(cst_firstname, ' ', cst_lastname) AS full_name,
        ISNULL(cst_marital_status, 'Unknown'),
        CASE 
            WHEN cst_gndr IN ('M','Male') THEN 'Male'
            WHEN cst_gndr IN ('F','Female') THEN 'Female'
            ELSE 'Unknown'
        END,
        cst_create_date
    FROM bronze.crm_cust_info;

    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' +
          CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


    ------------------------------------------------------
    -- 2️⃣ Load Product Info
    ------------------------------------------------------

    SET @start_time = GETDATE();

    PRINT '>> Truncating Table: silver.crm_prd_info';
    TRUNCATE TABLE silver.crm_prd_info;

    PRINT '>> Transforming & Loading: silver.crm_prd_info';
    INSERT INTO silver.crm_prd_info
    SELECT
        prd_id,
        prd_key,
        prd_nm,
        CAST(prd_cost AS DECIMAL(10,2)),
        prd_line,
        CAST(prd_start_dt AS DATE),
        CAST(prd_end_dt AS DATE)
    FROM bronze.crm_prd_info;

    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' +
          CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


    ------------------------------------------------------
    -- 3️⃣ Load Sales Details
    ------------------------------------------------------

    SET @start_time = GETDATE();

    PRINT '>> Truncating Table: silver.crm_sales_details';
    TRUNCATE TABLE silver.crm_sales_details;

    PRINT '>> Transforming & Loading: silver.crm_sales_details';
    INSERT INTO silver.crm_sales_details
    SELECT
        sls_ord_num,
        sls_prd_key,
        sls_cust_id,

        -- Convert INT (YYYYMMDD) → DATE
        TRY_CONVERT(DATE, CAST(sls_order_dt AS VARCHAR), 112),
        TRY_CONVERT(DATE, CAST(sls_ship_dt AS VARCHAR), 112),
        TRY_CONVERT(DATE, CAST(sls_due_dt AS VARCHAR), 112),

        CAST(sls_sales AS DECIMAL(12,2)),
        sls_quantity,
        CAST(sls_price AS DECIMAL(10,2))
    FROM bronze.crm_sales_details;

    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' +
          CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


    ------------------------------------------------------
    -- 4️⃣ Load ERP Location
    ------------------------------------------------------

    SET @start_time = GETDATE();

    PRINT '>> Truncating Table: silver.erp_loc_a101';
    TRUNCATE TABLE silver.erp_loc_a101;

    INSERT INTO silver.erp_loc_a101
    SELECT
        cid,
        cntry
    FROM bronze.erp_loc_a101;

    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' +
          CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


    ------------------------------------------------------
    -- 5️⃣ Load ERP Customer Extra
    ------------------------------------------------------

    SET @start_time = GETDATE();

    PRINT '>> Truncating Table: silver.erp_cust_a121';
    TRUNCATE TABLE silver.erp_cust_a121;

    INSERT INTO silver.erp_cust_a121
    SELECT
        cid,
        bdate,
        CASE 
            WHEN gen IN ('M','Male') THEN 'Male'
            WHEN gen IN ('F','Female') THEN 'Female'
            ELSE 'Unknown'
        END
    FROM bronze.erp_cust_a121;

    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' +
          CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


    ------------------------------------------------------
    -- 6️⃣ Load Product Category
    ------------------------------------------------------

    SET @start_time = GETDATE();

    PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';
    TRUNCATE TABLE silver.erp_px_cat_g1v2;

    INSERT INTO silver.erp_px_cat_g1v2
    SELECT
        id,
        cat,
        subcat,
        maintenance
    FROM bronze.erp_px_cat_g1v2;

    SET @end_time = GETDATE();
    PRINT '>> Load Duration: ' +
          CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


    ------------------------------------------------------
    -- Batch Completion
    ------------------------------------------------------

    SET @batch_end_time = GETDATE();

    PRINT '===========================================';
    PRINT 'Silver Layer Loading Completed';
    PRINT 'Total Load Duration: ' +
          CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
          + ' seconds';
    PRINT '===========================================';


END TRY

BEGIN CATCH

    PRINT '*******************************************';
    PRINT 'ERROR OCCURRED DURING LOADING SILVER LAYER';
    PRINT 'Error Message: ' + ERROR_MESSAGE();
    PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
    PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
    PRINT '*******************************************';

END CATCH
```

END;
GO
