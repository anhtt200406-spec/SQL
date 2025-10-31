WITH skills_demand AS(
SELECT 
    COUNT(skills_job_dim.job_id) AS demand_count,
    skills_dim.skills,
    skills_dim.skill_id
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND job_work_from_home IS TRUE AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
)
,
avg_salary_table1 AS (
    SELECT 
    ROUND(AVG(salary_year_avg), 0) AS avg_salary,
    skills_dim.skills,
    skills_dim.skill_id
FROM 
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
GROUP BY skills_dim.skill_id
)
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    avg_salary,
    demand_count
FROM
    skills_demand
INNER JOIN avg_salary_table1 ON skills_demand.skill_id = avg_salary_table1.skill_id
WHERE demand_count > 10
ORDER BY
avg_salary DESC,
demand_count DESC 
LIMIT 25;

--rewrite more concisely
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM
    job_postings_fact
INNER JOIN skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE job_title_short = 'Data Analyst' AND salary_year_avg IS NOT NULL
AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT
    25

