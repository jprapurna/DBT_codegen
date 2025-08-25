{% macro split_bi_limit(bi_lmt) %}
    {% set v_bi_lmt = bi_lmt | replace(',', '') %}
    {% set v_bi_lmt_parts = v_bi_lmt | length - v_bi_lmt | replace('/', '') | length + 1 %}
    {% set v_bi_lmt_part1_pos = v_bi_lmt.find('/') %}
    {% set v_bi_lmt_part2_pos = v_bi_lmt.find('/', v_bi_lmt_part1_pos + 1) %}
    {% set limit_field1 = 
        (v_bi_lmt_parts == 1) | v_bi_lmt |
        (v_bi_lmt_parts == 2) | v_bi_lmt[:v_bi_lmt_part1_pos] |
        (v_bi_lmt_parts == 3) | v_bi_lmt[:v_bi_lmt_part1_pos] |
        '0' %}
    {% set limit_field2 = 
        (v_bi_lmt_parts == 1) | '0' |
        (v_bi_lmt_parts == 2) | v_bi_lmt[v_bi_lmt_part1_pos + 1:] |
        (v_bi_lmt_parts == 3) | v_bi_lmt[v_bi_lmt_part1_pos + 1:v_bi_lmt_part2_pos] |
        '0' %}
    {% set limit_field3 = 
        (v_bi_lmt_parts == 1) | '0' |
        (v_bi_lmt_parts == 2) | '0' |
        (v_bi_lmt_parts == 3) | v_bi_lmt[v_bi_lmt_part2_pos + 1:] |
        '0' %}
    {% set bi_lmt_1_decimal = limit_field1 | int %}
    {% set bi_lmt_2_decimal = limit_field2 | int %}
    {% set bi_lmt_3_decimal = limit_field3 | int %}
    {% set bi_lmt_no_of_parts = v_bi_lmt_parts %}
    {% set src_bi_lmt = v_bi_lmt %}
    return {
        "bi_lmt_1_decimal": bi_lmt_1_decimal,
        "bi_lmt_2_decimal": bi_lmt_2_decimal,
        "bi_lmt_3_decimal": bi_lmt_3_decimal,
        "bi_lmt_no_of_parts": bi_lmt_no_of_parts,
        "src_bi_lmt": src_bi_lmt
    }
{% endmacro %}