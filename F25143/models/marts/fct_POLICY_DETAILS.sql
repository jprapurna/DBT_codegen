{{ config(materialized='table') }}
SELECT
    src.PLCY_CNTRCT_NUM AS policy_contract_number,
    src.EFF_DT AS effective_date,
    src.NISS_STATE_CODE AS state_code,
    src.NISS_TERR_CD AS territory_code,
    src.WRITTN_PREM_AMT AS written_premium_amount
FROM {{ ref('int_EXPTRANS') }} src;