# caged-construction-analytics

Analytics engineering project on Brazilian formal employment data (Novo CAGED) for the construction sector. Built in BigQuery with a medallion architecture and dbt, ending in a BigQuery vs Athena proof of concept.

## Questions this project answers

- How does formal employment in construction evolve by state, occupation and worker profile?
- What does it cost, and how fast is it, to run the same model in two cloud warehouses?
- How do you prove a migration between them did not change a single number?

## Data

| Item | Value |
|---|---|
| Source | Base dos Dados, `basedosdados.br_me_caged.microdados_movimentacao` (public, BigQuery) |
| Grain | One employment movement (a hire or a separation) |
| Scope | CNAE section F (construction), 2020 to 2025 |
| Rows in scope | 24,596,998 |

2026 is out of scope: the source applies row-level security and only January and February are visible. A partial year would distort year-over-year comparisons.

## Architecture

    Base dos Dados (public)
            |
            v
    bronze  raw copy of the scoped data, partitioned by year, clustered by month and state
            |
            v
    silver  typed, cleaned, codes decoded with the source dictionary        (planned)
            |
            v
    gold    star schema with conformed dimensions, modeled in dbt            (planned)
            |
            v
    POC     same model on Athena, cost and query time compared, reconciled   (planned)

## Status

**Done**
- [x] Source profiled through INFORMATION_SCHEMA: 25 columns, 261.7M rows, partitioned by `ano`, clustered by `mes` and `sigla_uf`
- [x] Bronze table created in my own project (`sql/bronze/01_create_movimentacao_construcao.sql`)
- [x] Source vs bronze reconciliation by year: zero difference in all 6 years (`sql/bronze/02_reconcile_source_vs_bronze.sql`)

**Next**
- [ ] Silver layer: typing, cleaning, decoding codes
- [ ] Gold layer in dbt: star schema and tests
- [ ] Athena version and BigQuery vs Athena comparison

## Key decisions

| Decision | Why |
|---|---|
| Copy the scoped data into a bronze table instead of querying the public source directly | The source uses row-level security, so BigQuery hides bytes processed and billed and dry runs always show 0 B. In my own table, cost is visible and controllable. |
| Same partitioning and clustering as the source | Keeps queries filtered by year, month and state cheap downstream. |
| Reconcile by year with a FULL OUTER JOIN | Catches years present on only one side, which an INNER JOIN would hide. |

## Repository structure

    sql/
      bronze/
        01_create_movimentacao_construcao.sql
        02_reconcile_source_vs_bronze.sql
