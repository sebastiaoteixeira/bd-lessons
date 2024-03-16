-- Join Pessoa, Aluno, Turma, Professor and Pessoa (professor)
SELECT ATL_Pessoa.cc,ATL_Pessoa.nome, ATL_Pessoa.dataNascimento, ATL_Pessoa.morada, ATL_Turma.designacao, ATL_Turma.maxAlunos, ATL_Turma.Classe_id, Professor.Professor_nome, Professor.Professor_dataNascimento, Professor.Professor_morada, Professor.Professor_telefone, Professor.Professor_email
FROM 
(ATL_Pessoa JOIN ATL_Aluno ON ATL_Pessoa.cc = ATL_Aluno.cc_Pessoa JOIN ATL_Turma ON ATL_Aluno.turma_id = ATL_Turma.id)
JOIN
(
    SELECT ATL_Professor.email AS Professor_email, ATL_Professor.telefone AS Professor_telefone, ATL_Pessoa.cc AS Professor_cc, ATL_Pessoa.nome AS Professor_nome, ATL_Pessoa.dataNascimento AS Professor_dataNascimento, ATL_Pessoa.morada AS Professor_morada, ATL_Professor.numFuncionario
    FROM ATL_Professor JOIN ATL_Pessoa ON ATL_Professor.cc_Pessoa = ATL_Pessoa.cc
) AS Professor
ON ATL_Turma.professor_numFuncionario = Professor.numFuncionario
