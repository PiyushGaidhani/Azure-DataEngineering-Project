# Architecture Diagram Source

Use this Mermaid diagram directly in GitHub or as a reference when recreating the architecture in draw.io or Excalidraw.

```mermaid
flowchart LR
    GH[GitHub\nSource Data Files] --> ADF[Azure Data Factory\nDynamicGitToRaw]
    ADF --> B[ADLS Gen2\nbronze]
    B --> DB[Azure Databricks\nsilver_layer.ipynb]
    DB --> S[ADLS Gen2\nsilver]
    DB --> G[ADLS Gen2\ngold]
    S --> SYNS[Synapse Serverless SQL\nGold Views and External Tables]
    G --> SYNS
    SYNS --> DW[Synapse Dedicated SQL Pool\ndwh_ext* / Star Schema]
    PL[Synapse Pipeline\npl_load_sales_dwh] --> DW
    DW --> PBI[Power BI\nDirectQuery Reporting]
```
