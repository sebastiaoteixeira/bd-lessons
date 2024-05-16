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
... Write here your answer ...
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
... Write here your answer ...
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
... Write here your answer ...
```

### *g)* 

```
... Write here your answer ...
```

### *h)* 

```
... Write here your answer ...
```

### *i)* 

```
... Write here your answer ...
```
