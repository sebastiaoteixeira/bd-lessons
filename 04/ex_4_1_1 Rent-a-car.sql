CREATE TABLE Tipo_Veiculo (
    codigo INT PRIMARY KEY,
    arcondicionado BIT,
    designacao VARCHAR(255)
);

CREATE TABLE Similaridade (
    TV_codigo1 INT NOT NULL,
    TV_codigo2 INT NOT NULL,
    FOREIGN KEY (TV_codigo1) REFERENCES Tipo_Veiculo(codigo),
    FOREIGN KEY (TV_codigo2) REFERENCES Tipo_Veiculo(codigo)
);

CREATE TABLE Veiculo (
    matricula VARCHAR(16) PRIMARY KEY,
    marca VARCHAR(255) NOT NULL,
    ano INT NOT NULL,
    Tipo_Veiculo_codigo INT NOT NULL,
    FOREIGN KEY (Tipo_Veiculo_codigo) REFERENCES Tipo_Veiculo(codigo)
);

CREATE TABLE Ligeiro (
    id INT PRIMARY KEY,
    numLugares INT NOT NULL,
    portas INT NOT NULL,
    combustivel VARCHAR(255) NOT NULL,
    TVcodigo INT NOT NULL,
    FOREIGN KEY (TVcodigo) REFERENCES Tipo_Veiculo(codigo)
);

CREATE TABLE Pesado (
    id INT PRIMARY KEY,
    peso DECIMAL(10, 2) NOT NULL,
    passageiros INT NOT NULL,
    TVcodigo INT NOT NULL,
    FOREIGN KEY (TVcodigo) REFERENCES Tipo_Veiculo(codigo)
);

CREATE TABLE Cliente (
    nif VARCHAR(255) PRIMARY KEY,
    num_carta VARCHAR(255) NOT NULL,
    endereco VARCHAR(255),
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Balcao (
    numero INT PRIMARY KEY,
    endereco VARCHAR(255) NOT NULL,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE Aluguer (
    numero INT PRIMARY KEY,
    data DATE NOT NULL,
    duracao INT NOT NULL,
    Veiculo_matricula VARCHAR(16) NOT NULL,
    Cliente_nif VARCHAR(255) NOT NULL,
    Balcao_numero INT NOT NULL,
    FOREIGN KEY (Veiculo_matricula) REFERENCES Veiculo(matricula),
    FOREIGN KEY (Cliente_nif) REFERENCES Cliente(nif),
    FOREIGN KEY (Balcao_numero) REFERENCES Balcao(numero)
);
