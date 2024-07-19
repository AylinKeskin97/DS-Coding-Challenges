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
-- Advanced Training with Subqueries and Other Operations:
----------------------------------------------------------
--##############################################################################
-- Find customers who have placed more than 10 orders.

SELECT c.name
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 10;

-- or
SELECT name
FROM Customers
WHERE customer_id IN (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 10
);
--##############################################################################
-- Update the status of products that have not been ordered in the last
-- year to 'Discontinued'.

UPDATE Products
SET status = 'Discontinued'
WHERE product_id NOT IN (
    SELECT DISTINCT product_id
    FROM OrderItems oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE o.order_date >= ADD_MONTHS(SYSDATE, -12)
);
--##############################################################################
-- Delete customers who have never placed an order.

DELETE FROM Customers
WHERE customer_id NOT IN (
    SELECT DISTINCT customer_id
    FROM Orders
);
--##############################################################################
-- Insert a new product and ensure no duplicate product names are allowed.

INSERT INTO Products (product_id, name, category, price, stock)
SELECT 101, 'New Product', 'Category', 29.99, 100
FROM DUAL
WHERE NOT EXISTS (
    SELECT 1
    FROM Products
    WHERE name = 'New Product'
);
--##############################################################################
-- Find products that have been reviewed by every customer who has ordered them.

SELECT p.name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1
    FROM OrderItems oi
    JOIN Orders o ON oi.order_id = o.order_id
    WHERE oi.product_id = p.product_id
      AND NOT EXISTS (
          SELECT 1
          FROM Reviews r
          WHERE r.product_id = p.product_id
            AND r.customer_id = o.customer_id
      )
);
--##############################################################################
-- Calculate the average rating of products in each category that have more than 5 reviews.

SELECT category, AVG(avg_rating) AS overall_avg_rating
FROM (
    SELECT p.category, p.product_id, AVG(r.rating) AS avg_rating
    FROM Products p
    JOIN Reviews r ON p.product_id = r.product_id
    GROUP BY p.category, p.product_id
    HAVING COUNT(r.review_id) > 5
)
GROUP BY category;
--##############################################################################
-- List customers who have placed orders only in their join year.

SELECT name
FROM Customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM Orders o
    WHERE o.customer_id = c.customer_id
      AND EXTRACT(YEAR FROM o.order_date) != EXTRACT(YEAR FROM c.join_date)
);
--##############################################################################
-- Find products that are out of stock but have pending orders.

SELECT name
FROM Products p
WHERE stock = 0
  AND EXISTS (
      SELECT 1
      FROM OrderItems oi
      JOIN Orders o ON oi.order_id = o.order_id
      WHERE oi.product_id = p.product_id
        AND o.status = 'Pending'
  );
--##############################################################################
-- List the top 3 customers by total amount spent.

SELECT name, total_spent
FROM (
    SELECT c.name, SUM(oi.quantity * p.price) AS total_spent,
           ROW_NUMBER() OVER (ORDER BY SUM(oi.quantity * p.price) DESC) AS rnk
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    JOIN OrderItems oi ON o.order_id = oi.order_id
    JOIN Products p ON oi.product_id = p.product_id
    GROUP BY c.name
)
WHERE rnk <= 3;

--##############################################################################
-- Find the most frequently reviewed product category in the last year.

SELECT category
FROM (
    SELECT p.category, COUNT(r.review_id) AS review_count,
           RANK() OVER (ORDER BY COUNT(r.review_id) DESC) AS rnk
    FROM Products p
    JOIN Reviews r ON p.product_id = r.product_id
    WHERE r.review_date >= ADD_MONTHS(SYSDATE, -12)
    GROUP BY p.category
)
WHERE rnk = 1;
--##############################################################################
