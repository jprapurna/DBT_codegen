-- Purpose: Loads processed audit item data into the final audit item table
WITH final_data AS (
    SELECT 
        row_ID,
        operation_dt,
        fieldname,
        newvalue,
        oldvalue
    FROM {{ ref('int_tbl_S_Audit_Item_SF_NewProcess_to_tbl_S_Audit_Item_Temp_NewProcess') }}
)
SELECT * FROM final_data