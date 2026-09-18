# Berlin Working-Student Data & Analytics Job Analysis

## Overview

This project uses SQL and Python to examine a small sample of active Berlin student and intern roles related to data analytics, data science, AI, and reporting.

The goal was not to claim a complete view of the Berlin market. It was to practice turning real job postings into a structured dataset, answering a focused question, and translating the result into a practical learning plan.

## Key findings

- SQL appeared in 3 of 4 roles (75%).
- Python appeared in 3 of 4 roles (75%).
- English was requested in all 4 roles.
- The roles combined analysis/reporting work with communication, research, documentation, and stakeholder-facing responsibilities.

## Career implication

For an Applied AI student targeting data analytics and BI roles, the evidence supports prioritising:

1. SQL fundamentals and practical querying.
2. Python with pandas for cleaning and analysis.
3. A reporting tool such as Power BI or Tableau.
4. Basic statistics and exploratory data analysis.
5. Git/GitHub and clear project documentation.
6. English communication and the ability to explain findings.

## Reproducibility

- `roles.csv` — role-level dataset.
- `role_skills.csv` — normalised skill mentions.
- `role_summary.csv` — summary output by role.
- `skill_summary.csv` — summary output by skill.
- `analysis.sql` — SQL queries used for the analysis.
- `analyze.py` — pandas and SQLite analysis script.
- `job_market_report.html` — visual report.

Run:

```bash
python analyze.py
```

## Scope and limitations

- Four active public postings were checked on 7 September 2026.
- Official company applicant-tracking pages were prioritised where available.
- Archived or expired postings were excluded from the main dataset.
- The sample is small and directional; percentages should not be generalised to all Berlin jobs.
- Job postings describe employer requirements, not guaranteed day-to-day work.

## Sources

- KNIME: https://knime.jobs.personio.de/job/2766994?language=en
- JustWatch: https://jobs.lever.co/justwatch/6c3c41c8-c9e9-4187-a325-049d54097009
- Corning: https://corningjobs.corning.com/job/Berlin-IT-Working-Student-%28Documentation%2C-Data-Analytics-&-Project-Management%29-%28mfd%29-10117/1426764000/
- OMMAX: https://ommax.jobs.personio.de/job/2543869
- Market overview: https://www.workingstudentjobs.de/de/jobs/in/berlin/tech/data-analytics
