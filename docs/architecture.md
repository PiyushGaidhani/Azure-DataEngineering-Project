# Architecture

## Overview

This project implements an Azure medallion architecture using Azure Data Factory for ingestion, ADLS Gen2 for storage, Azure Databricks for transformation, Azure Synapse Analytics for serverless lake querying, a Synapse dedicated SQL Pool for warehousing, and Power BI for reporting.

The platform is organized into two connected analytical layers:

- Lakehouse layer
  Bronze: raw landed data
  Silver: cleaned and transformed data
  Gold: curated analytical data stored in Parquet
- Warehouse layer
  Dedicated SQL Pool schemas and star-schema tables built on top of the gold layer for reporting and BI consumption

## End-to-End Flow

### 1. Source

Source files are stored in GitHub and are referenced dynamically by Azure Data Factory.

### 2. Ingestion

Azure Data Factory uses `ADF/Pipelines/DynamicGitToRaw.json` together with `ADF/Parameters/git.json` to ingest files from GitHub into ADLS Gen2 bronze storage.

### 3. Bronze Layer

The `bronze` container stores the raw files exactly as ingested. This is the landing and traceability layer.

### 4. Transformation

Azure Databricks runs `Databricks/silver_layer.ipynb` to process bronze data and generate transformed outputs for downstream analytics.

### 5. Silver and Gold Layers

The `silver` container stores refined intermediate datasets.
The `gold` container stores curated analytical datasets, typically in Parquet format.

### 6. Synapse Serverless Layer

Azure Synapse serverless SQL uses the gold-layer Parquet files to create lake-facing views and external tables.

In this repository, that layer is represented by:

- `Synapse/Scripts/Create Schema.sql`
- `Synapse/Scripts/Create Views Gold.sql`
- `Synapse/Scripts/Create External Table.sql`

This layer provides the first SQL-serving surface over the curated gold data.

### 7. Dedicated SQL Pool Warehouse Layer

On top of the Synapse gold layer, the project builds a dedicated SQL Pool warehouse.

This warehouse introduces:

- `dwh`, `rpt`, and `meta` schemas
- a `dwh_ext*` CETAS ingestion layer
- schema-aligned external tables for dedicated SQL Pool
- a star schema with dimensions and fact table
- stored procedures for repeatable loads
- a Synapse pipeline for orchestration

In this repository, the warehouse layer is represented by:

- `Synapse/Scripts/Create Schemas dwh.sql`
- `Synapse/Scripts/Create External Table dwh.sql`
- `Synapse/Scripts/Create External Tables Dedicated.sql`
- `Synapse/Scripts/Create Dimensional Model.sql`
- `Synapse/Scripts/Create Stored Procedure FACT LOAD.sql`
- `Synapse/Scripts/Reporting views.sql`
- `Synapse/Pipelines/pl_load_sales_dwh.json`

### 8. BI Consumption

Power BI connects to the Synapse dedicated SQL Pool using DirectQuery and reads from the reporting layer for dashboarding and analytics.

In this repository, the BI asset is:

- `PowerBI/Sales Analytics Dashboard.pbix`

## Pipeline Narrative

1. GitHub stores the source files.
2. Azure Data Factory ingests those files dynamically into the ADLS Gen2 bronze layer.
3. Azure Databricks reads bronze data and writes transformed outputs into the silver and gold layers.
4. Synapse serverless SQL exposes the gold layer through external tables and views.
5. A `dwh_ext*` CETAS ingestion layer is created from the curated gold data.
6. Dedicated SQL Pool external tables are created with schema alignment to fix data type and column order issues.
7. A star schema is built with dimensions and a fact table inside the `dwh` schema.
8. Stored procedures and a Synapse pipeline orchestrate repeatable warehouse loads.
9. A reporting view in the `rpt` schema exposes the analytical model for BI consumption.
10. Power BI connects through DirectQuery to the Synapse dedicated SQL Pool.

## Diagram Guide

Use these components in draw.io or Excalidraw.

### Boxes

- `GitHub`
  Label: `Source Data Files`

- `Azure Data Factory`
  Label: `DynamicGitToRaw Pipeline`

- `ADLS Gen2 - Bronze`
  Label: `Raw Files`

- `Azure Databricks`
  Label: `silver_layer.ipynb`

- `ADLS Gen2 - Silver`
  Label: `Transformed Data`

- `ADLS Gen2 - Gold`
  Label: `Curated Data`

- `Azure Synapse Serverless SQL`
  Label: `Gold Views and External Tables`

- `Synapse Dedicated SQL Pool`
  Label: `dwh_ext* / Star Schema / Stored Procedures`

- `Synapse Pipeline`
  Label: `Warehouse Load Orchestration`

- `Power BI`
  Label: `DirectQuery Reporting`

### Arrows

- `GitHub` -> `Azure Data Factory`
  Label: `Dynamic ingestion`

- `Azure Data Factory` -> `ADLS Gen2 - Bronze`
  Label: `Raw file landing`

- `ADLS Gen2 - Bronze` -> `Azure Databricks`
  Label: `Read bronze data`

- `Azure Databricks` -> `ADLS Gen2 - Silver`
  Label: `Write transformed data`

- `Azure Databricks` -> `ADLS Gen2 - Gold`
  Label: `Write curated data`

- `ADLS Gen2 - Silver` -> `Azure Synapse Serverless SQL`
  Label: `External Parquet access`

- `ADLS Gen2 - Gold` -> `Azure Synapse Serverless SQL`
  Label: `External Parquet access`

- `Azure Synapse Serverless SQL` -> `Synapse Dedicated SQL Pool`
  Label: `CETAS and external ingestion layer`

- `Synapse Pipeline` -> `Synapse Dedicated SQL Pool`
  Label: `Stored procedure execution`

- `Synapse Dedicated SQL Pool` -> `Power BI`
  Label: `DirectQuery reporting`

## Reuse Notes

To recreate this architecture in another Azure subscription:

- provision Azure Data Factory, Databricks, Synapse, and ADLS Gen2
- create the `bronze`, `silver`, `gold`, and `parameters` containers
- configure ADF ingestion from GitHub
- import and run the Databricks notebook
- create the Synapse serverless views and external tables
- build the dedicated SQL Pool warehouse objects
- run the Synapse pipeline or stored procedures for warehouse loads
- validate the reporting layer and connect Power BI through DirectQuery

## Security Note

If credentials are hard-coded in notebooks, pipeline definitions, or SQL objects, keep the logic unchanged and move secrets to:

- Azure Key Vault
- Databricks secret scopes
- Managed Identity where supported
