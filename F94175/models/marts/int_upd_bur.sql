SELECT 
  in_INTEGRATION_ID,
  LKP_INTEGRATION_ID,
  o_Flag,
  BATCH_ID,
  'DD_UPDATE' AS Update_Strategy_Expression_78066
FROM {{ ref('int_rtr_clm_insert_upd') }}