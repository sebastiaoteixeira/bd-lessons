-- Crie uma UDF que, para determinado departamento, retorne um record-set com os 
--projetos desse departamento. Para cada projeto devemos ter um atributo com seu o 
--orçamento  mensal  de  mão  de  obra  e  outra  coluna  com  o  valor  acumulado  do 
--orçamento.   
--Nota: parta do princípio que um funcionário trabalha 40 horas por semana para o 
--cálculo do custo da sua afetação ao projeto.
--Exemplo: select * from dbo.employeeDeptHighAverage(3);
--Recomendação: utilize um cursor.

CREATE OR ALTER FUNCTION dbo.employeeDeptHighAverage(@dno INT)
RETURNS TABLE
AS
RETURN (
    SELECT p.pname, p.pnumber, p.plocation, p.dnum, SUM(e.salary) AS budget, SUM(SUM(e.salary / 4)) AS totalbudget
    FROM Company_project p
    JOIN Company_works_on w ON p.pnumber = w.pno
    JOIN Company_employee e ON w.essn = e.ssn
    WHERE p.dnum = @dno
    GROUP BY p.pname, p.pnumber, p.plocation, p.dnum
);