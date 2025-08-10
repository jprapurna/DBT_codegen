-- Purpose: Lookup and transform mapping audit ID and company code

WITH audit_id_lookup AS (
    SELECT 
        WRK_FLOW_RUN_ID AS wrk_flow_run_id,
        NISS_CMPNY_CD AS niss_cmpny_cd,
        ST_NM AS st_nm
    FROM {{ ref('some_source_model') }}
)

SELECT 
    wrk_flow_run_id,
    IIF(LTRIM(RTRIM(st_nm)) = 'Unknown', '???', niss_cmpny_cd) AS niss_cmpny_cd
FROM audit_id_lookup