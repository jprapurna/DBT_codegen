-- Purpose: Extracts audit item data from Salesforce case history for processing
WITH source_data AS (
    SELECT 
        casehist1.ID AS row_id,
        casehist1.CASEID AS record_id,
        casehist1.CREATEDBYID AS created_by,
        casehist1.CREATEDBYID AS last_upd_by,
        casehist1.CREATEDDATE AS created,
        casehist1.CREATEDDATE AS last_upd,
        casehist1.CREATEDDATE AS operation_dt,
        0 AS modification_num,
        0 AS conflict_id,
        'Salesforce' AS buscomp_name,
        casehist1.CREATEDBYID AS user_id,
        casehist1.OLDVALUE AS old_source,
        casehist1.NEWVALUE AS new_source,
        'Modify' AS operation_cd,
        FIELD AS field_name
    FROM {{ source('Salesforce', 'tblSF_CaseHistory_Import') }} casehist1
    WHERE casehist1.FIELD = 'Origin'
)
SELECT * FROM source_data