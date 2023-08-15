USE DATABASE ecommerce;
SELECT count(*) FROM clients; -- Número de Clientes
SELECT concat(fname, ' ', lname) AS ClientName, idOrder AS Request, orderStatus AS OrderStatus -- Informação sobre Pedidos dos clientes
	FROM clients AS c, orders AS o 
    WHERE c.idClient = idOrderClient;
SELECT count(*) -- Número de Clientes que fizeram pedidos
	FROM clients AS C, orders AS o
    WHERE c.idClient = o.idOrderClient;
SELECT *  -- Clientes que fizeram ou não fizeram pedidos
	FROM clients LEFT OUTER JOIN orders ON idClient = idOrderClient;
SELECT idClient, concat(fname, ' ', lname) AS ClientName, count(*) AS NumberOfOrders -- Número de Pedidos feitos por cada Cliente que fez um pedido
	FROM clients AS c INNER JOIN orders AS o ON c.idClient = o.idOrderClient 
	GROUP BY idClient;
SELECT idClient, concat(fname, ' ', lname) AS ClientName, count(*) AS NumberOfOrders -- Número de Pedidos feitos por cada Cliente que fez um pedido com produto associado
	FROM clients AS c INNER JOIN orders  AS o ON c.idClient = o.idOrderClient 
					  INNER JOIN productOrder AS p ON p.idPOrder = o.idOrder
	GROUP BY idClient;