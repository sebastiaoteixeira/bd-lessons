CREATE TABLE Conferencia (
    nome VARCHAR(255) PRIMARY KEY
);

CREATE TABLE Pessoa (
    enderecoEmail VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE ArtigoCientifico (
    numRegistro INT PRIMARY KEY,
    titulo VARCHAR(255)
);

CREATE TABLE Autor (
    Pessoa_enderecoEmail VARCHAR(255),
    Pessoa_nome VARCHAR(255),
    instituicao VARCHAR(255),
    ArtigoCientifico_numRegistro INT,
    PRIMARY KEY (Pessoa_enderecoEmail, ArtigoCientifico_numRegistro),
    FOREIGN KEY (Pessoa_enderecoEmail) REFERENCES Pessoa(enderecoEmail),
    FOREIGN KEY (ArtigoCientifico_numRegistro) REFERENCES ArtigoCientifico(numRegistro)
);

CREATE TABLE Participante (
    Pessoa_enderecoEmail VARCHAR(255),
    Pessoa_nome VARCHAR(255),
    morada VARCHAR(255),
    instituicao VARCHAR(255),
    dataInscricao DATE,
    PRIMARY KEY (Pessoa_enderecoEmail),
    FOREIGN KEY (Pessoa_enderecoEmail) REFERENCES Pessoa(enderecoEmail)
);

CREATE TABLE Estudante (
    Participante_Pessoa_enderecoEmail VARCHAR(255),
    comprovativoInstituicao VARCHAR(255),
    PRIMARY KEY (Participante_Pessoa_enderecoEmail),
    FOREIGN KEY (Participante_Pessoa_enderecoEmail) REFERENCES Participante(Pessoa_enderecoEmail)
);

CREATE TABLE NaoEstudante (
    Participante_Pessoa_enderecoEmail VARCHAR(255),
    referenciaTransacao VARCHAR(255),
    PRIMARY KEY (Participante_Pessoa_enderecoEmail),
    FOREIGN KEY (Participante_Pessoa_enderecoEmail) REFERENCES Participante(Pessoa_enderecoEmail)
);
