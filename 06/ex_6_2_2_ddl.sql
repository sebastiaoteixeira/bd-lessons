DROP TABLE IF EXISTS geststock_item;
DROP TABLE IF EXISTS geststock_encomenda;
DROP TABLE IF EXISTS geststock_produto;
DROP TABLE IF EXISTS geststock_fornecedor;
DROP TABLE IF EXISTS geststock_tipo_fornecedor;


CREATE TABLE geststock_tipo_fornecedor
(
    codigo INT PRIMARY KEY,
    designacao VARCHAR(255)
);

CREATE TABLE geststock_fornecedor
(
    nif INT PRIMARY KEY,
    nome VARCHAR(255),
    fax INT,
    endereco VARCHAR(255),
    condpag INT,
    tipo INT,
    FOREIGN KEY (tipo) REFERENCES geststock_tipo_fornecedor(codigo)
);

CREATE TABLE geststock_produto
(
    codigo INT PRIMARY KEY,
    nome VARCHAR(255),
    preco DECIMAL(10,2),
    iva DECIMAL(10,2),
    unidades INT
);

CREATE TABLE geststock_encomenda
(
    numero INT PRIMARY KEY,
    data DATE,
    geststock_fornecedor INT,
    FOREIGN KEY (geststock_fornecedor) REFERENCES geststock_fornecedor(nif)
);

CREATE TABLE geststock_item
(
    numEnc INT,
    codProd INT,
    unidades INT,
    PRIMARY KEY (numEnc, codProd),
    FOREIGN KEY (numEnc) REFERENCES geststock_encomenda(numero),
    FOREIGN KEY (codProd) REFERENCES geststock_produto(codigo)
);
