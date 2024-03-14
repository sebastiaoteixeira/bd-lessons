IF OBJECT_ID('Rent_Aluguer', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Aluguer
IF OBJECT_ID('Rent_Balcao', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Balcao
IF OBJECT_ID('Rent_Cliente', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Cliente
IF OBJECT_ID('Rent_Pesado', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Pesado
IF OBJECT_ID('Rent_Ligeiro', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Ligeiro
IF OBJECT_ID('Rent_Veiculo', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Veiculo
IF OBJECT_ID('Rent_Similaridade', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Similaridade
IF OBJECT_ID('Rent_Tipo_Veiculo', 'U') IS NOT NULL
    DROP TABLE dbo.Rent_Tipo_Veiculo

CREATE TABLE Rent_Tipo_Veiculo (
    codigo INT PRIMARY KEY,
    arcondicionado BIT,
    designacao VARCHAR(255)
);

CREATE TABLE Rent_Similaridade (
    TV_codigo1 INT NOT NULL,
    TV_codigo2 INT NOT NULL,
    FOREIGN KEY (TV_codigo1) REFERENCES Rent_Tipo_Veiculo(codigo),
    FOREIGN KEY (TV_codigo2) REFERENCES Rent_Tipo_Veiculo(codigo)
);

CREATE TABLE Rent_Veiculo (
    matricula VARCHAR(16) PRIMARY KEY,
    marca VARCHAR(255) NOT NULL,
    ano INT NOT NULL,
    Tipo_Veiculo_codigo INT NOT NULL,
    FOREIGN KEY (Tipo_Veiculo_codigo) REFERENCES Rent_Tipo_Veiculo(codigo)
);

CREATE TABLE Rent_Ligeiro (
    id INT PRIMARY KEY,
    numLugares INT NOT NULL,
    portas INT NOT NULL,
    combustivel VARCHAR(255) NOT NULL,
    TVcodigo INT NOT NULL,
    FOREIGN KEY (TVcodigo) REFERENCES Rent_Tipo_Veiculo(codigo)
);

CREATE TABLE Rent_Pesado (
    id INT PRIMARY KEY,
    peso DECIMAL(10, 2) NOT NULL,
    passageiros INT NOT NULL,
    TVcodigo INT NOT NULL,
    FOREIGN KEY (TVcodigo) REFERENCES Rent_Tipo_Veiculo(codigo)
);

CREATE TABLE Rent_Cliente (
    nif VARCHAR(255) PRIMARY KEY,
    num_carta VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Rent_Balcao (
    numero INT PRIMARY KEY,
    endereco VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Rent_Aluguer (
    numero INT PRIMARY KEY,
    data DATE NOT NULL,
    duracao INT NOT NULL,
    Veiculo_matricula VARCHAR(16) NOT NULL,
    Cliente_nif VARCHAR(255) NOT NULL,
    Balcao_numero INT NOT NULL,
    FOREIGN KEY (Veiculo_matricula) REFERENCES Rent_Veiculo(matricula),
    FOREIGN KEY (Cliente_nif) REFERENCES Rent_Cliente(nif),
    FOREIGN KEY (Balcao_numero) REFERENCES Rent_Balcao(numero)
);
