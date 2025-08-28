-- Purpose: Staging model for maximum ROW_WID lookup
WITH max_row_wid_data AS (
    SELECT 
        NVL(MAX(ROW_WID), 0) AS ROW_WID,
        {{ ref('mapplet_tgt_table_name') }} AS TABLE_NAME
    FROM {{ ref('mapplet_schema_cdm') }}.{{ ref('mapplet_tgt_table_name') }}
)
SELECT * FROM max_row_wid_data