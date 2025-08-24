{% macro flag_evaluation(lookup_value, current_value) %}
    case
        when {{ lookup_value }} is null then 'I'
        when md5({{ lookup_value }}) = md5({{ current_value }}) then 'NC'
        else 'U'
    end
{% endmacro %}