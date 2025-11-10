-- **************************************
-- PRACTICAL 3: JOINS, SUBQUERIES, AND VIEWS
-- **************************************

-- 1️⃣ Create a New Database
CREATE DATABASE CompanyDB;
USE CompanyDB;

-- 2️⃣ Create Department Table
CREATE TABLE Department (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(30) UNIQUE,
    location VARCHAR(30)
);

-- 3️⃣ Create Employee Table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,
    dept_id INT,
    salary DECIMAL(10,2),
    manager_id INT,
    city VARCHAR(30),
    FOREIGN KEY (dept_id) REFERENCES Department(dept_id)
);

-- 4️⃣ Insert Data into Department Table
INSERT INTO Department (dept_name, location) VALUES
('HR', 'Pune'),
('Finance', 'Mumbai'),
('IT', 'Nashik'),
('Marketing', 'Delhi');

-- 5️⃣ Insert Data into Employee Table
INSERT INTO Employee (emp_name, dept_id, salary, manager_id, city) VALUES
('Akash', 3, 55000, NULL, 'Nashik'),
('Neha', 3, 48000, 1, 'Nashik'),
('Rohan', 1, 40000, 2, 'Pune'),
('Meera', 2, 60000, 1, 'Mumbai'),
('Anjali', 4, 45000, 3, 'Delhi'),
('Saurabh', 2, 52000, 1, 'Mumbai'),
('Kiran', 1, 35000, 3, 'Pune');

-- **************************************
-- JOINS
-- **************************************

-- 1️⃣ INNER JOIN: Employees with their Department Names
SELECT e.emp_name, d.dept_name, e.salary
FROM Employee e
INNER JOIN Department d ON e.dept_id = d.dept_id;

-- 2️⃣ LEFT JOIN: Show All Employees (even if department not assigned)
SELECT e.emp_name, d.dept_name
FROM Employee e
LEFT JOIN Department d ON e.dept_id = d.dept_id;

-- 3️⃣ RIGHT JOIN: Show All Departments (even if no employee)
SELECT e.emp_name, d.dept_name
FROM Employee e
RIGHT JOIN Department d ON e.dept_id = d.dept_id;

-- 4️⃣ SELF JOIN: Employees with their Managers
SELECT e.emp_name AS Employee, m.emp_name AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.manager_id = m.emp_id;

-- **************************************
-- SUBQUERIES
-- **************************************

-- 5️⃣ Subquery: Employees earning above average salary
SELECT emp_name, salary
FROM Employee
WHERE salary > (SELECT AVG(salary) FROM Employee);

-- 6️⃣ Subquery: Employees working in the 'IT' department
SELECT emp_name
FROM Employee
WHERE dept_id = (SELECT dept_id FROM Department WHERE dept_name = 'IT');

-- 7️⃣ Subquery: Employees with the highest salary
SELECT emp_name, salary
FROM Employee
WHERE salary = (SELECT MAX(salary) FROM Employee);

-- 8️⃣ Subquery in FROM Clause: Average salary per department
SELECT dept_name, avg_sal
FROM (
    SELECT d.dept_name, AVG(e.salary) AS avg_sal
    FROM Employee e
    JOIN Department d ON e.dept_id = d.dept_id
    GROUP BY d.dept_name
) AS dept_avg;

-- **************************************
-- VIEWS
-- **************************************

-- 9️⃣ Create a View: Employees with their Department Info
CREATE OR REPLACE VIEW EmpDept_View AS
SELECT e.emp_name, d.dept_name, e.salary, e.city
FROM Employee e
JOIN Department d ON e.dept_id = d.dept_id;

-- 🔟 Query the View: Employees with Salary above 50,000
SELECT * FROM EmpDept_View WHERE salary > 50000;

-- **************************************
-- END OF PRACTICAL 3
-- **************************************
