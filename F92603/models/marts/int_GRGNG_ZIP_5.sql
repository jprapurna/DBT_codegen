-- Purpose: Custom calculation for garage zip code
SELECT 
  DECODE(1, 
    ISNULL(i_GRGNG_ZIP), '00000', 
    IS_SPACES(i_GRGNG_ZIP), '00000', 
    LTRIM(RTRIM(i_GRGNG_ZIP)) = '0', '00000', 
    LTRIM(RTRIM(i_GRGNG_ZIP))
  ) AS grgng_zip_5
FROM {{ source('powercenter', 'WRK_BIRP_NISS_APRM_DETL') }}