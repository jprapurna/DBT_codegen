{% macro hash_compare(value1, value2) %}
  MD5({{ value1 }}) = MD5({{ value2 }})
{% endmacro %}