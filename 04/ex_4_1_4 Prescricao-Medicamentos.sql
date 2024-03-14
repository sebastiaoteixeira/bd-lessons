CREATE TABLE Farmaco (
    formula VARCHAR(255) PRIMARY KEY,
    nomeComercial VARCHAR(255)
);

CREATE TABLE Farmaceutica (
    registoNacional VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    endereco VARCHAR(255),
    telefone VARCHAR(255)
);

CREATE TABLE FarmacoFarmaceutica (
    Farmaceutica_registoNacional VARCHAR(255),
    Farmaco_formula VARCHAR(255),
    PRIMARY KEY (Farmaceutica_registoNacional, Farmaco_formula),
    FOREIGN KEY (Farmaceutica_registoNacional) REFERENCES Farmaceutica(registoNacional),
    FOREIGN KEY (Farmaco_formula) REFERENCES Farmaco(formula)
);

CREATE TABLE Farmacia (
    nif VARCHAR(255) PRIMARY KEY,
    nome VARCHAR(255),
    endereco VARCHAR(255),
    telefone VARCHAR(255)
);

CREATE TABLE FarmacoFarmacia (
    Farmacia_nif VARCHAR(255),
    Farmaco_formula VARCHAR(255),
    PRIMARY KEY (Farmacia_nif, Farmaco_formula),
    FOREIGN KEY (Farmacia_nif) REFERENCES Farmacia(nif),
    FOREIGN KEY (Farmaco_formula) REFERENCES Farmaco(formula)
);

CREATE TABLE Paciente (
    numero INT PRIMARY KEY,
    nome VARCHAR(255),
    dataNascimento DATE,
    endereco VARCHAR(255)
);

CREATE TABLE Especialidade (
    id INT PRIMARY KEY,
    nome VARCHAR(255)
);

CREATE TABLE Medico (
    id INT PRIMARY KEY,
    nome VARCHAR(255),
    Especialidade_id INT,
    FOREIGN KEY (Especialidade_id) REFERENCES Especialidade(id)
);

CREATE TABLE Prescricao (
    numero INT PRIMARY KEY,
    data DATE,
    Medico_id INT,
    Paciente_numero INT,
    FOREIGN KEY (Medico_id) REFERENCES Medico(id),
    FOREIGN KEY (Paciente_numero) REFERENCES Paciente(numero)
);

CREATE TABLE PrescricaoFarmaco (
    Farmaco_formula VARCHAR(255),
    Prescricao_numero INT,
    PRIMARY KEY (Farmaco_formula, Prescricao_numero),
    FOREIGN KEY (Farmaco_formula) REFERENCES Farmaco(formula),
    FOREIGN KEY (Prescricao_numero) REFERENCES Prescricao(numero)
);

CREATE TABLE PrescricaoFarmacia (
    dataProcessamento DATE,
    Prescricao_numero INT,
    Farmacia_nif VARCHAR(255),
    PRIMARY KEY (Prescricao_numero, Farmacia_nif),
    FOREIGN KEY (Prescricao_numero) REFERENCES Prescricao(numero),
    FOREIGN KEY (Farmacia_nif) REFERENCES Farmacia(nif)
);