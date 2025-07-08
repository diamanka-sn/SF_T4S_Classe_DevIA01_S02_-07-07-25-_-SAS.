-- challenge 01

SELECT o.order_id, o.order_date, o.total_amount, c.first_name, c.last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT c.customer_id, c.first_name, c.last_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS number_of_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

-- challenge 02
SELECT SUM(total_amount) AS total_sales FROM orders;

SELECT COUNT(*) AS total_customers FROM customers;

SELECT AVG(total_amount) AS average_order_amount FROM orders;

-- challenge 03

SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, COUNT(*) AS order_count
FROM orders
GROUP BY month;

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, AVG(total_amount) AS avg_order
FROM orders
GROUP BY month;

SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
HAVING total_spent > 1000;

-- challenge 04

SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 200;

SELECT c.customer_id, c.first_name, c.last_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 1;

SELECT * FROM orders
WHERE total_amount > (
  SELECT AVG(total_amount) FROM orders
);

-- challenge 05



CREATE VIEW customer_orders_view AS
SELECT o.order_id, o.order_date, o.total_amount,
       c.customer_id, c.first_name, c.last_name
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT customer_id, first_name, last_name, SUM(total_amount) AS total_spent
FROM customer_orders_view
GROUP BY customer_id
HAVING total_spent > 1000;

CREATE VIEW monthly_sales_view AS
SELECT DATE_FORMAT(order_date, '%Y-%m') AS month, SUM(total_amount) AS total_sales
FROM orders
GROUP BY month;

