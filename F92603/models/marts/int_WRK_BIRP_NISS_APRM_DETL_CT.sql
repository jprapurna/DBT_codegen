{{ config(materialized='table') }}
SELECT 
    NISS_APRM_DETL_SK, 
    ST_ABBR, 
    ACCTNG_LOB, 
    CVG_TYP_CD, 
    CVG_AMT, 
    NISS_CVG_CD
FROM {{ source('FDR', 'WRK_BIRP_NISS_APRM_DETL') }}
WHERE ST_ABBR='CT'