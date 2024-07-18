/*
Table: Students
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| student_id  | int     |
| name        | varchar |
| birth_date  | date    |
| gender      | varchar |
+-------------+---------+

Table: Professors
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| professor_id| int     |
| name        | varchar |
| department  | varchar |
| hire_date   | date    |
+-------------+---------+

Table: Courses
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| course_id   | int     |
| title       | varchar |
| department  | varchar |
| credits     | int     |
+-------------+---------+

Table: Enrollments
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| enrollment_id| int    |
| student_id   | int    |
| course_id    | int    |
| enrollment_date | date|
+-------------+---------+

Table: Assignments
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| assignment_id| int    |
| course_id    | int    |
| title        | varchar|
| due_date     | date   |
+-------------+---------+

Table: Grades
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| grade_id    | int     |
| student_id  | int     |
| assignment_id| int    |
| grade        | varchar|
+-------------+---------+

*/
--##############################################################################
-- Find the names of students who are enrolled in more than 3 courses.

SELECT s.name
FROM Students s
JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.name
HAVING COUNT(e.course_id) > 3;
--##############################################################################
-- List the names of professors who have given assignments in at least 3 different courses.

SELECT p.name
FROM Professors p
JOIN Courses c ON p.department = c.department
JOIN Assignments a ON c.course_id = a.course_id
GROUP BY p.name
HAVING COUNT(DISTINCT a.course_id) >= 3;
--##############################################################################
-- Find the students who have submitted assignments for courses across different departments.

SELECT s.name
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
JOIN Assignments a ON g.assignment_id = a.assignment_id
JOIN Courses c ON a.course_id = c.course_id
GROUP BY s.name
HAVING COUNT(DISTINCT c.department) > 1;
--##############################################################################
-- List the titles of courses that have more than 2 assignments with due dates in the same month.

SELECT c.title
FROM Courses c
JOIN Assignments a ON c.course_id = a.course_id
GROUP BY c.title, EXTRACT(MONTH FROM a.due_date), EXTRACT(YEAR FROM a.due_date)
HAVING COUNT(a.assignment_id) > 2;
--##############################################################################
-- Find the professors who have assigned grades to both male and female students.

SELECT p.name
FROM Professors p
JOIN Courses c ON p.department = c.department
JOIN Assignments a ON c.course_id = a.course_id
JOIN Grades g ON a.assignment_id = g.assignment_id
JOIN Students s ON g.student_id = s.student_id
GROUP BY p.name
HAVING COUNT(DISTINCT s.gender) = 2;
--##############################################################################
-- Calculate the average grade for each course.

SELECT c.title, AVG(CASE
                        WHEN g.grade = 'A' THEN 4
                        WHEN g.grade = 'B' THEN 3
                        WHEN g.grade = 'C' THEN 2
                        WHEN g.grade = 'D' THEN 1
                        WHEN g.grade = 'F' THEN 0
                    END) AS avg_grade
FROM Courses c
JOIN Assignments a ON c.course_id = a.course_id
JOIN Grades g ON a.assignment_id = g.assignment_id
GROUP BY c.title;
--##############################################################################
-- List the names of students who have not submitted any assignments.

SELECT s.name
FROM Students s
LEFT JOIN Grades g ON s.student_id = g.student_id
WHERE g.assignment_id IS NULL;
--##############################################################################
-- Find the students who have received at least one 'A' grade.

SELECT DISTINCT s.name
FROM Students s
JOIN Grades g ON s.student_id = g.student_id
WHERE g.grade = 'A';

--##############################################################################
--
--##############################################################################
--
--##############################################################################
