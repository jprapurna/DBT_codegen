-- Purpose: Deletes existing records in the temporary audit item table and inserts new records from the Salesforce audit item table
DELETE FROM {{ source('Salesforce', 'tbl_S_AUDIT_ITEM_Temp_NewProcess') }}
WHERE row_ID IN (SELECT row_ID FROM {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }});

INSERT INTO {{ source('Salesforce', 'tbl_S_AUDIT_ITEM_Temp_NewProcess') }}
SELECT * FROM {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }};