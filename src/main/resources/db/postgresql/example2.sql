SELECT *
FROM person
ORDER BY age DESC, first_name /*ASC*/;

SELECT
  *,
  row_number()
  OVER () AS rnum
FROM (
       SELECT
         p.person_id,
         p.first_name,
         p.last_name,
         p.email,
         p.age
       FROM person p
       ORDER BY age DESC, first_name /*ASC*/
     ) AS p
OFFSET 5
LIMIT 10;

SELECT *
FROM person p
  LEFT JOIN person p_next ON p.person_id + 1 = p_next.person_id
WHERE p_next ISNULL;

SELECT p.*
FROM person p
  LEFT JOIN person p_same_age
    ON p.age = p_same_age.age
       AND p.person_id <> p_same_age.person_id
WHERE p_same_age ISNULL;

SELECT
  p.person_id,
  p.first_name,
  p.last_name,
  sum(jh.duration)                 sum_duration,
  count(DISTINCT jh.position_code) positions,
  count(DISTINCT jh.employer_code) employers,
  sum(CASE WHEN jh ISNULL
    THEN 0
      ELSE 1 END)                  records
FROM person p
  LEFT JOIN employee e ON p.person_id = e.person_id
  LEFT JOIN job_history jh ON e.employee_id = jh.employee_id
GROUP BY p.person_id, p.first_name, p.last_name
HAVING sum(CASE WHEN jh ISNULL
  THEN 0
           ELSE 1 END) > 2
ORDER BY sum_duration NULLS LAST;

SELECT p_cool.*
FROM (
       SELECT
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
     ) p_cool
  LEFT JOIN
  (
    SELECT
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
  ) p_cooleer
    ON p_cool.person_id <> p_cooleer.person_id
       AND p_cool.position_code = p_cooleer.position_code
       AND p_cool.sum_duration < p_cooleer.sum_duration
WHERE p_cooleer ISNULL;


WITH cool_person AS (
    SELECT
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
)
SELECT p_cool.*
FROM cool_person p_cool
  LEFT JOIN cool_person AS p_cooleer
    ON p_cool.person_id <> p_cooleer.person_id
       AND p_cool.position_code = p_cooleer.position_code
       AND p_cool.sum_duration < p_cooleer.sum_duration
WHERE p_cooleer ISNULL;
