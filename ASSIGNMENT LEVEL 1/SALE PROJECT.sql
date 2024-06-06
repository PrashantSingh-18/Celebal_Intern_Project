--Creating DataBase
CREATE DATABASE SALE

USE SALE

-- Create the Sales table
CREATE TABLE Sales(
ProductCategory VARCHAR(50),
ProductName VARCHAR(50),
SaleAmount DECIMAL(10,2)
);

-- Insert the sample data into the Sales table
INSERT INTO Sales (ProductCategory, ProductName, SaleAmount) VALUES
('Electronics', 'Laptop', 1000.00),
('Electronics', 'Phone', 800.00),
('Electronics', 'Tablet', 500.00),
('Clothing', 'Shirt', 300.00),
('Clothing', 'Pants', 400.00),
('Furniture', 'Sofa', 1200.00),
('Furniture', 'Bed', 900.00);

SELECT * FROM Sales

--Using ROLLUP function:

SELECT 
    ProductCategory, 
    ProductName,
    SUM(SaleAmount) AS TotalSales
FROM 
    Sales
GROUP BY 
    ROLLUP (ProductCategory, ProductName)
ORDER BY 
    CASE 
        WHEN ProductCategory IS NULL THEN 1 
        ELSE 0 
    END, 
    ProductCategory, 
    CASE 
        WHEN ProductName IS NULL THEN 1 
        ELSE 0 
    END, 
    ProductName;


--USING COALESCE FUNCTION TO REMOVE NULL

SELECT 
    COALESCE(ProductCategory, 'TOTAL') AS ProdcutCategory, 
    COALESCE(ProductName, 'TOTAL') AS ProductName,
    SUM(SaleAmount) AS TotalSales
FROM 
    Sales
GROUP BY 
    ROLLUP (ProductCategory, ProductName)
ORDER BY 
    CASE 
        WHEN ProductCategory IS NULL THEN 1 
        ELSE 0 
    END, 
    ProductCategory, 
    CASE 
        WHEN ProductName IS NULL THEN 1 
        ELSE 0 
    END, 
    ProductName;
