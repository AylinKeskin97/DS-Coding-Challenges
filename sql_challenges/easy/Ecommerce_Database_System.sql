/*
Table: Customers
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| name        | varchar |
| join_date   | date    |
| email       | varchar |
+-------------+---------+

Table: Products
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| name        | varchar |
| category    | varchar |
| price       | decimal |
| stock       | int     |
+-------------+---------+

Table: Orders
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| order_id    | int     |
| customer_id | int     |
| order_date  | date    |
| status      | varchar |
+-------------+---------+

Table: OrderItems
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| order_item_id| int    |
| order_id     | int    |
| product_id   | int    |
| quantity     | int    |
+-------------+---------+

Table: Reviews
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| review_id   | int     |
| product_id  | int     |
| customer_id | int     |
| rating      | int     |
| review_date | date    |
+-------------+---------+
*/
--##############################################################################
-- Find the names of customers who have placed more than 5 orders.

SELECT  c.name
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.name
HAVING COUNT(o.order_id) > 5;
--##############################################################################
-- List the names of products that have never been ordered.

SELECT p.name
FROM Products p
LEFT JOIN OrderItems oi ON oi.product_id = p.product_id
WHERE oi.order_id IS NULL;
--##############################################################################
-- Find the most frequently ordered product.

SELECT p.name
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY COUNT(oi.order_id) DESC
FECTH FIRST 1 ROW ONLY;
--##############################################################################
-- List the names of customers who have reviewed more than one product.

SELECT c.name
FROM Customers c
JOIN Reviews r ON c.customer_id = r.customer_id
GROUP BY c.name
HAVING COUNT(DISTINCT r.product_id) > 1 ;
--##############################################################################
-- Find the products ordered by customers from more than one order.

SELECT p.name
FROM Products p
JOIN OrderItems oi ON oi.product_id = p.product_id
GROUP BY p.name
HAVING COUNT(DISTINCT oi.order_id) > 1;
--##############################################################################
-- Calculate the average rating for each product.

SELECT p.name, AVG(r.rating) AS average_rating
FROM Products p
JOIN Reviews r ON r.product_id = p.product_id
GROUP BY p.name;
--##############################################################################
-- List the names of customers who have not placed any orders

SELECT c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

--##############################################################################
-- Find the customers who have placed orders in every month of 2021.

SELECT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2021
GROUP BY c.name
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) = 12;
--##############################################################################
-- List the names of products that have received both 1-star and 5-star reviews.

SELECT p.name
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.name
HAVING COUNT(CASE WHEN r.rating = 1 THEN 1 ELSE NULL END) > 0
   AND COUNT(CASE WHEN r.rating = 5 THEN 1 ELSE NULL END) > 0;
--##############################################################################
-- Find the customers who have reviewed every product they ordered.

SELECT c.name
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN OrderItems oi ON o.order_id = oi.order_id
LEFT JOIN Reviews r ON oi.product_id = r.product_id AND c.customer_id = r.customer_id
GROUP BY c.name
HAVING COUNT(DISTINCT oi.product_id) = COUNT(DISTINCT r.product_id);
--##############################################################################
