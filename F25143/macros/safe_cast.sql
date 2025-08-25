{% macro safe_cast(field, target_type) %}
    dbt_utils.safe_cast({{ field }}, {{ target_type }})
{% endmacro %}