# Architecture

## Overview

This project implements the medallion architecture on Azure using Azure Data Factory for ingestion, ADLS Gen2 for storage, Azure Databricks for transformation, and Azure Synapse Analytics for SQL-based consumption.

The lake is organized into three layers:

- Bronze: raw landed data
- Silver: cleaned and transformed data
- Gold: curated analytical data

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

### 6. Consumption

Azure Synapse uses the SQL scripts in `Synapse/Scripts/` to create the schema, views, and external tables required to query the final lake data.

## Pipeline Narrative

1. GitHub stores the source files.
2. Azure Data Factory ingests those files dynamically.
3. Files are copied into ADLS Gen2 bronze storage.
4. Azure Databricks transforms the bronze data.
5. Refined outputs are written to silver and gold.
6. Azure Synapse exposes the final datasets through external tables and views.
7. Users query the gold layer through SQL.

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

- `Azure Synapse`
  Label: `Schema, Views, External Tables`

- `SQL Consumers`
  Label: `Analytics / Reporting`

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

- `ADLS Gen2 - Silver` -> `Azure Synapse`
  Label: `External Parquet access`

- `ADLS Gen2 - Gold` -> `Azure Synapse`
  Label: `External Parquet access`

- `Azure Synapse` -> `SQL Consumers`
  Label: `Views and external tables`

## Reuse Notes

To recreate this architecture in another Azure subscription:

- provision the same Azure services
- create the `bronze`, `silver`, `gold`, and `parameters` containers
- configure ADF ingestion from GitHub
- import and run the Databricks notebook
- execute the Synapse SQL scripts in order
- validate the gold layer with sample SQL queries

## Security Note

If credentials are hard-coded in notebooks, pipeline definitions, or SQL objects, keep the logic unchanged and move secrets to:

- Azure Key Vault
- Databricks secret scopes
- Managed Identity where supported
