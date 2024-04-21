-- Dropping Tables for clean start - Not necessary to run
DROP TABLE titles CASCADE;
DROP TABLE employees CASCADE;
DROP TABLE departments CASCADE;
DROP TABLE department_employees CASCADE;
DROP TABLE department_manager CASCADE;
DROP TABLE salaries CASCADE;
--

-- DATA ENGINEERING

-- Creating Tables
CREATE TABLE titles (
	title_id VARCHAR(6) PRIMARY KEY UNIQUE NOT NULL,
	title VARCHAR(100)
);

CREATE TABLE employees (
	emp_no INT PRIMARY KEY UNIQUE NOT NULL,
	emp_title VARCHAR(100),
	birth_date DATE NOT NULL,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	sex VARCHAR(1),
	hire_date DATE NOT NULL
);

CREATE TABLE departments (
	dept_no VARCHAR(5) PRIMARY KEY UNIQUE NOT NULL,
	dept_name VARCHAR(100)
);

CREATE TABLE department_employees (
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	dept_no VARCHAR(5) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	PRIMARY KEY (emp_no, dept_no)	
);

CREATE TABLE department_manager (
	dept_no VARCHAR(5) NOT NULL,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	emp_no INT NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY (dept_no, emp_no)	
);

CREATE TABLE salaries (
	emp_no INT PRIMARY KEY NOT NULL,
	salary MONEY,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

-- INSERT data from .csv files into created tables 
SELECT * FROM titles;
SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM department_employees;
SELECT * FROM department_manager;
SELECT * FROM salaries;
--

-- DATA ANALYSIS

-- Query Tables
-- 1. List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no, e.last_name, e.first_name, e.sex, s.salary
FROM employees e
FULL OUTER JOIN salaries s ON e.emp_no=s.emp_no
;

-- 2. List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name, last_name, hire_date
FROM employees
WHERE DATE_PART('year', hire_date) = 1986
;

-- 3. List the manager of each department along with their department number, department name, 
-- employee number, last name, and first name.
SELECT dm.dept_no, d.dept_name, 
	dm.emp_no AS "Manager No.", e.last_name AS "Manager Last Name", e.first_name AS "Manager First Name"
FROM department_manager dm
INNER JOIN departments d 
	ON dm.dept_no = d.dept_no
LEFT JOIN employees e
	ON dm.emp_no = e.emp_no
;

-- 4. List the department number for each employee along with that employee’s employee number, 
-- last name, first name, and department name.
SELECT de.dept_no, de.emp_no, e.last_name, e.first_name, d.dept_name
FROM department_employees de
INNER JOIN employees e 
	ON de.emp_no = e.emp_no
LEFT JOIN departments d
	ON de.dept_no = d.dept_no
;

-- 5. List first name, last name, and sex of each employee whose first name is Hercules and 
-- whose last name begins with the letter B.
SELECT first_name, last_name, sex
FROM employees
WHERE first_name = 'Hercules' AND SUBSTRING(last_name, 1 , 1 ) = 'B'
;

-- 6. List each employee in the Sales department, including their employee number, last name, 
-- and first name.
SELECT d.dept_name, de.emp_no, e.last_name, e.first_name
FROM department_employees de
INNER JOIN departments d 
	ON de.dept_no = d.dept_no
LEFT JOIN employees e
	ON de.emp_no = e.emp_no
WHERE d.dept_name = 'Sales'
;

-- 7. List each employee in the Sales and Development departments, including their 
-- employee number, last name, first name, and department name.
SELECT de.emp_no, e.last_name, e.first_name, d.dept_name
FROM department_employees de
INNER JOIN departments d 
	ON de.dept_no = d.dept_no
LEFT JOIN employees e
	ON de.emp_no = e.emp_no
WHERE d.dept_name IN ('Sales', 'Development')
;

-- 8. List the frequency counts, in descending order, of all the employee last names 
-- (that is, how many employees share each last name).
SELECT last_name, COUNT(last_name) AS "Last Name Freq Count"
FROM employees
GROUP BY last_name
ORDER BY "Last Name Freq Count" desc
;
