--Crie um stored procedure que retorne um record-set com os funcionários gestores
--de departamentos, assim como o ssn e número de anos (como gestor) do funcionário
--mais antigo dessa lista

CREATE OR ALTER PROCEDURE gestores (
    @older_ssn CHAR(11) OUTPUT,
    @older_years INT OUTPUT
)
AS
BEGIN
    SELECT @older_ssn = e.ssn, @older_years = DATEDIFF(YEAR, d.mgrstartdate, GETDATE())
    FROM Company_employee AS e
    JOIN Company_department AS d
    ON e.ssn = d.mgrssn
    WHERE d.mgrstartdate = (
        SELECT MIN(d.mgrstartdate)
        FROM Company_employee AS e
        JOIN Company_department AS d
        ON e.ssn = d.mgrssn
    )

    SELECT * FROM Company_employee AS e
    JOIN Company_department AS d
    ON e.ssn = d.mgrssn
END
