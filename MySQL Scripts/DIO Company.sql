CREATE SCHEMA IF NOT EXISTS company;
USE company;

CREATE TABLE company.employee (
	fname VARCHAR(15) NOT NULL,
    minit CHAR,
    lname VARCHAR(15) NOT NULL,
    ssn   CHAR(9) NOT NULL,
    bdate DATE,
    address VARCHAR(30),
    sex CHAR,
    salary DECIMAL(10,2),
    dno INT NOT NULL,
    PRIMARY KEY (ssn)
);
CREATE TABLE departament (
	dname VARCHAR(15) NOT NULL,
    dnumber INT NOT NULL,
    mgr_ssn CHAR(9),
    mgr_start_date DATE,
    PRIMARY KEY (dnumber),
    UNIQUE (dname),
    FOREIGN KEY (mgr_ssn) REFERENCES employee(ssn)
);
CREATE TABLE dept_locations (
	dnumber INT NOT NULL,
    dlocation VARCHAR(15) NOT NULL,
    PRIMARY KEY (dnumber, dlocation),
    FOREIGN KEY (dnumber) REFERENCES departament(dnumber)
);
CREATE TABLE project (
	pname VARCHAR(15) NOT NULL,
    pnumber INT NOT NULL,
    plocation VARCHAR(15),
    dnumber INT NOT NULL,
    PRIMARY KEY (pnumber),
    UNIQUE (pname),
    FOREIGN KEY (dnumber) REFERENCES departament(dnumber)
);
CREATE TABLE works_on (
	essn CHAR(9) NOT NULL,
    pnumber INT NOT NULL,
    hours DECIMAL(3,1) NOT NULL,
    PRIMARY KEY (essn, pnumber),
    FOREIGN KEY (essn) REFERENCES employee(ssn),
    FOREIGN KEY (pnumber) REFERENCES project(pnumber)
);
CREATE TABLE dependant (
	essn CHAR(9) NOT NULL,
    dependant_name VARCHAR(15) NOT NULL,
    sex CHAR,
    bdate DATE,
    relationship VARCHAR(8),
    PRIMARY KEY (essn, dependant_name),
    FOREIGN KEY (essn) REFERENCES employee(ssn)
);
SHOW TABLES;
DESC dependant;

-- CREATE DOMAIN d_num AS INT CHECK(d_num > 0 and d_num < 21);
SELECT * FROM information_schema.table_constraints WHERE constraint_schema =  "company";
SELECT * FROM information_schema.referential_constraints WHERE constraint_schema = "company";
SELECT * FROM information_schema.table_constraints WHERE table_schema = 'company' AND table_name = 'dependant';
ALTER TABLE employee ADD CONSTRAINT chk_salary_employee CHECK (salary > 2000.00);
ALTER TABLE departament ADD CONSTRAINT chk_date_dept CHECK (dept_create_date < mgr_start_date);
ALTER TABLE dependant
	ADD age INT NOT NULL,
    ADD CONSTRAINT chk_age_dependant CHECK (age < 22);

-- Modificando Constraints com ALTER TABLE --
DESC employee;
ALTER TABLE employee
	ADD CONSTRAINT fk_employee FOREIGN KEY (super_ssn) REFERENCES employee (ssn)
    ON DELETE SET NULL
    ON UPDATE CASCADE;
RENAME TABLE departament TO department;
ALTER TABLE department -- O MySQL não reconhece o DROP e o ADD de Constraints em um único ALTER TABLE --
	DROP CONSTRAINT department_ibfk_1,
    ADD CONSTRAINT  fk_dept FOREIGN KEY (mgr_ssn) REFERENCES employee (ssn) ON UPDATE CASCADE;
SELECT CONSTRAINT_NAME, TABLE_NAME, COLUMN_NAME, REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME FROM
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE
    REFERENCED_TABLE_NAME IS NOT NULL AND TABLE_SCHEMA = 'company' AND TABLE_NAME = 'dept_locations';
ALTER TABLE dept_locations DROP CONSTRAINT dept_locations_ibfk_1;
ALTER TABLE dept_locations ADD CONSTRAINT fk_dept_locations FOREIGN KEY (dnumber) REFERENCES department (dnumber)
	ON DELETE CASCADE
    ON UPDATE CASCADE;
ALTER TABLE works_on DROP CONSTRAINT works_on_ibfk_1;
ALTER TABLE works_on DROP CONSTRAINT works_on_ibfk_2;
ALTER TABLE works_on
	ADD CONSTRAINT fk_employee_works_on FOREIGN KEY (essn) REFERENCES employee (ssn),
    ADD CONSTRAINT fk_project_works_on FOREIGN KEY (pnumber) REFERENCES project (pnumber);
ALTER TABLE dependant DROP CONSTRAINT dependant_ibfk_1;
ALTER TABLE dependant ADD CONSTRAINT fk_dependant FOREIGN KEY (essn) REFERENCES employee (ssn);
ALTER TABLE project DROP CONSTRAINT project_ibfk_1;
ALTER TABLE project ADD CONSTRAINT fk_project FOREIGN KEY (dnumber) REFERENCES department (dnumber);

-- Persistindo Informações
INSERT INTO employee VALUES ('John',     'B', 'Smith',   123456789, '1965-01-09', '731-Fondren-Houstoun-TX', 'M', 30000, 5, NULL);
INSERT INTO employee VALUES ('Franklin', 'T', 'Wong',    333445555, '1955-12-08', '638-Voss-Houston-TX',     'M', 40000, 5, 123456789),
							('Alicia',   'J', 'Zelaya',  999887777, '1968-01-19', '3321-Castle-Spring-TX',   'F', 25000, 4, 333445555),
                            ('Jennifer', 'S', 'Wallace', 987654321, '1941-06-20', '291-Berry-Bellaire-TX',   'F', 43000, 4, NULL),
                            ('Ramesh',   'K', 'Narayan', 666884444, '1962-09-15', '975-Fire-Oak-Humble-TX',  'M', 38000, 5, 987654321),
                            ('Joyce',    'A', 'English', 453453453, '1972-07-31', '5631-Rice-Houston-TX',    'F', 25000, 5, 987654321),
                            ('Ahmad',    'V', 'Jabbar',  987987987, '1969-03-29', '980-Dallas-Houston-TX',   'M', 25000, 4, 123456789),
                            ('James',    'E', 'Borg',    888665555, '1937-11-10', '450-Stone-Houston-TX',    'M', 55000, 1, 333445555);
INSERT INTO dependant VALUES (333445555, 'Alice',     'F', '1986-04-05', 'Daughter'),
							 (333445555, 'Theodore',  'M', '1983-10-25', 'Son'),
                             (333445555, 'Joy',       'F', '1958-05-03', 'Spouse'),
                             (987654321, 'Abner',     'F', '1942-02-28', 'Spouse'),
                             (123456789, 'Michael',   'M', '1988-01-04', 'Son'),
                             (123456789, 'Alice',     'F', '1988-12-30', 'Daughter'),
                             (123456789, 'Elizabeth', 'F', '1967-05-05', 'Spouse');
INSERT INTO department VALUES ('Research',       5, 333445555, '1988-05-22', '1986-05-22'),
							  ('Administration', 4, 987654321, '1995-01-01', '1994-01-01'),
                              ('Headquarters',   1, 888665555, '1981-06-19', '1980-06-19');
INSERT INTO dept_locations VALUES (1, 'Houston'),
								  (4, 'Stafford'),
                                  (5, 'Bellaire'),
                                  (5, 'Sugarland'),
                                  (5, 'Houston');
INSERT INTO project VALUES ('ProductX',         1, 'Bellaire',  5),
						   ('ProductY',         2, 'SugarLand', 5),
                           ('ProductZ',         3, 'Houston',   5),
                           ('Computerization', 10, 'Stafford',  4),
                           ('Reorganization',  20, 'Houston',   1),
                           ('NewBenefits',     30, 'Stafford',  4);
INSERT INTO works_on VALUES (123456789, 1, 32.5),
							(123456789, 2, 7.5),
                            (666884444, 3, 40.0),
                            (453453453, 1, 20.0),
                            (453453453, 2, 20.0),
                            (333445555, 2, 10.0),
                            (333445555, 3, 10.0),
                            (333445555, 10, 10.0),
                            (333445555, 20, 10.0),
                            (999887777, 30, 30.0),
                            (999887777, 10, 10.0),
                            (987987987, 10, 35.0),
                            (987987987, 30, 5.0),
                            (987654321, 20, 15.0),
                            (987654321, 30, 20.0),
                            (888665555, 20, 0.0);

-- Recuperando Informações com Queries --
SELECT * FROM employee;
	-- Gerente & Seu Departamento --
SELECT ssn, fname, dname FROM employee e, department d WHERE (e.ssn = d.mgr_ssn);
	
    -- Dependendentes dos Empregados
SELECT fname, dependant_name, relationship FROM employee, dependant WHERE essn = ssn;
SELECT bdate, address FROM employee WHERE fname = 'John' AND minit = 'B' and lname = 'Smith';

	-- Recuperando Departamento Específico -
SELECT * FROM department WHERE dname = 'Research';
SELECT fname, lname, address FROM employee AS e, department AS d WHERE d.dname = 'Research' AND d.dnumber=e.dno;

	-- Recuperando múltiplos atributos de múltiplas tabelas sob critérios específicos --
SELECT pname, essn, fname, hours FROM project AS p, works_on AS w, employee AS e WHERE p.pnumber = w.pnumber AND w.essn = e.ssn;

-- Realizando Queries com Alias --
SELECT dname AS Department_name, dlocation AS Department_location FROM department AS d, dept_locations AS l WHERE d.dnumber = l.dnumber;
SELECT concat(fname, " ", lname) AS Employee FROM employee;

-- Submetendo Queries SQL com Expressões ao Banco de Dados --
SELECT fname, lname, salary, round(salary * 0.11, 2) AS INSS FROM employee; -- Recolher INSS
SELECT concat(fname, ' ', lname) AS complete_name, salary, round(salary * 1.10,2) AS increased_salary -- Aumento para Funcionários específicos
	FROM employee AS e, works_on AS w, project AS p 
	WHERE (e.ssn = w.essn AND w.pnumber = p.pnumber and p.pname = 'ProductX');
SELECT concat(fname, ' ', lname) AS complete_name, address FROM employee AS e, department AS d WHERE d.dname = 'Research' AND d.dnumber = e.dno;

-- Expressões e Operações de Conjunts --
SELECT dname AS Department_Name, concat(fname, ' ', lname) AS Employee_Name, ssn AS Employee_ssn, address -- Gerentes
	FROM department AS d, dept_locations AS l, employee AS e
	WHERE d.dnumber = l.dnumber AND d.mgr_ssn = e.ssn;
SELECT dname AS Department_Name, concat(fname, ' ', lname) AS Employee_Name, ssn AS Employee_ssn, address -- Gerentes em Stafford
	FROM department AS d, dept_locations AS l, employee AS e
	WHERE d.dnumber = l.dnumber AND d.mgr_ssn = e.ssn AND l.dlocation = 'Stafford';
SELECT pnumber, p.dnumber, lname, address, bdate, p.plocation
	FROM department AS d, project AS p, employee AS e
    WHERE d.dnumber = p.dnumber AND p.plocation = 'Stafford' AND d.mgr_ssn = e.ssn;

-- Like e Between --
SELECT concat(fname, ' ', lname) AS Complete_Name, dname AS Department_Name, address AS Address 
	FROM employee AS e, department AS d
    WHERE (e.dno = d.dnumber AND e.address LIKE "%Houston%");
SELECT fname, lname, salary FROM employee WHERE (salary BETWEEN 30000 AND 40000); -- BETWEEN considera os extremos.
SELECT fname, lname, salary FROM employee WHERE (salary > 30000 AND salary < 40000);

-- Mais operações --
SELECT bdate, address FROM employee WHERE fname = 'John' AND minit = 'B' AND lname = 'Smith';
SELECT * FROM department WHERE dname = 'Research' OR dname = 'Administration';
SELECT concat(fname, ' ', lname) AS Complete_Name FROM employee AS e, department AS d WHERE d.dname = 'Research' AND d.dnumber = e.dno;

-- Subqueries --
SELECT DISTINCT pnumber 
	FROM project
	WHERE pnumber IN
			(SELECT pnumber
			FROM project AS p, department AS d, employee AS e
			WHERE mgr_ssn = ssn AND lname = 'Smith' AND p.dnumber = d.dnumber)
        OR
          pnumber IN
			(SELECT DISTINCT pnumber
            FROM works_on, employee
            WHERE essn = ssn AND lname = 'Smith');
            
-- Mais um Exemplo de Subquery --
SELECT * 
	FROM works_on
    WHERE (pnumber, hours) IN 
			(SELECT pnumber, hours 
            FROM works_on
            WHERE essn=123456789);

-- Cláusulas com Exists e Unique --
SELECT concat(fname, ' ', lname) AS Employee_Name -- Funcionários que possuem dependentes
	FROM employee AS e
    WHERE EXISTS (SELECT *
				 FROM dependant AS d 
                 WHERE (e.ssn = d.essn));
SELECT concat(fname, ' ', lname) AS Employee_Name -- Funcionários que possuem dependentes filhas
	FROM employee AS e
    WHERE EXISTS (SELECT *
				 FROM dependant AS d 
                 WHERE (e.ssn = d.essn AND d.relationship = 'Daughter'));
SELECT concat(fname, ' ', lname) AS Employee_Name -- Funcionários que não possuem dependentes
	FROM employee AS e
    WHERE NOT EXISTS (SELECT *
					 FROM dependant AS d
					 WHERE (e.ssn = d.essn));
SELECT concat(fname, ' ', lname) AS Employee_Name -- Gerentes que possuem dependentes
	FROM employee AS e, department AS de
	WHERE (e.ssn = de.mgr_ssn) AND EXISTS (SELECT * FROM dependant AS d WHERE (e.ssn = d.essn));
SELECT fname, lname -- Número de Dependentes de um Funcionário
	FROM employee AS e
    WHERE (SELECT count(*) 
		  FROM dependant AS d
          WHERE e.ssn = d.essn) >= 2;
SELECT DISTINCT essn, pnumber -- Funcionários que Trabalham nos Projetos de id 1, 2 e 3
	FROM works_on
    WHERE pnumber IN (1, 2, 3);

-- Cláusulas de Ordenação --
SELECT * FROM employee;
SELECT * FROM employee ORDER BY dno DESC;
SELECT * FROM employee ORDER BY fname, lname;
SELECT DISTINCT dname, concat(fname, ' ', lname) AS Manager, address AS Address -- Nome do Departamento, Nome do Gerente e Endereço
	FROM department AS d, employee AS e, works_on AS w, project AS p
    WHERE (d.dnumber = e.dno AND e.ssn = d.mgr_ssn AND w.pnumber = p.pnumber)
    ORDER BY d.dname, e.fname, e.lname;
SELECT dname AS Department, concat(fname, ' ', lname) AS Employee, pname AS Project_Name -- Funcionários e seus Projetos em Andamento
	FROM department AS d, employee AS e, works_on AS w, project AS p
    WHERE (d.dnumber = e.dno AND e.ssn = w.essn AND w.pnumber = p.pnumber)
    ORDER BY d.dname DESC, e.fname ASC, e.lname ASC;

-- Agrupando Registros & Experimentando Funções --
SELECT count(*) FROM employee;
SELECT dno, count(*) AS instancias, round(AVG(salary),2) AS media FROM employee GROUP BY dno;
SELECT p.pnumber, pname, count(*)
	FROM project AS p, works_on AS w
    WHERE p.pnumber = w.pnumber
    GROUP BY p.pnumber, p.pname;
SELECT count(DISTINCT salary) FROM employee;
SELECT round(sum(salary), 2) AS Total_Salary, round(max(salary), 2) AS Max_Salary, round(min(salary), 2) AS Min_Salary, 
	   round(AVG(salary), 2) AS Avg_Salary FROM employee;

-- Explorando Cláusulas de Agrupamento com SQL --
SELECT p.pnumber AS Project_No, p.pname AS Project_Name, count(*) AS Number_Tuples, round(AVG(salary), 2) AS Average_Salary 
	FROM project AS p, works_on AS w, employee as e
    WHERE w.pnumber = p.pnumber AND w.essn = e.ssn
    GROUP BY p.pnumber, p.pname
    ORDER BY AVG(salary) DESC;

-- Group By & Having --
SELECT p.pnumber, pname, count(*)
	FROM project AS p, works_on AS w
    WHERE p.pnumber = w.pnumber
    GROUP BY p.pnumber, p.pname HAVING count(*) > 2;
SELECT dno, count(*)
	FROM employee
    WHERE salary > 30000
    GROUP BY dno HAVING count(*) >= 2;
SELECT dno, count(*)
	FROM employee
    WHERE salary > 20000 AND dno in (SELECT dno
									FROM employee
									GROUP BY dno HAVING count(*) >= 2) 
    GROUP BY dno;

-- CASE Statement (safe mode off) --
UPDATE employee
	SET salary = CASE
					WHEN dno = 5 THEN salary + 2000
					WHEN dno = 4 THEN salary + 1500
					WHEN dno = 1 THEN salary + 3000
					ELSE salary + 0
				END;
SELECT fname, dno, salary FROM employee;

-- JOIN Statement --
SELECT * FROM employee JOIN works_on;

-- INNER JOIN = JOIN ON --
SELECT * FROM employee JOIN works_on ON ssn = essn;
SELECT * FROM employee JOIN department ON ssn = mgr_ssn;
SELECT fname, lname, address
	FROM employee JOIN department ON dno = dnumber
    WHERE dname = 'Research';

SELECT dname AS Department, dept_create_date AS Create_Date, dlocation AS Location
	FROM department JOIN dept_locations USING (dnumber)
    GROUP BY dlocation
    ORDER BY Create_Date;

-- CROSS JOIN = Apenas JOIN = Produto Cartesiano --
SELECT * FROM employee CROSS JOIN dependant;

-- JOIN Statemente com Mais de 2 Tabelas --
SELECT concat(fname, ' ', lname) AS Complete_Name, dno, pname, p.pnumber, plocation 
	FROM employee AS e INNER JOIN works_on AS W ON ssn = essn
					   INNER JOIN project  AS p ON w.pnumber = p.pnumber
	WHERE p.pname LIKE 'Product%'
    ORDER BY p.pnumber;
SELECT dnumber, dname, concat(fname, ' ', lname) AS Manager, salary, round(salary * 0.05, 2) AS Bonus
	FROM department INNER JOIN dept_locations USING (dnumber)
					INNER JOIN employee ON ssn = mgr_ssn
	GROUP BY dnumber HAVING count(*) > 1;
SELECT dnumber, dname, concat(fname, ' ', lname) AS Manager, salary, round(salary * 0.05, 2) AS Bonus
	FROM department INNER JOIN dept_locations USING (dnumber)
					INNER JOIN (dependant INNER JOIN employee ON ssn = essn) ON ssn = mgr_ssn
	GROUP BY dnumber HAVING count(*) > 1;

-- OUTER JOIN --
SELECT * FROM employee;
SELECT * FROM dependant;
SELECT * FROM employee INNER JOIN dependant ON ssn = essn;
SELECT * FROM employee LEFT JOIN dependant ON ssn = essn;
SELECT * FROM employee LEFT OUTER JOIN dependant ON ssn = essn;