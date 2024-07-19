/*
Table: Customers
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| customer_id | int     |
| name        | varchar |
| join_date   | date    |
| email       | varchar |
| status      | varchar |
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
-- Find the customers who have placed orders in every month of a specific year.

SELECT c.name
FROM Customers c
JOIN Orders o ON o,.customer_id = c.customer_id
WHERE EXTRACT(YEAR FROM o.order_date) = 2021
GROUP BY c.name
HAVING COUNT(DISTINCT EXTRACT(MONTH FROM o.order_date)) = 12;
--##############################################################################
-- Update the status of all inactive customers who have not placed any orders in the last year.

UPDATE Customers c
SET c.status = 'Inactive'
WHERE c.customer_id NOT IN (
    SELECT o.customer_id
    FROM Orders o
    WHERE o.order_date >= ADD_MONTHS(SYSDATE, -12) --subtract last 12 months from current date
)
AND c.status <> 'Inactive';

-- or
UPDATE Customers c
SET status = 'Inactive'
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
      AND o.order_date >= ADD_MONTHS(SYSDATE, -12)
)
AND c.status <> 'Inactive';

--##############################################################################
-- Delete products that have not been ordered in the last 2 years.

DELETE FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderItems oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE oi.product_id = p.product_id
      AND o.order_date >= ADD_MONTHS(SYSDATE, -24)
);
--##############################################################################
-- Insert a new customer and ensure no duplicate emails are allowed.

INSERT INTO Customers (customer_id, name, join_date, email, status)
SELECT 5, 'New Customer', SYSDATE, 'newcustomer@example.com', 'Active'
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM Customers
    WHERE email = 'newcustomer@example.com'
);
--##############################################################################
-- List the names of products that have received both 1-star and 5-star reviews.

SELECT p.name
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.name
HAVING COUNT(CASE WHEN r.rating = 1 THEN 1 ELSE NULL END) > 0
   AND COUNT(CASE WHEN r.rating = 5 THEN 1 ELSE NULL END) > 0;
--##############################################################################
-- Find the average rating of products in each category.

SELECT p.category, AVG(r.rating) AS avg_rating
FROM Products p
JOIN Reviews r ON p.product_id = r.product_id
GROUP BY p.category;
--##############################################################################
-- List the customers who have not placed any orders since joining.

SELECT c.name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
--##############################################################################
-- Find the products that have been out of stock for more than a month.

SELECT p.name
FROM Products p
WHERE p.stock = 0
  AND NOT EXISTS (
    SELECT 1
    FROM OrderItems oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE oi.product_id = p.product_id
      AND o.order_date >= ADD_MONTHS(SYSDATE, -1)
);
--##############################################################################
-- List the top 3 products by total sales quantity.

SELECT p.name, SUM(oi.quantity) AS total_quantity
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
GROUP BY p.name
ORDER BY total_quantity DESC
FETCH FIRST 3 ROWS ONLY;
--##############################################################################
-- Find the most frequently ordered product category in the last 6 months.

SELECT p.category
FROM Products p
JOIN OrderItems oi ON p.product_id = oi.product_id
JOIN Orders o ON oi.order_id = o.order_id
WHERE o.order_date >= ADD_MONTHS(SYSDATE, -6)
GROUP BY p.category
ORDER BY COUNT(oi.order_item_id) DESC
FETCH FIRST 1 ROWS ONLY;
--##############################################################################
