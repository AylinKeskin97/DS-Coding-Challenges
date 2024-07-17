/*
Table: Books
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| book_id     | int     |
| title       | varchar |
| author      | varchar |
| pub_year    | int     |
| genre       | varchar |
+-------------+---------+

Table: Members
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| member_id   | int     |
| name        | varchar |
| join_date   | date    |
| membership  | varchar |
+-------------+---------+

Table: Loans
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| loan_id     | int     |
| book_id     | int     |
| member_id   | int     |
| loan_date   | date    |
| return_date | date    |
+-------------+---------+

*/
--##############################################################################
-- Find the titles of books that have never been loaned.

SELECT b.title
FROM Books b
LEFT JOIN Loans l ON b.book_id = l.book_id
WHERE l.book_id IS NULL;
--##############################################################################
-- List the names of members who joined in the year 2020.

SELECT name
FROM Members
WHERE join_date >= TO_DATE('2020-01-01', 'YYYY-MM-DD')
AND join_date < TO_DATE('2021-01-01', 'YYYY-MM-DD');

-- or
SELECT name
FROM Members
WHERE EXTRACT(YEAR FROM join_date) = 2020;
--##############################################################################
-- Find the most frequently borrowed book.

SELECT title
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
GROUP BY b.title
ORDER BY COUNT(l.loan_id) DESC
FETCH FIRST 1 ROWS ONLY;
--##############################################################################
-- List the members who have borrowed more than 5 books.

SELECT m.name
FROM Members m
JOIN Loans l ON m.member_id = l.member_id
GROUP BY m.name
HAVING COUNT(l.loan_id) > 5;
--##############################################################################
-- Find the authors whose books belong to more than one genre.

SELECT b.author
FROM Books b
GROUP BY b.author
HAVING COUNT(DISTINCT b.genre) > 1;
--##############################################################################
-- Find the books that have been borrowed by members with a 'Premium' membership.

SELECT b.title
FROM Books b
JOIN Loans l ON b.book_id = l.book_id
JOIN Members m ON l.member_id = m.member_id
WHERE m.membership = 'Premium';
--##############################################################################
-- List the names of members who have not borrowed any books.

SELECT m.name
FROM Members m
LEFT JOIN Loans l ON l.member_id= m.member_id
WHERE l.loan_id IS NULL;

-- or
SELECT name
FROM Members
WHERE member_id NOT IN (SELECT member_id FROM Loans);
--##############################################################################
-- Find the genres of books that have been borrowed at least 10 times.

SELECT b.genre
FROM Books b
JOIN Loans l ON l.book_id = b.book_id
GROUP BY b.genre
HAVING COUNT(l.load_id) >= 10;
--##############################################################################
-- Calculate the average number of books borrowed by members who joined before 2019.

SELECT AVG(borrowed_count) AS avg_borrowed
FROM (
    SELECT COUNT(l.loan_id) AS borrowed_count
    FROM Members m
    JOIN Loans l ON m.member_id = l.member_id
    WHERE m.join_date < TO_DATE('2019-01-01', 'YYYY-MM-DD')
    GROUP BY m.member_id
);

--##############################################################################
-- List the titles and authors of books that were borrowed and returned within the same month.

SELECT b.title, b.author
FROM Books b
JOIN Loans l ON l.book_id= b.book_id
WHERE EXTRACT(MONTH FROM l.loan_date) = EXTRACT(MONTH FROM l.return_date)
AND EXTRACT(YEAR FROM l.loan_date) = EXTRACT(YEAR FROM l.return_date);
--##############################################################################
