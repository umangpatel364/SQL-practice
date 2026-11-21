CREATE DATABASE OnlineRetailDB;
USE OnlineRetailDB;
CREATE TABLE Customers(
 	CustomerID INT AUTO_INCREMENT PRIMARY KEY,
     FirstName VARCHAR(50) NOT NULL,
     LastName VARCHAR(50) NOT NULL,
     Email VARCHAR(100) UNIQUE ,
     Phone VARCHAR(50),
     Address VARCHAR(255),
     City VARCHAR(50),
     State VARCHAR(50),
     ZipCode VARCHAR(50),
     Country VARCHAR(50),
     CreatedAT DATETIME DEFAULT Now()
 );
  CREATE TABLE Categories(
 	 CategoryID INT AUTO_INCREMENT PRIMARY KEY,
     CategoryName VARCHAR(100),
     Description VARCHAR(255)
 );
 
 CREATE TABLE Products(
 	 ProductID INT AUTO_INCREMENT PRIMARY KEY,
     ProductName VARCHAR(100),
     CategoryID INT,
     Price DECIMAL(10,2) CHECK (Price >= 0),
     Stock INT,
     CreatedAT DATETIME DEFAULT NOW(),
     FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
 );

CREATE TABLE Orders(
	OrderID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT NOW(),
    TotalAmount DECIMAL(10,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);
CREATE TABLE OrderItems(
	OrderItemID INT AUTO_INCREMENT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Categories (CategoryName, Description)
VALUES
('Electronics', 'Devices and Gadgets'), 
('Clothing', 'Apparel and Accessories'), 
('Books', 'Printed and Electronic Books');

INSERT INTO Products (ProductName, CategoryID, Price, Stock) VALUES 
('Smartphone',1, 699.99, 50),
('Laptop',1, 999.99, 30), 
('T-shirt', 2, 19.99, 100), 
('Jeans', 2, 49.99, 60), 
('Fiction Novel', 3, 14.99, 200), 
('Science Journal', 3, 29.99, 150);

INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES
('Sameer','Khanna','sameer.khanna@example.com','123-456-7890','123 Elm St.','Springfield','IL', '62701', 'USA'), 
('Jane', 'Smith', 'jane.smith@example.com', '234-567-8901', '456 Oak St.', 'Madison', 'WI', '53703', 'USA'), 
('harshad', 'patel', 'harshad.patel@example.com', '345-678-9012', '789 Dalal St.', 'Mumbai', 'Maharashtra', '41523', 'INDIA');

INSERT INTO Orders (CustomerID, OrderDate ,TotalAmount)
VALUES 
(1, NOW(), 719.98),(2, NOW(), 49.99),(3, NOW(), 44.98);

INSERT INTO OrderItems(OrderID, ProductID, Quantity, Price) 
VALUES
(1, 1, 1, 699.99), (1, 3, 1, 19.99), (2, 4, 1, 49.99), (3, 5, 1, 14.99), (3, 6, 1, 29.99);

-- QUERY 1
SELECT o.OrderID, o.OrderDate, o.TotalAmount, p.ProductID, p.ProductName, oi.Quantity, oi.Price
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p ON p.ProductID = oi.ProductID
WHERE o.CustomerID = 1;

-- QUERY 2 : Find total sale for each product
SELECT p.ProductID, p.ProductName, SUM(oi.Quantity * oi.Price) AS TotalSale
FROM OrderItems oi 
JOIN Products p ON oi.ProductID =  p.ProductID
GROUP BY p.ProductId , p.ProductName
ORDER BY TotalSale DESC;

-- QUERY 3 : Calculate Avg order value 
SELECT AVG(TotalAmount) AS AvgOrderValue FROM Orders;

-- QUERY 4 : List the top 5 costumer by total spending
SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpending 
FROM Orders o
JOIN Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY TotalSpending DESC LIMIT 0,5;   -- IT MEANS START FROM 0 INDEX AND PRINT NEXT COMING 5 RESULT
 
-- QUERY 5 : Retrive most popular product category
SELECT c.CategoryID, c.CategoryName, SUM(oi.Quantity) AS MostPopularCategory 
FROM OrderItems oi
JOIN Products p ON p.ProductID = oi.ProductID
JOIN Categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY MostPopularCategory DESC LIMIT 2; 
-- when tie then use "ORDER BY MostPopularCategory DESC, c.CategoryID ASC LIMIT 2or1;"

INSERT INTO Products (ProductName, CategoryID, Price, Stock) VALUES ('Keyboard',1, 69.99, 0);
-- QUERY 6 : List all products that out of stock
SELECT * FROM Products WHERE Stock = 0;
-- select only imp things
SELECT ProductID, ProductName, Stock FROM Products WHERE Stock = 0;
-- Also When need Categoty name
SELECT  p.ProductID, p.ProductName, c.CategoryName, p.Stock 
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE Stock = 0;

-- QUERY 7 : Find Customers who place orders in the last 30 days
SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone, o.OrderDate 
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID
WHERE OrderDate >= NOW() - INTERVAL 30 DAY;

-- QUERY 8 : Calculate Total Number of orders place each month
SELECT YEAR(OrderDate) AS OrderYear, 
MONTH(OrderDate) AS OrderMonth,
COUNT(OrderID) AS TotalOrder
FROM Orders 
GROUP BY YEAR(OrderDate), MONTH(OrderDate)  -- Year does not mention so we take all Year
ORDER BY OrderYear, OrderMonth; -- Here it is optional but use for better understanding when too much data present

-- QUERY 9 : Retrieve the detail of most recent Order
SELECT o.OrderID, o.OrderDate, o.TotalAmount, c.FirstName, c.LastName
FROM Customers c
JOIN Orders o ON o.CustomerID = c.CustomerID 
ORDER BY OrderDate DESC LIMIT 1;

-- QUERY 10 : Find AVG price of products in each categary
SELECT c.CategoryID, c.CategoryName, AVG(p.Price) AS AvgPriceOfCategory
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY AvgPriceOfCategory DESC;

-- QUERY 11 : List Customer who have never place an order
 
-- Simple Insert coustmer that does not make trancation 
-- Here we use left join when customer on left or full Join
-- we use only JOIN then Insert new coustmer does not print because for that cousmer orders value is null
-- JOIN print those that this present on both table 
 
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, ZipCode, Country)
VALUES
('Umang','mhanna','Umang.munna@example.com','123-556-7890','125 Elm St.','Upringfield','IT', '62707', 'UA');

SELECT c.CustomerID, c.FirstName, c.LastName, c.Email, c.Phone , o.OrderID, o.TotalAmount
FROM Customers c 
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID  -- Why We write c table on left see reson on upper comment
WHERE OrderID IS NULL; 

-- QUERY 12 :Reterive the total quality sold for each product
SELECT p.ProductID, p.ProductName, SUM(oi.Quantity) AS ToatalQuantity
FROM Products p JOIN OrderItems oi ON oi.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName;

-- QUERY 13 :Calculate the total revenue generated from each category
SELECT c.CategoryID, c.CategoryName, SUM(oi.Quantity * oi.Price) AS totalrevenu
FROM  OrderItems oi
JOIN Products p ON p.ProductID = oi.ProductID
JOIN Categories c ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY totalrevenu DESC;

-- QUERY 14 : Find highest Pricce product in each category
-- It give all products of each category
-- SELECT c.CategoryID, c.CategoryName, p.ProductID, p.ProductName, p.Price 
-- FROM Products p JOIN Categories c ON p.CategoryID = c.CategoryID
-- WHERE p.Price >= 0
-- ORDER BY  Price DESC;

-- It give max price of product for each category
SELECT c.CategoryID, c.CategoryName, p1.ProductID, p1.ProductName, p1.Price 
FROM Products p1 JOIN Categories c ON p1.CategoryID = c.CategoryID
WHERE p1.Price = (SELECT MAX(Price) FROM Products p2 WHERE p1.CategoryID = p2.CategoryID)
ORDER BY  Price DESC;

-- QUERY 15 : Reterive Order with a total amount grater than a specific value(e.g. 49.99$)
SELECT o.OrderID, c.FirstName, c.LastName, o.TotalAmount
FROM Customers c JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.TotalAmount >= 49.99
ORDER BY o.TotalAmount DESC; 

 -- QUERY 16 : List Product along with the number of orders they appear in
 SELECT p.ProductID, p.ProductName, COUNT(oi.OrderID) AS OrderCount
 FROM Products p 
 JOIN OrderItems oi ON oi.ProductID = p.ProductID
 GROUP BY p.ProductID, p.ProductName
 ORDER BY OrderCount DESC;
 
 -- QUERY 17 : Find top 3 most frequent ordered products
 SELECT p.ProductID, p.ProductName, COUNT(oi.OrderID) AS OrderCount
 FROM Products p 
 JOIN OrderItems oi ON oi.ProductID = p.ProductID
 GROUP BY p.ProductID, p.ProductName
 ORDER BY OrderCount DESC LIMIT 0,3; 
 
 -- QUERY 18 : Calculate total number of customer of each country
 SELECT Country, COUNT(CustomerID) AS TotalNumberOfCusomers
 FROM Customers 
 GROUP BY Country
 ORDER BY TotalNumberOfCusomers DESC;
 
 -- QUERY 19 : Retrive the list of Customers along with their total spending
 SELECT c.CustomerID, c.FirstName, c.LastName, SUM(o.TotalAmount) AS TotalSpending
 FROM Customers c JOIN Orders o ON o.CustomerID = c.CustomerID
 GROUP BY c.CustomerID, c.FirstName, c.LastName
 ORDER BY TotalSpending DESC;
 
 -- QUERY 20 : List Orders with more than  a specific Number of items(e.g. 5)
SELECT o.OrderID, c.FirstName, c.LastName, COUNT(oi.OrderItemID) AS NumberOfItems
FROM Orders o 
JOIN Customers c ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON oi.OrderID = o.OrderID
GROUP BY o.OrderID, c.FirstName, c.LastName
HAVING NumberOfItems >= 1        -- We use HAVING instend of Where beacuse HAVING is use after or with GROUP BY when WHERE use before GROUP BY
ORDER BY NumberOfItems DESC;


-- DROP DATABASE OnlineRetailDB;