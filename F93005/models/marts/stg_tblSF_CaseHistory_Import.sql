{{ config(materialized='view') }}

SELECT
"ROW_ID" AS row_id, -- Unique identifier for rows
"OPERATION_DT" AS operation_dt, -- Date of operation
"FIELDNAME" AS fieldname, -- Name of the field
"NEWVALUE" AS newvalue, -- New value of the field
"OLDVALUE" AS oldvalue, -- Old value of the field
"ColCode" AS col_code -- Column code (null)
FROM {{ source('Salesforce', 'tblSF_CaseHistory_Import') }}