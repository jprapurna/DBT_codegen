{% macro hash_compare(column1, column2) %}
  MD5({{ column1 }}) = MD5({{ column2 }})
{% endmacro %}