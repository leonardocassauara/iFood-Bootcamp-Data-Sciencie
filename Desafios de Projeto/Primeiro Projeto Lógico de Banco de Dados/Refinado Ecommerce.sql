CREATE DATABASE IF NOT EXISTS ecommerce_refinado;
USE ecommerce_refinado;

CREATE TABLE Clients (
	idClient INT PRIMARY KEY AUTO_INCREMENT,
    fname VARCHAR(15),
    minit CHAR(3),
    lname VARCHAR(15),
    address VARCHAR(30),
    birthDate DATE,
	typeClient ENUM('PF', 'PJ')
);
CREATE TABLE Product (
	idProduct INT AUTO_INCREMENT PRIMARY KEY,
    pname VARCHAR(40) NOT NULL,
    classificationKids BOOL DEFAULT FALSE,
    category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
    productDescription VARCHAR(40),
    rating FLOAT DEFAULT 0,
    size VARCHAR(10)
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
    socialName VARCHAR(45) NOT NULL,
    abstractName VARCHAR(40),
    CNPJ CHAR(15),
    CPF CHAR(9),
    location VARCHAR(45),
    contact CHAR(11) NOT NULL,
    CONSTRAINT unique_Seller_cnpj UNIQUE (CNPJ),
    CONSTRAINT unique_Seller_cpf UNIQUE (CPF)
);
CREATE TABLE Client_PF (
	idClientPF INT PRIMARY KEY,
    CPF CHAR(11) UNIQUE NOT NULL,
    CONSTRAINT fk_ClientPF_Client FOREIGN KEY (idClientPF) REFERENCES Clients(idClient)
);
CREATE TABLE Client_PJ (
	idClientPJ INT PRIMARY KEY,
    CNPJ CHAR(15) UNIQUE NOT NULL,
    CONSTRAINT fk_ClientPJ_Client FOREIGN KEY (idClientPJ) REFERENCES Clients(idClient)
);
CREATE TABLE Orders  (
	idOrder INT AUTO_INCREMENT,
    idOrderClient INT,
    orderStatus ENUM('Cancelado', 'Confirmado', 'Processando') DEFAULT 'Processando',
    orderTrackingCode CHAR(13) NOT NULL UNIQUE,
    orderDescription VARCHAR(50),
    shippingValue FLOAT DEFAULT 10,
	PRIMARY KEY (idOrder, idOrderClient),
    CONSTRAINT fk_Orders_Clients FOREIGN KEY (idOrderClient) REFERENCES Clients (idClient) ON UPDATE CASCADE
);
CREATE TABLE Payment (
	idPayment INT AUTO_INCREMENT,
    idPaymentClient INT,
    typePayment ENUM('Boleto', 'Pix', 'Cartão', 'Dois Cartões') DEFAULT 'Cartão',
    valuePayment FLOAT NOT NULL,
    installment ENUM('À vista','2x sem juros','3x sem juros','4x com juros') DEFAULT 'À vista',
    PRIMARY KEY (idPayment, idPaymentClient),
    CONSTRAINT fk_Payment_Client FOREIGN KEY (idPaymentClient) REFERENCES Clients (idClient),
    CONSTRAINT fk_Payment_Order FOREIGN KEY (idPayment) REFERENCES Orders (idOrder)
);
CREATE TABLE StorageLocation (
	idLstorage INT,
    idLproduct INT,
    location VARCHAR(45) NOT NULL,
    PRIMARY KEY (idLproduct, idLstorage),
    CONSTRAINT fk_storage_location_product FOREIGN KEY (idLproduct) REFERENCES Product(idProduct),
    CONSTRAINT fk_storage_location_storage FOREIGN KEY (idLstorage) REFERENCES ProductStorage(idProductStorage)
);
CREATE TABLE ProductOrder  (
	idPOproduct INT,
    idPOorder INT,
    poQuantity INT DEFAULT 1,
    poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (idPOproduct, idPOOrder),
    CONSTRAINT fk_productOrder_product FOREIGN KEY (idPOproduct) REFERENCES Product (idProduct),
    CONSTRAINT fk_productOrder_orders  FOREIGN KEY (idPOorder) REFERENCES Orders (idOrder)
);
CREATE TABLE ProductSeller (
	idPsSeller INT,
    idPsProduct INT,
    prodQuantity INT DEFAULT 1,
    PRIMARY KEY (idPsSeller, idPsProduct),
    CONSTRAINT fk_product_seller FOREIGN KEY (idPsSeller) REFERENCES Seller (idSeller),
    CONSTRAINT fk_produtctSeller_product FOREIGN KEY (idPsProduct) REFERENCES Product (idProduct)
);
CREATE TABLE ProductSupplier (
	idPsSupplier INT,
    idPsProduct  INT,
    quantity INT NOT NULL,
    PRIMARY KEY (idPsSupplier, idPsProduct),
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (idPsSupplier) REFERENCES Supplier (idSupplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (idPsProduct) REFERENCES Product (idProduct)
);

ALTER TABLE clients AUTO_INCREMENT = 1;
ALTER TABLE product AUTO_INCREMENT = 1;
ALTER TABLE orders AUTO_INCREMENT = 1;
ALTER TABLE productstorage AUTO_INCREMENT = 1;
ALTER TABLE supplier AUTO_INCREMENT = 1;
ALTER TABLE seller AUTO_INCREMENT = 1;
ALTER TABLE payment AUTO_INCREMENT = 1;

-- Persistir Dados com INSERT INTO --
INSERT INTO Clients (fname, minit, lname, address, typeClient) VALUES
	('Maria',   'M', 'Silva',    'rua lá',   'PF'),
    ('Matheus', 'O', 'Pimentel', 'rua delá', 'PF'),
    ('Ricardo', 'F', 'Silva',    'rua alí',  'PF'),
    ('Julia',   'S', 'França',   'rua dalí', 'PJ'),
    ('Roberta', 'G', 'Assis',    'rua cá',   'PJ'),
    ('Isabela', 'M', 'Cruz',     'rua decá', 'PJ');
INSERT INTO Client_PF VALUES
	(1, 123456789),
    (2, 987654321),
    (3, 456789134);
INSERT INTO Client_PJ VALUES
	(4, 123456789123456),
    (5, 654321987654321),
    (6, 123456789045678);
INSERT INTO Product (pname, classificationKids, category, rating, size) VALUES
	('Fone de Ouvido',    false, 'Eletrônico', '4', null),
    ('Barbie Elsa',       true,  'Brinquedos', '3', null),
    ('Body Carters',      true,  'Vestimenta', '5', null),
    ('Microfone Vedo',    false, 'Eletrônico', '4', null),
    ('Sofá Retrátil',     false, 'Móveis',     '3', '3x57x80'),
    ('Farinha de Arroz',  false, 'Alimentos',  '2', null),
    ('Fire Stick Amazon', false, 'Eletrônico', '3', null);
INSERT INTO Orders (idOrderClient, orderStatus, orderDescription, shippingValue, orderTrackingCode) VALUES
	(1, default,      'compra via aplicativo', null, 'AA123456789BB'),
    (2, default,      'compra via aplicativo', 50,   'CC987654321DD'),
    (3, 'Confirmado', null,                    null, 'XX555555555YY'),
    (2, default,      'compra via aplicativo', null, 'ZZ111111111AA'),
    (4, default,      'compra via web site',   150,  'BB999999999CC');
INSERT INTO Payment (idPaymentClient, typePayment, valuePayment, installment) VALUES
	(1, 'Boleto', 450, default),
    (2, 'Pix', 100, default),
    (3, 'Cartão', 1000, '3x sem juros'),
    (2, 'Boleto', 540, '2x sem juros'),
    (4, 'Dois Cartões', 1000, '4x com juros');
INSERT INTO productorder (idPOproduct, idPOorder, poQuantity, poStatus) VALUES
	(1, 5, 2, null),
    (2, 5, 1, null),
    (3, 4, 1, null);
INSERT INTO productstorage (storageLocation, quantity) VALUES
	('Rio de Janeiro', 1000),
    ('Rio de Janeiro', 500),
    ('São Paulo',      10),
    ('São Paulo',      100),
    ('São Paulo',      10),
    ('Brasília',       60);
INSERT INTO storagelocation (idLproduct, idLstorage, location) VALUES
	(1, 2, 'RJ'),
    (2, 6, 'GO');
INSERT INTO supplier (socialName, CNPJ, contact) VALUES
	('Almeida e filhos',  123456789123456, 21985474),
    ('Eletrônicos Silva', 854519649143457, 21985484),
    ('Eletrônicos Valma', 934567893934695, 21975474),
    ('Tech Eletronics',   123456789456321, 219946287);
INSERT INTO productsupplier (idPsSupplier, idPsProduct, quantity) VALUES
	(1, 1, 500),
    (1, 2, 400),
    (2, 4, 633),
    (3, 3, 5),
    (2, 5, 10);
INSERT INTO seller (socialName, abstractName, CNPJ, CPF, location, contact) VALUES
	('Tech Eletronics', null, 123456789456321, null,      'Rio de Janeiro', 219946287),
    ('Botique Durgas',  null, null,            123456783, 'Rio de Janeiro', 219567895),
    ('Kids World',      null, 456789123654485, null,      'São Paulo',      1198657484);
INSERT INTO productseller (idPsSeller, idPsProduct, prodQuantity) VALUES
	(1, 6, 80),
    (2, 7, 10);
