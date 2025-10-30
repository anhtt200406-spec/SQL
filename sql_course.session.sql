
SELECT
    COUNT(DISTINCT job_id) AS total_job_postings
FROM
    job_postings_fact
INNER JOIN company_dim
    ON job_postings_fact.company_id = skills_dim.company_id
GROUP BY
    company_dim.skill_id
LIMIT 20;
