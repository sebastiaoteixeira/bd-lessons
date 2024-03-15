IF OBJECT_ID('Stocks_Item', 'U') IS NOT NULL
    DROP TABLE dbo.Stocks_Item
IF OBJECT_ID('Stocks_Encomenda', 'U') IS NOT NULL
    DROP TABLE dbo.Stocks_Encomenda
IF OBJECT_ID('Stocks_Fornecedor', 'U') IS NOT NULL
    DROP TABLE dbo.Stocks_Fornecedor
IF OBJECT_ID('Stocks_CondicaoPagamento', 'U') IS NOT NULL
    DROP TABLE dbo.Stocks_CondicaoPagamento
IF OBJECT_ID('Stocks_TipoFornecedor', 'U') IS NOT NULL
    DROP TABLE dbo.Stocks_TipoFornecedor
IF OBJECT_ID('Stocks_Produto', 'U') IS NOT NULL
    DROP TABLE dbo.Stocks_Produto

CREATE TABLE Stocks_Produto (
    codigo INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    iva DECIMAL(5, 2) NOT NULL DEFAULT 0 CHECK (iva >= 0 AND iva <= 100)
);

CREATE TABLE Stocks_TipoFornecedor (
    codigo INT PRIMARY KEY
);

CREATE TABLE Stocks_CondicaoPagamento (
    codigo INT PRIMARY KEY,
    numDias INT NOT NULL,
);

CREATE TABLE Stocks_Fornecedor (
    codigo INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    nif VARCHAR(255) NOT NULL,
    endereco VARCHAR(255) NOT NULL,
    fax VARCHAR(255) NOT NULL,
    TipoFornecedor_Codigo INT NOT NULL,
    CondicaoPagamento_Codigo INT NOT NULL,
    FOREIGN KEY (TipoFornecedor_Codigo) REFERENCES Stocks_TipoFornecedor(codigo),
    FOREIGN KEY (CondicaoPagamento_Codigo) REFERENCES Stocks_CondicaoPagamento(codigo)
);

CREATE TABLE Stocks_Encomenda (
    numero INT PRIMARY KEY NOT NULL,
    dataRealizacao DATE NOT NULL,
    Fornecedor_codigo INT NOT NULL,
    FOREIGN KEY (Fornecedor_codigo) REFERENCES Stocks_Fornecedor(codigo)
);

CREATE TABLE Stocks_Item (
    Encomenda_numero INT NOT NULL,
    quantidade INT NOT NULL,
    codigo_Produto INT NOT NULL,
    PRIMARY KEY (Encomenda_numero, codigo_Produto),
    FOREIGN KEY (Encomenda_numero) REFERENCES Stocks_Encomenda(numero),
    FOREIGN KEY (codigo_Produto) REFERENCES Stocks_Produto(codigo)
);
