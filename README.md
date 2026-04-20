# Azure Medallion Architecture on Azure

An end-to-end Azure data engineering project that implements the medallion architecture using Azure Data Factory, ADLS Gen2, Azure Databricks, Azure Synapse Analytics, and Power BI.

## Project Summary

This solution ingests source files from GitHub into Azure Data Lake Storage Gen2, transforms them through bronze, silver, and gold layers, and extends the gold layer into a Synapse dedicated SQL Pool warehouse for dimensional modeling and BI reporting.

### End-to-End Data Flow

1. Azure Data Factory ingests data dynamically from GitHub into the ADLS Gen2 `bronze` container.
2. Azure Databricks transforms bronze data into `silver` and `gold` Parquet datasets.
3. Synapse serverless SQL exposes the gold layer through external tables and views.
4. A dedicated SQL Pool warehouse is built on top of Synapse using a `dwh_ext*` ingestion layer created with CETAS.
5. A star schema is loaded into the dedicated pool with dimensions, fact tables, stored procedures, and a Synapse pipeline.
6. A reporting view is exposed for analytics and connected to Power BI using DirectQuery.

## Project Outcomes

- Dynamic GitHub-to-bronze ingestion with Azure Data Factory
- Medallion-style transformation flow across bronze, silver, and gold layers
- Synapse serverless external tables and views over gold Parquet data
- Dedicated SQL Pool warehouse built on top of Synapse
- `dwh_ext*` CETAS ingestion layer for warehouse loading
- Schema-aligned external tables in dedicated SQL Pool
- Star schema with fact and dimension tables
- Stored procedures and Synapse pipeline orchestration for warehouse loads
- Reporting view consumed in Power BI via DirectQuery

## Tech Stack

- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks
- Azure Synapse Analytics
- Synapse Dedicated SQL Pool
- Power BI DirectQuery
- GitHub
- Parquet

## Repository Structure

- `Data/`: source files used by ingestion. Kept unchanged.
- `ADF/`: Azure Data Factory pipeline and parameter artifacts
- `Databricks/`: Databricks notebook(s) used for transformations
- `Synapse/`: Synapse SQL scripts, Synapse pipeline JSON, and Synapse screenshots
- `PowerBI/`: Power BI report and screenshots
- `docs/`: architecture documentation and diagram notes
- `infra/`: infrastructure and setup notes

Useful starting points:

- [Architecture walkthrough](docs/architecture.md)
- [Run order](docs/run-order.md)
- [Diagram source](docs/diagrams/architecture-diagram.md)
- `ADF/images/`, `Synapse/Images/`, and `PowerBI/Images/` for visuals

## Key Files

### Ingestion and Lakehouse

- `ADF/Pipelines/DynamicGitToRaw.json`
- `ADF/Parameters/git.json`
- `Databricks/silver_layer.ipynb`
- `Synapse/Scripts/Create Schema.sql`
- `Synapse/Scripts/Create Views Gold.sql`
- `Synapse/Scripts/Create External Table.sql`

### Synapse Warehouse

- `Synapse/Scripts/Create Schemas dwh.sql`
- `Synapse/Scripts/Create External Table dwh.sql`
- `Synapse/Scripts/Create External Tables Dedicated.sql`
- `Synapse/Scripts/Create Dimensional Model.sql`
- `Synapse/Scripts/Create Stored Procedure FACT LOAD.sql`
- `Synapse/Scripts/Reporting views.sql`
- `Synapse/Pipelines/pl_load_sales_dwh.json`

### BI Layer

- `PowerBI/Sales Analytics Dashboard.pbix`

## Prerequisites

To recreate this project, you need:

- An Azure subscription
- A resource group
- An ADLS Gen2 storage account
- ADLS containers:
  - `bronze`
  - `silver`
  - `gold`
  - `parameters`
- Azure Data Factory
- Azure Databricks
- Azure Synapse Analytics
- A Synapse dedicated SQL Pool
- Power BI Desktop
- A GitHub repository containing the source files

## Deployment Steps

### 1. Provision Azure Resources

1. Create a resource group.
2. Create an ADLS Gen2 storage account.
3. Create the `bronze`, `silver`, `gold`, and `parameters` containers.
4. Create Azure Data Factory, Databricks, and Synapse in the same resource group.
5. Create a dedicated SQL Pool in Synapse for warehouse objects.
6. Grant the required storage and SQL permissions.

### 2. Configure Ingestion in Azure Data Factory

1. Open Azure Data Factory.
2. Use `ADF/Pipelines/DynamicGitToRaw.json` as the main ingestion pipeline reference.
3. Use `ADF/Parameters/git.json` as the input configuration reference.
4. Configure linked services for GitHub or HTTP access and ADLS Gen2.
5. Publish and run the pipeline.
6. Confirm that raw files are copied into the `bronze` container.

### 3. Run Transformations in Databricks

1. Import `Databricks/silver_layer.ipynb` into Azure Databricks.
2. Attach it to a cluster.
3. Run the notebook.
4. Verify that transformed Parquet outputs are written to the `silver` and `gold` containers.

### 4. Create Synapse Serverless Objects

Run the lake-facing Synapse scripts in this order:

1. `Synapse/Scripts/Create Schema.sql`
2. `Synapse/Scripts/Create Views Gold.sql`
3. `Synapse/Scripts/Create External Table.sql`

This creates the base schema, serverless views, and serverless external tables over the gold layer.

### 5. Build the Dedicated SQL Pool Warehouse

Run the dedicated pool scripts in this order:

1. `Synapse/Scripts/Create Schemas dwh.sql`
2. `Synapse/Scripts/Create External Table dwh.sql`
3. `Synapse/Scripts/Create External Tables Dedicated.sql`
4. `Synapse/Scripts/Create Dimensional Model.sql`
5. `Synapse/Scripts/Create Stored Procedure FACT LOAD.sql`
6. `Synapse/Scripts/Reporting views.sql`

This stage:

- creates `dwh`, `rpt`, and `meta` schemas
- builds the `dwh_ext*` CETAS ingestion layer
- creates schema-aligned external tables in the dedicated pool
- builds the star schema with dimensions and fact table
- creates stored procedures for warehouse loading
- creates the reporting view used for analytics

### 6. Orchestrate Warehouse Loads in Synapse Pipelines

Use `Synapse/Pipelines/pl_load_sales_dwh.json` to orchestrate stored procedure execution for warehouse loads in the dedicated SQL Pool.

### 7. Connect Power BI

1. Open `PowerBI/Sales Analytics Dashboard.pbix`.
2. Connect Power BI to the Synapse dedicated SQL Pool using DirectQuery.
3. Validate that the report is reading from the reporting layer, not directly from raw lake storage.

## Verification

Example validation queries:

### Serverless Gold Layer

```sql
SELECT TOP 10 * FROM gold.sales;
SELECT TOP 10 * FROM gold.products;
SELECT COUNT(*) AS total_sales_rows FROM gold.extsales;
SELECT COUNT(*) AS total_customer_rows FROM gold.extcustomers;
```

### Dedicated SQL Pool Warehouse

```sql
SELECT TOP 10 * FROM dwh.dim_customer;
SELECT TOP 10 * FROM dwh.fact_sales;
SELECT COUNT(*) AS fact_sales_rows FROM dwh.fact_sales;
SELECT TOP 10 * FROM rpt.vw_sales_analysis;
```

These checks confirm that:

- ADF ingested source files into bronze
- Databricks produced transformed outputs in silver and gold
- Synapse serverless can query the lake
- the dedicated SQL Pool warehouse loaded successfully
- the reporting view is ready for Power BI consumption

## Screenshots and Assets

- ADF pipeline screenshot: `ADF/images/`
- Synapse warehouse and pipeline screenshots: `Synapse/Images/`
- Power BI dashboard screenshot: `PowerBI/Images/`
- Power BI report file: `PowerBI/Sales Analytics Dashboard.pbix`

## Security Notes

Before publishing this repository publicly, review all ADF, Databricks, Synapse, and Power BI assets for exposed:

- client secrets
- storage keys
- SAS tokens
- connection strings
- service principal credentials

Recommended secure alternatives:

- Azure Key Vault
- Databricks secret scopes
- Managed Identity
- Parameterized linked services

The Databricks notebook secret value in `Databricks/silver_layer.ipynb` has been masked in this repo. The recommended production approach is to retrieve credentials from Databricks secret scopes or Azure Key Vault instead of storing them directly in notebook code.

## Reproducibility

This project can be recreated in another Azure subscription by provisioning the same Azure services, creating the same lake containers, configuring ADF ingestion, running the Databricks notebook, building the dedicated SQL Pool warehouse, executing the Synapse pipeline and SQL scripts in order, and connecting Power BI through DirectQuery.
