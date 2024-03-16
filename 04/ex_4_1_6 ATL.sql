IF OBJECT_ID('ATL_Relationship', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Relationship
IF OBJECT_ID('ATL_Aluno_Atividade', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Aluno_Atividade
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
IF OBJECT_ID('ATL_Pessoa', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Pessoa
IF OBJECT_ID('ATL_Classe', 'U') IS NOT NULL
    DROP TABLE dbo.ATL_Classe

CREATE TABLE ATL_Classe (
    id INT PRIMARY KEY
);

CREATE TABLE ATL_Pessoa (
    cc VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    morada VARCHAR(255) NOT NULL,
    dataNascimento DATE NOT NULL
);

CREATE TABLE ATL_Professor (
    numFuncionario INT PRIMARY KEY,
    cc_Pessoa VARCHAR(255) UNIQUE,
    telefone VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
	FOREIGN KEY (cc_Pessoa) REFERENCES ATL_Pessoa(cc)
);

CREATE TABLE ATL_Turma (
    id INT PRIMARY KEY,
    designacao VARCHAR(255) NOT NULL,
    maxAlunos INT,
    professor_numFuncionario INT NOT NULL,
    Classe_id INT NOT NULL,
    FOREIGN KEY (professor_numFuncionario) REFERENCES ATL_Professor(numFuncionario),
    FOREIGN KEY (Classe_id) REFERENCES ATL_Classe(id)
);

CREATE TABLE ATL_Desconto (
    id INT PRIMARY KEY,
    valorDesconto DECIMAL(10, 2) NOT NULL
);

CREATE TABLE ATL_Recurrencia (
    id INT PRIMARY KEY,
    meses INT NOT NULL
);

CREATE TABLE ATL_Pagamento (
    id INT PRIMARY KEY,
    custo DECIMAL(10, 2) NOT NULL,
    desconto_id INT,
    recurrencia_id INT,
    FOREIGN KEY (desconto_id) REFERENCES ATL_Desconto(id),
    FOREIGN KEY (recurrencia_id) REFERENCES ATL_Recurrencia(id)
);

CREATE TABLE ATL_Atividade (
    id INT PRIMARY KEY,
    designacao VARCHAR(255) NOT NULL,
    pagamento_Id INT NOT NULL,
    FOREIGN KEY (pagamento_Id) REFERENCES ATL_Pagamento(id)
);

CREATE TABLE ATL_Turma_Atividade (
    turma_id INT,
    atividade_id INT,
	PRIMARY KEY (turma_id, atividade_id),
    FOREIGN KEY (turma_id) REFERENCES ATL_Turma(id),
    FOREIGN KEY (atividade_id) REFERENCES ATL_Atividade(id)
);

CREATE TABLE ATL_Aluno (
    cc_Pessoa VARCHAR(255) PRIMARY KEY,
    turma_id INT,
    FOREIGN KEY (turma_id) REFERENCES ATL_Turma(id)
);

CREATE TABLE ATL_EncarregadoEducacao (
    cc_Pessoa VARCHAR(255),
    telefone VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
    PRIMARY KEY (cc_Pessoa),
    FOREIGN KEY (cc_Pessoa) REFERENCES ATL_Pessoa(cc)
);

CREATE TABLE ATL_PessoasAutorizadas (
    cc_Pessoa VARCHAR(255),
    telefone VARCHAR(255) UNIQUE,
    email VARCHAR(255) UNIQUE,
    cc_Pessoa_Aluno VARCHAR(255),
    PRIMARY KEY (cc_Pessoa, cc_Pessoa_Aluno),
    FOREIGN KEY (cc_Pessoa_Aluno) REFERENCES ATL_Aluno(cc_Pessoa)
);

CREATE TABLE ATL_Aluno_Atividade (
    Atividade_id INT NOT NULL,
    Aluno_id VARCHAR(255) NOT NULL,
	PRIMARY KEY (Atividade_id, Aluno_id),
    FOREIGN KEY (Atividade_id) REFERENCES ATL_Atividade(id),
    FOREIGN KEY (Aluno_id) REFERENCES ATL_Aluno(cc_Pessoa)
);

CREATE TABLE ATL_Relationship (
    Relation_cc_Pessoa_ee VARCHAR(255) ,
    Relation_cc_Pessoa_Aluno VARCHAR(255),
	Relation VARCHAR(255),
	PRIMARY KEY (Relation_cc_Pessoa_ee, Relation_cc_Pessoa_Aluno),
    FOREIGN KEY (Relation_cc_Pessoa_ee) REFERENCES ATL_EncarregadoEducacao(cc_Pessoa),
    FOREIGN KEY (Relation_cc_Pessoa_Aluno) REFERENCES ATL_Aluno(cc_Pessoa)
);
