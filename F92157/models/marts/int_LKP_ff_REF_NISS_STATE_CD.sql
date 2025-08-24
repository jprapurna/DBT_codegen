{{ config(materialized='table') }}
-- This source is a flat file lookup used to map state names to state codes.
SELECT
  i_ST_NM,
  FARMERS_STATE_NAME,
  NISS_STATE_CODE
FROM {{ source('Flat_File_Lookup', 'LookupFile_ff_NISS_STATE') }}
WHERE 1=1
-- Add any additional transformations or filters here.