
 -- STORED PROCEDURE FACT LOAD

CREATE PROCEDURE meta.sp_load_fact_sales
AS
BEGIN

    TRUNCATE TABLE dwh.fact_sales;

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

END;

-- STORED PROCEDUR DIM CUST

CREATE PROCEDURE meta.sp_load_dim_customer
AS
BEGIN

    TRUNCATE TABLE dwh.dim_customer;

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

END;


