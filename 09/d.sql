--Crie um trigger que não permita que determinado funcionário tenha um vencimento
--superior ao vencimento do gestor do seu departamento. Nestes casos, o trigger deve
--ajustar o salário do funcionário para um valor igual ao salário do gestor menos uma
--unidade. 

CREATE OR ALTER TRIGGER ajustar_salario
ON Company_employee
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @salario_gestor DECIMAL(10,2)
    DECLARE @salario_funcionario DECIMAL(10,2)
    DECLARE @ssn_gestor INT
    DECLARE @ssn_funcionario INT
    DECLARE @salario_novo DECIMAL(10,2)
    
    SELECT @ssn_gestor = d.mgrssn
    FROM Company_department AS d
    JOIN inserted AS i
    ON d.dnumber = i.dno

    SELECT @salario_gestor = e.salary
    FROM Company_employee AS e
    WHERE e.ssn = @ssn_gestor

    SELECT @salario_funcionario = i.salary
    FROM inserted AS i

    IF @salario_funcionario > @salario_gestor
    BEGIN
        SET @salario_novo = @salario_gestor
        UPDATE Company_employee
        SET salary = @salario_novo
        WHERE ssn = @ssn_funcionario
    END
    ELSE
    BEGIN
        INSERT INTO Company_employee
        SELECT * FROM inserted
    END
END