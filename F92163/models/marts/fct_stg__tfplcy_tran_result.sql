{{
  config(
    materialized='table'
  )
}}

SELECT *
FROM {{ ref('int_stg__tfplcy_tran_result') }}