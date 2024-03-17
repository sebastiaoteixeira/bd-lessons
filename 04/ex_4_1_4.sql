IF OBJECT_ID('Prescicao_Medicamentos_PrescricaoFarmacia', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_PrescricaoFarmacia
IF OBJECT_ID('Prescicao_Medicamentos_PrescricaoFarmaco', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_PrescricaoFarmaco
IF OBJECT_ID('Prescicao_Medicamentos_Prescricao', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Prescricao
IF OBJECT_ID('Prescicao_Medicamentos_Medico', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Medico
IF OBJECT_ID('Prescicao_Medicamentos_Especialidade', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Especialidade
IF OBJECT_ID('Prescicao_Medicamentos_Paciente', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Paciente
IF OBJECT_ID('Prescicao_Medicamentos_FarmacoFarmacia', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_FarmacoFarmacia
IF OBJECT_ID('Prescicao_Medicamentos_Farmacia', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Farmacia
IF OBJECT_ID('Prescicao_Medicamentos_FarmacoFarmaceutica', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_FarmacoFarmaceutica
IF OBJECT_ID('Prescicao_Medicamentos_Farmaceutica', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Farmaceutica
IF OBJECT_ID('Prescicao_Medicamentos_Farmaco', 'U') IS NOT NULL
    DROP TABLE dbo.Prescicao_Medicamentos_Farmaco

CREATE TABLE Prescicao_Medicamentos_Farmaco (
    formula VARCHAR(255) PRIMARY KEY NOT NULL,
    nomeComercial VARCHAR(255) NOT NULL
);

CREATE TABLE Prescicao_Medicamentos_Farmaceutica (
    registoNacional VARCHAR(255) PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    telefone VARCHAR(255)
);

CREATE TABLE Prescicao_Medicamentos_FarmacoFarmaceutica (
    Farmaceutica_registoNacional VARCHAR(255) NOT NULL,
    Farmaco_formula VARCHAR(255) NOT NULL,
    CONSTRAINT PK_FarmacoFarmaceutica PRIMARY KEY (Farmaceutica_registoNacional, Farmaco_formula),
    FOREIGN KEY (Farmaceutica_registoNacional) REFERENCES Prescicao_Medicamentos_Farmaceutica(registoNacional),
    FOREIGN KEY (Farmaco_formula) REFERENCES Prescicao_Medicamentos_Farmaco(formula)
);

CREATE TABLE Prescicao_Medicamentos_Farmacia (
    nif VARCHAR(255) PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    telefone VARCHAR(255) UNIQUE
);

CREATE TABLE Prescicao_Medicamentos_FarmacoFarmacia (
    Farmacia_nif VARCHAR(255) NOT NULL,
    Farmaco_formula VARCHAR(255) NOT NULL,
    PRIMARY KEY (Farmacia_nif, Farmaco_formula),
    FOREIGN KEY (Farmacia_nif) REFERENCES Prescicao_Medicamentos_Farmacia(nif),
    FOREIGN KEY (Farmaco_formula) REFERENCES Prescicao_Medicamentos_Farmaco(formula)
);

CREATE TABLE Prescicao_Medicamentos_Paciente (
    numero INT PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
    dataNascimento DATE NOT NULL,
    endereco VARCHAR(255) NOT NULL
);

CREATE TABLE Prescicao_Medicamentos_Especialidade (
    id INT PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE Prescicao_Medicamentos_Medico (
    id INT PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
    Especialidade_id INT NOT NULL,
    FOREIGN KEY (Especialidade_id) REFERENCES Prescicao_Medicamentos_Especialidade(id)
);

CREATE TABLE Prescicao_Medicamentos_Prescricao (
    numero INT PRIMARY KEY NOT NULL,
    data DATE NOT NULL,
    Medico_id INT NOT NULL,
    Paciente_numero INT NOT NULL,
    FOREIGN KEY (Medico_id) REFERENCES Prescicao_Medicamentos_Medico(id),
    FOREIGN KEY (Paciente_numero) REFERENCES Prescicao_Medicamentos_Paciente(numero)
);

CREATE TABLE Prescicao_Medicamentos_PrescricaoFarmaco (
    Farmaco_formula VARCHAR(255) NOT NULL,
    Prescricao_numero INT NOT NULL,
    PRIMARY KEY (Farmaco_formula, Prescricao_numero),
    FOREIGN KEY (Farmaco_formula) REFERENCES Prescicao_Medicamentos_Farmaco(formula),
    FOREIGN KEY (Prescricao_numero) REFERENCES Prescicao_Medicamentos_Prescricao(numero)
);

CREATE TABLE Prescicao_Medicamentos_PrescricaoFarmacia (
    dataProcessamento DATE,
    Prescricao_numero INT NOT NULL,
    Farmacia_nif VARCHAR(255) NOT NULL,
    PRIMARY KEY (Prescricao_numero, Farmacia_nif),
    FOREIGN KEY (Prescricao_numero) REFERENCES Prescicao_Medicamentos_Prescricao(numero),
    FOREIGN KEY (Farmacia_nif) REFERENCES Prescicao_Medicamentos_Farmacia(nif)
);