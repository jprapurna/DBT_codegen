-- Purpose: Source table for audit items from Salesforce
SELECT row_ID FROM {{ source('Salesforce', 'tbl_S_AUDIT_ITEM_SF_NewProcess') }}