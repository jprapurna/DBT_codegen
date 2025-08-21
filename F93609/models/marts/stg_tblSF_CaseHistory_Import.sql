{{ config(materialized='view') }}

SELECT
"ROW_ID" AS row_id, -- Unique row identifier
"OPERATION_DT" AS operation_dt, -- Operation timestamp
"FIELDNAME" AS fieldname, -- Field name
"NEWVALUE" AS newvalue, -- New value
"OLDVALUE" AS oldvalue, -- Old value
"ColCode" AS colcode -- Placeholder column
FROM {{ source('Salesforce_Audit_Data_Integration', 'tblSF_CaseHistory_Import') }}