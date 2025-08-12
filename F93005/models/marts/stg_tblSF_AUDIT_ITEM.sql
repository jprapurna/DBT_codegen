{{ config(materialized='view') }}

SELECT
"ROW_ID" AS row_id, -- Unique identifier for rows
"RECORD_ID" AS record_id, -- Record identifier
"CREATED_BY" AS created_by, -- Creator of the record
"LAST_UPD_BY" AS last_upd_by, -- Last updater of the record
"CREATED" AS created, -- Creation date
"LAST_UPD" AS last_upd, -- Last update date
"OPERATION_DT" AS operation_dt, -- Date of operation
"MODIFICATION_NUM" AS modification_num, -- Modification number
"CONFLICT_ID" AS conflict_id, -- Conflict identifier
"BUSCOMP_NAME" AS buscomp_name, -- Business component name
"USER_ID" AS user_id, -- User identifier
"Old_Owner" AS old_owner, -- Previous owner
"New_Owner" AS new_owner, -- New owner
"OPERATION_CD" AS operation_cd, -- Operation code
"FIELD_NAME" AS field_name -- Field name
FROM {{ source('Salesforce', 'tblSF_AUDIT_ITEM') }}