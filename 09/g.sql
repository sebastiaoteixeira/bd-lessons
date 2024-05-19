-- Crie uma UDF que, para determinado departamento, retorne um record-set com os 
--projetos desse departamento. Para cada projeto devemos ter um atributo com seu o 
--orçamento  mensal  de  mão  de  obra  e  outra  coluna  com  o  valor  acumulado  do 
--orçamento.   
--Nota: parta do princípio que um funcionário trabalha 40 horas por semana para o 
--cálculo do custo da sua afetação ao projeto.
--Exemplo: select * from dbo.employeeDeptHighAverage(3);
--Recomendação: utilize um cursor.

CREATE OR ALTER FUNCTION employeeDeptHighAverage(@dno INT)
RETURNS @result TABLE
(
    pname VARCHAR(255),
    pnumber INT,
    plocation VARCHAR(255),
    dnum INT,
    budget DECIMAL(10,2),
    accbudget DECIMAL(10,2)
)
AS
BEGIN
    DECLARE C cursor FAST_FORWARD
    FOR SELECT p.pname, p.pnumber, p.plocation, p.dnum, SUM(e.salary) AS budget
    FROM Company_project p
    JOIN Company_works_on w ON p.pnumber = w.pno
    JOIN Company_employee e ON w.essn = e.ssn
    WHERE p.dnum = @dno
    GROUP BY p.pname, p.pnumber, p.plocation, p.dnum

    DECLARE @pname VARCHAR(255)
    DECLARE @pnumber INT
    DECLARE @plocation VARCHAR(255)
    DECLARE @dnum INT
    DECLARE @budget DECIMAL(10,2)
    DECLARE @accbudget DECIMAL(10,2)

    OPEN C

    WHILE @@FETCH_STATUS = 0
    BEGIN
        FETCH NEXT FROM C INTO @pname, @pnumber, @plocation, @dnum, @budget
        
        SET @accbudget = @budget

        INSERT INTO @result
        VALUES (@pname, @pnumber, @plocation, @dnum, @budget, @accbudget)
    END

    CLOSE C
    DEALLOCATE C

    RETURN;
END