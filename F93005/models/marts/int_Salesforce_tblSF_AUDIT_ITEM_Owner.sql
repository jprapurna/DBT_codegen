-- Purpose: Extracts audit item data from Salesforce case history, joining with user data to determine old and new owners
WITH owner_data AS (
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
        casehist1.OLDVALUE AS old_owner,
        casehist1.NEWVALUE AS new_owner,
        'Modify' AS operation_cd,
        LEFT(casehist1.FIELD, 5) AS field_name
    FROM {{ source('Salesforce', 'tblSF_CaseHistory_Import') }} casehist1
    JOIN {{ source('Salesforce', 'tblSF_USER') }} user1 ON casehist1.OLDVALUE = user1.ID
    WHERE LEFT(casehist1.FIELD, 5) = 'Owner'
    UNION
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
        casehist1.OLDVALUE AS old_owner,
        casehist1.NEWVALUE AS new_owner,
        'Modify' AS operation_cd,
        LEFT(casehist1.FIELD, 5) AS field_name
    FROM {{ source('Salesforce', 'tblSF_CaseHistory_Import') }} casehist1
    JOIN {{ source('Salesforce', 'tblSF_USER') }} user1 ON casehist1.NEWVALUE = user1.ID
    WHERE LEFT(casehist1.FIELD, 5) = 'Owner'
)
SELECT * FROM owner_data