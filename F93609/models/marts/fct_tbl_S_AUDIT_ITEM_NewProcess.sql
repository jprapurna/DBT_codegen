-- Purpose: Loads data into the tbl_S_AUDIT_ITEM_NewProcess table in the InSightETL2 database.

WITH combined_data AS (
  SELECT * FROM {{ ref('int_tblSF_CaseHistory_Import') }}
  UNION ALL
  SELECT * FROM {{ ref('int_tblSF_AUDIT_ITEM_Owner') }}
  UNION ALL
  SELECT * FROM {{ ref('int_tblSF_AUDIT_ITEM_Status') }}
  UNION ALL
  SELECT * FROM {{ ref('int_tblSF_AUDIT_ITEM_Source') }}
  UNION ALL
  SELECT * FROM {{ ref('int_tbl_S_AUDIT_ITEM_Parsed_Log_SF_NewProcess') }}
  UNION ALL
  SELECT * FROM {{ ref('int_tbl_S_AUDIT_ITEM_SF_NewProcess') }}
)

SELECT 
  ROW_ID,
  OPERATION_DT,
  FIELDNAME,
  NEWVALUE,
  OLDVALUE,
  ColCode
FROM combined_data