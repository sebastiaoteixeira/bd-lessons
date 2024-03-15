IF OBJECT_ID('Conferencias_NaoEstudante', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_NaoEstudante
IF OBJECT_ID('Conferencias_Estudante', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Estudante
IF OBJECT_ID('Conferencias_Participante', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Participante
IF OBJECT_ID('Conferencias_Autor', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Autor
IF OBJECT_ID('Conferencias_ArtigoCientifico', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_ArtigoCientifico
IF OBJECT_ID('Conferencias_Pessoa', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Pessoa
IF OBJECT_ID('Conferencias_Conferencia', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Conferencia

CREATE TABLE Conferencias_Conferencia (
    nome VARCHAR(255) PRIMARY KEY
);

CREATE TABLE Conferencias_Pessoa (
    enderecoEmail VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE Conferencias_ArtigoCientifico (
    numRegistro INT PRIMARY KEY,
    titulo VARCHAR(255)
);

CREATE TABLE Conferencias_Autor (
    Pessoa_enderecoEmail VARCHAR(255),
    Pessoa_nome VARCHAR(255),
    instituicao VARCHAR(255),
    ArtigoCientifico_numRegistro INT,
    PRIMARY KEY (Pessoa_enderecoEmail, ArtigoCientifico_numRegistro),
    FOREIGN KEY (Pessoa_enderecoEmail) REFERENCES Conferencias_Pessoa(enderecoEmail),
    FOREIGN KEY (ArtigoCientifico_numRegistro) REFERENCES Conferencias_ArtigoCientifico(numRegistro)
);

CREATE TABLE Conferencias_Participante (
    Pessoa_enderecoEmail VARCHAR(255),
    Pessoa_nome VARCHAR(255),
    morada VARCHAR(255),
    instituicao VARCHAR(255),
    dataInscricao DATE,
    PRIMARY KEY (Pessoa_enderecoEmail),
    FOREIGN KEY (Pessoa_enderecoEmail) REFERENCES Conferencias_Pessoa(enderecoEmail)
);

CREATE TABLE Conferencias_Estudante (
    Participante_Pessoa_enderecoEmail VARCHAR(255),
    comprovativoInstituicao VARCHAR(255),
    PRIMARY KEY (Participante_Pessoa_enderecoEmail),
    FOREIGN KEY (Participante_Pessoa_enderecoEmail) REFERENCES Conferencias_Participante(Pessoa_enderecoEmail)
);

CREATE TABLE Conferencias_NaoEstudante (
    Participante_Pessoa_enderecoEmail VARCHAR(255),
    referenciaTransacao VARCHAR(255),
    PRIMARY KEY (Participante_Pessoa_enderecoEmail),
    FOREIGN KEY (Participante_Pessoa_enderecoEmail) REFERENCES Conferencias_Participante(Pessoa_enderecoEmail)
);
