{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "Mapplet_TGT_TABLE_NAME" AS mapplet_tgt_table_name -- Target table name for mapplet
    FROM {{ source('genai_power_bi', 'mapplet_tgt_table_name') }}
)
SELECT
    mapplet_tgt_table_name
FROM source_data