{% macro md5_hash(expr) -%}
md5(cast({{ expr }} as string))
{%- endmacro %}
