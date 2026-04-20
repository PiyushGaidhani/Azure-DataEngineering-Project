-- Customer Dimension
CREATE TABLE dwh.dim_customer
(
    customer_sk INT IDENTITY(1,1),
    customer_id INT,
    customer_name VARCHAR(255),
    gender VARCHAR(10),
    email VARCHAR(255),
    start_date DATETIME,
    end_date DATETIME,
    is_current BIT
)
WITH
(
    DISTRIBUTION = HASH(customer_id),
    CLUSTERED COLUMNSTORE INDEX
);

-- Initial load 
INSERT INTO dwh.dim_customer
(
    customer_id,
    customer_name,
    gender,
    email,
    start_date,
    end_date,
    is_current
)
SELECT 
    CustomerKey,
    fullName,
    Gender,
    EmailAddress,
    GETDATE(),
    NULL,
    1
FROM dwh.extcustomers;

select count(*) from dwh.dim_customer

-- DIM PRODUCT
CREATE TABLE dwh.dim_product
(
    product_key INT,
    product_name VARCHAR(255),
    subcategory_key INT,
    price FLOAT,
    cost FLOAT
)
WITH
(
    DISTRIBUTION = HASH(product_key),
    CLUSTERED COLUMNSTORE INDEX
);

-- INITIAL LOAD
INSERT INTO dwh.dim_product
SELECT DISTINCT
    ProductKey,
    ProductName,
    ProductSubcategoryKey,
    ProductPrice,
    ProductCost
FROM dwh.extproducts;

-- DIM DATE 
CREATE TABLE dwh.dim_date
(
    date_key DATE,
    month INT,
    year INT
)
WITH
(
    DISTRIBUTION = ROUND_ROBIN
);

-- INITIAL LOAD
INSERT INTO dwh.dim_date
SELECT DISTINCT
    [Date],
    [Month],
    [Year]
FROM dwh.extcalendar;

-- DIM TERRITORY
CREATE TABLE dwh.dim_territory
(
    territory_key INT,
    region VARCHAR(255),
    country VARCHAR(255),
    continent VARCHAR(255)
)
WITH
(
    DISTRIBUTION = HASH(territory_key)
);

-- LOAD
INSERT INTO dwh.dim_territory
SELECT DISTINCT
    SalesTerritoryKey,
    Region,
    Country,
    Continent
FROM dwh.extterritories;

-- FACT SALES

CREATE TABLE dwh.fact_sales
(
    product_key INT,
    customer_sk INT,
    territory_key INT,
    order_date DATE,
    quantity INT
)
WITH
(
    DISTRIBUTION = HASH(customer_sk),   -- FIXED
    CLUSTERED COLUMNSTORE INDEX
);

-- LOAD
INSERT INTO dwh.fact_sales
SELECT 
    s.ProductKey,
    c.customer_sk,
    s.TerritoryKey,
    s.OrderDate,
    s.OrderQuantity
FROM dwh.extsales s
JOIN dwh.dim_customer c
    ON s.CustomerKey = c.customer_id
    AND c.is_current = 1;


select * from dwh.fact_sales








ALTER TABLE dwh.dim_customer
ADD CONSTRAINT pk_dim_customer PRIMARY KEY NONCLUSTERED (customer_sk) NOT ENFORCED;
