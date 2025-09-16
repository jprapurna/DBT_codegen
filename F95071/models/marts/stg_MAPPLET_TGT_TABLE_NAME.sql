{{ config(materialized='view') }}

SELECT
    Mapplet_TGT_TABLE_NAME AS mapplet_tgt_table_name -- Mapplet target table name
FROM {{ source('Snowflake_CDM', 'Mapplet_TGT_TABLE_NAME') }}