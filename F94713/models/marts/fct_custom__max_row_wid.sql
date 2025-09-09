{{
  config(materialized='table')
}}

SELECT *
FROM {{ ref('int_custom__max_row_wid') }}