{{ config(materialized='table') }}
SELECT 
    ROW_WID, 
    BUR, 
    NEW_BUR, 
    OLD_BUR, 
    o_Flag, 
    CDM_INSERT_DT, 
    CDM_UPDATE_DT
FROM {{ ref('int_rtr_clm_insert_upd') }}