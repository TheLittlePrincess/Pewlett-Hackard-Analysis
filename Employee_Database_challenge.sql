-- Use Dictinct with Orderby to remove duplicate rows
--SELECT DISTINCT ON (______) _____,
--______,
--______,
--______

--INTO nameyourtable
--FROM _______
--ORDER BY _____, _____ DESC;
-- Use Dictinct with Orderby to remove duplicate rows
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




