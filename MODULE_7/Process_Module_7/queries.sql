-- Creating tables for PH-EmployeeDB
CREATE TABLE departments(
	dept_no varchar(4) NOT NULL,
	dept_name varchar(40) NOT NULL,
	PRIMARY KEY (dept_no),
	UNIQUE (dept_name)
);

CREATE TABLE employees(
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)	
);

CREATE TABLE dept_emp(
    emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE salaries (
  	emp_no INT NOT NULL,
  	salary INT NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	PRIMARY KEY (emp_no)
);

CREATE TABLE managers (
  	dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
  	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  	FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (dept_no, emp_no),
	UNIQUE (dept_no,emp_no)
);

CREATE TABLE titles(
    emp_no INT NOT NULL,
	title VARCHAR (40),
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date),
	UNIQUE (emp_no)
);

SELECT * FROM departments;

SELECT * FROM titles;

SELECT * FROM managers;

SELECT * FROM salaries;

SELECT * FROM dept_emp;

SELECT * FROM employees;

-- Retirement eligibility

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';
-- 90398

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';
--21209

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';
--22857

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';
--23228

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';
--23104

-- WILL PRINT A LIST
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- WILL PRINT THE TOTAL = 41380
SELECT COUNT (first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31') 
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- To save into a new table
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- SEE THE NEW TABLE
SELECT * FROM retirement_info;

-- delete retirment table to recreate
DROP TABLE retirement_info;

-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

-- Joining departments and dept_manager (for me managers) tables
SELECT departments.dept_name,
     managers.emp_no,
     managers.from_date,
     managers.to_date
FROM departments
INNER JOIN managers
ON departments.dept_no = managers.dept_no;

--Join retirement_info and dept_emp tables

SELECT retirement_info.emp_no,
	retirement_info.first_name,
	retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info
LEFT JOIN dept_emp
ON retirement_info.emp_no=dept_emp.emp_no;

--Join retirement_info AS a and dept_emp AS b tables using nicknames

SELECT a.emp_no,
	a.first_name,
	a.last_name,
	b.to_date
FROM retirement_info as a
LEFT JOIN dept_emp as b
ON a.emp_no= b.emp_no;

-- Joining departments and dept_manager (for me managers) tables with nicknames
SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
FROM departments as d
INNER JOIN managers as dm
ON d.dept_no = dm.dept_no;

--create a new table to hold the data of the join between retirement_info as a and
-- dept_emp as b. The new table will be named current_emp

SELECT a.emp_no,
	a.first_name,
	a.last_name,
	b.to_date
INTO current_emp
FROM retirement_info as a
LEFT JOIN dept_emp as b
ON a.emp_no= b.emp_no
WHERE b.to_date = ('9999-01-01');

SELECT COUNT (emp_no)
FROM current_emp;

-- Employee count by department number
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;

-- Employee count by department number order by department
SELECT COUNT(a.emp_no), b.dept_no
FROM current_emp as a
LEFT JOIN dept_emp as b
ON a.emp_no = b.emp_no
GROUP BY b.dept_no
ORDER BY b.dept_no;

--
-- Employee count by department number order by count (ascendent is the default)
SELECT COUNT(a.emp_no), b.dept_no
FROM current_emp as a
LEFT JOIN dept_emp as b
ON a.emp_no = b.emp_no
GROUP BY b.dept_no
ORDER BY count;

-- Employee count by department number order by department to a new table
SELECT COUNT(a.emp_no), b.dept_no
INTO retirement_per_dept
FROM current_emp as a
LEFT JOIN dept_emp as b
ON a.emp_no = b.emp_no
GROUP BY b.dept_no
ORDER BY b.dept_no;

SELECT * FROM retirement_per_dept;

SELECT * FROM salaries
ORDER BY to_date DESC;

-- creating employee info table emp_info
SELECT emp_no,
    first_name,
	last_name,
    gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--create a emp_info from joining employees with salaries and dept_emp

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    e.gender,
    s.salary,
    de.to_date
INTO emp_info
FROM employees as e
INNER JOIN salaries as s
	ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
	ON (e.emp_no = de.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');

SELECT COUNT (emp_no) FROM emp_info;

SELECT * FROM emp_info;

copy public.titles (emp_no, title, from_date, to_date) 
FROM '/Users/ana/titles.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE titles(
    emp_no INT NOT NULL,
	title VARCHAR (40) NOT NULL,
	from_date DATE NOT NULL,
  	to_date DATE NOT NULL,
  	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (emp_no, title, from_date)
);
--	UNIQUE (emp_no)
SELECT * FROM titles;

SELECT * FROM emp_info

-- List of managers per department (I named mine managers and not dept_manager)
SELECT  dm.dept_no,
        d.dept_name,
        dm.emp_no,
        ce.last_name,
        ce.first_name,
        dm.from_date,
        dm.to_date
INTO manager_info
FROM managers AS dm
    INNER JOIN departments AS d
        ON (dm.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (dm.emp_no = ce.emp_no);
		
SELECT ce.emp_no,
	ce.first_name,
	ce.last_name,
	d.dept_name
-- INTO dept_info
FROM current_emp as ce
	INNER JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	INNER JOIN departments AS d
		ON (de.dept_no = d.dept_no);
		
-- creating sales_retirement_info 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_retirement_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (d.dept_no = de.dept_no)		
WHERE (dept_name ='Sales');

-- creating sales_Dev_retirement_info for users about to retire 
-- in Develompent and Sales 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
--INTO sales_Dev_retirement_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (d.dept_no = de.dept_no)		
WHERE dept_name ='Sales'
	OR dept_name ='Development';

SELECT * FROM departments;

-- creating sales_Dev_retirement_info for users about to retire 
-- in Develompent and Sales 
SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
	d.dept_name
INTO sales_dev_retirement_info
FROM retirement_info as ri
	INNER JOIN dept_emp as de
		ON (ri.emp_no = de.emp_no)
	INNER JOIN departments as d
		ON (d.dept_no = de.dept_no)		
WHERE dept_name IN ('Sales','Development');

SELECT * FROM sales_dev_retirement_info;
SELECT COUNT (emp_no) FROM sales_dev_retirement_info;
-- 18928 count

SELECT DISTINCT ON (last_name) last_name, city, state
FROM contacts
ORDER BY last_name, city, state;


SELECT e.emp_no,
    e.first_name,
	e.last_name,
    tr.title,
    tr.from_date,
    tr.to_date
--INTO retirement_titles_tr
FROM employees as e
INNER JOIN titles as tr
	ON (e.emp_no = tr.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
--AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')
ORDER BY emp_no;

SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

--INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;


--START OF THE CHALLENGE MODULE 7

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) emp_no,
title,
from_date,
to_date

--INTO titles_recent
FROM titles
ORDER BY emp_no, to_date DESC;

-- DELIVERABLE 1

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
	ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

--number of employees by their most recent job title who are about to retire
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC

--DELIVERABLE 2
--Write a query to create a Mentorship Eligibility table 

SELECT DISTINCT ON (emp_no)e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tr.title		
INTO mentorship_eligibilty
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles_recent as tr
		ON (e.emp_no =tr.emp_no)		
WHERE ((birth_date BETWEEN '1965-01-01' and '1965-12-31')
	   AND de.to_date = ('9999-01-01'))
ORDER BY emp_no, to_date DESC;

----
--ROUND TWO
-- DELIVERABLE 1

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles
FROM employees as e
INNER JOIN titles as t
	ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

--remove duplicates 
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

--number of employees by their most recent job title who are about to retire
SELECT COUNT(title), title
INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY count DESC

SELECT * FROM retiring_titles;
--DELIVERABLE 2
--Write a query to create a Mentorship Eligibility table 
SELECT DISTINCT ON (emp_no)e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tr.title		
INTO mentorship_eligibilty
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN titles_recent as tr
		ON (e.emp_no =tr.emp_no)		
WHERE ((birth_date BETWEEN '1965-01-01' and '1965-12-31')
	   AND de.to_date = ('9999-01-01'))
ORDER BY emp_no, to_date DESC;

