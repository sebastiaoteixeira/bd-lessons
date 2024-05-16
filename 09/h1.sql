--Pretende-se criar um trigger que, quando se elimina um departamento, este passe para
--uma tabela department_deleted com a mesma estrutura da department. Caso esta
--tabela não exista então deve criar uma nova e só depois inserir o registo. Implemente
--a solução com um trigger de cada tipo (after e instead of). Discuta vantagens e
--desvantagem de cada implementação.

CREATE OR ALTER TRIGGER eliminar_departamento_after
ON Company_department
AFTER DELETE
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
