USE ecommerce_refinado;
SELECT * FROM Clients; -- Dados de todos os Clientes
SELECT se.socialName, se.contact, se.location -- Vendedores que Também são Fornecedores
	FROM seller AS se, supplier AS su
    WHERE se.CNPJ = su.CNPJ;
SELECT DISTINCT idClient, concat(fname, ' ', lname) AS ClientName, typeClient AS AccountType, CPF -- Dados dos Clientes PF que fizeram pedidos
	FROM clients, orders, client_pf
    WHERE idOrderClient = idClient AND idClient = idClientPF
    ORDER BY idClient;
SELECT DISTINCT idClient, concat(fname, ' ', lname) AS ClientName, typeClient AS AccountType, CNPJ -- Dados dos Clientes PJ que fizeram pedidos
	FROM clients, orders, client_pj
    WHERE idOrderClient = idClient AND idClient = idClientPJ
    ORDER BY idClient;
SELECT idClient, concat(fname, ' ', lname) AS ClientName, orderStatus, orderTrackingCode, typePayment, valuePayment, installment -- Pedidos e Métodos de Pagamento de Cada Cliente que fez um pedido
	FROM clients, orders, payment
    WHERE idClient = idOrderClient AND idOrder = idPayment
    ORDER BY idClient;
SELECT idClient, concat(fname, ' ', lname) AS ClientName, count(*) AS NumberOfOrders, SUM(valuePayment) AS TotalPaid -- Total Gasto por Cliente que fizeram mais de 1 pedido
	FROM clients, orders, payment
	WHERE idOrder = idPayment AND idClient = idOrderClient
    GROUP BY idClient HAVING NumberOfOrders > 1;
SELECT idClient, concat(fname, ' ', lname) AS ClientName -- Clientes que fizeram ou não fizeram pedidos
	FROM clients LEFT OUTER JOIN orders ON idOrderClient = idClient
    GROUP BY idClient;
SELECT count(*) AS TotalOrders, SUM(valuePayment) AS Billing -- Faturamento durante todo o período
	FROM orders INNER JOIN payment ON idOrder = idPayment;
SELECT idSeller, socialName, CNPJ, CPF, pname, prodQuantity, rating -- Produtos de Vendedores
	FROM seller AS se INNER JOIN productseller AS ps ON se.idSeller = ps.idPsSeller
					  INNER JOIN product       AS pr ON ps.idPsProduct = pr.idProduct;
SELECT idSupplier, socialName, CNPJ, count(socialName) AS UniqueProducts -- Fornecedores que enviaram mais de 1 produto diferente
	FROM supplier AS su INNER JOIN productsupplier AS ps ON su.idSupplier = ps.idPsSupplier
						INNER JOIN product 		   AS pr ON ps.idPsProduct = pr.idProduct
	GROUP BY socialName HAVING count(socialName) > 1;
SELECT idProduct, socialName, pname, ps.quantity AS AmmountSupplied, pst.quantity AS AmmountInStorage, sl.location AS StorageUF, pst.storagelocation AS StorageLocation  -- Produtos de Fornecedores armazenados no Estoque
	FROM product AS pr INNER JOIN productsupplier  AS ps ON pr.idProduct = ps.idPsProduct
					   INNER JOIN storagelocation AS sl ON pr.idProduct = sl.idLproduct
                       INNER JOIN supplier AS su ON su.idSupplier = ps.idPsSupplier
                       INNER JOIN productstorage as pst ON pst.idProductStorage = sl.idLstorage;