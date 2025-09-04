{% macro macro_isnull(lkp_batch_id) %}
case 
  when {{ lkp_batch_id }} is null then -999
  else {{ lkp_batch_id }}
end
{% endmacro %}