CREATE OR ALTER TRIGGER eliminar_departamento_instead_of
ON Company_department
INSTEAD OF DELETE
AS
BEGIN
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES
        WHERE TABLE_SCHEMA = 'myschema' AND TABLE_NAME = 'mytable'))
        INSERT INTO department_deleted (dname, dnumber, mgrssn, mgrstartdate)
        SELECT dname, dnumber, mgrssn, mgrstartdate
        FROM deleted
    ELSE
    BEGIN
        CREATE TABLE department_deleted (
            dname VARCHAR(255) NOT NULL,
            dnumber INT NOT NULL PRIMARY KEY,
            mgrssn CHAR(11),
            mgrstartdate DATE
        );
        INSERT INTO department_deleted (dname, dnumber, mgrssn, mgrstartdate)
        SELECT dname, dnumber, mgrssn, mgrstartdate
        FROM deleted
    END
END