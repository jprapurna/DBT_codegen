-- Purpose: Load detailed data for NISS auto territory reporting.

WITH detailed_data AS (
    SELECT 
        a.*,
        b.ref_auto_terr_sk,
        c.mapping_name,
        c.folder_name,
        c.workflow_name
    FROM 
        {{ ref('int_EXPTRANS') }} a
    LEFT JOIN 
        {{ ref('int_LKP_RBI_REF_AUTO_TERR_ByStZipLob') }} b ON a.niss_st_cd = b.niss_st_cd AND a.st_abbrv = b.st_abbrv AND a.zip_cd = b.zip_cd AND a.pp_commrcl_cd = b.pp_commrcl_cd
    LEFT JOIN 
        {{ ref('int_EXP_ABC_MAPPING_AUDIT_ID_LOOKUP') }} c ON a.mapping_name = c.mapping_name AND a.folder_name = c.folder_name AND a.workflow_name = c.workflow_name
)

SELECT 
    *
FROM 
    detailed_data