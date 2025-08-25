{% macro hash_compare(value1, value2) %}
    md5({{ value1 }}) = md5({{ value2 }})
{% endmacro %}