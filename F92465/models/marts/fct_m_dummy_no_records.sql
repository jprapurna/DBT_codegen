{{ config(materialized='table') }}

SELECT 
  'dummy_email@example.com' AS EmailToList,
  'Dummy Success Email' AS EmailSubject,
  'This is a dummy success email body.' AS EmailBody
FROM {{ ref('int_m_dummy_no_records') }}