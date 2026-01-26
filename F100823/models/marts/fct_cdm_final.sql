{{
  config(materialized='table')
}}

SELECT *
FROM {{ ref('int_cdm__row_wid_expression') }}