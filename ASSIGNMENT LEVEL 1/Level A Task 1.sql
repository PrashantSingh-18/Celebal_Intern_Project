USE AdventureWorks2022
GO


-- 1.List of all customers

 SELECT 
     c.CustomerID,
     p.FirstName,
     p.LastName,
     pe.EmailAddress
 FROM 
     Sales.Customer AS c
 JOIN 
     Person.Person AS p
 ON 
     c.PersonID = p.BusinessEntityID
 LEFT JOIN 
     Person.EmailAddress AS pe
 ON 
     p.BusinessEntityID = pe.BusinessEntityID;

---2. List of all customers where company name ending in N.

SELECT 
    c.CustomerID, 
    s.Name AS CompanyName
FROM 
    Sales.Customer c
JOIN 
    Sales.Store s ON c.StoreID = s.BusinessEntityID
WHERE 
    s.Name LIKE '%N';

-- 3.  list of all customers who live in Berlin or London

 SELECT 
     
     s.Name, p.FirstName, p.LastName, a.City, a.AddressLine1
 
 FROM 
     
     [Sales].[Customer] c
 
 JOIN
  
  [Sales].[Store] s ON c.StoreID = s.BusinessEntityID
 
 JOIN 
      
     [Person].[Person] p ON c.CustomerID = p.BusinessEntityID
 
 JOIN 
     
     [Person].[Address] a ON a.AddressID = a.AddressID
 
 WHERE 
    
     a.City in ('Berlin', 'London');

-- 4. list of all customers who live in UK or USA

SELECT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName, 
    a.City, 
    sp.Name AS Country
FROM 
    Sales.Customer AS c
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
JOIN 
    Person.BusinessEntityAddress AS bea ON c.CustomerID = bea.BusinessEntityID
JOIN 
    Person.Address AS a ON bea.AddressID = a.AddressID
JOIN 
    Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion AS cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE 
    cr.Name IN ('United Kingdom', 'United States');

-- 5. list of all products sorted by product name

SELECT 
    ProductID, 
    Name, 
    ProductNumber, 
    Color, 
    StandardCost, 
    ListPrice, 
    Size, 
    Weight
FROM 
    Production.Product
ORDER BY 
    Name;

-- 6. List of all products where product name starts with an A

SELECT 
    ProductID, 
    Name, 
    ProductNumber, 
    Color, 
    StandardCost, 
    ListPrice, 
    Size, 
    Weight
FROM 
    Production.Product
WHERE 
    Name LIKE 'A%'
ORDER BY 
    Name;

-- 7.  List of customers who ever placed an order

SELECT DISTINCT
    c.CustomerID, 
    p.FirstName, 
    p.LastName, 
	c.TerritoryID
FROM 
    Sales.Customer AS c
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
LEFT JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
ORDER BY 
    c.CustomerID;

-- 8. list of Customers who live in London and have bought chai

SELECT DISTINCT
    c.CustomerID,
    p.FirstName,
    p.LastName,
    a.City,
    pr.Name AS ProductName
FROM 
    Sales.Customer AS c
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product AS pr ON sod.ProductID = pr.ProductID
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
JOIN 
    Person.BusinessEntityAddress AS bea ON p.BusinessEntityID = bea.BusinessEntityID
JOIN 
    Person.Address AS a ON bea.AddressID = a.AddressID
WHERE 
    a.City = 'London'
    AND pr.Name = 'Chai'
ORDER BY 
    c.CustomerID;

-- 9. List of customers who never place an order
SELECT 
    c.CustomerID, 
    p.FirstName, 
    p.LastName
FROM 
    Sales.Customer AS c
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
LEFT JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
WHERE 
    soh.CustomerID IS NULL;

-- 10. List of customers who ordered Tofu

SELECT DISTINCT
    c.CustomerID, 
    p.FirstName, 
    p.LastName
FROM 
    Sales.Customer AS c
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product AS pr ON sod.ProductID = pr.ProductID
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
WHERE 
    pr.Name = 'Tofu';

-- 11.  Details of first order of the system

SELECT TOP 1
    soh.SalesOrderID,
    c.CustomerID,
    p.FirstName,
    p.LastName,
    soh.OrderDate,
    sod.ProductID,
    pr.Name AS ProductName,
    sod.UnitPrice,
    sod.OrderQty,
    sod.LineTotal
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Sales.Customer AS c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
JOIN 
    Production.Product AS pr ON sod.ProductID = pr.ProductID
WHERE 
    soh.OrderDate = (
        SELECT MIN(OrderDate) FROM Sales.SalesOrderHeader
    );


-- 12. Find the details of most expensive order date

SELECT TOP 1
    soh.SalesOrderID,
    c.CustomerID,
    p.FirstName,
    p.LastName,
    soh.OrderDate,
    SUM(sod.LineTotal) AS TotalAmount
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Sales.Customer AS c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
GROUP BY
    soh.SalesOrderID,
    c.CustomerID,
    p.FirstName,
    p.LastName,
    soh.OrderDate
ORDER BY 
    TotalAmount DESC;

-- 13. For each order get the OrderID and Average quantity of items in that order

SELECT
    soh.SalesOrderID,
    AVG(sod.OrderQty) AS AverageQuantity
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    soh.SalesOrderID;

-- 14. For each order get the orderID, minimum quantity and maximum quantity for that order

SELECT
    soh.SalesOrderID,
    MIN(sod.OrderQty) AS MinimumQuantity,
    MAX(sod.OrderQty) AS MaximumQuantity
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    soh.SalesOrderID;

-- 15. Get a list of all managers and total number of employees who report to them
SELECT 
    mgr.BusinessEntityID AS ManagerID,
    CONCAT(p.FirstName, ' ', p.LastName) AS ManagerName,
    COUNT(emp.BusinessEntityID) AS TotalEmployees
FROM 
    HumanResources.Employee AS mgr
JOIN 
    HumanResources.Employee AS emp ON mgr.BusinessEntityID = emp.ManagerID
JOIN 
    Person.Person AS p ON mgr.BusinessEntityID = p.BusinessEntityID
GROUP BY 
    mgr.BusinessEntityID, p.FirstName, p.LastName
ORDER BY 
    TotalEmployees DESC;

-- 16.  Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
SELECT 
    soh.SalesOrderID AS OrderID,
    SUM(sod.OrderQty) AS TotalQuantity
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    soh.SalesOrderID
HAVING 
    SUM(sod.OrderQty) > 300;

-- 17. list of all orders placed on or after 1996/12/31
SELECT 
    SalesOrderID,
    OrderDate
FROM 
    Sales.SalesOrderHeader
WHERE 
    OrderDate >= '1996-12-31';

-- 18. list of all orders shipped to Canada
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    a.AddressLine1,
    a.City,
    sp.Name AS StateProvince,
    cr.Name AS CountryRegion
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Person.Address AS a ON soh.ShipToAddressID = a.AddressID
JOIN 
    Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion AS cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE 
    cr.Name = 'Canada';

-- 19. list of all orders with order total > 200
SELECT 
    soh.SalesOrderID,
    SUM(sod.LineTotal) AS OrderTotal
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY 
    soh.SalesOrderID
HAVING 
    SUM(sod.LineTotal) > 200;

-- 20. List of countries and sales made in each country
SELECT 
    cr.Name AS Country,
    SUM(soh.TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Person.Address AS a ON soh.ShipToAddressID = a.AddressID
JOIN 
    Person.StateProvince AS sp ON a.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion AS cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY 
    cr.Name;

-- 21. List of Customer Contact Name and number of orders they placed
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM 
    Sales.Customer AS c
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY 
    p.FirstName, p.LastName;

-- 22. List of customer contactnames who have placed more than 3 orders
SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS ContactName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM 
    Sales.Customer AS c
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
GROUP BY 
    p.FirstName, p.LastName
HAVING 
    COUNT(soh.SalesOrderID) > 3;

-- 23.  List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.DiscontinuedDate
FROM 
    Production.Product AS p
JOIN 
    Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
JOIN 
    Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE 
    p.DiscontinuedDate IS NOT NULL
    AND soh.OrderDate >= '1997-01-01'
    AND soh.OrderDate < '1998-01-01';

-- 24.  List of employee firsname, lastName, superviser FirstName, LastName
SELECT 
    e.FirstName AS EmployeeFirstName,
    e.LastName AS EmployeeLastName,
    s.FirstName AS SupervisorFirstName,
    s.LastName AS SupervisorLastName
FROM 
    HumanResources.Employee AS emp
JOIN 
    Person.Person AS e ON emp.BusinessEntityID = e.BusinessEntityID
LEFT JOIN 
    HumanResources.Employee AS sup ON emp.OrganizationNode.GetAncestor(1) = sup.OrganizationNode
LEFT JOIN 
    Person.Person AS s ON sup.BusinessEntityID = s.BusinessEntityID;

-- 25. List of Employees id and total sale condcuted by employee
SELECT 
    emp.BusinessEntityID AS EmployeeID,
    SUM(soh.TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesPerson AS sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN 
    HumanResources.Employee AS emp ON sp.BusinessEntityID = emp.BusinessEntityID
GROUP BY 
    emp.BusinessEntityID;

-- 26. List of employees whose First Name contains character a
SELECT 
    e.BusinessEntityID,
    e.FirstName,
    e.LastName
FROM 
    HumanResources.Employee AS emp
JOIN 
    Person.Person AS e ON emp.BusinessEntityID = e.BusinessEntityID
WHERE 
    e.FirstName LIKE '%a%';

-- 27.  List of managers who have more than four people reporting to them
SELECT 
    m.BusinessEntityID AS ManagerID,
    p.FirstName AS ManagerFirstName,
    p.LastName AS ManagerLastName,
    COUNT(e.BusinessEntityID) AS NumberOfReports
FROM 
    HumanResources.Employee AS e
JOIN 
    HumanResources.Employee AS m ON e.OrganizationNode.GetAncestor(1) = m.OrganizationNode
JOIN 
    Person.Person AS p ON m.BusinessEntityID = p.BusinessEntityID
GROUP BY 
    m.BusinessEntityID, p.FirstName, p.LastName
HAVING 
    COUNT(e.BusinessEntityID) > 4;

-- 28. List of Orders and ProductNames
SELECT 
    soh.SalesOrderID,
    p.Name AS ProductName
FROM 
    Sales.SalesOrderDetail AS sod
JOIN 
    Sales.SalesOrderHeader AS soh ON sod.SalesOrderID = soh.SalesOrderID
JOIN 
    Production.Product AS p ON sod.ProductID = p.ProductID
ORDER BY 
    soh.SalesOrderID;

-- 29. List of orders place by the best customer

-- Step 1: Identify the best customer by the total value of orders
SELECT TOP 1 
    CustomerID
INTO #BestCustomer
FROM 
    Sales.SalesOrderHeader
GROUP BY 
    CustomerID
ORDER BY 
    SUM(TotalDue) DESC;

-- Step 2: Retrieve the orders placed by the best customer
SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    #BestCustomer AS bc ON soh.CustomerID = bc.CustomerID
ORDER BY 
    soh.OrderDate;

-- Clean up temporary table
-- DROP TABLE #BestCustomer;


-- 30. List of orders placed by customers who do not have a Fax number

SELECT 
    soh.SalesOrderID,
    soh.OrderDate,
    soh.TotalDue,
    c.CustomerID,
    p.FirstName,
    p.LastName
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.Customer AS c ON soh.CustomerID = c.CustomerID
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
LEFT JOIN 
    Person.PersonPhone AS pp ON p.BusinessEntityID = pp.BusinessEntityID AND pp.PhoneNumberTypeID = 3 -- Assuming fax number type is 3
WHERE 
    pp.PhoneNumber IS NULL
ORDER BY 
    soh.OrderDate;

-- 31.  List of Postal codes where the product Tofu was shipped
SELECT DISTINCT
    adr.PostalCode
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product AS p ON sod.ProductID = p.ProductID
JOIN 
    Person.Address AS adr ON soh.ShipToAddressID = adr.AddressID
WHERE 
    p.Name = 'Tofu';

-- 32. List of product Names that were shipped to France
SELECT DISTINCT
    p.Name AS ProductName
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.SalesOrderDetail AS sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN 
    Production.Product AS p ON sod.ProductID = p.ProductID
JOIN 
    Person.Address AS adr ON soh.ShipToAddressID = adr.AddressID
JOIN 
    Person.StateProvince AS sp ON adr.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion AS cr ON sp.CountryRegionCode = cr.CountryRegionCode
WHERE 
    cr.Name = 'France';

-- 33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.
SELECT 
    p.Name AS ProductName,
    pc.Name AS CategoryName
FROM 
    Production.Product AS p
JOIN 
    Production.ProductSubcategory AS psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN 
    Production.ProductCategory AS pc ON psc.ProductCategoryID = pc.ProductCategoryID
LEFT JOIN 
    Purchasing.ProductVendor AS pv ON p.ProductID = pv.ProductID
LEFT JOIN 
    Purchasing.Vendor AS v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE 
    v.Name = 'Specialty Biscuits, Ltd.' OR v.Name IS NULL;

-- 34.  List of products that were never ordered
SELECT 
    p.ProductID,
    p.Name AS ProductName
FROM 
    Production.Product AS p
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM Sales.SalesOrderDetail AS sod
        WHERE sod.ProductID = p.ProductID
    );

-- 35. List of products where units in stock is less than 10 and units on order are 0.
SELECT 
    ProductID,
    Name AS ProductName,
    Quantity AS UnitsInStock,
    QuantityOnOrder AS UnitsOnOrder
FROM 
    Production.Product
WHERE 
    Quantity < 10
    AND QuantityOnOrder = 0;

-- 36. List of top 10 countries by sales

SELECT TOP 10
    cr.Name AS Country,
    SUM(soh.TotalDue) AS TotalSales
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Person.Address AS adr ON soh.ShipToAddressID = adr.AddressID
JOIN 
    Person.StateProvince AS sp ON adr.StateProvinceID = sp.StateProvinceID
JOIN 
    Person.CountryRegion AS cr ON sp.CountryRegionCode = cr.CountryRegionCode
GROUP BY 
    cr.Name
ORDER BY 
    TotalSales DESC;

-- 37.  Number of orders each employee has taken for customers with CustomerIDs between A and AO
SELECT 
    e.BusinessEntityID AS EmployeeID,
    CONCAT(p.FirstName, ' ', p.LastName) AS EmployeeName,
    COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM 
    Sales.SalesOrderHeader AS soh
JOIN 
    Sales.Customer AS c ON soh.CustomerID = c.CustomerID
JOIN 
    Sales.SalesPerson AS sp ON soh.SalesPersonID = sp.BusinessEntityID
JOIN 
    HumanResources.Employee AS e ON sp.BusinessEntityID = e.BusinessEntityID
JOIN 
    Person.Person AS p ON e.BusinessEntityID = p.BusinessEntityID
WHERE 
    c.CustomerID BETWEEN 1 AND 45  -- Assuming CustomerIDs between 1 and 45
GROUP BY 
    e.BusinessEntityID, p.FirstName, p.LastName
ORDER BY 
    NumberOfOrders DESC;

-- 38. Orderdate of most expensive order

SELECT 
    soh.OrderDate
FROM 
    Sales.SalesOrderHeader AS soh
WHERE 
    soh.TotalDue = (
        SELECT 
            MAX(TotalDue)
        FROM 
            Sales.SalesOrderHeader
    );

 -- 39. Product name and total revenue from that product
SELECT 
    p.Name AS ProductName,
    SUM(sod.UnitPrice * sod.OrderQty) AS TotalRevenue
FROM 
    Production.Product AS p
JOIN 
    Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID
GROUP BY 
    p.Name
ORDER BY 
    TotalRevenue DESC;

-- 40. Supplierid and number of products offered

SELECT 
    pv.BusinessEntityID AS SupplierID,
    COUNT(p.ProductID) AS NumberOfProductsOffered
FROM 
    Purchasing.ProductVendor AS pv
JOIN 
    Production.Product AS p ON pv.ProductID = p.ProductID
GROUP BY 
    pv.BusinessEntityID
ORDER BY 
    NumberOfProductsOffered DESC;

-- 41. Top ten customers based on their business
SELECT TOP 10
    c.CustomerID,
    c.AccountNumber,
    CONCAT(p.FirstName, ' ', p.LastName) AS CustomerName,
    SUM(soh.TotalDue) AS TotalSpending
FROM 
    Sales.Customer AS c
JOIN 
    Sales.SalesOrderHeader AS soh ON c.CustomerID = soh.CustomerID
JOIN 
    Person.Person AS p ON c.PersonID = p.BusinessEntityID
GROUP BY 
    c.CustomerID, c.AccountNumber, p.FirstName, p.LastName
ORDER BY 
    TotalSpending DESC;

-- 42. What is the total revenue of the company.
SELECT 
    SUM(TotalDue) AS TotalRevenue
FROM 
    Sales.SalesOrderHeader;
