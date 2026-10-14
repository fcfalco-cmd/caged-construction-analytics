CREATE TABLE `projeto1-poc.caged_bronze.movimentacao_construcao`
PARTITION BY RANGE_BUCKET(ano, GENERATE_ARRAY(2020, 2027, 1))
CLUSTER BY mes, sigla_uf
AS
SELECT
  *,
  CURRENT_TIMESTAMP() AS _ingerido_em
FROM `basedosdados.br_me_caged.microdados_movimentacao`
WHERE ano BETWEEN 2020 AND 2025
  AND cnae_2_secao = 'F'
