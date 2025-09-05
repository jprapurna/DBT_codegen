{{ config(materialized='view') }}

WITH mapplet_tgt_table_name_data AS (
    SELECT
        *
    FROM {{ source('Snowflake_Cloud_Data_Warehouse', 'Mapplet_TGT_TABLE_NAME') }}
)
SELECT
    *
FROM mapplet_tgt_table_name_data