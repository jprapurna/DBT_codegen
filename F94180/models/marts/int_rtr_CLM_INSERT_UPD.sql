-- Purpose: Segregates data based on operation type (Insert/Update).
SELECT *
FROM {{ ref('int_EXP_Flag') }}
WHERE 
  {% if is_incremental() %}
    o_Flag = 'I' OR o_Flag = 'U'
  {% endif %}