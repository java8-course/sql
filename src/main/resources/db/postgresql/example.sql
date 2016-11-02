-- SELECT e.*, p.*
-- FROM employee AS e,
--   person AS p
-- WHERE e.person_id = p.person_id;


-- SELECT
--   e.*,
--   p.first_name,
--   jh.duration,
--   pos.name  AS position,
--   empl.name AS employer
-- FROM employee AS e,
--   person AS p,
--   job_history AS jh,
--   position AS pos,
--   employer AS empl
-- WHERE e.person_id = p.person_id
--       AND e.employee_id = jh.employee_id
--       AND jh.employer_code = empl.employer_code
--       AND jh.position_code = pos.position_code;

-- SELECT
--   e.*,
--   p.first_name,
--   jh.duration,
--   pos.name  AS position,
--   empl.name AS employer
-- FROM employee AS e
-- INNER JOIN person AS p ON e.person_id = p.person_id
-- /*INNER*/ JOIN job_history AS jh ON e.employee_id = jh.employee_id
-- /*INNER*/ JOIN position AS pos ON jh.position_code = pos.position_code
-- /*INNER*/ JOIN employer AS empl ON jh.employer_code = empl.employer_code
-- ;

-- SELECT
--   e.employee_id, e.person_id,
--   jh.employer_code,
--   jh.position_code,
--   jh.duration
-- FROM employee AS e
-- JOIN job_history AS jh ON e.employee_id = jh.employee_id
--
-- UNION ALL
-- SELECT e.employee_id, e.person_id,
--   NULL AS employer_code,
--   NULL AS position_code,
--   NULL AS duration
-- FROM employee AS e
-- WHERE NOT exists(SELECT 1 FROM job_history AS jh WHERE jh.employee_id = e.employee_id)
-- ;

-- SELECT
--   e.*,
--   p.first_name,
--   CASE WHEN jh ISNULL
--     THEN 0
--   ELSE jh.duration END AS duration,
--   pos.name             AS position,
--   empl.name            AS employer
-- FROM employee AS e
--   INNER JOIN person AS p ON e.person_id = p.person_id
--   LEFT OUTER JOIN job_history AS jh ON e.employee_id = jh.employee_id
--   LEFT /*OUTER*/ JOIN position AS pos ON jh.position_code = pos.position_code
--   LEFT /*OUTER*/ JOIN employer AS empl ON jh.employer_code = empl.employer_code;

SELECT
  e.employee_id,
  e.person_id,
  jh.employer_code,
  jh.position_code,
  jh.duration
FROM job_history AS jh
  RIGHT JOIN employee AS e ON e.employee_id = jh.employee_id;

SELECT
  p.email,
  p.first_name AS name
FROM person AS p
WHERE NOT exists(SELECT 1
                 FROM subscription s
                 WHERE p.email = s.email)

UNION ALL
SELECT
  p.email,
  p.first_name AS name
FROM person AS p
  JOIN subscription AS s ON p.email = s.email

UNION ALL
SELECT
  s.email,
  s.name
FROM subscription AS s
WHERE NOT exists(SELECT 1
                 FROM person p
                 WHERE p.email = s.email);

SELECT
  CASE WHEN p ISNULL
    THEN s.email
  ELSE p.email END      AS email,
  CASE WHEN p ISNULL
    THEN s.name
  ELSE p.first_name END AS name
FROM person AS p
  FULL JOIN subscription AS s ON p.email = s.email
;

SELECT
  e.*,
  p.first_name,
  CASE WHEN jh ISNULL
    THEN 0
  ELSE jh.duration END AS duration,
  pos.name             AS position,
  empl.name            AS employer
FROM person AS p
  JOIN employee AS e ON e.person_id = p.person_id
  LEFT JOIN job_history AS jh USING (employee_id)
  LEFT JOIN position AS pos USING (position_code)
  LEFT JOIN employer AS empl USING (employer_code)
--   NATURAL LEFT JOIN job_history AS jh
--   NATURAL LEFT JOIN position AS pos
--   NATURAL LEFT JOIN employer AS empl
;



-- SELECT *
-- FROM person
-- WHERE age > 35;