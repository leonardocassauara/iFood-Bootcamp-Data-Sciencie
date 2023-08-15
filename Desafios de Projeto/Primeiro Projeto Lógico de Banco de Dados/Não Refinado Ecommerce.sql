-- Desafio de Projeto --

-- Criação do Banco de Dados para o Cenário de E-commerce --
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;

-- Criar Tabelas --
CREATE TABLE Clients (
	idClient INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(15),
    minit CHAR(3),
    lname VARCHAR(15),
    CPF CHAR(11) NOT NULL,
    address VARCHAR(30),
    CONSTRAINT unique_Clients_cpf UNIQUE (CPF)
);
CREATE TABLE Product (
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
    pname VARCHAR(40) NOT NULL,
    classificationKids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    productDescription VARCHAR(40),
    stars FLOAT DEFAULT 0,
    size VARCHAR(10)
);
CREATE TABLE Orders  (
	idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Processando') DEFAULT 'Processando',
    orderDescription VARCHAR(50),
    shippingValue FLOAT DEFAULT 10,
    paymentCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_Orders_Clients FOREIGN KEY (idOrderClient) REFERENCES Clients (idClient) ON UPDATE CASCADE
);
CREATE TABLE ProductStorage (
	idProductStorage INT AUTO_INCREMENT PRIMARY KEY,
    storageLocation VARCHAR(45) NOT NULL,
    quantity INT DEFAULT 0
);
CREATE TABLE Supplier(
	idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(45) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_Supplier_cnpj UNIQUE (CNPJ)
);
CREATE TABLE Seller  (
	idSeller INT AUTO_INCREMENT PRIMARY KEY,
    socialName VARCHAR(40) NOT NULL,
    abstractName VARCHAR(40),
    CNPJ CHAR(15),
    CPF CHAR(9),
    location VARCHAR(45),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_Seller_cnpj UNIQUE (CNPJ),
    CONSTRAINT unique_Seller_cpf UNIQUE (CPF)
);
CREATE TABLE ProductSeller (
	idPseller INT,
    idProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPseller, idProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPseller) REFERENCES Seller (idSeller),
    CONSTRAINT fk_produtctSeller_product FOREIGN KEY (idProduct) REFERENCES Product (idProduct)
);
CREATE TABLE ProductOrder  (
	idPOproduct INT,
    idPOrder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOrder),
    CONSTRAINT fk_productOrder_product FOREIGN KEY (idPOproduct) REFERENCES Product (idProduct),
    CONSTRAINT fk_productOrder_orders  FOREIGN KEY (idPOrder) REFERENCES Orders (idOrder)
);
CREATE TABLE StorageLocation (
	idSlocation INT,
    idPlocation INT,
    location VARCHAR(45) NOT NULL,
    PRIMARY KEY (idSlocation, idPlocation),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idPlocation) REFERENCES Product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idSlocation) REFERENCES ProductStorage(idProductStorage)
);
CREATE TABLE ProductSupplier (
	idPSupplier INT,
    idPProduct  INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPSupplier, idPProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPSupplier) REFERENCES Supplier (idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPProduct) REFERENCES Product (idProduct)
);

ALTER TABLE clients AUTO_INCREMENT = 1;
ALTER TABLE product AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;
ALTER TABLE productstorage AUTO_INCREMENT = 1;
ALTER TABLE supplier AUTO_INCREMENT = 1;
ALTER TABLE seller AUTO_INCREMENT = 1;

-- Persistindo Informações com INSERT INTO --
INSERT INTO Clients (fname, minit, lname, CPF, address) VALUES
	('Maria',   'M', 'Silva',    123456789, 'rua lá'),
    ('Matheus', 'O', 'Pimentel', 987654321, 'rua delá'),
    ('Ricardo', 'F', 'Silva',    45678913,  'rua alí'),
    ('Julia',   'S', 'França',   789123456, 'rua dalí'),
    ('Roberta', 'G', 'Assis',    98745631,  'rua cá'),
    ('Isabela', 'M', 'Cruz',     654789123, 'rua decá');
INSERT INTO Product (pname, classificationKids, category, stars, size) VALUES
	('Fone de Ouvido',    false, 'Eletrônico', '4', null),
    ('Barbie Elsa',       true,  'Brinquedos', '3', null),
    ('Body Carters',      true,  'Vestimenta', '5', null),
    ('Microfone Vedo',    false, 'Eletrônico', '4', null),
    ('Sofá Retrátil',     false, 'Móveis',     '3', '3x57x80'),
    ('Farinha de Arroz',  false, 'Alimentos',  '2', null),
    ('Fire Stick Amazon', false, 'Eletrônico', '3', null);
INSERT INTO Orders (idOrderClient, orderStatus, orderDescription, shippingValue, paymentCash) VALUES
	(1, default,      'compra via aplicativo', null, 1),
    (2, default,      'compra via aplicativo', 50,   0),
    (3, 'Confirmado', null,                    null, 1),
    (2, default,      'compra via aplicativo', null, 1),
    (4, default,      'compra via web site',   150,  0);
INSERT INTO productorder (idPOproduct, idPOrder, poQuantity, poStatus) VALUES
	(1, 5, 2, null),
    (2, 5, 1, null),
    (3, 6, 1, null);
INSERT INTO productstorage (storageLocation, quantity) VALUES
	('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo',      10),
    ('São Paulo',      100),
    ('São Paulo',      10),
    ('Brasília',       60);
INSERT INTO storagelocation (idPlocation, idSlocation, location) VALUES
	(1, 2, 'RJ'),
    (2, 6, 'GO');
INSERT INTO supplier (socialName, CNPJ, contact) VALUES
	('Almeida e filhos',  123456789123456, 21985474),
    ('Eletrônicos Silva', 854519649143457, 21985484),
    ('Eletrônicos Valma', 934567893934695, 21975474);
INSERT INTO productsupplier (idPSupplier, idPProduct, quantity) VALUES
	(1, 1, 500),
    (1, 2, 400),
    (2, 4, 633),
    (3, 3, 5),
    (2, 5, 10);
INSERT INTO seller (socialName, abstractName, CNPJ, CPF, location, contact) VALUES
	('Tech Eletronics', null, 123456789456321, null,      'Rio de Janeiro', 219946287),
    ('Botique Durgas',  null, null,            123456783, 'Rio de Janeiro', 219567895),
    ('Kids World',      null, 456789123654485, null,      'São Paulo',      1198657484);
