{{ config(materialized='ephemeral') }}

WITH max_row_wid_data AS (
  SELECT 
    {{ macro_lookup_max_row_wid('table_name') }}
)

SELECT * FROM max_row_wid_data