CREATE TABLE Produto (
    codigo INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(5, 2) NOT NULL DEFAULT 0 CHECK (iva >= 0 AND iva <= 100)
);

CREATE TABLE TipoFornecedor (
    codigo INT PRIMARY KEY
);

CREATE TABLE Fornecedor (
    codigo INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nif VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    fax VARCHAR(255) NOT NULL,
    TipoFornecedor_Codigo INT NOT NULL,
    CondicaoPagamento_Codigo INT NOT NULL,
    FOREIGN KEY (TipoFornecedor_Codigo) REFERENCES TipoFornecedor(codigo),
    FOREIGN KEY (CondicaoPagamento_Codigo) REFERENCES CondicaoPagamento(codigo)
);

CREATE TABLE Encomenda (
    numero INT PRIMARY KEY NOT NULL,
    dataRealizacao DATE NOT NULL,
    Fornecedor_codigo INT NOT NULL,
    FOREIGN KEY (Fornecedor_codigo) REFERENCES Fornecedor(codigo)
);

CREATE TABLE Item (
    Encomenda_numero INT NOT NULL,
    quantidade INT NOT NULL,
    codigo_Produto INT NOT NULL,
    PRIMARY KEY (Encomenda_numero, codigo_Produto),
    FOREIGN KEY (Encomenda_numero) REFERENCES Encomenda(numero),
    FOREIGN KEY (codigo_Produto) REFERENCES Produto(codigo)
);

CREATE TABLE CondicaoPagamento (
    codigo INT PRIMARY KEY,
    numDias INT NOT NULL,
    Fornecedor_Codigo INT NOT NULL,
    FOREIGN KEY (Fornecedor_Codigo) REFERENCES Fornecedor(codigo)
);
