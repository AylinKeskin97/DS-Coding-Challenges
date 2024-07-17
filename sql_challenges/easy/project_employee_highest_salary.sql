/*
+-------------+---------+------------+--------+------------+
| employee_id | name    | department | salary | hire_date  |
+-------------+---------+------------+--------+------------+
| 1           | Alice   | HR         | 70000  | 2015-01-15 |
| 2           | Bob     | IT         | 90000  | 2016-03-10 |
| 3           | Charlie | IT         | 85000  | 2017-07-23 |
| 4           | David   | HR         | 80000  | 2018-01-12 |
| 5           | Eva     | Finance    | 75000  | 2019-11-30 |
+-------------+---------+------------+--------+------------+

Problem: Find the Employee with the Highest Salary
*/

SELECT name
FROM Employee
ORDER BY salary DESC
FETCH FIRST 1 ROWS ONLY;

-- OR

SELECT name
FROM Employee
WHERE salary = (SELECT MAX(salary) FROM Employee);
