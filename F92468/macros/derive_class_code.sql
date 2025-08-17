{% macro derive_class_code(st_abbr, age, gendr, mrtl_stat, auto_use_cd, soi_typ, acctng_lob, cvg_typ_cd, mlt_car_ind) %}
CASE
  WHEN {{ st_abbr }} IS NULL OR {{ age }} IS NULL OR {{ gendr }} IS NULL OR {{ mrtl_stat }} IS NULL THEN 'UNKNOWN'
  WHEN {{ auto_use_cd }} = 'P' AND {{ soi_typ }} = 'PRIVATE' THEN 'PRIVATE_CLASS'
  WHEN {{ acctng_lob }} = 'AUTO' AND {{ cvg_typ_cd }} = 'LIABILITY' THEN 'AUTO_LIABILITY_CLASS'
  WHEN {{ mlt_car_ind }} = 'Y' THEN 'MULTI_CAR_CLASS'
  ELSE 'DEFAULT_CLASS'
END
{% endmacro %}