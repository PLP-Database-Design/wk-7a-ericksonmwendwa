-- 1NF
-- Create the normalized table structure
CREATE TABLE
  ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
  );

-- Split and insert data from the original table
INSERT INTO
  ProductDetail_1NF (OrderID, CustomerName, Product)
SELECT
  OrderID,
  CustomerName,
  TRIM(value) AS Product
FROM
  ProductDetail CROSS APPLY STRING_SPLIT (Products, ',');

-- 2NF
-- Create Customers table to store order-customer relationships
CREATE TABLE
  Customers (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
  );

-- Create OrderProducts table for product-specific order details
CREATE TABLE
  OrderProducts (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Customers (OrderID)
  );

-- Populate Customers table with unique order-customer pairs
INSERT INTO
  Customers (OrderID, CustomerName)
SELECT DISTINCT
  OrderID,
  CustomerName
FROM
  OrderDetails;

-- Insert product details into normalized table
INSERT INTO
  OrderProducts (OrderID, Product, Quantity)
SELECT
  OrderID,
  Product,
  Quantity
FROM
  OrderDetails;
