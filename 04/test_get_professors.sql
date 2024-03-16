-- JOIN Pessoa and Professor
SELECT ATL_Pessoa.cc, ATL_Pessoa.nome, ATL_Pessoa.dataNascimento, ATL_Pessoa.morada, ATL_Professor.numFuncionario, ATL_Professor.telefone, ATL_Professor.email
FROM ATL_Pessoa JOIN ATL_Professor ON ATL_Pessoa.cc = ATL_Professor.cc_Pessoa