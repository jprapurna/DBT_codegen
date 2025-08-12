-- Purpose: Executes SQL updates to translate status and mode fields in the audit item table
UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET New_Mode = 'Button'
WHERE New_Status = 'Referred';

UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET Old_Status = 'Reopen_SF'
WHERE Old_Status = 'Re-Open';

UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET New_Status = 'Reopen_SF'
WHERE New_Status = 'Re-Open';

UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET Old_Status = 'Pending Documentation'
WHERE Old_Status = 'Customer/Agent Action Needed';

UPDATE {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
SET New_Status = 'Pending Documentation'
WHERE New_Status = 'Customer/Agent Action Needed';