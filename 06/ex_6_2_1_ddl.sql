DROP TABLE IF EXISTS Company_dependent;
DROP TABLE IF EXISTS Company_works_on;
DROP TABLE IF EXISTS Company_project;
DROP TABLE IF EXISTS Company_dept_locations;
DROP TABLE IF EXISTS Company_employee;
DROP TABLE IF EXISTS Company_department;

CREATE TABLE Company_department (
  dname VARCHAR(255) NOT NULL,
  dnumber INT NOT NULL PRIMARY KEY,
  mgrssn CHAR(11),
  mgrstartdate DATE
);

CREATE TABLE Company_employee (
  fname VARCHAR(255) NOT NULL,
  minit CHAR(1),
  lname VARCHAR(255) NOT NULL,
  ssn INT PRIMARY KEY,
  bdate DATE,
  address VARCHAR(255),
  sex CHAR(1),
  salary DECIMAL(10,2),
  super_ssn INT,
  dno INT NOT NULL,
  FOREIGN KEY (dno) REFERENCES Company_department(dnumber)
);

CREATE TABLE Company_dept_locations (
  dnumber INT NOT NULL,
  dlocation VARCHAR(255) NOT NULL,
  PRIMARY KEY (dnumber, dlocation),
  FOREIGN KEY (dnumber) REFERENCES Company_department(dnumber)
);

CREATE TABLE Company_project (
  pname VARCHAR(255) NOT NULL,
  pnumber INT NOT NULL PRIMARY KEY,
  plocation VARCHAR(255),
  dnum INT NOT NULL,
  FOREIGN KEY (dnum) REFERENCES Company_department(dnumber)
);

CREATE TABLE Company_works_on (
  essn INT NOT NULL,
  pno INT NOT NULL,
  hours INT,
  PRIMARY KEY (essn, pno),
  FOREIGN KEY (essn) REFERENCES Company_employee(ssn),
  FOREIGN KEY (pno) REFERENCES Company_project(pnumber)
);

CREATE TABLE Company_dependent (
  essn INT NOT NULL,
  dependent_name VARCHAR(255) NOT NULL,
  sex CHAR(1),
  bdate DATE,
  relationship VARCHAR(255),
  PRIMARY KEY (essn, dependent_name),
  FOREIGN KEY (essn) REFERENCES Company_employee(ssn)
);
