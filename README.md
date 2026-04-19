# Azure Medallion Architecture on Azure

An end-to-end Azure data engineering project that implements the medallion architecture using Azure Data Factory, ADLS Gen2, Azure Databricks, and Azure Synapse Analytics.

## Project Summary

This solution ingests source files from GitHub into Azure Data Lake Storage Gen2, transforms them through bronze, silver, and gold layers, and exposes curated data through Synapse external tables and views.

### Data Flow

1. Azure Data Factory ingests data dynamically from GitHub.
2. Raw files are landed in the ADLS Gen2 `bronze` container.
3. Azure Databricks transforms bronze data into `silver` and `gold` Parquet datasets.
4. Azure Synapse reads the lake data and exposes it through external tables and SQL views.

## Project Outcomes

- Dynamic ingestion from GitHub into ADLS Gen2 bronze storage
- Medallion-style transformation flow across bronze, silver, and gold layers
- Databricks-based lake transformations stored as Parquet
- Synapse external tables and views over curated analytical data
- Reusable documentation for recreating the solution in another Azure subscription

## Tech Stack

- Azure Data Factory
- Azure Data Lake Storage Gen2
- Azure Databricks
- Azure Synapse Analytics
- GitHub
- Parquet

## Repository Structure

- `Data/`: source files used by ingestion. Kept unchanged.
- `ADF/`: Azure Data Factory pipeline and parameter artifacts
- `Databricks/`: Databricks notebook(s) used for transformations
- `Synapse/`: Synapse SQL scripts for schema, views, and external tables
- `docs/`: architecture documentation and diagram notes
- `infra/`: infrastructure and setup notes

Useful starting points:

- [Architecture walkthrough](docs/architecture.md)
- [Run order](docs/run-order.md)
- [Diagram source](docs/diagrams/architecture-diagram.md)
- `docs/screenshots/` for pipeline and result snapshots

## Key Files

- `ADF/Pipelines/DynamicGitToRaw.json`
- `ADF/Parameters/git.json`
- `Databricks/silver_layer.ipynb`
- `Synapse/Scripts/Create Schema.sql`
- `Synapse/Scripts/Create Views Gold.sql`
- `Synapse/Scripts/Create External Table.sql`

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
- A GitHub repository containing the source files

## Deployment Steps

### 1. Provision Azure Resources

1. Create a resource group.
2. Create an ADLS Gen2 storage account.
3. Create the `bronze`, `silver`, `gold`, and `parameters` containers.
4. Create Azure Data Factory, Databricks, and Synapse in the same resource group.
5. Grant the required storage permissions.

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

### 4. Create Synapse Objects

Run the SQL scripts in this order:

1. `Synapse/Scripts/Create Schema.sql`
2. `Synapse/Scripts/Create Views Gold.sql`
3. `Synapse/Scripts/Create External Table.sql`

This creates the schema, SQL views, and external tables used to query the final analytical layer.

## Verification

Example validation queries:

```sql
SELECT TOP 10 * FROM gold.sales;
SELECT TOP 10 * FROM gold.products;
SELECT COUNT(*) AS total_sales_rows FROM gold.extsales;
SELECT COUNT(*) AS total_customer_rows FROM gold.extcustomers;
```

## Security Notes

Before publishing this repository publicly, review all ADF, Databricks, and Synapse assets for exposed:

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

## Screenshots

Recommended screenshots to include in `docs/screenshots/`:

- ADF pipeline canvas and successful pipeline run
- Databricks notebook or workflow execution
- ADLS Gen2 bronze, silver, and gold container layout
- Synapse query results against the gold layer

## Reproducibility

This project can be recreated in another Azure subscription by provisioning the same Azure services, creating the same lake containers, configuring ADF ingestion, running the Databricks notebook, and executing the Synapse SQL scripts in the documented order.
