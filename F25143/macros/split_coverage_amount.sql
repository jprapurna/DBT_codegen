{% macro split_coverage_amount(cvg_amt) %}
    {% set v_cvg_amt = cvg_amt | replace(',', '') %}
    {% set v_cvg_amt_parts = v_cvg_amt | length - v_cvg_amt | replace('/', '') | length + 1 %}
    {% set v_cvg_amt_part1_pos = v_cvg_amt.find('/') %}
    {% set v_cvg_amt_part2_pos = v_cvg_amt.find('/', v_cvg_amt_part1_pos + 1) %}
    {% set amount_field1 = 
        (v_cvg_amt_parts == 1) | v_cvg_amt |
        (v_cvg_amt_parts == 2) | v_cvg_amt[:v_cvg_amt_part1_pos] |
        (v_cvg_amt_parts == 3) | v_cvg_amt[:v_cvg_amt_part1_pos] |
        '0' %}
    {% set amount_field2 = 
        (v_cvg_amt_parts == 1) | '0' |
        (v_cvg_amt_parts == 2) | v_cvg_amt[v_cvg_amt_part1_pos + 1:] |
        (v_cvg_amt_parts == 3) | v_cvg_amt[v_cvg_amt_part1_pos + 1:v_cvg_amt_part2_pos] |
        '0' %}
    {% set amount_field3 = 
        (v_cvg_amt_parts == 1) | '0' |
        (v_cvg_amt_parts == 2) | '0' |
        (v_cvg_amt_parts == 3) | v_cvg_amt[v_cvg_amt_part2_pos + 1:] |
        '0' %}
    {% set cvg_amt_1_decimal = amount_field1 | float %}
    {% set cvg_amt_2_decimal = amount_field2 | float %}
    {% set cvg_amt_3_decimal = amount_field3 | float %}
    {% set cvg_amt_no_of_parts = v_cvg_amt_parts %}
    {% set src_cvg_amt = v_cvg_amt %}
    return {
        "cvg_amt_1_decimal": cvg_amt_1_decimal,
        "cvg_amt_2_decimal": cvg_amt_2_decimal,
        "cvg_amt_3_decimal": cvg_amt_3_decimal,
        "cvg_amt_no_of_parts": cvg_amt_no_of_parts,
        "src_cvg_amt": src_cvg_amt
    }
{% endmacro %}