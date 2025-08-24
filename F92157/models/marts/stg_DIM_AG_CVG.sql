{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "CVG_SK" AS cvg_sk, -- Surrogate key for coverage
        "ACCTNG_LOB" AS acctng_lob, -- Accounting line of business
        "CVG_TYP_CD" AS cvg_typ_cd -- Coverage type code
    FROM {{ source('AGDM', 'DIM_AG_CVG') }}
)
SELECT
    cvg_sk,
    acctng_lob,
    cvg_typ_cd
FROM source_data