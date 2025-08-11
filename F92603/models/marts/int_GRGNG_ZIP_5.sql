-- Purpose: Custom calculation for garage zip code.
WITH garage_zip_code AS (
  SELECT 
    DECODE(1, 
      ISNULL(i_GRGNG_ZIP),'00000', 
      IS_SPACES(i_GRGNG_ZIP),'00000', 
      LTRIM(RTRIM(i_GRGNG_ZIP))='0','00000', 
      LTRIM(RTRIM(i_GRGNG_ZIP))
    ) AS grgng_zip_5
)
SELECT 
  grgng_zip_5
FROM garage_zip_code