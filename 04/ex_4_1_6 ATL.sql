IF OBJECT_ID('ATL_Relationship', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Relationship
IF OBJECT_ID('ATL_Aluno_Atividade', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Aluno_Atividade
IF OBJECT_ID('ATL_Pessoa', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Pessoa
IF OBJECT_ID('ATL_PessoasAutorizadas', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_PessoasAutorizadas
IF OBJECT_ID('ATL_EncarregadoEducacao', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_EncarregadoEducacao
IF OBJECT_ID('ATL_Aluno', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Aluno
IF OBJECT_ID('ATL_Turma_Atividade', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Turma_Atividade
IF OBJECT_ID('ATL_Turma_Atividade', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Turma_Atividade
IF OBJECT_ID('ATL_Atividade', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Atividade
IF OBJECT_ID('ATL_Pagamento', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Pagamento
IF OBJECT_ID('ATL_Recurrencia', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Recurrencia
IF OBJECT_ID('ATL_Desconto', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Desconto
IF OBJECT_ID('ATL_Turma', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Turma
IF OBJECT_ID('ATL_Professor', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Professor
IF OBJECT_ID('ATL_Classe', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Classe

CREATE TABLE ATL_Classe (
    id INT PRIMARY KEY
);

CREATE TABLE ATL_Professor (
    numFuncionario INT PRIMARY KEY,
    cc_Pessoa VARCHAR(255),
    telefone VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE ATL_Turma (
    id INT PRIMARY KEY,
    designacao VARCHAR(255),
    maxAlunos INT,
    professor_numFuncionario INT,
    Classe_id INT,
    FOREIGN KEY (professor_numFuncionario) REFERENCES ATL_Professor(numFuncionario),
    FOREIGN KEY (Classe_id) REFERENCES ATL_Classe(id)
);

CREATE TABLE ATL_Desconto (
    id INT PRIMARY KEY,
    valorDesconto DECIMAL(10, 2)
);

CREATE TABLE ATL_Recurrencia (
    id INT PRIMARY KEY,
    meses INT
);

CREATE TABLE ATL_Pagamento (
    id INT PRIMARY KEY,
    custo DECIMAL(10, 2),
    desconto_id INT,
    recurrencia_id INT,
    FOREIGN KEY (desconto_id) REFERENCES ATL_Desconto(id),
    FOREIGN KEY (recurrencia_id) REFERENCES ATL_Recurrencia(id)
);

CREATE TABLE ATL_Atividade (
    id INT PRIMARY KEY,
    designacao VARCHAR(255),
    pagamento_Id INT,
    FOREIGN KEY (pagamento_Id) REFERENCES ATL_Pagamento(id)
);

CREATE TABLE ATL_Turma_Atividade (
    turma_id INT,
    atividade_id INT,
    FOREIGN KEY (turma_id) REFERENCES ATL_Turma(id),
    FOREIGN KEY (atividade_id) REFERENCES ATL_Atividade(id)
);

CREATE TABLE ATL_Aluno (
    cc_Pessoa VARCHAR(255) PRIMARY KEY,
    turma_id INT,
    FOREIGN KEY (turma_id) REFERENCES ATL_Turma(id)
);

CREATE TABLE ATL_EncarregadoEducacao (
    cc_Pessoa VARCHAR(255) PRIMARY KEY,
    telefone VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE ATL_PessoasAutorizadas (
    cc_Pessoa VARCHAR(255),
    telefone VARCHAR(255),
    email VARCHAR(255),
    cc_Pessoa_Aluno VARCHAR(255),
    FOREIGN KEY (cc_Pessoa_Aluno) REFERENCES ATL_Aluno(cc_Pessoa)
);

CREATE TABLE ATL_Pessoa (
    cc VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    morada VARCHAR(255),
    dataNascimento DATE
);

CREATE TABLE ATL_Aluno_Atividade (
    Atividade_id INT,
    Aluno_id VARCHAR(255),
    FOREIGN KEY (Atividade_id) REFERENCES ATL_Atividade(id),
    FOREIGN KEY (Aluno_id) REFERENCES ATL_Aluno(cc_Pessoa)
);

CREATE TABLE ATL_Relationship (
    Relation_cc_Pessoa_ee VARCHAR(255),
    Relation_cc_Pessoa_Aluno VARCHAR(255),
    FOREIGN KEY (Relation_cc_Pessoa_ee) REFERENCES ATL_EncarregadoEducacao(cc_Pessoa),
    FOREIGN KEY (Relation_cc_Pessoa_Aluno) REFERENCES ATL_Aluno(cc_Pessoa)
);