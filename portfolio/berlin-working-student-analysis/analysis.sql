-- Berlin working-student data/analytics sample
-- Run with SQLite after loading roles.csv and role_skills.csv.

-- 1. Active roles by employment type
SELECT employment_type, COUNT(*) AS role_count
FROM roles
WHERE status = 'Active'
GROUP BY employment_type
ORDER BY role_count DESC;

-- 2. Most frequent skills across the sample
SELECT skill, COUNT(DISTINCT role_id) AS roles_requesting_skill,
       ROUND(100.0 * COUNT(DISTINCT role_id) / (SELECT COUNT(*) FROM roles WHERE status = 'Active'), 1) AS pct_of_active_roles
FROM role_skills
JOIN roles USING (role_id)
WHERE roles.status = 'Active'
GROUP BY skill
ORDER BY roles_requesting_skill DESC, skill;

-- 3. Required versus preferred technical skills
SELECT requirement_type, skill_group, COUNT(*) AS skill_mentions
FROM role_skills
GROUP BY requirement_type, skill_group
ORDER BY requirement_type, skill_group;

-- 4. Roles that request both SQL and Python
SELECT r.title, r.company, r.source_url
FROM roles r
WHERE r.status = 'Active'
  AND EXISTS (SELECT 1 FROM role_skills s WHERE s.role_id = r.role_id AND s.skill = 'SQL')
  AND EXISTS (SELECT 1 FROM role_skills s WHERE s.role_id = r.role_id AND s.skill = 'Python');

-- 5. Roles with reporting/dashboard work
SELECT DISTINCT r.title, r.company
FROM roles r
JOIN role_skills s USING (role_id)
WHERE r.status = 'Active'
  AND (s.skill IN ('Reports and Data Apps', 'Power BI', 'Data analytics and reporting'));
