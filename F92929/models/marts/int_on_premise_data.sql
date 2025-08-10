-- Purpose: Securely connect and ingest data from on-premise databases like Oracle, SQL Server, and MySQL

WITH on_premise_data AS (
  SELECT
    oracle_field AS oracle_field,
    sql_server_field AS sql_server_field,
    mysql_field AS mysql_field,
    COALESCE(expression_transformation(oracle_field), 'default_value') AS normalized_oracle_field,
    COALESCE(expression_transformation(sql_server_field), 'default_value') AS normalized_sql_field,
    COALESCE(expression_transformation(mysql_field), 'default_value') AS normalized_mysql_field
  FROM {{ source('Snowflake', 'on_premise_data') }}
)

SELECT
  oracle_field,
  sql_server_field,
  mysql_field,
  normalized_oracle_field,
  normalized_sql_field,
  normalized_mysql_field
FROM on_premise_data