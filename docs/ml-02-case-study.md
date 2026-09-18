# ML-02 Case Study — Research Question and Provisional Lane

## Context

As part of the FlyRank AI Machine Learning Internship, I completed ML-02: Research Question and Provisional Lane. The assignment focused on framing a useful machine-learning problem before building a model.

## Lane

**Refresh / Content Opportunity Scoring**

The proposed use case is to help an SEO or content editor decide which content pages should be reviewed first. The intended output is a ranked review list with a priority score and an explanation, not an automatic publishing decision.

## Initial evidence

The anonymized starter dataset contains 30,000 content rows and 44 columns. A first inspection found:

- Median 90-day impressions: 731
- Median 90-day sessions: 7
- Downward trend direction: 54.2% of rows

These observations suggest that content visibility and freshness are reasonable areas for further investigation. They do not prove that refreshing a page will improve performance.

## What the work can and cannot claim

The notebook can describe observed relationships among visibility, traffic, freshness, click-through rate, engagement, and trend direction. It can support a directional review ranking and help prioritise future experiments.

It cannot prove causation, predict Google’s ranking decisions, or justify automatically changing content without human review.

## Technical evidence

- Python and pandas for data inspection.
- Reproducible loading from the public anonymized dataset.
- Explicit separation between code cells and written reasoning.
- Notebook outputs saved in GitHub.

- [Open the completed notebook](../work/notebooks/w01_research_question.ipynb)
- [Open the internship repository](https://github.com/labanaprince72-a11y/internship)
- [Open the verified ML-02 commit](https://github.com/labanaprince72-a11y/internship/commit/f4e914af551ff03783625e5473d947257185bcb9)

## Reflection

The main lesson was that useful machine-learning work begins with decision framing, data discovery, and honest boundaries. A model should support a clearly defined human decision rather than replace the decision before the evidence is strong enough.

The dataset is anonymized and contains no private client data. Results are directional and should be treated as decision support.
