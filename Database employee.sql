/* [Author - Prabin] */

-- _________________________________________________________________________________________________-


CREATE database db_employee;
USE db_employee;


/*creating tables*/

CREATE TABLE tbl_employee(
employee_name VARCHAR(69) PRIMARY KEY,
street VARCHAR(69),
city VARCHAR(69)
);


/*Run 'tbl_employee' and 'tbl_company' first before the following 'tbl_works' query,
because 'tbl_works' has a foreign key that refers to a primary key in the table 'tbl_company'*/

CREATE TABLE tbl_works(
employee_name VARCHAR(69) PRIMARY KEY,
company_name VARCHAR(69),
salary INT, 
FOREIGN KEY(employee_name) REFERENCES tbl_employee(employee_name),
FOREIGN KEY(company_name) REFERENCES tbl_company(company_name)
);

CREATE TABLE tbl_company(
company_name VARCHAR(69) PRIMARY KEY,
city VARCHAR(69) 
);

CREATE TABLE tbl_manages(
employee_name VARCHAR(69) PRIMARY KEY,
manager_name VARCHAR(69),
FOREIGN KEY(employee_name) REFERENCES tbl_employee(employee_name)
);


/*adding data to tables*/

INSERT INTO tbl_employee(employee_name, street, city)
VALUES 
       ( 'Jones Hetfield', '30 yeah', 'Colorado'),
	   ( 'Lars Ulrich', '31 umm', 'LA'),  
       ( 'Kirk Hammett', '32 omg', 'LA'), 
       ( 'Dave Mustaine', '33 nah', 'Detroit'),
       ( 'Marty Friedman', '33 nah', 'Detroit'),
       ( 'Cliff Burton', '24 rip', 'San Francisco');

SELECT * FROM tbl_employee;
 


 /*Run 'tbl_employee', and 'tbl_company' first before running the following query, 
 in order to not violate foreign key constraints*/
 
INSERT INTO tbl_works(employee_name, company_name, salary)
VALUES
      ( 'Jones Hetfield', 'First Bank Corporation', 30000),
      ( 'Lars Ulrich', 'First Bank Corporation', 25000),
      ( 'Kirk Hammett', 'First Bank Corporation', 20000),
      ( 'Dave Mustaine', 'Small Bank Corporation', 10000),
      ( 'Marty Friedman', 'Small Bank Corporation', 5000),
      ( 'Cliff Burton', 'Metallica', 8000);
      
SELECT * FROM tbl_works;

INSERT INTO tbl_company(company_name, city)
VALUES
	  ( 'First Bank Corporation', 'LA'),
      ( 'Small Bank Corporation', 'Detroit'), 
      ( 'Metallica', 'San Francisco');
      
SELECT * FROM tbl_company;

INSERT INTO tbl_manages(employee_name, manager_name)
VALUES
      ( 'Lars Ulrich', 'Jones Hetfield'),
      ( 'Kirk Hammett', 'Jones Hetfield'),
      ( 'Marty Friedman', 'Dave Mustaine'),
      ( 'Cliff Burton', 'No one');
      
SELECT * FROM tbl_manages;


-- ______________________________________________________________________________________________________________________________________________________________

-- Q.n. 2a (method 1)
SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation';
-- Q.n.2a (method 2)
SELECT * FROM tbl_employee NATURAL JOIN tbl_works WHERE company_name = 'First Bank Corporation';


-- __________________________________________________________________________________________________________________________________________________________________

-- Q.N.2b (method 1)
SELECT employee_name, city FROM tbl_employee WHERE employee_name IN 
       (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation');   /*here table employee doesnt have the info about company name, so we first retrieve that info from works table*/ 

-- Q.N.2b (method 2)
SELECT employee_name , city FROM tbl_employee NATURAL JOIN tbl_works WHERE company_name = 'First Bank Corporation';  /*here join automatically establishes relation with another table, so no need to write long codes to bring info manually*/
/* note that multiple columns is retrieved with commas while multiple conditions are written using 'and' */

-- ______________________________________________________________________________________________________________________________________________________________________

-- Q.N.2C (method 1)
SELECT * FROM tbl_employee WHERE employee_name IN
 (SELECT employee_name FROM tbl_works WHERE company_name = 'First Bank Corporation' AND salary > 10000); 
 
 -- Q.N.2C (method 2)
SELECT * FROM tbl_employee NATURAL JOIN tbl_works WHERE company_name = 'First Bank Corporation' AND salary > 10000;

-- _____________________________________________________________________________________________________________________________________________________________

-- Q.N.2D (method 1)
SELECT * FROM tbl_employee, tbl_works, tbl_company WHERE 
tbl_employee.employee_name = tbl_works.employee_name AND        /* here conditions from multiple tables have to be evaluated*/
tbl_works.company_name = tbl_company.company_name    AND
tbl_employee.city = tbl_company.city;

-- Q.N.2D  (method 2) 
SELECT * FROM tbl_employee INNER JOIN tbl_company ON tbl_employee.city = tbl_company.city; 

-- __________________________________________________________________________________________________________________________________________________________

-- Q.N. 2E (method 1) 
  SELECT E1.employee_name, M.manager_name
FROM tbl_employee E1, tbl_employee E2, tbl_manages M
WHERE
        E1.employee_name = M.employee_name
    AND E2.employee_name = M.manager_name
    AND E1.street = E2.street
    AND E1.city = E2.city;
  
 -- Q.N.2.E (METHOD 2) 
 SELECT t.employee_name, t.manager_name FROM
(SELECT employee_name, manager_name,tbl_employee.city, tbl_employee.street FROM tbl_manages NATURAL join tbl_employee) t 
JOIN tbl_employee ON t.manager_name = tbl_employee.employee_name WHERE t.city = tbl_employee.city AND t.street = tbl_employee.street;
 

 -- ___________________________________________________________________________________________________________________________________________________________
 
 
-- Q.N.2.F (method 1)
 SELECT employee_name FROM  tbl_works WHERE company_name != 'First Bank Corporation';

-- Q.N.2F (method 2)
SELECT employee_name FROM tbl_employee NATURAL JOIN tbl_works WHERE company_name != 'First Bank Corporation';


-- ___________________________________________________________________________________________________________________________________________________________

-- Q.N.2G (method 1) 
SELECT @maxsal := MAX(salary) FROM Tbl_works WHERE company_name = 'Small Bank Corporation';   /* First find max salary from small bank */
SELECT employee_name FROM Tbl_works MAX salary > @maxsal;                                     /* then find other employees who earn more than the above max salary */


-- Q.N.2G (method 2) 
SELECT employee_name FROM tbl_works WHERE salary >
(SELECT MAX(salary) FROM tbl_works NATURAL JOIN tbl_company  WHERE company_name = 'Small Bank Corporation');

-- _____________________________________________________________________________________________________________________________________________________________

-- Q.N. 2H (method 1) 
SELECT company_name FROM tbl_company WHERE city =                                                 /*First find out cities where small bank is located, then find out other companies in those cities */
        (SELECT city FROM tbl_company WHERE company_name = 'Small Bank Corporation');

-- Q.N. 2H (method 2) 
SELECT t2.company_name FROM tbl_company t1 JOIN tbl_company t2 ON t1.city = t2.city 
WHERE t1.company_name = 'Small Bank Corporation' ;


-- ________________________________________________________________________________________________________________________________________________________________
-- Q.N.2i (method 1) 
SELECT employee_name FROM tbl_works WHERE salary >
       (SELECT AVG(salary) FROM tbl_works);
       
-- Q.N.2i (method 2) 
SELECT employee_name FROM tbl_employee NATURAL JOIN tbl_works WHERE salary > (SELECT AVG(salary) FROM tbl_works); 

-- _________________________________________________________________________________________________________________________________________________________________

-- Q.n 2j  
SELECT Tbl_Works.company_name, COUNT(*) AS num_employees FROM Tbl_Works      /*note that 'AS' is used as an alias to make the code readable*/
GROUP BY Tbl_Works.company_name ORDER BY num_employees DESC LIMIT 1;         /*'limit' limits the no of rows*/

-- ______________________________________________________________________________________________________________________________________________________________

-- Q.N.2K  
SELECT company_name FROM tbl_works WHERE salary = (SELECT MIN(salary) FROM tbl_works);

-- _______________________________________________________________________________________________________________________________________________________________

-- Q.n. 2l  
SELECT company_name FROM tbl_works  
  WHERE tbl_works.salary > (SELECT AVG(salary) FROM tbl_works 
                                            WHERE tbl_works.company_name = 'First Bank Corporation');
                                            
 -- ____________________________________________________________________________________________________________________________________________________________
 
 
 -- Q.N.3A  
 SELECT * FROM tbl_employee;
 UPDATE tbl_employee SET city = ' Newtown' WHERE employee_name = 'Jones Hetfield';
 SELECT * FROM tbl_employee;
 
 -- ______________________________________________________________________________________________________________________________________________________________
 
 -- Q.n.3b 
 SELECT * FROM tbl_works;
 UPDATE tbl_works SET salary = salary * 1.1 WHERE tbl_works.company_name = 'First Bank Corporation';
 SELECT * FROM tbl_works;
 
 
 -- ___________________________________________________________________________________________________________________________________________________________
 
 -- Q.N.3c
 SELECT * FROM tbl_works;
 UPDATE tbl_works SET salary = salary * 1.1 WHERE tbl_works.company_name = 'First Bank Corporation'
                                             AND tbl_works.employee_name IN ( SELECT manager_name FROM tbl_manages);
 SELECT * FROM tbl_works;   
 
 
 -- _______________________________________________________________________________________________________________________________________________________________
 
 -- Q.N.3D 
 SELECT * FROM tbl_works;
UPDATE Tbl_Works SET salary = IF( salary < 100000, salary * 1.1 , salary*1.03) WHERE company_name = "First Bank Corporation"
	                                                                           AND tbl_works.employee_name IN (SELECT manager_name FROM  Tbl_Manages);
 SELECT *FROM tbl_works;                               
 
 
 -- ____________________________________________________________________________________________________________________________________________________________________________
 
 -- Q.N.3E
 SELECT * FROM tbl_works;
 DELETE FROM tbl_works WHERE tbl_works.company_name = 'First Bank Corporation';
 SELECT * FROM tbl_works;
 
 /* Here tuple means rows, which are deleted as specified by the question under a given condition, 
 which is the name of the company being 'First Bank Corporation' */
 /*To view the original table for the First Bank Corporation jump to INSERTION part into the table */
 
 -- _______________________________________________________________________________________________________________________________________________________________
 
 
          /*  [THE END] */
