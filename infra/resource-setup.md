# Resource Setup

## Azure Resources

This project uses a single Azure resource group containing:

- Azure Data Factory
- Azure Databricks
- Azure Synapse Analytics
- Azure Data Lake Storage Gen2

## Storage Layout

The ADLS Gen2 account contains:

- `bronze`: raw ingested files
- `silver`: transformed intermediate datasets
- `gold`: curated analytical datasets
- `parameters`: ingestion configuration and metadata

## Recommended Provisioning Order

1. Create a resource group.
2. Create an ADLS Gen2 storage account.
3. Create the `bronze`, `silver`, `gold`, and `parameters` containers.
4. Create Azure Data Factory.
5. Create Azure Databricks.
6. Create Azure Synapse.
7. Grant storage access to all services.

## Security Guidance

For a portfolio-safe deployment:

- Prefer Managed Identity where possible
- Store secrets in Azure Key Vault
- Use Databricks secret scopes for notebook credentials
- Avoid committing hard-coded connection strings, storage keys, or secrets

## Note

The existing `Data/` folder is intentionally preserved as-is because it is referenced by the ingestion flow.
