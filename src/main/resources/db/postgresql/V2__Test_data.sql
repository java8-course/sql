SET SCHEMA 'test_schema';

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
UNION ALL SELECT 3, 'Name3', 'Last name 3', 'name3@email', 43
UNION ALL SELECT 4, 'Name4', 'Last name 4', 'name4@email', 44
UNION ALL SELECT 5, 'Name5', 'Last name 5', 'name5@email', 45
UNION ALL SELECT 6, 'Name6', 'Last name 6', 'name6@email', 46
UNION ALL SELECT 7, 'Name7', 'Last name 7', 'name7@email', 47
-- UNION ALL SELECT 8, 'Name8', 'Last name 8', 'name8@email', 41
UNION ALL SELECT 9, 'Name9', 'Last name 9', 'name9@email', 42
UNION ALL SELECT 10, 'Name10', 'Last name 10', 'name10@email', 34
UNION ALL SELECT 11, 'Name11', 'Last name 11', 'name11@email', 54
UNION ALL SELECT 12, 'Name12', 'Last name 12', 'name12@email', 14
UNION ALL SELECT 13, 'Name13', 'Last name 13', 'name13@email', 24
UNION ALL SELECT 14, 'Name14', 'Last name 14', 'name14@email', 35
-- UNION ALL SELECT 15, 'Name15', 'Last name 15', 'name15@email', 56
UNION ALL SELECT 16, 'Name16', 'Last name 16', 'name16@email', 123
UNION ALL SELECT 17, 'Name17', 'Last name 17', 'name17@email', 44
UNION ALL SELECT 18, 'Name18', 'Last name 18', 'name18@email', 57
-- UNION ALL SELECT 19, 'Name19', 'Last name 19', 'name19@email', 71
-- UNION ALL SELECT 20, 'Name20', 'Last name 20', 'name20@email', 44
UNION ALL SELECT 21, 'Name21', 'Last name 21', 'name21@email', 34
UNION ALL SELECT 22, 'Name22', 'Last name 22', 'name22@email', 64
UNION ALL SELECT 23, 'Name23', 'Last name 23', 'name23@email', 11
;


INSERT INTO employee (employee_id, person_id)
          SELECT 1, (SELECT person_id FROM person WHERE first_name = 'John')
UNION ALL SELECT 2, (SELECT person_id FROM person WHERE first_name = 'Name2')
UNION ALL SELECT 3, (SELECT person_id FROM person WHERE first_name = 'Name3');


INSERT INTO job_history(employee_id, position_code, employer_code, duration)
    SELECT 1, 'dev', 'epam', 10
UNION ALL SELECT 1, 'dev', 'ya', 1
UNION ALL SELECT 2, 'QA', 'google', 2
UNION ALL SELECT 2, 'BA', 'google', 1
UNION ALL SELECT 2, 'QA', 'google', 1
UNION ALL SELECT 2, 'QA', 'abc', 2
UNION ALL SELECT 2, 'dev', 'epam', 2
UNION ALL SELECT 2, 'QA', 'epam', 2
UNION ALL SELECT 2, 'BA', 'abc', 2

UNION ALL SELECT 3, 'BA', 'google', 1
UNION ALL SELECT 3, 'QA', 'google', 1
UNION ALL SELECT 3, 'dev', 'google', 1
UNION ALL SELECT 3, 'dev', 'google', 1
UNION ALL SELECT 3, 'BA', 'google', 1
UNION ALL SELECT 3, 'QA', 'google', 1
;

INSERT INTO subscription(email, name)
    SELECT 'name1@email', 'name1'
UNION ALL SELECT 'name2@email', 'name2'
UNION ALL SELECT 'name3@email', 'name3'
UNION ALL SELECT 'name4@email', 'name4'