-- ================================
-- SILVER LAYER DDL (CLEANED DATA)
-- ================================

-- 1. Create Silver Schema
IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'silver')
BEGIN
EXEC('CREATE SCHEMA silver');
END
GO

-- ================================
-- 2. Customer Table
-- ================================
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
DROP TABLE silver.crm_cust_info;
GO

CREATE TABLE silver.crm_cust_info (
cst_id INT PRIMARY KEY,
cst_key NVARCHAR(50),
full_name NVARCHAR(120),
marital_status NVARCHAR(20),
gender NVARCHAR(10),
create_date DATE
);
GO

-- ================================
-- 3. Product Table
-- ================================
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
DROP TABLE silver.crm_prd_info;
GO

CREATE TABLE silver.crm_prd_info (
prd_id INT PRIMARY KEY,
prd_key NVARCHAR(50),
product_name NVARCHAR(100),
product_cost DECIMAL(10,2),
product_line NVARCHAR(50),
start_date DATE,
end_date DATE
);
GO

-- ================================
-- 4. Sales Table
-- ================================
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
DROP TABLE silver.crm_sales_details;
GO

CREATE TABLE silver.crm_sales_details (
order_number NVARCHAR(50),
product_key NVARCHAR(50),
customer_id INT,
order_date DATE,
ship_date DATE,
due_date DATE,
sales_amount DECIMAL(12,2),
quantity INT,
price DECIMAL(10,2)
);
GO

-- ================================
-- 5. Location Table
-- ================================
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
DROP TABLE silver.erp_loc_a101;
GO

CREATE TABLE silver.erp_loc_a101 (
customer_id NVARCHAR(50),
country NVARCHAR(50)
);
GO

-- ================================
-- 6. Customer Extra Info
-- ================================
IF OBJECT_ID('silver.erp_cust_a121', 'U') IS NOT NULL
DROP TABLE silver.erp_cust_a121;
GO

CREATE TABLE silver.erp_cust_a121 (
customer_id NVARCHAR(50),
birth_date DATE,
gender NVARCHAR(10)
);
GO

-- ================================
-- 7. Product Category Table
-- ================================
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
DROP TABLE silver.erp_px_cat_g1v2;
GO

CREATE TABLE silver.erp_px_cat_g1v2 (
product_id NVARCHAR(50),
category NVARCHAR(50),
subcategory NVARCHAR(50),
maintenance_type NVARCHAR(50)
);
GO
