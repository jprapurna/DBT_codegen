{{
  config(materialized='table')
}}

SELECT *
FROM {{ ref('int_cdh_gwods__cdh_gw_bur') }}