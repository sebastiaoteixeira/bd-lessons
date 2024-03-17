IF OBJECT_ID('Conferencias_ArtigoCientifico_Conferencia', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_ArtigoCientifico_Conferencia
IF OBJECT_ID('Conferencias_Participante_Conferencia', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Participante_Conferencia
IF OBJECT_ID('Conferencias_NaoEstudante', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_NaoEstudante
IF OBJECT_ID('Conferencias_Estudante', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Estudante
IF OBJECT_ID('Conferencias_Participante', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_Participante
IF OBJECT_ID('Conferencias_ArtigoCientifico_Autor', 'U') IS NOT NULL
    DROP TABLE dbo.Conferencias_ArtigoCientifico_Autor
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
    PRIMARY KEY (Pessoa_enderecoEmail),
    FOREIGN KEY (Pessoa_enderecoEmail) REFERENCES Conferencias_Pessoa(enderecoEmail)
);

CREATE TABLE Conferencias_ArtigoCientifico_Autor (
    ArtigoCientifico_numRegistro INT,
    Autor_Pessoa_enderecoEmail VARCHAR(255),
    PRIMARY KEY (ArtigoCientifico_numRegistro, Autor_Pessoa_enderecoEmail),
    FOREIGN KEY (ArtigoCientifico_numRegistro) REFERENCES Conferencias_ArtigoCientifico(numRegistro),
    FOREIGN KEY (Autor_Pessoa_enderecoEmail) REFERENCES Conferencias_Autor(Pessoa_enderecoEmail)
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

CREATE TABLE Conferencias_Participante_Conferencia (
    Participante_Pessoa_enderecoEmail VARCHAR(255),
    Conferencia_nome VARCHAR(255),
    PRIMARY KEY (Participante_Pessoa_enderecoEmail, Conferencia_nome),
    FOREIGN KEY (Participante_Pessoa_enderecoEmail) REFERENCES Conferencias_Participante(Pessoa_enderecoEmail),
    FOREIGN KEY (Conferencia_nome) REFERENCES Conferencias_Conferencia(nome)
);

CREATE TABLE Conferencias_ArtigoCientifico_Conferencia (
    ArtigoCientifico_numRegistro INT,
    Conferencia_nome VARCHAR(255),
    PRIMARY KEY (ArtigoCientifico_numRegistro, Conferencia_nome),
    FOREIGN KEY (ArtigoCientifico_numRegistro) REFERENCES Conferencias_ArtigoCientifico(numRegistro),
    FOREIGN KEY (Conferencia_nome) REFERENCES Conferencias_Conferencia(nome)
);
