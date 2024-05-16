CREATE OR ALTER PROCEDURE remove_employee(@ssn CHAR(9))
AS
BEGIN
    DELETE FROM company_employee WHERE ssn = @ssn;
    DELETE FROM company_works_on WHERE essn = @ssn;
    DELETE FROM company_dependent WHERE essn = @ssn;
END;