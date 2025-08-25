-- Purpose: Final model for reporting and analytics on NISS_APRM_LND data.

{{ config(materialized='table') }}

SELECT *
FROM {{ ref('int_WRK_BIRP_NISS_APRM_LND') }}
