SET SCHEMA test_schema;

DELETE FROM job_history;
DELETE FROM employee;
DELETE FROM person;
DELETE FROM employer;
DELETE FROM position;
DELETE FROM subscription;

INSERT INTO employer (employer_code, name, description)
VALUES ('epam', 'EPAM', 'Epam systems');
INSERT INTO employer (employer_code, name, description)
VALUES ('google', 'Google', 'google.com');
INSERT INTO employer (employer_code, name, description)
VALUES ('ya', 'yandex', 'yandex.ru');
INSERT INTO employer (employer_code, name, description)
VALUES ('abc', 'ABC', 'abc descritpion');


INSERT INTO position (position_code, name, description)
SELECT 'dev', 'Developer', 'Application developer'
UNION ALL SELECT 'QA', 'QA', 'quality assurance'
UNION ALL SELECT 'BA', 'BA', 'business analyst';


INSERT INTO person(person_id, first_name, last_name, email, age)
SELECT 1, 'John', 'Doe', 'john@email', 33
UNION ALL SELECT 2, 'Name2', 'Last name 2', 'name2@email', 44
UNION ALL SELECT 3, 'Name3', 'Last name 3', 'name3@email', 44
;


INSERT INTO employee (employee_id, person_id)
          SELECT 1, (SELECT person_id FROM person WHERE first_name = 'John')
UNION ALL SELECT 2, (SELECT person_id FROM person WHERE first_name = 'Name2')
UNION ALL SELECT 3, (SELECT person_id FROM person WHERE first_name = 'Name3');


INSERT INTO job_history(employee_id, position_code, employer_code, duration)
    SELECT 1, 'dev', 'epam', 10
UNION ALL SELECT 1, 'dev', 'ya', 1
UNION ALL SELECT 2, 'QA', 'google', 2;

INSERT INTO subscription(email, name)
    SELECT 'name1@email', 'name1'
UNION ALL SELECT 'name2@email', 'name2'
UNION ALL SELECT 'name3@email', 'name3'
UNION ALL SELECT 'name4@email', 'name4'