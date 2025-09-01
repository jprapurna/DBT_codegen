{{
  config(materialized='ephemeral')
}}

WITH EXP_Gen_CvgAttrCheckSum AS (
  -- Node: EXP_Gen_CvgAttrCheckSum
  -- Description: Generates a checksum for CVG_ATTR using MD5 and passes NISS_APRM_DETL_SK unchanged.
  SELECT
    NISS_APRM_DETL_SK,
    CVG_ATTR,
    MD5(CVG_ATTR) AS CVG_ATTR_CHCKSUM
  FROM {{ source('genai_power_bi', 'WRK_BIRP_NISS_APRM_DETL') }}
),

Upd_CVG_ATTR_SK AS (
  -- Node: Upd_CVG_ATTR_SK
  -- Description: Update Strategy transformation configured to update rows (DD_UPDATE) and forward rejected rows.
  SELECT
    NISS_APRM_DETL_SK,
    CVG_ATTR_CHCKSUM,
    CASE 
      WHEN 'DD_UPDATE' THEN CVG_ATTR_CHCKSUM
      ELSE NULL
    END AS CVG_ATTR_CHCKSUM_UPDATED
  FROM EXP_Gen_CvgAttrCheckSum
)

SELECT *
FROM Upd_CVG_ATTR_SK;