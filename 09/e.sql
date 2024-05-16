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