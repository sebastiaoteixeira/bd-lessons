-- Drop tables if they already exist (order doesn't matter here)
DROP TABLE IF EXISTS emp_DEPENDENT;
DROP TABLE IF EXISTS emp_WORKS_ON;
DROP TABLE IF EXISTS emp_PROJECT;
DROP TABLE IF EXISTS emp_DEPT_LOCATIONS;
DROP TABLE IF EXISTS emp_EMPLOYEE;
DROP TABLE IF EXISTS emp_DEPARTMENT;

-- 1. Department table (independent table)
CREATE TABLE emp_DEPARTMENT (
  Dname VARCHAR(255) NOT NULL,
  Dnumber INT NOT NULL PRIMARY KEY,
  Mgrssn CHAR(11),
  Mgrstartdate DATE
);

-- 2. Employee table (references Department.Dnumber)
CREATE TABLE emp_EMPLOYEE (
  Fname VARCHAR(255) NOT NULL,
  Minit CHAR(1),
  Lname VARCHAR(255) NOT NULL,
  Ssn INT PRIMARY KEY,
  Bdate DATE,
  Address VARCHAR(255),
  Sex CHAR(1),
  Salary DECIMAL(10,2),
  Superssn INT,
  Dno INT NOT NULL,
  FOREIGN KEY (Dno) REFERENCES emp_DEPARTMENT(Dnumber)
);

-- 3. Department Locations table (referenced by Department.Dnumber)
CREATE TABLE emp_DEPT_LOCATIONS (
  Dnumber INT NOT NULL,
  Dlocation VARCHAR(255) NOT NULL,
  PRIMARY KEY (Dnumber, Dlocation),
  FOREIGN KEY (Dnumber) REFERENCES emp_DEPARTMENT(Dnumber)
);

-- 4. Project table (referenced by Department.Dnumber)
CREATE TABLE emp_PROJECT (
  Pname VARCHAR(255) NOT NULL,
  Pnumber INT NOT NULL PRIMARY KEY,
  Plocation VARCHAR(255),
  Dnum INT NOT NULL,
  FOREIGN KEY (Dnum) REFERENCES emp_DEPARTMENT(Dnumber)
);

-- 5. Works On table (references Employee.Ssn and Project.Pnumber)
CREATE TABLE emp_WORKS_ON (
  Essn INT NOT NULL,
  Pno INT NOT NULL,
  Hours INT,
  PRIMARY KEY (Essn, Pno),
  FOREIGN KEY (Essn) REFERENCES emp_EMPLOYEE(Ssn),
  FOREIGN KEY (Pno) REFERENCES emp_PROJECT(Pnumber)
);

-- 6. Dependent table (references Employee.Ssn)
CREATE TABLE emp_DEPENDENT (
  Essn INT NOT NULL,
  Dependent_name VARCHAR(255) NOT NULL,
  Sex CHAR(1),
  Bdate DATE,
  Relationship VARCHAR(255),
  PRIMARY KEY (Essn, Dependent_name),
  FOREIGN KEY (Essn) REFERENCES emp_EMPLOYEE(Ssn)
);
