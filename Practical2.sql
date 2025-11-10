-- **************************************
-- PRACTICAL 2: SQL DDL and DML Statements (MySQL Compatible)
-- **************************************

-- 1️⃣ Create Database
DROP DATABASE IF EXISTS CollegeDB;
CREATE DATABASE CollegeDB;
USE CollegeDB;

-- 2️⃣ Create Department Table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(30) UNIQUE,
    location VARCHAR(20)
);

-- 3️⃣ Create Student Table with AUTO_INCREMENT
CREATE TABLE Student (
    roll_no INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    dept_id INT,
    marks INT CHECK (marks BETWEEN 0 AND 100),
    city VARCHAR(30) DEFAULT 'Nashik',
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 4️⃣ Insert Data into Department Table
INSERT INTO Department VALUES (1, 'Computer', 'Building A');
INSERT INTO Department VALUES (2, 'IT', 'Building B');
INSERT INTO Department VALUES (3, 'ENTC', 'Building C');

-- 5️⃣ Insert Data into Student Table (roll_no auto-generates)
INSERT INTO Student (name, dept_id, marks, city) VALUES ('Akash', 1, 85, 'Nashik');
INSERT INTO Student (name, dept_id, marks, city) VALUES ('Neha', 2, 92, 'Pune');
INSERT INTO Student (name, dept_id, marks, city) VALUES ('Rohan', 1, 78, 'Nashik');
INSERT INTO Student (name, dept_id, marks, city) VALUES ('Meera', 3, 67, 'Mumbai');
INSERT INTO Student (name, dept_id, marks) VALUES ('Anjali', 2, 88);

-- 6️⃣ Create a View
CREATE OR REPLACE VIEW Student_View AS
SELECT s.name, d.dept_name, s.marks
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id;

-- 7️⃣ Create an Index
CREATE INDEX idx_marks ON Student(marks);

-- **************************************
-- PART B: 10 SQL QUERIES (DML + FUNCTIONS)
-- **************************************

-- 1. Display all students
SELECT * FROM Student;

-- 2. Display students having marks greater than 80
SELECT name, marks FROM Student WHERE marks > 80;

-- 3. Display students from Nashik or Pune
SELECT name, city FROM Student WHERE city IN ('Nashik', 'Pune');

-- 4. Increase marks by 5 for Computer department students
UPDATE Student
SET marks = marks + 5
WHERE dept_id = (SELECT dept_id FROM Department WHERE dept_name = 'Computer');

-- 5. Delete students having marks less than 60
DELETE FROM Student WHERE marks < 60;

-- 6. Find average marks of each department
SELECT d.dept_name, AVG(s.marks) AS avg_marks
FROM Student s
JOIN Department d ON s.dept_id = d.dept_id
GROUP BY d.dept_name;

-- 7. Find maximum marks in each city
SELECT city, MAX(marks) AS max_marks
FROM Student
GROUP BY city;

-- 8. Display students whose name starts with 'A'
SELECT * FROM Student WHERE name LIKE 'A%';

-- 9. Use set operator (UNION)
SELECT city FROM Student WHERE dept_id = 1
UNION
SELECT city FROM Student WHERE dept_id = 2;

-- 10. Display top 3 students by marks
SELECT name, marks FROM Student
ORDER BY marks DESC
LIMIT 3;

-- **************************************
-- END OF PRACTICAL 2
-- **************************************
