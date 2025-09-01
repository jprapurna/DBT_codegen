{{
  config(
    materialized='ephemeral'
  )
}}

WITH EXP_To_Drv_Class_Cd1 AS (
  -- Node: EXP_To_Drv_Class_Cd1
  -- Purpose: Expression transformation to derive NISS classification code
  SELECT
    NISS_APRM_DETL_SK,
    NULL AS ST_ABBR, -- Placeholder for ST_ABBR as no source identified
    CASE 
      WHEN SUBSTRING(TRIM(v_NISS_CLASS_CD), 1, 4) = '????' OR SUBSTRING(v_NISS_CLASS_CD, 5, 6) = '??' THEN '??????'
      ELSE v_NISS_CLASS_CD
    END AS NISS_CLASS_CD,
    CASE 
      WHEN i_REC_EXCPN_IND = 'Y' OR REC_EXCP_IND = 'Y' THEN 'Y'
      ELSE ''
    END AS REC_EXCPN_IND,
    REC_EXCPTN_RSN_DESC_ZIP || REC_EXCP_DESC_CLASS AS REC_EXCP_DESC
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

UPD_NISS_CLASS_CD AS (
  -- Node: UPD_NISS_CLASS_CD
  -- Purpose: Update Strategy transformation to update NISS_CLASS_CD
  SELECT
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND,
    REC_EXCP_DESC
  FROM EXP_To_Drv_Class_Cd1
  WHERE 1=1 -- Placeholder for DD_UPDATE logic
)

SELECT *
FROM UPD_NISS_CLASS_CD;