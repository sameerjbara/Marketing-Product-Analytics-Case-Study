# Marketing & Product Analytics Portfolio Project

**SQL · Python · Excel · Data Visualization**

A marketing and product analytics project focused on evaluating user acquisition, retargeting, early-stage ROAS, and product feature performance in *Dice Dreams*.

## Project Overview

This project applies cohort analysis, marketing KPIs, and SQL-based methods to explore acquisition efficiency, user reactivation, campaign measurement, and product engagement.

### User Acquisition Performance
Reviewed acquisition performance across install cohorts, countries, platforms, and campaigns using:
- Cost per install (CPI)
- D30 return on ad spend (ROAS)
- D7 retention
- D30 payer rate and ARPU

The analysis framework supports comparisons across acquisition segments and helps assess performance using consistent marketing metrics.

### Retargeting Effectiveness
Developed a measurement framework for campaigns targeting users who installed the game but had not logged in for at least seven days.

The evaluation covers reactivation, engagement after return, retention, revenue, and campaign efficiency. It also considers the limitations of measuring incremental impact without a randomized holdout group.

### Early-Stage ROAS Benchmarking
Explored D0, D3, and D7 ROAS as early indicators for evaluating acquisition cohorts against a target of **100% ROAS by D360**.

The approach considers how early-ROAS thresholds can be assessed alongside cohort volume and the reliability of longer-term outcomes.

### Product Feature Impact
Designed an analytical approach to investigate a feature launched in *Dice Dreams* on **February 18, 2025**, which becomes visible at Level 20 and opens at Level 25.

The analysis plan considers:
- Progression to Levels 20, 25, 30, 40, and beyond
- Engagement and rolls around Level 25
- D1, D7, D14, and D30 retention
- Revenue and conversion from non-paying to paying users

SQL datasets are structured to support analysis of level progression, engagement around Level 25, and post-Level-25 payer conversion.

## Analytical Considerations

- Compare cohorts using consistent observation windows.
- Account for platform, country, media source, and campaign mix.
- Apply volume and eligibility checks when interpreting cohort-level metrics.
- Distinguish observed pre/post differences from causal impact.
- Use a `feature_opened` event with `user_id` and `event_timestamp` to identify actual feature exposure rather than using Level 25 attainment as a proxy.

## Tools & Skills

- **Python:** pandas, NumPy
- **Visualization:** Matplotlib, Seaborn
- **SQL:** CTEs, aggregation, conditional metrics, cohort analysis, and date-window logic
- **Analytics:** Acquisition performance, ROAS benchmarking, reactivation, retention, monetization, segmentation, and observational analysis

## Project Files

| File | Description |
|---|---|
| `UA_performance.ipynb` | User acquisition analysis |
| `Retargeting_Activity.ipynb` | Retargeting measurement |
| `early_stage_ROAS_benchmarks.ipynb` | Early ROAS benchmark analysis |
| `sql_q.sql` | SQL for the product-feature analysis datasets |
| `product_feature.docx` | Product feature exploration and validation plan |
