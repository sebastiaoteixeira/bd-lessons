CREATE TABLE Classe (
    id INT PRIMARY KEY
);

CREATE TABLE Professor (
    numFuncionario INT PRIMARY KEY,
    cc_Pessoa VARCHAR(255),
    telefone VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE Turma (
    id INT PRIMARY KEY,
    designacao VARCHAR(255),
    maxAlunos INT,
    professor_numFuncionario INT,
    Classe_id INT,
    FOREIGN KEY (professor_numFuncionario) REFERENCES Professor(numFuncionario),
    FOREIGN KEY (Classe_id) REFERENCES Classe(id)
);

CREATE TABLE Desconto (
    id INT PRIMARY KEY,
    valorDesconto DECIMAL(10, 2)
);

CREATE TABLE Recurrencia (
    id INT PRIMARY KEY,
    meses INT
);

CREATE TABLE Pagamento (
    id INT PRIMARY KEY,
    custo DECIMAL(10, 2),
    desconto_id INT,
    recurrencia_id INT,
    FOREIGN KEY (desconto_id) REFERENCES Desconto(id),
    FOREIGN KEY (recurrencia_id) REFERENCES Recurrencia(id)
);

CREATE TABLE Atividade (
    id INT PRIMARY KEY,
    designacao VARCHAR(255),
    pagamento_Id INT,
    FOREIGN KEY (pagamento_Id) REFERENCES Pagamento(id)
);

CREATE TABLE Turma_Atividade (
    turma_id INT,
    atividade_id INT,
    FOREIGN KEY (turma_id) REFERENCES Turma(id),
    FOREIGN KEY (atividade_id) REFERENCES Atividade(id)
);

CREATE TABLE Aluno (
    cc_Pessoa VARCHAR(255) PRIMARY KEY,
    turma_id INT,
    FOREIGN KEY (turma_id) REFERENCES Turma(id)
);

CREATE TABLE EncarregadoEducacao (
    cc_Pessoa VARCHAR(255) PRIMARY KEY,
    telefone VARCHAR(255),
    email VARCHAR(255)
);

CREATE TABLE PessoasAutorizadas (
    cc_Pessoa VARCHAR(255),
    telefone VARCHAR(255),
    email VARCHAR(255),
    cc_Pessoa_Aluno VARCHAR(255),
    FOREIGN KEY (cc_Pessoa_Aluno) REFERENCES Aluno(cc_Pessoa)
);

CREATE TABLE Pessoa (
    cc VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    morada VARCHAR(255),
    dataNascimento DATE
);

CREATE TABLE Aluno_Atividade (
    Atividade_id INT,
    Aluno_id VARCHAR(255),
    FOREIGN KEY (Atividade_id) REFERENCES Atividade(id),
    FOREIGN KEY (Aluno_id) REFERENCES Aluno(cc_Pessoa)
);

CREATE TABLE Relationship (
    Relation_cc_Pessoa_ee VARCHAR(255),
    Relation_cc_Pessoa_Aluno VARCHAR(255),
    FOREIGN KEY (Relation_cc_Pessoa_ee) REFERENCES EncarregadoEducacao(cc_Pessoa),
    FOREIGN KEY (Relation_cc_Pessoa_Aluno) REFERENCES Aluno(cc_Pessoa)
);