WITH experience AS (SELECT
                      p.person_id,
                      p.first_name,
                      p.last_name,
                      jh.position_code,
                      sum(jh.duration)                 sum_duration,
                      count(DISTINCT jh.employer_code) employers,
                      sum(CASE WHEN jh ISNULL
                        THEN 0
                          ELSE 1 END)                  records
                    FROM person p
                      JOIN employee e ON p.person_id = e.person_id
                      JOIN job_history jh ON e.employee_id = jh.employee_id
                    GROUP BY p.person_id, p.first_name, p.last_name, jh.position_code
                    ORDER BY jh.position_code, sum_duration DESC
),
    positioned AS (SELECT
                     e.person_id,
                     e.first_name,
                     e.last_name,
                     e.position_code,
                     e.sum_duration,
                     rank()
                     OVER (PARTITION BY e.position_code
                       ORDER BY e.sum_duration DESC)     AS rank_over_position,
                     avg(e.sum_duration)
                     OVER (PARTITION BY e.position_code) AS avg_over_position,
                     rank()
                     OVER (
                       ORDER BY e.sum_duration)          AS rank_over_all,
                     avg(e.sum_duration)
                     OVER ()                             AS avg_over_all
                   FROM experience e
                   ORDER BY e.position_code, rank_over_position
  )
SELECT p.*
FROM positioned p
WHERE p.rank_over_position <= 3

;