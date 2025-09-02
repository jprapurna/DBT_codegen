{{
  config(materialized='ephemeral')
}}

WITH dim_dt AS (
  SELECT 
    DT_SK,
    CLNDR_DT,
    CLNDR_DAY,
    CLNDR_MNTH,
    CLNDR_YR,
    DAY_NM,
    MNTH_NM,
    MNTH_END_IND,
    DAY_NUM,
    WK_NUM,
    CLNDR_DT_STRING,
    QTR_STRING,
    AUTO_MNTH_END_IND,
    HM_MNTH_END_IND,
    COMMRCL_MNTH_END_IND,
    LIFE_MNTH_END_IND,
    MNTH_NUM,
    UMB_MNTH_END_IND,
    CLM_MNTH_END_IND,
    MNTH_SHRT_DESC
  FROM {{ source('source_system', 'DIM_DT') }}
),
dim_ag_farmr_geo_st AS (
  SELECT 
    FARMR_GEO_ST_SK,
    CHK_SUM_ATTR,
    ST_CD,
    ST_NM,
    ZONE,
    CORE_29_IND,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
  FROM {{ source('source_system', 'DIM_AG_FARMR_GEO_ST') }}
),
dim_ag_rated_geo AS (
  SELECT 
    RATED_GEO_SK,
    CHK_SUM_ATTR,
    GRGNG_ZIP_3,
    GRGNG_ZIP_5,
    GRGNG_ZIP_PLUS4,
    FARMR_GEO_ST_SK,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
  FROM {{ source('source_system', 'DIM_AG_RATED_GEO') }}
),
dim_ag_cvg AS (
  SELECT 
    CVG_SK,
    CHK_SUM_ATTR,
    ACCTNG_LOB,
    LOB,
    CVG_TYP_CD,
    CVG_TYP_DESC,
    DED_PCT,
    MINI_CVG_SK,
    MINI_CVG_CHK_SUM,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID
  FROM {{ source('source_system', 'DIM_AG_CVG') }}
),
dim_ag_mini_cvg AS (
  SELECT 
    MINI_CVG_SK,
    CHK_SUM_ATTR,
    CVG_AMT,
    CVG_PTRN,
    WRKSTATN_MAJ_GRP,
    WRKSTATN_MNR_GRP,
    FLEX_PKG_CD,
    FLEX_PKG_DESC,
    CR_BY_MAPNG_ID,
    DW_CR_TMSP,
    UPD_BY_MAPNG_ID,
    DW_UPD_TMSP,
    WRK_FLOW_RUN_ID,
    SUM_CVG_CHK_SUM,
    SUM_CVG_SK
  FROM {{ source('source_system', 'DIM_AG_MINI_CVG') }}
),
final AS (
  SELECT 
    dim_dt.*,
    dim_ag_farmr_geo_st.*,
    dim_ag_rated_geo.*,
    dim_ag_cvg.*,
    dim_ag_mini_cvg.*
  FROM dim_dt
  LEFT JOIN dim_ag_farmr_geo_st ON dim_dt.DT_SK = dim_ag_farmr_geo_st.FARMR_GEO_ST_SK
  LEFT JOIN dim_ag_rated_geo ON dim_ag_farmr_geo_st.FARMR_GEO_ST_SK = dim_ag_rated_geo.FARMR_GEO_ST_SK
  LEFT JOIN dim_ag_cvg ON dim_ag_rated_geo.RATED_GEO_SK = dim_ag_cvg.CVG_SK
  LEFT JOIN dim_ag_mini_cvg ON dim_ag_cvg.MINI_CVG_SK = dim_ag_mini_cvg.MINI_CVG_SK
)

SELECT * FROM final;