-- Purpose: Final model for reporting and analytics on detailed NISS APRM data.

{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_WRK_BIRP_NISS_APRM_DETL') }}
