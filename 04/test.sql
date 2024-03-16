--Add a Pessoas
INSERT INTO ATL_Pessoa (cc, nome, dataNascimento, morada)
VALUES ('123456789', 'Professor P', '1990-01-01', 'Rua do Professor')
INSERT INTO ATL_Pessoa (cc, nome, dataNascimento, morada)
VALUES ('386745123', 'Aluno A', '2000-01-01', 'Rua do Aluno')

--Add a Professor
INSERT INTO ATL_Professor (numFuncionario, cc_Pessoa, telefone, email)
VALUES (1, '123456789', '987654321', 'professor@gmail.com')

--Add a Classe
INSERT INTO ATL_Classe (id)
VALUES (1)

--Add a Turma
INSERT INTO ATL_Turma (id, designacao, maxAlunos, professor_numFuncionario, Classe_id)
VALUES (1, 'Turma A', 10, 1, 1)

--Add a Aluno
INSERT INTO ATL_Aluno (cc_Pessoa, turma_id)
VALUES ('386745123', 1)