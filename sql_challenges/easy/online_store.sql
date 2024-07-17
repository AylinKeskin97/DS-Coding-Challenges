/*
Table: Customers
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| name        | varchar |
| join_date   | date    |
+-------------+---------+

Table: Products
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| name        | varchar |
| price       | int     |
| category    | varchar |
+-------------+---------+

Table: Orders
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| order_id    | int     |
| customer_id | int     |
| order_date  | date    |
+-------------+---------+

Table: OrderDetails
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| order_id    | int     |
| product_id  | int     |
| quantity    | int     |
+-------------+---------+
*/
--##############################################################################
-- Find the names of customers who have placed an order.
SELECT c.name
FROM Customers c
WHERE c.customer_id IN (SELECT customer_id FROM ORDERS);

-- or

SELECT DISTINCT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id;

--##############################################################################
-- List the names of products that have never been ordered.
SELECT p.name
FROM Products p
WHERE product_id NOT IN (SELECT product_id FROM OrderDetails);

-- or

SELECT p.name
FROM Products p
LEFT JOIN OrderDetails od ON p.product_id = od.product_id
WHERE od.product_id IS NULL;
--##############################################################################
-- Find the total quantity of each product ordered.
SELECT SUM(quantity)
FROM OrderDetails
GROUP BY product_id;

-- prettier output
SELECT p.name, SUM(od.quantity) AS total_quantity
FROM Products p
JOIN OrderDetails od ON p.product_id = od.product_id
GROUP BY p.name;
--##############################################################################
-- List the customers who joined before 2020 and have placed at least one order.
SELECT c.name
FROM Customers c
WHERE c.customer_id IN(SELECT customer_id FROM Orders)
AND c.join_date < TO_DATE('2020-01-01', 'YYYY-MM-DD');

-- or (faster computationally)
SELECT DISTINCT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.join_date < TO_DATE('2020-01-01', 'YYYY-MM-DD');
--##############################################################################
-- Find the products ordered by each customer.

SELECT c.name AS customer_name, p.name AS product_name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
ORDER BY c.name;
--##############################################################################
-- List the names of customers who have ordered more than one product
SELECT c.name
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
JOIN OrderDetails od ON od.order_id = o.order_id
GROUP BY c.name
HAVING COUNT(DISTINCT od.product_id) > 1;
--##############################################################################
-- Find the customers who have not placed any orders.
SELECT c.name
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
WHERE o.customer_id IS NULL;

-- or
SELECT name
FROM Customers
WHERE customer_id NOT IN (SELECT customer_id FROM Orders);
--##############################################################################
-- Find the products that have been ordered at least three times.
SELECT p.name
FROM Products p
JOIN OrderDetails od ON od.product_id = p.product_id
GROUP BY p.name
HAVING COUNT(od.order_id) > 2;
--##############################################################################
-- Calculate the total amount spent by each customer.
SELECT c.name, SUM(p.price * od.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
GROUP BY c.name;
--##############################################################################
-- List the customers who have ordered products from the 'Electronics' category.

SELECT DISTINCT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderDetails od ON o.order_id = od.order_id
JOIN Products p ON od.product_id = p.product_id
WHERE p.category = 'Electronics';
--##############################################################################
