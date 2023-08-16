CREATE DATABASE IF NOT EXISTS workshop;
USE workshop;

-- Criar Tabelas Fortes --
CREATE TABLE IF NOT EXISTS Clients (
	idClient INT AUTO_INCREMENT,
    fname VARCHAR(45),
    minit VARCHAR(3),
    lname VARCHAR(45),
    CPF CHAR(11) NOT NULL UNIQUE,
    PRIMARY KEY (idClient)
);
CREATE TABLE IF NOT EXISTS Vehicle (
	idVehicle INT AUTO_INCREMENT,
    licensePlate CHAR(7) NOT NULL UNIQUE,
    model VARCHAR(25) NOT NULL,
    PRIMARY KEY (idVehicle)
);
CREATE TABLE IF NOT EXISTS Orders  (
	idOrder INT AUTO_INCREMENT,
    orderStatus ENUM('Em espera', 'Processando', 'Finalizado') NOT NULL DEFAULT 'Processando',
    orderStartDate DATETIME,
    orderEndDatePreview DATETIME,
    orderRequest ENUM('Manutenção', 'Balanceamento', 'Alinhamento', 'Balanceamento e Alinhamento') DEFAULT 'Manutenção' NOT NULL,
    orderValue FLOAT NOT NULL,
    PRIMARY KEY (idOrder)
);
CREATE TABLE IF NOT EXISTS Product (
	idProduct INT AUTO_INCREMENT,
    pname VARCHAR(45),
    quantity INT,
    productValue FLOAT,
    PRIMARY KEY (idProduct)
);
CREATE TABLE IF NOT EXISTS Mechanic (
	idMechanic INT AUTO_INCREMENT,
    fname VARCHAR(45),
    minit VARCHAR(3),
    lname VARCHAR(45),
    CPF CHAR(11) NOT NULL UNIQUE,
    salary FLOAT NOT NULL DEFAULT 1300,
    tier ENUM('Estágiario','Técnico') NOT NULL DEFAULT 'Técnico',
    PRIMARY KEY (idMechanic)
);

-- Criar Tabelas Fracas --
CREATE TABLE IF NOT EXISTS ClientVehicle (
	idCVclient INT,
    idCVvehicle INT,
    CPF CHAR(11) NOT NULL UNIQUE,
    licensePlate CHAR(7) NOT NULL UNIQUE,
    PRIMARY KEY(idCVclient, idCVvehicle),
    CONSTRAINT fk_CV_Client FOREIGN KEY (idCVclient) REFERENCES Clients (idClient),
    CONSTRAINT fk_CV_Vehicle FOREIGN KEY (idCVvehicle) REFERENCES Vehicle (idVehicle)
);
CREATE TABLE IF NOT EXISTS VehicleOrder (
	idVOvehicle INT,
    idVOorder INT,
    licensePlate CHAR(7) NOT NULL,
    orderRequest ENUM('Manutenção', 'Balanceamento', 'Alinhamento', 'Balanceamento e Alinhamento') DEFAULT 'Manutenção' NOT NULL,
    PRIMARY KEY (idVOvehicle, idVOorder),
    CONSTRAINT fk_VO_Vehicle FOREIGN KEY (idVOvehicle) REFERENCES Vehicle (idVehicle),
    CONSTRAINT fk_VO_Order FOREIGN KEY (idVOorder) REFERENCES Orders (idOrder)
);
CREATE TABLE IF NOT EXISTS ClientPaymentOrder(
	idCPOclient INT,
    idCPOorder INT,
    paymentMethod ENUM('Boleto', 'Pix', 'Cartão', 'Dinheiro') DEFAULT 'Pix' NOT NULL,
    installment ENUM('À vista', '2x sem juros', '3x sem juros', '4x com juros') DEFAULT 'À vista' NOT NULL,
    subtotal FLOAT,
    PRIMARY KEY (idCPOclient, idCPOorder),
    CONSTRAINT fk_CPO_Client FOREIGN KEY (idCPOclient) REFERENCES Clients (idClient),
    CONSTRAINT fk_CPO_Order FOREIGN KEY (idCPOorder) REFERENCES Orders (idOrder)
);
CREATE TABLE IF NOT EXISTS MechanicOrder (
	idMOorder INT,
    idMOmechanic INT,
    orderDescription VARCHAR(100) NOT NULL,
    commission FLOAT NOT NULL DEFAULT 10,
    PRIMARY KEY (idMOorder, idMOmechanic),
    CONSTRAINT fk_MO_Order FOREIGN KEY (idMOorder) REFERENCES Orders (idOrder),
    CONSTRAINT fk_MO_Mechanic FOREIGN KEY (idMOmechanic) REFERENCES Mechanic (idMechanic)
);
CREATE TABLE IF NOT EXISTS OrderProduct (
	idOPproduct INT,
    idOPorder INT,
    productValue FLOAT,
    orderProductquantity INT,
    PRIMARY KEY (idOPproduct, idOPorder),
    CONSTRAINT fk_OP_product FOREIGN KEY (idOPproduct) REFERENCES Product (idProduct),
    CONSTRAINT fk_OP_Order FOREIGN KEY (idOPorder) REFERENCES Orders (idOrder)
);

ALTER TABLE Clients AUTO_INCREMENT = 1;
ALTER TABLE Vehicle AUTO_INCREMENT = 1;
ALTER TABLE Orders AUTO_INCREMENT = 1;
ALTER TABLE Product AUTO_INCREMENT = 1;
ALTER TABLE Mechanic AUTO_INCREMENT = 1;

-- Persistindo Informações nas Tabelas e Relações --
INSERT INTO Clients (fname, minit, lname, CPF) VALUES
	('Franklin', 'T', 'Wong',    33344555555),
	('Alicia',   'J', 'Zelaya',  99988777777),
	('Jennifer', 'S', 'Wallace', 98765432111),
	('Ramesh',   'K', 'Narayan', 66688444444),
    ('Joyce',    'A', 'English', 45345345333),
    ('Ahmad',    'V', 'Jabbar',  98798798777),
    ('John',     'B', 'Smith',   12345678999),
    ('Celica',   'Z', 'Anthiese', 12456784321);
INSERT INTO Vehicle (licensePlate, model) VALUES
	('ABC1234', 'Sedan A'),
	('XYZ5678', 'SUV B'),
	('DEF9012', 'Hatchback C'),
	('GHI3456', 'Pickup D'),
	('JKL7890', 'Coupe E'),
	('MNO2345', 'Convertible F');
INSERT INTO Orders (orderStatus, orderStartDate, orderEndDatePreview, orderRequest, orderValue) VALUES
	('Finalizado',   '2023-08-15 10:00:00', '2023-08-15 14:00:00', 'Balanceamento', 50.00),
	('Finalizado', '2023-08-16 13:30:00', '2023-08-16 17:00:00', 'Alinhamento', 75.50),
	('Finalizado',  '2023-08-17 09:15:00', '2023-08-17 11:30:00', 'Balanceamento e Alinhamento', 100.00),
	('Em espera',   '2023-08-18 11:45:00', NULL,                  'Manutenção', 250.00),
	('Processando', '2023-08-19 14:00:00', '2023-08-20 10:00:00', 'Manutenção', 200.00),
	('Finalizado',  '2023-08-21 08:30:00', '2023-08-21 12:00:00', 'Balanceamento', 50.00),
    ('Processando', '2023-07-22 09:30:00', '2023-07-23 12:00:00', 'Manutenção', 50.00);
INSERT INTO Product (pname, quantity, productValue) VALUES
	('Óleo de Motor',                  50, 35.00),
	('Filtro de Ar',                  30,  15.00),
	('Pastilhas de Freio',            25,  45.00),
	('Alinhamento de Rodas',        null,  60.00),
	('Balanceamento de Rodas',      null,  40.00),
	('Reparo do Motor',             null,  150.00),
    ('Alinhamento e Balanceamento', null,  90.00);
INSERT INTO Mechanic (fname, minit, lname, CPF, salary, tier) VALUES
	('João',  'A.', 'Silva',    '12345678901', 1500.00, 'Técnico'),
	('Maria', 'B.', 'Santos',   '23456789012', 1400.00, 'Técnico'),
	('Pedro', 'C.', 'Oliveira', '34567890123', 1300.00, 'Estágiario');
INSERT INTO ClientVehicle (idCVclient, idCVvehicle, CPF, licensePlate) VALUES
	(1, 1, 33344555555, 'ABC1234'),
    (2, 2, 99988777777, 'XYZ5678'),
    (3, 3, 98765432111, 'DEF9012'),
    (4, 4, 66688444444, 'GHI3456'),
    (5, 5, 45345345333, 'JKL7890'),
    (6, 6, 98798798777, 'MNO2345');
INSERT INTO VehicleOrder (idVOvehicle, idVOorder, licensePlate, orderRequest) VALUES
	(1, 1, 'ABC1234', 'Balanceamento'),
    (2, 2, 'XYZ5678', 'Alinhamento'),
    (3, 3, 'DEF9012', 'Balanceamento e Alinhamento'),
    (4, 4, 'GHI3456', 'Manutenção'),
    (5, 5, 'JKL7890', 'Manutenção'),
    (6, 6, 'MNO2345', 'Balanceamento'),
    (1, 7, 'ABC1234', 'Manutenção');
INSERT INTO ClientPaymentOrder (idCPOclient, idCPOorder, paymentMethod, installment, subtotal) VALUES
	(1, 1, 'Boleto',   'À vista',      50.00),
	(2, 2, 'Cartão',   '2x sem juros', 75.50),
	(3, 3, 'Pix',      'À vista',      100.00),
	(4, 4, 'Dinheiro', 'À vista',      250.00),
	(5, 5, 'Cartão',   '3x sem juros', 200.00),
	(6, 6, 'Boleto',   'À vista',      50.00),
    (1, 7, 'Dinheiro', 'À vista',      50.00);
INSERT INTO MechanicOrder (idMOorder, idMOmechanic, orderDescription, commission) VALUES
	(1, 1, 'Balanceamento das 4 Rodas', 15),
    (2, 2, 'Alinhamento das 4 Rodas', 15),
    (3, 3, 'Balanceamento e Alinhamento das 4 Rodas', 25),
    (4, 2, 'Reparo do Motor muito danificado', 50),
    (5, 1, 'Troca das Pastilhas', 50),
    (6, 1, 'Balanceamento das 4 Rodas', 15),
    (7, 3, 'Troca de Óleo', 10);
INSERT INTO OrderProduct (idOPorder, idOPproduct, productValue, orderProductQuantity) VALUES
	(1, 5, 40.00, null),
    (2, 4, 60.00, null),
    (3, 7, 90.00, null),
    (4, 6, 150.00, null),
    (5, 3, 45.00, 4),
    (6, 5, 40.00, null),
    (7, 1, 35.00, 1);
