-- Purpose: Lookup procedure for mapping ID
WITH map_id_lookup AS (
  SELECT 
    lkp_MAP_ID(MAPPING_NAME, FOLDER_NAME) AS map_id
  FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}
)
SELECT 
  map_id
FROM map_id_lookup