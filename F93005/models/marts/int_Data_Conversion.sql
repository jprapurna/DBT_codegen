-- Purpose: Converts data types for compatibility with destination schema
WITH conversion AS (
    SELECT 
        CAST(BUSCOMP_NAME AS NVARCHAR) AS buscomp_name_wstr,
        CAST(OPERATION_CD AS NVARCHAR) AS operation_cd_wstr
    FROM {{ ref('int_Salesforce_tblSF_AUDIT_ITEM_Owner') }}
)
SELECT * FROM conversion