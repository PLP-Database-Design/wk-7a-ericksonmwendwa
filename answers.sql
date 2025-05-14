-- Create ProductDetail table
CREATE TABLE
  ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(100)
  );

-- Insert data into the ProductDetail table
INSERT INTO
  ProductDetail (OrderID, CustomerName, Products)
VALUES
  (101, 'John Doe', 'Laptop'),
  (101, 'John Doe', 'Mouse'),
  (102, 'Jane Smith', 'Tablet'),
  (102, 'Jane Smith', 'Keyboard'),
  (102, 'Jane Smith', 'Mouse'),
  (103, 'Emily Clark', 'Phone');

-- Create orders table
CREATE TABLE
  orders (
    OrderID INT PRIMARY KEY,
    customerName VARCHAR(100)
  );

-- Insert data into the orders table
INSERT INTO
  orders (OrderID, CustomerName)
VALUES
  (101, 'John Doe'),
  (102, 'Jane Smith'),
  (103, 'Emily Clark');

-- Create product table
CREATE TABLE
  product (
    product_id INT primary key,
    productName varchar(100),
    quantity INT,
    order_id INT,
    foreign key (order_id) references orders (OrderID)
  );

-- Insert data into the product table
INSERT INTO
  product (product_id, productName, quantity, order_id) VALUE (1, 'laptop', 2, 101),
  (2, 'Mouse', 1, 101),
  (3, 'Tablet', 3, 102),
  (4, 'Keyboard', 2, 102),
  (5, 'Mouse', 1, 102),
  (6, 'Phone', 1, 103);

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
-- Create the Customers table to store order-customer relationships
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

-- Populate the Customers table with unique order-customer pairs
INSERT INTO
  Customers (OrderID, CustomerName)
SELECT DISTINCT
  OrderID,
  CustomerName
FROM
  OrderDetails;

-- Insert product details into the normalized table
INSERT INTO
  OrderProducts (OrderID, Product, Quantity)
SELECT
  OrderID,
  Product,
  Quantity
FROM
  OrderDetails;
