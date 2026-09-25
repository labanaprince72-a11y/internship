# Capstone Report — Refresh / Content Opportunity Scoring

- **Author:** Prince Nayak
- **Lane:** Refresh / Content Opportunity Scoring
- **Repo:** https://github.com/labanaprince72-a11y/internship
- **Date:** 2026-09-25

## 0. Abstract

This capstone asks which observable content signals can support a transparent, human-reviewed queue for content refresh decisions without using retrospective outcomes as production features. It uses FlyRank's anonymized 30,000-row starter release, where each row represents a pseudonymized content item with trailing-90-day measures and static metadata. I compared a transparent visibility/position/CTR/freshness baseline with logistic regression and random forest models using nine prior-window or static fields, evaluating primarily with a 75/25 client-grouped holdout. On the grouped holdout, the selected logistic model reached Precision@50 of 0.62 versus 0.44 for the transparent baseline, with ROC-AUC 0.535; this is a ranking result in one snapshot, not causal evidence. The output is a 30,000-row action queue with reason codes, priority tiers, next steps, effort/value proxies, and human-review gates for editorial decision support.

## 1. Problem framing

The supported decision is which anonymized content items an editor or SEO reviewer should inspect first and what kind of review should happen next. The unit of analysis is one content item. The output is a ranked queue with a priority tier, reason code, recommended next step, estimated effort, value band, and human-review gate. A wrong call can waste editorial time or cause an unnecessary content change, so the queue favors transparent, reversible review rather than automatic action. ML helps by comparing observable signals consistently and making the trade-offs inspectable; it does not replace editorial judgment.

## 2. Data safety

The analysis uses `data/raw/content_refresh_anonymized.csv`, a 30,000-row starter release with 44 columns. It is a single snapshot with trailing-90-day performance measures and static content metadata. No client names, domains, URLs, raw queries, or credentials are used. `client_id` is used only to create a grouped holdout and is not a model feature. The audit target is `observed_decline_outcome = (trend_direction == "down")`; `trend_direction`, `trend_pct`, `observed_decline_outcome`, and `is_declining_label` are excluded from final features and action exports because they are retrospective or label-derived. No client-identifying details appear in `work/`.

## 3. Baseline

The Week-4 transparent baseline adds interpretable points for visible impressions, position 1–20 with low CTR, and stale update age. It uses `impressions_90d`, `avg_position`, `ctr`, and `days_since_last_update`, with no fitted weights and no retrospective label fields. On the grouped client-holdout, its Precision@50 is 0.44. It is a fair comparison because it ranks the same held-out rows and is evaluated with the same Precision@K metrics as the models.

## 4. Model / analysis

The selected model is class-balanced logistic regression with median imputation, missingness indicators, and standardization. The nine features are `impressions_prev_30d`, `clicks_prev_30d`, `sessions_prev_30d`, `content_age_days`, `days_since_last_update`, `search_volume`, `competition`, `word_count`, and `char_count`. The target is an audit-only retrospective indicator of whether the row's observed trend direction was down; it is not a deployable future label in this snapshot. A random forest was also tested, but logistic regression was selected by grouped-holdout Precision@50 among the tested models.

## 5. Evaluation

The primary split is a 75/25 `GroupShuffleSplit` by `client_id`, `random_state=42`, with 24 train clients and 8 test clients and zero client overlap. The grouped holdout's test base rate is 51.7%. The selected logistic model reached Precision@10 0.40, Precision@50 0.62, Precision@100 0.61, ROC-AUC 0.535, and threshold accuracy 0.532. The transparent baseline reached Precision@10 0.60, Precision@50 0.44, Precision@100 0.43, and ROC-AUC 0.500. A random split reached a higher logistic Precision@50 of 0.68 and ROC-AUC 0.642, but it allows repeated-client patterns and is not the primary estimate. An intentional target-copy canary reached ROC-AUC 1.0, confirming that the leakage test would expose a direct label copy; that canary was excluded from the final feature list.

## 6. Interpretation

The largest held-out permutation-importance association was `content_age_days`, followed by much smaller contributions from clicks, word count, sessions, search volume, and prior impressions. These are predictive associations in this slice, not causal drivers. The model's modest ROC-AUC and grouped performance show that ranking is useful but uncertain. The negative result is important: the data does not justify saying that aging content, changing a snippet, or refreshing a page will cause better search performance.

## 7. Recommendation

The action playbook ranks the transparent Week-4 queue into four tiers: 2,182 P1 rows for review this week, 12,008 P2 rows for the next cycle, 6,673 P3 rows for monitoring or sampling, and 9,137 P4 rows to hold without new evidence. Each row includes a reason code, next step, estimated effort, captured click-equivalent value proxy, and a human-review gate. The `clicks × CPC` amount is explicitly a captured click-equivalent value proxy, not revenue.

FlyRank editors should first confirm that the page is live, the owner is known, the search intent and competition are understood, seasonality and sitewide context have been checked, facts/citations/brand/legal constraints are safe, cannibalization and technical blockers are understood, and the success metric plus follow-up window are recorded. The score must not autonomously publish, rewrite, delete, redirect, change indexing, make causal claims, or override editorial, legal, accessibility, or client constraints.

## 8. Reproducibility

From a fresh clone:

```bash
pip install -r requirements.txt
jupyter nbconvert --to notebook --execute work/notebooks/w04_baseline_score.ipynb --output work/notebooks/w04_baseline_score.ipynb --ExecutePreprocessor.timeout=600
jupyter nbconvert --to notebook --execute work/notebooks/w05_model.ipynb --output work/notebooks/w05_model.ipynb --ExecutePreprocessor.timeout=600
jupyter nbconvert --to notebook --execute work/notebooks/w06_validation_audit.ipynb --output work/notebooks/w06_validation_audit.ipynb --ExecutePreprocessor.timeout=600
jupyter nbconvert --to notebook --execute work/notebooks/w07_action_playbook.ipynb --output work/notebooks/w07_action_playbook.ipynb --ExecutePreprocessor.timeout=600
jupyter nbconvert --to notebook --execute work/notebooks/capstone.ipynb --output work/notebooks/capstone.ipynb --ExecutePreprocessor.timeout=600
```

The capstone uses `random_state=42`, records the primary grouped client holdout, and writes `work/outputs/ml_capstone_metrics.json`. Figures are committed under `work/figures/`. The large action queue CSV is regenerated by ML-10 and intentionally ignored by git.

## 9. Acknowledgments & data credit

Built on the [FlyRank ML Internship dataset](https://flyrank.ai). The public repository and paper contain aggregate findings and decision-support guidance only; they do not expose private client identifiers, domains, URLs, queries, credentials, or raw exports.
