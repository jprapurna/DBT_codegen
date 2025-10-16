with 
SQ_CDH_GW_BUR as (
    SELECT 
        CDH_GW_BUR.POLICY_STATE,
        CDH_GW_BUR.BUR,
        'GWCDH' AS SOURCE_NAME
    FROM {{ source('GENAI_POWER_BI_CDM', 'SQ_CDH_GW_BUR') }} CDH_GW_BUR
),

EXP_BUR AS (
    SELECT 
        POLICY_STATE,
        BUR,
        SOURCE_NAME,
        POLICY_STATE AS INTEGRATION_ID
    FROM SQ_CDH_GW_BUR
),

mplt_cdm_batch as (
    select * from {{ mplt_cdm_batch_id('exp_bur', 'SOURCE_NAME') }}
),

lkp_w_claim AS (
    SELECT 
        W_CLAIM_CD_BUR_SCD3.LKP_ROW_WID,
        W_CLAIM_CD_BUR_SCD3.LKP_INTEGRATION_ID,
        W_CLAIM_CD_BUR_SCD3.LKP_NEW_BUR
    FROM {{ source('GENAI_POWER_BI_CDM', 'LKP_W_CLAIM_CD_BUR_SCD3') }} AS W_CLAIM_CD_BUR_SCD3
),

joined as (
  select
    e.POLICY_STATE,
    e.BUR,
    e.SOURCE_NAME,
    e.INTEGRATION_ID,
    m.o_BATCH_ID,
    l.LKP_ROW_WID,
    l.LKP_INTEGRATION_ID,
    l.LKP_NEW_BUR
  from EXP_BUR e
  left join mplt_cdm_batch m
    on m.SOURCE_NAME = e.SOURCE_NAME
  left join lkp_w_claim l
    on l.LKP_INTEGRATION_ID = e.INTEGRATION_ID
),

EXP_Flag AS (
    select
        POLICY_STATE,
        BUR,
        SOURCE_NAME,
        INTEGRATION_ID,
        o_BATCH_ID,
        LKP_ROW_WID,
        LKP_INTEGRATION_ID,
        LKP_NEW_BUR,
        case
            when LKP_ROW_WID is null then 'I'
            when md5(BUR) = md5(LKP_NEW_BUR) then 'NC'
            else 'U'
        end as o_Flag,
        CURRENT_TIMESTAMP() as CDM_INSERT_DT,
        CURRENT_TIMESTAMP() as CDM_UPDATE_DT,
        'W_CLAIM_CD_BUR_SCD3' as TGT_TABLE_NAME
    from joined
),

rtr_CLM_INSERT_UPD AS (
  select
    *,
    case
      when o_Flag = 'I' then 'INSERT'
      when o_Flag = 'U' then 'UPDATE'
    end as router_group
  from EXP_Flag
),

mplt_row_wid as (
  select
    ROW_WID,
    TGT_TABLE_NAME
  from {{ mplt_cdm_row_wid('LKP_W_CLAIM_CD_BUR_SCD3') }}
),

upd_bur as (
  select
    r.*,
    'DD_UPDATE' as Update_Strategy_Expression_78066
  from rtr_CLM_INSERT_UPD r
),

to_insert as (
  select
    u.POLICY_STATE,
    u.BUR,
    u.SOURCE_NAME,
    u.INTEGRATION_ID,
    u.o_BATCH_ID,
    u.LKP_ROW_WID,
    u.LKP_NEW_BUR,
    u.o_Flag,
    u.CDM_INSERT_DT,
    u.CDM_UPDATE_DT,
    u.TGT_TABLE_NAME,
    coalesce(m.ROW_WID, 0) as ROW_WID
  from upd_bur u
  left join mplt_row_wid m
    on m.TGT_TABLE_NAME = u.TGT_TABLE_NAME
  where u.router_group = 'INSERT'
),

to_update as (
  select
    u.POLICY_STATE,
    u.BUR,
    u.SOURCE_NAME,
    u.INTEGRATION_ID,
    u.o_BATCH_ID,
    u.LKP_ROW_WID,
    u.LKP_NEW_BUR,
    u.o_Flag,
    u.CDM_INSERT_DT,
    u.CDM_UPDATE_DT,
    u.TGT_TABLE_NAME,
    u.Update_Strategy_Expression_78066
  from upd_bur u
  where u.router_group = 'UPDATE'
),

combined as (
  select 'INSERT' as _route, * from to_insert
  union all
  select 'UPDATE' as _route, * from to_update
)

select * from combined
