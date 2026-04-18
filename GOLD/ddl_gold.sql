-- ============================================
-- GOLD LAYER DDL (STAR SCHEMA)
-- ============================================

---

## -- 1. CREATE GOLD SCHEMA

IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = 'gold')
BEGIN
EXEC('CREATE SCHEMA gold');
END
GO

---

## -- 2. DIM CUSTOMER

IF OBJECT_ID('gold.dim_customer', 'U') IS NOT NULL
DROP TABLE gold.dim_customer;
GO

CREATE TABLE gold.dim_customer (
customer_key INT IDENTITY(1,1) PRIMARY KEY,
customer_id INT NOT NULL,
customer_code NVARCHAR(50),
full_name NVARCHAR(120),
gender NVARCHAR(10),
marital_status NVARCHAR(20),
country NVARCHAR(50),
birth_date DATE
);
GO

---

## -- 3. DIM PRODUCT

IF OBJECT_ID('gold.dim_product', 'U') IS NOT NULL
DROP TABLE gold.dim_product;
GO

CREATE TABLE gold.dim_product (
product_key INT IDENTITY(1,1) PRIMARY KEY,
product_id INT NOT NULL,
product_code NVARCHAR(50),
product_name NVARCHAR(100),
category NVARCHAR(50),
subcategory NVARCHAR(50),
product_line NVARCHAR(50),
cost DECIMAL(10,2)
);
GO

---

## -- 4. FACT SALES

IF OBJECT_ID('gold.fact_sales', 'U') IS NOT NULL
DROP TABLE gold.fact_sales;
GO

CREATE TABLE gold.fact_sales (
sales_key INT IDENTITY(1,1) PRIMARY KEY,
order_number NVARCHAR(50),

```
customer_key INT,
product_key INT,

order_date DATE,
ship_date DATE,
due_date DATE,

sales_amount DECIMAL(12,2),
quantity INT,
price DECIMAL(10,2),

-- Foreign Key Constraints (Optional but Recommended)
CONSTRAINT fk_customer FOREIGN KEY (customer_key)
    REFERENCES gold.dim_customer(customer_key),

CONSTRAINT fk_product FOREIGN KEY (product_key)
    REFERENCES gold.dim_product(product_key)
```

);
GO
