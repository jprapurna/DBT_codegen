-- Purpose: Fetch maximum ROW_WID from the target table
WITH max_row_wid_data AS (
    SELECT 
        NVL(MAX(ROW_WID), 0) AS row_wid, 
        '{{ var("TGT_TABLE_NAME") }}' AS table_name
    FROM {{ var("SCHEMA_CDM") }}.{{ var("TGT_TABLE_NAME") }}
)
SELECT 
    row_wid, 
    table_name
FROM max_row_wid_data