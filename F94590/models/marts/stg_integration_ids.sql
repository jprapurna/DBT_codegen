{{ config(materialized='view') }}

WITH integration_ids_data AS (
    SELECT
        "ROW_WID" AS row_wid, -- Unique row identifier
        "Mapplet_TGT_TABLE_NAME" AS mapplet_tgt_table_name -- Target table name for mapplet
    FROM {{ source('cdh_gwods', 'integration_ids') }}
)
SELECT
    row_wid,
    mapplet_tgt_table_name
FROM integration_ids_data