from pathlib import Path
import sqlite3
import pandas as pd

ROOT = Path(__file__).resolve().parent
roles = pd.read_csv(ROOT / 'roles.csv')
skills = pd.read_csv(ROOT / 'role_skills.csv')

# Basic quality checks
assert roles['role_id'].is_unique
assert set(roles['status']) == {'Active'}
assert skills['role_id'].isin(roles['role_id']).all()

# Load into SQLite and run reproducible queries
con = sqlite3.connect(':memory:')
roles.to_sql('roles', con, index=False)
skills.to_sql('role_skills', con, index=False)

skill_summary = pd.read_sql_query('''
    SELECT skill, COUNT(DISTINCT role_id) AS roles_requesting_skill,
           ROUND(100.0 * COUNT(DISTINCT role_id) /
                 (SELECT COUNT(*) FROM roles WHERE status = 'Active'), 1) AS pct_of_active_roles
    FROM role_skills JOIN roles USING (role_id)
    WHERE roles.status = 'Active'
    GROUP BY skill
    ORDER BY roles_requesting_skill DESC, skill
''', con)

role_summary = roles[['title', 'company', 'employment_type', 'location', 'status']]

skill_summary.to_csv(ROOT / 'skill_summary.csv', index=False)
role_summary.to_csv(ROOT / 'role_summary.csv', index=False)

print(f'Active roles analyzed: {len(roles)}')
print('\nSkill frequency:')
print(skill_summary.to_string(index=False))
print('\nQuality checks passed: unique role IDs, valid skill links, active-only sample.')
