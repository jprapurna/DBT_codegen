-- Purpose: Process batch ID using mapplet
SELECT 
  SOURCE_NAME, 
  (SELECT MAX(BATCH_ID) FROM {{ ref('int_CDM_BATCH_CTRLID') }} WHERE SOURCE_NAME = {{ ref('int_CDH_GW_BUR') }}.SOURCE_NAME) AS o_BATCH_ID
FROM 
  {{ ref('int_CDH_GW_BUR') }}