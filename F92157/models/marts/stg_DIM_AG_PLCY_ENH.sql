{{ config(materialized='view') }}

WITH source_data AS (
    SELECT
        "PLCY_ENH_SK" AS plcy_enh_sk, -- Surrogate key for policy enhancement
        "CIF_CD" AS cif_cd, -- CIF code
        "CIF_CD_DESC" AS cif_cd_desc -- CIF code description
    FROM {{ source('AGDM', 'DIM_AG_PLCY_ENH') }}
)
SELECT
    plcy_enh_sk,
    cif_cd,
    cif_cd_desc
FROM source_data
