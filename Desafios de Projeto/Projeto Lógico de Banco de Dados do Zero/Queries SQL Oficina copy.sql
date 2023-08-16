-- Recuperando Informações com Queries SQL --
USE workshop;
SELECT * FROM clients;
SELECT * FROM vehicle;
SELECT * FROM Mechanic;
SELECT * FROM Product;
SELECT * FROM Orders;

-- Clientes que fizeram Pedidos --
SELECT DISTINCT idClient, concat(fname, ' ', minit, ' ', lname) AS ClientName, CPF 
	FROM clients AS c INNER JOIN clientpaymentorder AS cpo ON c.idClient = cpo.idCPOclient
					  INNER JOIN orders AS o ON cpo.idCPOorder = o.idOrder;
                      
-- Clientes que fizeram mais de um Pedido --
SELECT idClient, concat(fname, ' ', minit, ' ', lname) AS ClientName, CPF, count(*) AS NumberOfOrders
	FROM clients AS c INNER JOIN clientpaymentOrder AS cpo ON c.idClient = cpo.idCPOclient
					  INNER JOIN orders AS o ON cpo.idCPOorder = o.idOrder
	GROUP BY idClient HAVING NumberOfOrders > 1;

-- Número de Pedidos feito por cada Cliente que fez pelo menos um Pedido, ordenado de forma decrescence segundo o id do Cliente --
SELECT idClient, concat(fname, ' ', minit, ' ', lname) AS ClientName, CPF, count(*) AS NumberOfOrders
	FROM clients AS c INNER JOIN clientpaymentOrder AS cpo ON c.idClient = cpo.idCPOclient
				      INNER JOIN orders AS o ON cpo.idCPOorder = o.idOrder
	GROUP BY idClient
    ORDER BY idClient DESC;

-- Clientes que não Fizeram Pedidos --
SELECT idClient, concat(fname, ' ', minit, ' ', lname) AS ClientName, CPF
	FROM clients
    WHERE NOT EXISTS (SELECT * 
					 FROM clientpaymentorder AS cpo, orders AS o 
                     WHERE idClient = cpo.idCPOclient AND cpo.idCPOorder = o.idOrder);

-- Número de Serviços que Cada Mecânico Executou --
SELECT idMechanic, concat(fname, ' ', minit, ' ', lname) AS MechanicName, count(*) AS NumberOfOrders
	FROM mechanic AS me INNER JOIN mechanicorder AS mo ON me.idMechanic = mo.idMOmechanic
						INNER JOIN orders AS o ON mo.idMOorder = o.idOrder
	GROUP BY idMechanic 
    ORDER BY idMechanic;

-- Quanto de Comissão e Faturamento para Oficina cada Mecânico gerou --
SELECT idMechanic, concat(fname, ' ', minit, ' ', lname) AS MechanicName, count(*) AS NumberOfOrders, SUM(commission) AS Commission, SUM(orderValue) AS Billing
	FROM mechanic AS me INNER JOIN mechanicorder AS mo ON me.idMechanic = mo.idMOmechanic
						INNER JOIN orders AS o ON mo.idMOorder = o.idOrder
	GROUP BY idMechanic 
    ORDER BY idMechanic;

-- Veículos que Cada Mecânico Trabalhou --
SELECT idMechanic, concat(fname, ' ', minit, ' ', lname) AS MechanicName, licensePlate AS ClientVehicleLicensePlate
	FROM mechanic AS me INNER JOIN mechanicorder AS mo ON me.idMechanic = mo.idMOmechanic
					    INNER JOIN orders        AS o  ON mo.idMOorder  = o.idOrder
                        INNER JOIN vehicleorder  AS vo ON vo.idVOorder = o.idOrder
	ORDER BY idMechanic;

-- Veículo de Cada Cliente --
SELECT idClient, concat(fname, ' ', minit, ' ', lname) AS ClientName, c.CPF, cv.licensePlate, v.model
	FROM clients AS c INNER JOIN clientvehicle AS cv ON c.idClient = cv.idCVclient
					  INNER JOIN vehicle	   AS v  ON v.idVehicle = cv.idCVvehicle;

-- Qual Produto/Serviço foi Executado em cada Pedido --
SELECT idOrder, orderStatus, pname, orderRequest, p.productValue
	FROM orders AS o INNER JOIN orderproduct AS op ON o.idOrder = op.idOPorder
					 INNER JOIN product      AS p  ON p.idProduct = op.idOPproduct
	ORDER BY idOrder;