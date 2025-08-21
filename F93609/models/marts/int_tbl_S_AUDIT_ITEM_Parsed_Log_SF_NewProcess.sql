-- Purpose: Source table containing parsed log data from Salesforce for auditing purposes.

SELECT 
  ROW_ID,
  OPERATION_DT,
  FIELDNAME,
  NEWVALUE,
  OLDVALUE,
  ColCode
FROM {{ ref('int_tblSF_CaseHistory_Import') }}