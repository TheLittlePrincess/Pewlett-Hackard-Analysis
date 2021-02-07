--SELECT count(emp_no) FROM titles;
-- DELIVERABLE 1

SELECT e.emp_no,
    e.first_name,
	e.last_name,
    t.title,
    t.from_date,
    t.to_date
INTO retirement_titles_d1
FROM employees as e
INNER JOIN tittles as t
	ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY emp_no;

--SELECT * FROM retirement_titles_d1;
--SELECT  count (title)FROM retirement_titles
--WHERE title = ('Engineer');

--remove duplicates 
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles_d1
FROM retirement_titles_d1
ORDER BY emp_no, to_date DESC;

--SELECT COUNT (title)
--FROM unique_titles_d1
--WHERE title = 'Senior Engineer';
-- 29414

--number of employees by their most recent job title who are about to retire
SELECT COUNT(title), title
INTO retiring_titles_d1
FROM unique_titles_d1
GROUP BY title
ORDER BY count DESC


--SELECT * FROM retiring_titles_d1;

--DELIVERABLE 2
--Write a query to create a Mentorship Eligibility table 
SELECT DISTINCT ON (emp_no)e.emp_no,
	e.first_name,
	e.last_name,
	e.birth_date,
	de.from_date,
	de.to_date,
	tr.title		
INTO mentorship_eligibilty_D2
FROM employees as e
	INNER JOIN dept_emp as de
		ON (e.emp_no = de.emp_no)
	INNER JOIN tittles as tr
		ON (e.emp_no =tr.emp_no)		
WHERE ((birth_date BETWEEN '1965-01-01' and '1965-12-31')
	   AND de.to_date = ('9999-01-01'))
ORDER BY emp_no, to_date DESC;
