-- Purpose: Extracts data from tblSF_casehistory_Import for processing
WITH case_history AS (
    SELECT 
        ID AS row_id,
        CREATEDDATE AS operation_dt,
        FIELD AS fieldname,
        CAST(NEWVALUE AS NVARCHAR(500)) AS newvalue,
        CAST(OLDVALUE AS NVARCHAR(500)) AS oldvalue,
        NULL AS colcode
    FROM {{ source('Salesforce', 'tblSF_CaseHistory_Import') }}
)
SELECT * FROM case_history