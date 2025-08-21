-- Purpose: Extracts data from the tblSF_casehistory_Import table.

WITH source_data AS (
  SELECT 
    ID AS ROW_ID,
    CREATEDDATE AS OPERATION_DT,
    FIELD AS FIELDNAME,
    CAST(NEWVALUE AS NVARCHAR(500)) AS NEWVALUE,
    CAST(OLDVALUE AS NVARCHAR(500)) AS OLDVALUE,
    NULL AS ColCode
  FROM {{ source('Salesforce_Audit_Data_Integration', 'tblSF_CaseHistory_Import') }}
)

SELECT 
  ROW_ID,
  OPERATION_DT,
  FIELDNAME,
  NEWVALUE,
  OLDVALUE,
  ColCode
FROM source_data