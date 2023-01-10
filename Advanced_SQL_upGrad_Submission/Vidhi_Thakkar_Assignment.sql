# Vidhi Thakkar - UpGrad SQL Certification Assignment

# 1. Write an SQL script to create the tables and set constraints based on the given ER diagram. 
#    Also define the indexes as specified in the ER Diagram.

# Create new Database
CREATE DATABASE IF NOT EXISTS vision;
USE vision;

# Creating new tables and indexes as per the ER Diagram
# Using Char() data type instead of nvarchar() because of the warnings

# Customer Table
CREATE TABLE IF NOT EXISTS
Customer(
Id int NOT NULL,
FirstName char(40),
LastName char(40),
City char(40),
Country char(40),
Phone char(20),
PRIMARY KEY (Id)
);

CREATE INDEX CustomerName
ON Customer (FirstName, LastName);

# Supplier Table
CREATE TABLE IF NOT EXISTS
Supplier(
Id int NOT NULL,
CompanyName char(40),
ContactName char(50),
ContactTitle char(40),
City char(40),
Country char(40),
Phone char(30),
Fax char(30),
PRIMARY KEY (Id)
);

CREATE INDEX SupplierName
ON Supplier (ContactName);

CREATE INDEX SupplierCountry
ON Supplier (Country);

# Product Table
CREATE TABLE IF NOT EXISTS
Product(
Id int NOT NULL,
ProductName char(50),
SupplierId int NOT NULL,
UnitPrice decimal(12,2),
Package char(30),
IsDiscontinued bit,
PRIMARY KEY (Id)
);

CREATE INDEX ProductSuppliedId
ON Product (SupplierId);

CREATE INDEX ProductName
ON Product (ProductName);

# Order Table (Order is an identifier hence used ``)
CREATE TABLE IF NOT EXISTS
`Order`(
Id int NOT NULL,
OrderDate datetime,
OrderNumber char(10),
CustomerId int NOT NULL,
TotalAmount decimal(12,2),
PRIMARY KEY (Id)
);

CREATE INDEX OrderCustomerId
ON `Order` (CustomerId);

CREATE INDEX OrderOrderDate
ON `Order` (OrderDate);

# OrderItem Table
CREATE TABLE IF NOT EXISTS
OrderItem(
Id int NOT NULL,
OrderId int NOT NULL,
ProductId int NOT NULL,
UnitPrice decimal(12,2),
Quantity int,
PRIMARY KEY (Id)
);

CREATE INDEX OrderItemOrderId
ON OrderItem (OrderId);

CREATE INDEX OrderItemProductId
ON OrderItem (ProductId);


# Adding Foreign Key Constraints

ALTER TABLE `Order`
ADD CONSTRAINT fk_Customer_Id FOREIGN KEY (CustomerId) REFERENCES Customer(Id);

ALTER TABLE OrderItem
ADD CONSTRAINT fk_Order_Id FOREIGN KEY (OrderId) REFERENCES `Order`(Id),
ADD CONSTRAINT fk_Product_Id FOREIGN KEY (ProductId) REFERENCES Product(Id);

ALTER TABLE Product
ADD CONSTRAINT fk_Supplier_Id FOREIGN KEY (Supplierid) REFERENCES Supplier(Id);

SHOW TABLES;

DESCRIBE Customer;
DESCRIBE `Order`;
DESCRIBE OrderItem;
DESCRIBE Product;
DESCRIBE Supplier;

# Inserting data file
# One way to insert the data is to Copy paste the text file here in the SQL Query
# Other way is using Command Line Client to insert the data as follows:

# USE vision
# SOURCE C:\Users\thakk\Desktop\SQL_Assignment\data.sql

#Query OK, 91 rows affected (0.01 sec)
#Records: 91  Duplicates: 0  Warnings: 0

#Query OK, 29 rows affected (0.01 sec)
#Records: 29  Duplicates: 0  Warnings: 0

#Query OK, 78 rows affected (0.01 sec)
#Records: 78  Duplicates: 0  Warnings: 0

#Query OK, 830 rows affected (0.08 sec)
#Records: 830  Duplicates: 0  Warnings: 0

#Query OK, 2155 rows affected (0.19 sec)
#Records: 2155  Duplicates: 0  Warnings: 0

# **************************************************************************************************

# 2. The company wants to identify suppliers who are responsible for the highest revenue. 
#    This data would have to be regularly accessed. 
#    Create a view which has the following columns.
#    SupplierId, ProductId, Revenue

CREATE VIEW Highest_Revenue AS 
SELECT S.Id AS SupplierId, P.Id AS ProductId, SUM(O.TotalAmount) AS Revenue
FROM `Order` AS O
INNER JOIN OrderItem as OI ON O.Id = OI.OrderId
INNER JOIN Product AS P ON OI.ProductId = P.Id
INNER JOIN Supplier AS S ON P.SupplierId = S.Id
GROUP BY S.Id
ORDER BY Revenue DESC;

SELECT * FROM Highest_Revenue;


# ***************************************************************************************************

# 3. Write SQL transactions for the following activities:

# a. Adding a new customer to the database.
INSERT INTO customer (Id, FirstName, LastName, City, Country, Phone)
VALUES (92,'Jennifer','Coachren','Huntsville','USA','(469) 988-7527');

SELECT * FROM Customer WHERE Id = 92;

# b. Updating a new order into the database.
INSERT INTO `Order` (Id, OrderDate,  OrderNumber, CustomerId, TotalAmount)
VALUES (831,'2014-07-07  12:00:00', '543208', 90, 960.00);

SELECT * FROM `Order` WHERE Id = 831;

# ***************************************************************************************************

# 4. Vision International ltd. also intends to send out promotional offers to customers 
#    who have placed orders amounting to more than 5000. Identify the names of these customers. 
#    The output table should be:  Customer Name, No of Orders, Total Order Value 

SELECT CONCAT(C.FirstName," ",C.LastName) AS Customer_Name,
SUM(OI.Quantity) AS No_of_Orders,
SUM(O.TotalAmount) AS Total_Order_Value
FROM `Order` AS O
INNER JOIN OrderItem AS OI ON OI.OrderId = O.Id
INNER JOIN Customer AS C ON O.CustomerId = C.Id
GROUP BY C.Id
HAVING Total_Order_Value > 5000 
ORDER BY Total_Order_Value desc; 

# ***************************************************************************************************

# 5. Identify those customers who are responsible for at least 10 orders with the 
#    'average order value' being greater than 1000. 
#     The output table should contain the following columns:
#     Customer Name, No of Orders, Total order value, Average order value

SELECT CONCAT(C.FirstName," ",C.LastName) AS Customer_Name,
COUNT(OI.Quantity) AS No_of_Orders,
SUM(O.TotalAmount) AS Total_Order_Value,
ROUND(SUM(O.TotalAmount)/COUNT(OI.Quantity),2) AS Average_Order_Value
FROM `Order` AS O
INNER JOIN OrderItem AS OI ON OI.OrderId=O.Id
INNER JOIN Customer AS C ON O.customerId=C.Id
GROUP BY C.Id
HAVING No_of_Orders >= 10 AND Average_Order_Value > 1000
ORDER BY No_of_Orders, Average_Order_Value;

# ************************************************************************************************
# THE END
