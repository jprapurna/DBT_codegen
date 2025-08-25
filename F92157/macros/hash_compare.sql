{% macro hash_compare(column1, column2) %}
  CASE
    WHEN MD5({{ column1 }}) = MD5({{ column2 }}) THEN 'MATCH'
    ELSE 'DIFFERENT'
  END
{% endmacro %}
