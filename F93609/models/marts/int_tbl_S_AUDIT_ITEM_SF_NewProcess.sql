-- Purpose: Source table containing audit items from Salesforce for processing.

SELECT 
  *
FROM {{ ref('int_tbl_S_AUDIT_ITEM_Parsed_Log_SF_NewProcess') }}