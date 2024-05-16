-- Construa um  trigger  que  não permita  que  determinado  funcionário  seja  definido 
-- como gestor de mais do que um departamento. 

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