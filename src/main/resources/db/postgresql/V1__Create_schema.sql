DROP SCHEMA IF EXISTS test_schema CASCADE;

CREATE SCHEMA test_schema;

SET SCHEMA 'test_schema';

CREATE SEQUENCE person_seq MINVALUE 1000;

CREATE TABLE person (
  person_id  INTEGER NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name  VARCHAR(255) NOT NULL,
  email      VARCHAR(255) NOT NULL,
  age        INTEGER NOT NULL,
  PRIMARY KEY (person_id),
  UNIQUE (email)
);

CREATE SEQUENCE employee_seq MINVALUE 1000;

CREATE TABLE employee (
  employee_id INTEGER PRIMARY KEY,
  person_id   INTEGER NOT NULL,
  FOREIGN KEY (person_id) REFERENCES person (person_id)
);

CREATE TABLE position (
  position_code VARCHAR(64) PRIMARY KEY,
  name          VARCHAR(255) NOT NULL,
  description   VARCHAR(255)
);

CREATE TABLE employer (
  employer_code VARCHAR(64) PRIMARY KEY,
  name          VARCHAR(255) NOT NULL,
  description   VARCHAR(255)
);

CREATE TABLE job_history (
  employee_id   INTEGER NOT NULL,
  --   position_code VARCHAR(64),
  employer_code VARCHAR(64) NOT NULL,
  duration      INTEGER,
  --  FOREIGN KEY (position_code) REFERENCES position(position_code),
  FOREIGN KEY (employer_code) REFERENCES employer (employer_code),
  FOREIGN KEY (employee_id) REFERENCES employee (employee_id)
);

ALTER TABLE job_history
  ADD COLUMN position_code VARCHAR(64) NOT NULL;

ALTER TABLE job_history
  ADD /*CONSTRAINT job_history_to_position_fk*/
  FOREIGN KEY (position_code) REFERENCES position (position_code)
  ON DELETE RESTRICT;

CREATE TABLE subscription (
  email VARCHAR(255) PRIMARY KEY,
  name VARCHAR(255) NOT NULL
);