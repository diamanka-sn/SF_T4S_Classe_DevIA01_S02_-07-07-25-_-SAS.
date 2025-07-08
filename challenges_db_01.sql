-- Challenge 01

CREATE DATABASE store_db;
USE store_db;

--challenge 02
CREATE TABLE customers (
  customer_id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  phone_number VARCHAR(20)
);

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  name VARCHAR(100),
  price DECIMAL(10,2),
  category VARCHAR(50)
);

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  order_date DATE,
  total_amount DECIMAL(10,2)
);

CREATE TABLE order_items (
  item_id INT PRIMARY KEY,
  order_id INT,
  product_id INT,
  quantity INT
);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
ON DELETE CASCADE;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_order
FOREIGN KEY (order_id) REFERENCES orders(order_id)
ON DELETE CASCADE;

ALTER TABLE order_items
ADD CONSTRAINT fk_order_items_product
FOREIGN KEY (product_id) REFERENCES products(product_id);

-- Challenge 03

INSERT INTO customers (customer_id, first_name, last_name, email, phone_number) VALUES
(1, 'John', 'Doe', 'john.doe@gmail.com', '0612345678'),
(2, 'Alice', 'Smith', 'alice.smith@yahoo.com', '0623456789'),
(3, 'David', 'Dubois', 'david.dubois@live.com', '0634567890'),
(4, 'Maria', 'Gonzalez', 'maria.gon@gmail.com', '0645678901'),
(5, 'Karim', 'Dali', 'karim.dali@outlook.com', '0656789012');

INSERT INTO products (product_id, name, price, category) VALUES
(1, 'Laptop', 899.99, 'Electronics'),
(2, 'Smartphone', 599.50, 'Electronics'),
(3, 'Office Chair', 149.90, 'Furniture'),
(4, 'Coffee Maker', 79.99, 'Appliances'),
(5, 'USB-C Cable', 15.00, 'Accessories');

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
(1, 1, '2024-01-15', 914.99),
(2, 3, '2024-03-02', 78.99),
(3, 2, '2023-12-30', 149.90),
(4, 1, '2024-04-18', 614.50),
(5, 5, '2022-11-01', 79.99);

INSERT INTO order_items (item_id, order_id, product_id, quantity) VALUES
(1, 1, 1, 1),
(2, 1, 5, 1),
(3, 2, 4, 1),
(4, 3, 3, 1),
(5, 4, 2, 1),
(6, 5, 4, 1);

-- Challenge 04
SELECT * FROM customers;

SELECT * FROM orders WHERE order_date > '2024-01-01';

SELECT DISTINCT c.first_name, c.last_name, c.email
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;

-- Challenge 05
SELECT * FROM customers WHERE first_name = 'John';

SELECT * FROM orders WHERE total_amount > 100;

SELECT * FROM customers WHERE last_name LIKE 'D%';

-- Challenge 06
UPDATE customers
SET phone_number = '0699999999'
WHERE customer_id = 1;

UPDATE orders
SET total_amount = total_amount * 1.10;

UPDATE customers
SET email = 'maria.gonzalez@outlook.com'
WHERE customer_id = 4;

-- Challenge 07
DELETE FROM orders
WHERE order_date < '2023-01-01';

DELETE FROM customers
WHERE first_name = 'John' AND last_name = 'Doe';

DELETE FROM orders
WHERE customer_id = (
  SELECT customer_id FROM customers
  WHERE first_name = 'Alice' AND last_name = 'Smith'
);



