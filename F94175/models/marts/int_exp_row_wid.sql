SELECT 
  TGT_TABLE_NAME,
  {{ row_id_assignment('TGT_TABLE_NAME', 'V2') }} AS ROW_WID
FROM {{ ref('int_mplt_cdm_row_wid') }}