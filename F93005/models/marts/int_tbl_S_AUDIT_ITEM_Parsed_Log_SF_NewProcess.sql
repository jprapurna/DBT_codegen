-- Purpose: Source table for audit item parsed log from Salesforce
SELECT * FROM {{ source('Salesforce', 'tbl_S_AUDIT_ITEM_Parsed_Log_SF_NewProcess') }}