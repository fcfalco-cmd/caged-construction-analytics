CREATE SCHEMA `projeto1-poc.caged_gold`
OPTIONS (location = 'US');

CREATE TABLE `projeto1-poc.caged_gold.dim_tempo` AS
SELECT
  data_competencia,
  EXTRACT(YEAR FROM data_competencia) AS ano,
  EXTRACT(MONTH FROM data_competencia) AS mes,
  EXTRACT(QUARTER FROM data_competencia) AS trimestre,
  IF(EXTRACT(MONTH FROM data_competencia) <= 6, 1, 2) AS semestre,
  FORMAT_DATE('%Y-%m', data_competencia) AS ano_mes
FROM UNNEST(GENERATE_DATE_ARRAY('2020-01-01', '2025-12-01', INTERVAL 1 MONTH)) AS data_competencia
