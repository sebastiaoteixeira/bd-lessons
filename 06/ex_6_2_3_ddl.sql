DROP TABLE IF EXISTS Prescricao_presc_farmaco;
DROP TABLE IF EXISTS Prescricao_prescricao;
DROP TABLE IF EXISTS Prescricao_farmaco;
DROP TABLE IF EXISTS Prescricao_farmaceutica;
DROP TABLE IF EXISTS Prescricao_farmacia;
DROP TABLE IF EXISTS Prescricao_paciente;
DROP TABLE IF EXISTS Prescricao_medico;


CREATE TABLE Prescricao_medico
(
    numSNS INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    especialidade VARCHAR(255)
);


CREATE TABLE Prescricao_paciente
(
    numUtente INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    dataNasc DATE,
    endereco VARCHAR(255)
);


CREATE TABLE Prescricao_farmacia
(
    nome VARCHAR(255) PRIMARY KEY,
    telefone INT,
    endereco VARCHAR(255)
);


CREATE TABLE Prescricao_farmaceutica
(
    numReg INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255)
);


CREATE TABLE Prescricao_farmaco
(
    numRegFarm INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    formula VARCHAR(255) NOT NULL
);


CREATE TABLE Prescricao_prescricao
(
    numPresc INT PRIMARY KEY,
    numUtente INT NOT NULL,
    numMedico INT NOT NULL,
    farmacia VARCHAR(255) NOT NULL,
    dataProc DATE,
    FOREIGN KEY (numUtente) REFERENCES Prescricao_paciente(numUtente),
    FOREIGN KEY (numMedico) REFERENCES Prescricao_medico(numSNS),
    FOREIGN KEY (farmacia) REFERENCES Prescricao_farmacia(nome)
);


CREATE TABLE Prescricao_presc_farmaco
(
    numPresc INT PRIMARY KEY,
    numRegFarm INT PRIMARY KEY,
    nomeFarmaco VARCHAR(255),
    PRIMARY KEY (numPresc, numRegFarm),
    FOREIGN KEY (numPresc) REFERENCES Prescricao_prescricao(numPresc),
    FOREIGN KEY (numRegFarm) REFERENCES Prescricao_farmaco(numRegFarm)
);
