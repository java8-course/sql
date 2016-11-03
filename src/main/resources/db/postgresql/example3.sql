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
  --                     ORDER BY jh.position_code, sum_duration DESC
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
                       ORDER BY e.sum_duration DESC )          AS rank_over_all,
                     avg(e.sum_duration)
                     OVER ()                             AS avg_over_all
                   FROM experience e
                   ORDER BY e.position_code, rank_over_position
  )
SELECT p.*
FROM positioned p
WHERE p.rank_over_position <= 3;




WITH data as (
  SELECT 1 AS a
  UNION ALL SELECT 2
  UNION ALL SELECT 3
  UNION ALL SELECT 4
  UNION ALL SELECT 5
  UNION ALL SELECT 6
  UNION ALL SELECT 7
  UNION ALL SELECT 8
  UNION ALL SELECT 9
  UNION ALL SELECT 10
),
    data_with_i AS (
      SELECT a, 2 as i
      FROM data
  )
SELECT
  a,
  sum(i) OVER (ORDER BY a DESC) as subsum,
  sum(a) OVER (ORDER BY a ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) as near
FROM data_with_i
ORDER BY a DESC
;

WITH RECURSIVE data as (
  SELECT
    1 as a,
    2 as i

  UNION ALL
  SELECT
    a + 1 as a,
    i
  FROM data
  WHERE a < 20
)
SELECT
  a,
  sum(i) OVER (ORDER BY a DESC) as subsum,
  sum(a) OVER (ORDER BY a ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) as near
FROM data
ORDER BY a DESC
;

CREATE TABLE tree_table (
  id INTEGER PRIMARY KEY,
  parent INTEGER,
  FOREIGN KEY (parent) REFERENCES tree_table(id)
);

INSERT INTO tree_table(id, parent)
  SELECT
    1                     AS id,
    cast(NULL AS INTEGER) AS parent
  UNION ALL SELECT
              2 AS id,
              1 AS parent
  UNION ALL SELECT
              4 AS id,
              2 AS parent
  UNION ALL SELECT
              5 AS id,
              2 AS parent
  UNION ALL SELECT
              3 AS id,
              1 AS parent
  UNION ALL SELECT
              11                    AS id,
              cast(NULL AS INTEGER) AS parent
  UNION ALL SELECT
              12 AS id,
              11 AS parent
  UNION ALL SELECT
              14 AS id,
              12 AS parent
  UNION ALL SELECT
              15 AS id,
              12 AS parent
  UNION ALL SELECT
              13 AS id,
              11 AS parent;

WITH RECURSIVE res AS (
  SELECT 11 AS id, cast(NULL AS INTEGER) parent
  UNION ALL
  SELECT tt.id, tt.parent
  FROM res
    JOIN tree_table as tt ON tt.parent = res.id
)
SELECT *
FROM res
WHERE parent IS NOT NULL
;