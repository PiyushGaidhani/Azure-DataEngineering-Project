# Run Order

Use this order to execute the solution end to end.

## 1. Azure Data Factory

Run the ingestion pipeline:

- `ADF/Pipelines/DynamicGitToRaw.json`

Expected result:

- source files are copied from GitHub into the ADLS Gen2 `bronze` container

## 2. Azure Databricks

Run the transformation notebook:

- `Databricks/silver_layer.ipynb`

Expected result:

- transformed Parquet outputs are written to the `silver` and `gold` containers

## 3. Azure Synapse

Run the SQL scripts in this order:

1. `Synapse/Scripts/Create Schema.sql`
2. `Synapse/Scripts/Create Views Gold.sql`
3. `Synapse/Scripts/Create External Table.sql`

Expected result:

- Synapse creates the target schema
- Synapse exposes the lake data through views
- Synapse creates external tables over the curated layer

## 4. Validation

Run a few sample queries against the gold layer to confirm the pipeline completed successfully.
