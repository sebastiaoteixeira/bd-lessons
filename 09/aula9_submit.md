# BD: Guião 9


## ​9.1
 
### *a)*

```
CREATE OR ALTER PROCEDURE remove_employee(@ssn CHAR(9))
AS
BEGIN
    DELETE FROM company_employee WHERE ssn = @ssn;
    DELETE FROM company_works_on WHERE essn = @ssn;
    DELETE FROM company_dependent WHERE essn = @ssn;
END;
```

### *b)* 

```
CREATE OR ALTER PROCEDURE gestores (
    @fname VARCHAR(255) OUTPUT,
    @lname VARCHAR(255) OUTPUT,
    @ssn CHAR(11) OUTPUT,
    @anos_gestor INT OUTPUT
)
AS
BEGIN
    SELECT @fname = e.fname, @lname = e.lname, @ssn = e.ssn, @anos_gestor = DATEDIFF(YEAR, d.mgrstartdate, GETDATE())
    FROM Company_employee AS e
    JOIN Company_department AS d
    ON e.ssn = d.mgrssn
    
END
```

### *c)* 

```
CREATE OR ALTER TRIGGER TRG_GESTOR_DEPARTAMENTO ON company_department
AFTER INSERT, UPDATE
AS
BEGIN
    IF (SELECT COUNT(*) FROM company_department WHERE mgrssn = (SELECT mgrssn FROM inserted)) > 0
    BEGIN
        RAISERROR('Um funcionário não pode ser gestor de mais de um departamento.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
```

### *d)* 

```
CREATE OR ALTER FUNCTION funcionarios_acima_media (
    @dno INT
) RETURNS Table
AS
    RETURN (
        SELECT e.fname, e.lname, e.salary
        FROM Company_employee AS e
        JOIN Company_department AS d
        ON e.dno = d.dnumber
        WHERE e.salary > (
            SELECT AVG(e.salary)
            FROM Company_employee AS e
            WHERE e.dno = @dno
        )
    )
```

### *e)* 

```
CREATE OR ALTER FUNCTION function_empregado_projetos(@ssn CHAR(9))
RETURNS VARCHAR(100)
AS
BEGIN
    RETURN (
        SELECT p.pname, p.plocation
        FROM Company_works_on w
        JOIN Company_project p ON w.pno = p.pnumber
        WHERE w.essn = @ssn
    );
END;
```

### *f)* 

```
CREATE OR ALTER FUNCTION funcionarios_acima_media (
    @dno INT
) RETURNS Table
AS
    RETURN (
        SELECT e.fname, e.lname, e.salary
        FROM Company_employee AS e
        JOIN Company_department AS d
        ON e.dno = d.dnumber
        WHERE e.salary > (
            SELECT AVG(e.salary)
            FROM Company_employee AS e
            WHERE e.dno = @dno
        )
    )
```

### *g)* 

```
... Write here your answer ...
```

### *h)* 

```
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


A escolha entre AFTER DELETE e INSTEAD OF DELETE depende dos requisitos específicos do sistema. Se for necessária uma solução simples e direta, AFTER DELETE pode ser mais apropriado. No entanto, se for necessário mais controle sobre a operação de exclusão e validações adicionais, INSTEAD OF DELETE seria a melhor escolha.
```

### *i)* 

```
Stored Procedures são blocos de código SQL pré-compilados que podem modificar dados e suportam transações, loops e condições. Elas melhoram a performance, centralizam a lógica de negócios e reduzem o tráfego de rede. Usadas para operações de CRUD, processamento em massa e geração de relatórios. Exemplo: atualização de salário de um funcionário.

UDFs retornam um valor escalar ou uma tabela, são determinísticas e não podem modificar dados. Elas simplificam consultas complexas e encapsulam lógica repetitiva. Usadas para cálculos e transformações de dados. Exemplo: cálculo de imposto sobre salário em uma consulta.

Comparando as vantagens entre si, Stored Procedures podem modificar dados, enquanto UDFs não podem. Stored Procedures suportam transações e lógica complexa, enquanto UDFs são mais simples e focadas em cálculos e transformações. UDFs podem ser usadas diretamente em consultas SQL, oferecendo flexibilidade, enquanto Stored Procedures não podem ser invocadas diretamente em uma consulta. Stored Procedures melhoram a performance e oferecem maior segurança ao encapsular a lógica de negócios e reduzir o tráfego de rede.
```
