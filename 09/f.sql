--Crie uma UDF que, para determinado departamento (dno), retorne os funcionários
--com um vencimento superior à média dos vencimentos desse departamento;

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