-- Purpose: Represents the update strategy transformation logic for updating NISS_CLASS_CD with strategy DD_UPDATE

WITH updated_niss_class_cd AS (
  SELECT 
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCPN_IND AS rec_excp_ind,
    REC_EXCPN_RSN_DESC AS rec_excp_desc
  FROM {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
  NISS_APRM_DETL_SK,
  NISS_CLASS_CD,
  rec_excp_ind,
  rec_excp_desc
FROM updated_niss_class_cd