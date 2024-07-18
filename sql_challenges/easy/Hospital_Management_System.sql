/*
Table: Patients
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| patient_id  | int     |
| name        | varchar |
| birth_date  | date    |
| gender      | varchar |
+-------------+---------+

Table: Doctors
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| doctor_id   | int     |
| name        | varchar |
| specialty   | varchar |
| hire_date   | date    |
+-------------+---------+

Table: Appointments
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| appointment_id| int     |
| patient_id    | int     |
| doctor_id     | int     |
| appointment_date | date |
| diagnosis     | varchar |
+---------------+---------+

Table: Prescriptions
+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| prescription_id| int    |
| appointment_id | int    |
| medication     | varchar|
| dosage         | varchar|
+---------------+---------+
*/
--##############################################################################
-- Find the names of doctors who have more than 20 appointments.
SELECT d.name
FROM Doctors d
JOIN Appointments a ON a.doctor_id = d.doctor_id
GROUP BY d.name
HAVING COUNT(a.appointment_id) > 20;
--##############################################################################
-- List the names of patients who have never had an appointment.

SELECT p.name
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
WHERE a.appointment_id IS NULL;
--##############################################################################
-- Find the most common diagnosis given in the hospital

SELECT a.diagnosis, COUNT(*) AS most_common
FROM Appointments a
GROUP BY a.diagnosis
ORDER BY most_common DESC
FETCH FIRST 1 ROWS ONLY;
--##############################################################################
-- List the names and specialties of doctors who have prescribed 'Amoxicillin'.

SELECT DISTINCT d.name, d.specialty
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Prescriptions p ON a.appointment_id = p.appointment_id
WHERE p.medication = 'Amoxicillin';
--##############################################################################
-- Find the patients who have appointments with doctors from more than one specialty.

SELECT p.name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY p.name
HAVING COUNT(DISTINCT d.specialty) > 1;
--##############################################################################
-- Calculate the average age of patients at the time of their first appointment.

SELECT AVG(EXTRACT(YEAR FROM a.appointment_date) - EXTRACT(YEAR FROM p.birth_date)) AS avg_age
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE (p.patient_id, a.appointment_date) IN (
    SELECT patient_id, MIN(appointment_date)
    FROM Appointments
    GROUP BY patient_id
);
--##############################################################################
-- List the medications prescribed by each doctor along with their dosage.

SELECT d.name AS doctor_name, p.medication, p.dosage
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Prescriptions p ON a.appointment_id = p.appointment_id;
--##############################################################################
-- Find the patients who have appointments on their birthdays.

SELECT p.name
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
WHERE EXTRACT(MONTH FROM p.birth_date) = EXTRACT(MONTH FROM a.appointment_date)
AND EXTRACT(DAY FROM p.birth_date) = EXTRACT(DAY FROM a.appointment_date);
--##############################################################################
-- List the names of doctors who have seen patients from both genders.

SELECT d.name
FROM Doctors d
JOIN Appointments a ON d.doctor_id = a.doctor_id
JOIN Patients p ON a.patient_id = p.patient_id
GROUP BY d.name
HAVING COUNT(DISTINCT p.gender) = 2;
--##############################################################################
-- Find the doctors who have prescribed the highest number of unique medications.

SELECT d.name, COUNT(DISTINCT p.medication) AS most_unique_medication
FROM Doctors d.name
JOIN Appointments a ON a.doctor_id = d.doctor_id
JOIN Prescriptions p ON p.appointment_id = a.appointment_id
GROUP BY d.name
ORDER BY most_unique_medication DESC
FETCH FIRST 1 ROWS ONLY;
--##############################################################################
