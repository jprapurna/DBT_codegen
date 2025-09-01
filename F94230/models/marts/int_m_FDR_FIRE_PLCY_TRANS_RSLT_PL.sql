{{
  config(materialized='ephemeral')
}}

WITH flt_SRC_DUP AS (
  SELECT *
  FROM {{ source('genai_power_bi', 'STG_TFPLCY_TRAN_RESULT') }}
  WHERE <filter_condition>
),
agg_UPD_GATE_KPR AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM flt_SRC_DUP
  GROUP BY <group_by_fields>
),
agg_COUNT_SOURCE_UPDATE_INSERT AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM agg_UPD_GATE_KPR
  GROUP BY <group_by_fields>
),
nrm_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
  SELECT
    <normalization_logic>
  FROM agg_COUNT_SOURCE_UPDATE_INSERT
),
upd_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM nrm_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
),
exp_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
  SELECT
    <expression_logic>
  FROM upd_INSERT
),
exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
  SELECT
    <expression_logic>
  FROM exp_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
),
exp_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
  SELECT
    <expression_logic>
  FROM exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
),
exp_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
  SELECT
    <expression_logic>
  FROM exp_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
),
agg_INS_GATE_KPR AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM exp_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
  GROUP BY <group_by_fields>
),
exp_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
  SELECT
    <expression_logic>
  FROM agg_INS_GATE_KPR
),
exp_DEDUP AS (
  SELECT
    <deduplication_logic>
  FROM exp_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
),
exp_NORM_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
  SELECT
    <expression_logic>
  FROM exp_DEDUP
),
nrm_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
  SELECT
    <normalization_logic>
  FROM exp_NORM_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
),
upd_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM nrm_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
),
upd_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM upd_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
),
exp_NORM_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
  SELECT
    <expression_logic>
  FROM upd_ABC_BAL_DETAIL_AMTS_SOURCE_INSERT
),
upd_ABC_BAL_ROW_COUNTS_SOURCE_INSERT_UPDATE AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_NORM_ABC_BAL_DETAIL_AMTS_RP_INSERT
),
agg_COUNT_SOURCE_UPDATE AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM upd_ABC_BAL_ROW_COUNTS_SOURCE_INSERT_UPDATE
  GROUP BY <group_by_fields>
),
fil_UPD_GATE_KPR AS (
  SELECT *
  FROM agg_COUNT_SOURCE_UPDATE
  WHERE <filter_condition>
),
nrm_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
  SELECT
    <normalization_logic>
  FROM fil_UPD_GATE_KPR
),
rtr_SPLITS AS (
  SELECT
    <router_logic>
  FROM nrm_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
),
agg_COUNT_SOURCE_INSERT AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM rtr_SPLITS
  GROUP BY <group_by_fields>
),
exp_NORM_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
  SELECT
    <expression_logic>
  FROM agg_COUNT_SOURCE_INSERT
),
upd_SOURCE_UPDATE_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_NORM_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
),
lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_LAT_DT AS (
  SELECT
    <lookup_logic>
  FROM upd_SOURCE_UPDATE_INSERT
),
upd_INSERT_ABC AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_LAT_DT
),
agg_COUNTS_REPROC_INSERT AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM upd_INSERT_ABC
  GROUP BY <group_by_fields>
),
exp_LOOKUP_CODES AS (
  SELECT
    <lookup_logic>
  FROM agg_COUNTS_REPROC_INSERT
),
fil_PRE_FDR_MAPNG_ID_REPROCESSED_ROWS AS (
  SELECT *
  FROM exp_LOOKUP_CODES
  WHERE <filter_condition>
),
upd_INS_GATE_KPR AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM fil_PRE_FDR_MAPNG_ID_REPROCESSED_ROWS
),
upd_UPD_GATE_KPR AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM upd_INS_GATE_KPR
),
exp_ABC_BAL_ROW_COUNTS_AND_AMTS_REPROC_INSERT AS (
  SELECT
    <expression_logic>
  FROM upd_UPD_GATE_KPR
),
upd_REPROC_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_ABC_BAL_ROW_COUNTS_AND_AMTS_REPROC_INSERT
),
exp_DERIVE_FACESHEET_DT AS (
  SELECT
    <expression_logic>
  FROM upd_REPROC_INSERT
),
exp_ABC_BAL_ROW_COUNTS_AND_AMTS_SOURCE_INSERT AS (
  SELECT
    <expression_logic>
  FROM exp_DERIVE_FACESHEET_DT
),
exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE AS (
  SELECT
    <expression_logic>
  FROM exp_ABC_BAL_ROW_COUNTS_AND_AMTS_SOURCE_INSERT
),
exp_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
  SELECT
    <expression_logic>
  FROM exp_NORM_ABC_BAL_DETAIL_AMTS_SOURCE_UPDATE
),
upd_ABC_BAL_DETAIL_AMTS_REPROC_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_ABC_BAL_DETAIL_AMTS_RP_INSERT
),
upd_SOURCE_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM upd_ABC_BAL_DETAIL_AMTS_REPROC_INSERT
),
upd_FACESHEET_DT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM upd_SOURCE_INSERT
),
exp_ABC_BAL_ROW_COUNTS_AND_AMTS_SOURCE_UPDATE AS (
  SELECT
    <expression_logic>
  FROM upd_FACESHEET_DT
),
upd_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_ABC_BAL_ROW_COUNTS_AND_AMTS_SOURCE_UPDATE
),
nrm_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
  SELECT
    <normalization_logic>
  FROM upd_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
),
exp_ABC_BAL_ROW_COUNTS_AND_AMTS_RP_INSERT AS (
  SELECT
    <expression_logic>
  FROM nrm_ABC_BAL_DETAIL_AMTS_RP_INSERT
),
nrm_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE AS (
  SELECT
    <normalization_logic>
  FROM exp_ABC_BAL_ROW_COUNTS_AND_AMTS_RP_INSERT
),
agg_COUNT_REPROCESSED_ROWS AS (
  SELECT
    <group_by_fields>,
    <aggregate_functions>
  FROM nrm_ABC_BAL_DETAIL_AMTS_TARGET_INSERT_UPDATE
  GROUP BY <group_by_fields>
),
exp_DATE_LOGIC AS (
  SELECT
    <expression_logic>
  FROM agg_COUNT_REPROCESSED_ROWS
),
upd_ABC_BAL_ROW_COUNTS2 AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_DATE_LOGIC
),
upd_ABC_BAL_DETAIL_AMTS_RP_INSERT AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM upd_ABC_BAL_ROW_COUNTS2
),
lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_APLD_DT AS (
  SELECT
    <lookup_logic>
  FROM upd_ABC_BAL_DETAIL_AMTS_RP_INSERT
),
upd_ABC_BAL_ROW_COUNTS3 AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_UPDATE'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM lkp_FDR_FIRE_PLCY_TRANS_RSLT_TGT_DUP_CHK_APLD_DT
),
seq_FDR_LIB_ABC_BAL_ROW_COUNTS_SK AS (
  SELECT
    NEXTVAL AS sequence_value
  FROM some_sequence_table
),
lkp_FDR_LIB_FDR_FIRE_PLCY_TRANS_RSLT_MIN_EFF_DT AS (
  SELECT
    <lookup_logic>
  FROM seq_FDR_LIB_ABC_BAL_ROW_COUNTS_SK
),
lkp_FDR_LIB_FDR_FIRE_PLCY_TRANS_RSLT_LOW AS (
  SELECT
    <lookup_logic>
  FROM lkp_FDR_LIB_FDR_FIRE_PLCY_TRANS_RSLT_MIN_EFF_DT
),
lkp_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_TBL_OBJ_ID_SOURCE_INSERT AS (
  SELECT
    <lookup_logic>
  FROM lkp_FDR_LIB_FDR_FIRE_PLCY_TRANS_RSLT_LOW
),
exp_ABC_MAPPING_AUDIT_ID_LOOKUP AS (
  SELECT
    <expression_logic>
  FROM lkp_FDR_LIB_ABC_WRKFL_CMPNT_OBJ_STG_TO_PRE_FDR_TBL_OBJ_ID_SOURCE_INSERT
),
upd_INSERT_ERROR_RECORD AS (
  SELECT
    *,
    CASE 
      WHEN <condition> THEN 'DD_INSERT'
      ELSE 'DD_REJECT'
    END AS update_strategy
  FROM exp_ABC_MAPPING_AUDIT_ID_LOOKUP
),
exp_ASSIGN_ERROR_ID_AND_VALUES AS (
  SELECT
    <expression_logic>
  FROM upd_INSERT_ERROR_RECORD
)
SELECT *
FROM exp_ASSIGN_ERROR_ID_AND_VALUES