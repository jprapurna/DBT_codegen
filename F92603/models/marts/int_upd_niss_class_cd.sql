-- Purpose: Represents the update strategy transformation logic for updating NISS_CLASS_CD

WITH updated_niss_class_cd AS (
  SELECT 
    NISS_APRM_DETL_SK,
    NISS_CLASS_CD,
    REC_EXCP_IND,
    REC_EXCP_DESC
  FROM 
    {{ ref('WRK_BIRP_NISS_APRM_DETL') }}
)

SELECT 
  NISS_APRM_DETL_SK,
  NISS_CLASS_CD,
  REC_EXCP_IND,
  REC_EXCP_DESC
FROM 
  updated_niss_class_cd