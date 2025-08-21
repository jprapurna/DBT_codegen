{{ config(materialized='view') }}

SELECT
"ROW_WID" AS row_wid, -- Row width identifier
"TABLE_NAME" AS table_name -- Name of the table
FROM {{ source('Salesforce_Audit_Data_Integration', 'lkp_MAX_ROW_WID') }}