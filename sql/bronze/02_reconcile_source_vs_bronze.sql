WITH fonte AS (
  SELECT ano, COUNT(*) AS linhas
  FROM `basedosdados.br_me_caged.microdados_movimentacao`
  WHERE ano BETWEEN 2020 AND 2025
    AND cnae_2_secao = 'F'
  GROUP BY ano
),
bronze AS (
  SELECT ano, COUNT(*) AS linhas
  FROM `projeto1-poc.caged_bronze.movimentacao_construcao`
  GROUP BY ano
)
SELECT
  ano,
  fonte.linhas AS linhas_fonte,
  bronze.linhas AS linhas_bronze,
  fonte.linhas - bronze.linhas AS diferenca
FROM fonte
FULL OUTER JOIN bronze USING (ano)
ORDER BY ano
