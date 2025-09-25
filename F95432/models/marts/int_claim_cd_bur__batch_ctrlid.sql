{{ config(materialized='ephemeral') }}

WITH batch_ctrlid_data AS (
  {{ macro_batch_id_lookup(ref('status_running')) }}
)

SELECT * FROM batch_ctrlid_data