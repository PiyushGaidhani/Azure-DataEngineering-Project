-- credentials 
CREATE DATABASE SCOPED CREDENTIAL cred_piyush
WITH IDENTITY = 'Managed Identity';

-- Data Source
CREATE EXTERNAL DATA SOURCE source_gold
WITH
(
    LOCATION = 'abfss://gold@awstoragedatalakepg.dfs.core.windows.net/',
    CREDENTIAL = cred_piyush
);


-- CREATE EXTERNAL TABLES

-- CUSTOMERS

CREATE EXTERNAL TABLE dwh.extcustomers
(
    CustomerKey INT,
    Prefix VARCHAR(8000),
    FirstName VARCHAR(8000),
    LastName VARCHAR(8000),
    BirthDate DATE,
    MaritalStatus VARCHAR(8000),
    Gender VARCHAR(8000),
    EmailAddress VARCHAR(8000),
    AnnualIncome VARCHAR(8000),  -- IMPORTANT FIX
    TotalChildren INT,
    EducationLevel VARCHAR(8000),
    Occupation VARCHAR(8000),
    HomeOwner VARCHAR(8000),
    fullName VARCHAR(8000)
)
WITH
(
    LOCATION = 'dwh_extcustomers',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);
SELECT TOP 10 * FROM dwh.extcustomers;

-- CALENDAR

CREATE EXTERNAL TABLE dwh.extcalendar
(
    [Date] DATE,
    [Month] INT,
    [Year] INT
)
WITH
(
    LOCATION = 'dwh_extcalendar',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);

-- PRODUCTS

CREATE EXTERNAL TABLE dwh.extproducts
(
    ProductKey INT,
    ProductSubcategoryKey INT,
    ProductSKU VARCHAR(8000),
    ProductName VARCHAR(8000),
    ModelName VARCHAR(8000),
    ProductDescription VARCHAR(8000),
    ProductColor VARCHAR(8000),
    ProductSize VARCHAR(8000),
    ProductStyle VARCHAR(8000),
    ProductCost FLOAT,
    ProductPrice FLOAT
)
WITH
(
    LOCATION = 'dwh_extproducts',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);

-- RETURNS

CREATE EXTERNAL TABLE dwh.extreturns
(
    ReturnDate DATE,
    TerritoryKey INT,
    ProductKey INT,
    ReturnQuantity INT
)
WITH
(
    LOCATION = 'dwh_extreturns',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);

-- SALES

CREATE EXTERNAL TABLE dwh.extsales
(
    OrderDate DATE,
    StockDate DATETIME2,
    OrderNumber VARCHAR(8000),
    ProductKey INT,
    CustomerKey INT,
    TerritoryKey INT,
    OrderLineItem INT,
    OrderQuantity INT,
    multiply INT
)
WITH
(
    LOCATION = 'dwh_extsales',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);

--SUBCATEGORY

CREATE EXTERNAL TABLE dwh.extsubcategory
(
    ProductSubcategoryKey INT,
    SubcategoryName VARCHAR(8000),
    ProductCategoryKey INT
)
WITH
(
    LOCATION = 'dwh_extsubcategory',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);

-- TERRITORIES

CREATE EXTERNAL TABLE dwh.extterritories
(
    SalesTerritoryKey INT,
    Region VARCHAR(8000),
    Country VARCHAR(8000),
    Continent VARCHAR(8000)
)
WITH
(
    LOCATION = 'dwh_extterritories',
    DATA_SOURCE = source_gold,
    FILE_FORMAT = format_parquet
);




