/*
==================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
==================================================================

Script Purpose:
This stored procedure loads data into the 'bronze' schema
from external CSV files.

It performs the following actions:
- Truncates bronze tables before loading data.
- Uses BULK INSERT command to load CSV files.
- Tracks execution time.
- Handles errors using TRY...CATCH.

Parameters:
None.

Usage Example:
EXEC bronze.load_bronze;

==================================================================
*/

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN

    DECLARE 
        @start_time DATETIME,
        @end_time DATETIME,
        @batch_start_time DATETIME,
        @batch_end_time DATETIME;

    BEGIN TRY

        SET @batch_start_time = GETDATE();

        PRINT '===========================================';
        PRINT 'Loading Bronze Layer Started';
        PRINT '===========================================';


        ------------------------------------------------------
        -- 1️⃣ Load ERP Location
        ------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_loc_a101';
        TRUNCATE TABLE bronze.erp_loc_a101;

        PRINT '>> Inserting Data Into: bronze.erp_loc_a101';
        BULK INSERT bronze.erp_loc_a101
        FROM 'C:\sql\dwh_project\datasets\source_erp\loc_a101.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ------------------------------------------------------
        -- 2️⃣ Load ERP Customer
        ------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_cust_a121';
        TRUNCATE TABLE bronze.erp_cust_a121;

        PRINT '>> Inserting Data Into: bronze.erp_cust_a121';
        BULK INSERT bronze.erp_cust_a121
        FROM 'C:\sql\dwh_project\datasets\source_erp\cust_a121.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ------------------------------------------------------
        -- 3️⃣ Load ERP Product Category
        ------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
        TRUNCATE TABLE bronze.erp_px_cat_g1v2;

        PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
        BULK INSERT bronze.erp_px_cat_g1v2
        FROM 'C:\sql\dwh_project\datasets\source_erp\px_cat_g1v2.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ------------------------------------------------------
        -- 4️⃣ Load CRM Product Info
        ------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_prd_info';
        TRUNCATE TABLE bronze.crm_prd_info;

        PRINT '>> Inserting Data Into: bronze.crm_prd_info';
        BULK INSERT bronze.crm_prd_info
        FROM 'C:\sql\dwh_project\datasets\source_crm\prd_info.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ------------------------------------------------------
        -- 5️⃣ Load CRM Sales Details
        ------------------------------------------------------

        SET @start_time = GETDATE();

        PRINT '>> Truncating Table: bronze.crm_sales_details';
        TRUNCATE TABLE bronze.crm_sales_details;

        PRINT '>> Inserting Data Into: bronze.crm_sales_details';
        BULK INSERT bronze.crm_sales_details
        FROM 'C:\sql\dwh_project\datasets\source_crm\sales_details.csv'
        WITH (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '\n',
            TABLOCK
        );

        SET @end_time = GETDATE();
        PRINT '>> Load Duration: ' +
              CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';


        ------------------------------------------------------
        -- Batch Completion
        ------------------------------------------------------

        SET @batch_end_time = GETDATE();

        PRINT '===========================================';
        PRINT 'Bronze Layer Loading Completed';
        PRINT 'Total Load Duration: ' +
              CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR)
              + ' seconds';
        PRINT '===========================================';


    END TRY

    BEGIN CATCH

        PRINT '*******************************************';
        PRINT 'ERROR OCCURRED DURING LOADING BRONZE LAYER';
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Number: ' + CAST(ERROR_NUMBER() AS NVARCHAR);
        PRINT 'Error State: ' + CAST(ERROR_STATE() AS NVARCHAR);
        PRINT '*******************************************';

    END CATCH

END;
