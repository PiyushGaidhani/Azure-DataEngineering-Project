CREATE DATABASE SCOPED CREDENTIAL cred_piyush
WITH
    IDENTITY = 'Managed Identity'

CREATE EXTERNAL DATA SOURCE source_silver
WITH
(
    LOCATION = 'https://awstoragedatalakepg.dfs.core.windows.net/silver',
    CREDENTIAL = cred_piyush
)



CREATE EXTERNAL DATA SOURCE source_gold
WITH
(
    LOCATION = 'https://awstoragedatalakepg.dfs.core.windows.net/gold',
    CREDENTIAL = cred_piyush
)

CREATE EXTERNAL FILE FORMAT format_parquet
WITH
(
    FORMAT_TYPE = PARQUET,
    DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
)


-- CREATE EXTERNAL TABLE  EXTERNAL SALES 

CREATE EXTERNAL TABLE gold.extsales
WITH 
(
    LOCATION = 'extsales',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.sales


SELECT * from gold.extsales;

-- CREATE EXTERNAL TABLE  EXTERNAL CALENDaR

CREATE EXTERNAL TABLE gold.extcalendar
WITH 
(
    LOCATION = 'extcalendar',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.calendar

-- CREATE EXTERNAL TABLE  EXTERNAL CUSTOMERS

CREATE EXTERNAL TABLE gold.extcustomers
WITH 
(
    LOCATION = 'extcustomers',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.customers

-- CREATE EXTERNAL TABLE  EXTERNAL PRODUCTS

CREATE EXTERNAL TABLE gold.extproducts
WITH 
(
    LOCATION = 'extproducts',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.products

-- CREATE EXTERNAL TABLE  EXTERNAL RETURNS

CREATE EXTERNAL TABLE gold.extreturns
WITH 
(
    LOCATION = 'extreturns',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.returns

-- CREATE EXTERNAL TABLE  EXTERNAL SUBCATEGORY

CREATE EXTERNAL TABLE gold.extsubcategory
WITH 
(
    LOCATION = 'extsubcategory',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.subcategory

-- CREATE EXTERNAL TABLE  EXTERNAL TERRITORIES

CREATE EXTERNAL TABLE gold.extterritories
WITH 
(
    LOCATION = 'extterritories',
    DATA_SOURCE = source_gold,
    file_format = format_parquet


) AS 
SELECT * FROM gold.territories






