{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "TRANS_TYP_PLCY_SK" AS trans_typ_plcy_sk, -- Surrogate key for transaction type policy
        "TRANS_TYP_PLCY_CD" AS trans_typ_plcy_cd, -- Code for transaction type policy
        "TRANS_TYP_PLCY_DESC" AS trans_typ_plcy_desc -- Description for transaction type policy
    FROM {{ source('AGDM', 'DIM_AG_TRANS_TYP_PLCY') }}
)
SELECT
    trans_typ_plcy_sk,
    trans_typ_plcy_cd,
    trans_typ_plcy_desc
FROM source_data