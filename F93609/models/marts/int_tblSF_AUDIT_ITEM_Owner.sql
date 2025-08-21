-- Purpose: Extracts data from Salesforce audit item history and performs transformations for downstream processing.

WITH case_history AS (
  SELECT 
    ID AS ROW_ID,
    CASEID AS RECORD_ID,
    CREATEDBYID AS CREATED_BY,
    CREATEDBYID AS LAST_UPD_BY,
    CREATEDDATE AS CREATED,
    CREATEDDATE AS LAST_UPD,
    CREATEDDATE AS OPERATION_DT,
    0 AS MODIFICATION_NUM,
    0 AS CONFLICT_ID,
    'Salesforce' AS BUSCOMP_NAME,
    CREATEDBYID AS USER_ID,
    OLDVALUE AS Old_Owner,
    NEWVALUE AS New_Owner,
    'Modify' AS OPERATION_CD,
    LEFT(FIELD, 5) AS FIELD_NAME
  FROM {{ ref('int_tblSF_CaseHistory_Import') }}
)

SELECT 
  ROW_ID,
  RECORD_ID,
  CREATED_BY,
  LAST_UPD_BY,
  CREATED,
  LAST_UPD,
  OPERATION_DT,
  MODIFICATION_NUM,
  CONFLICT_ID,
  BUSCOMP_NAME,
  USER_ID,
  Old_Owner,
  New_Owner,
  OPERATION_CD,
  FIELD_NAME
FROM case_history