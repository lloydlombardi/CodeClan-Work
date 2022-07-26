-- Find the number of employees within each department of the corp
SELECT
	count(id) AS department_count
FROM employees
WHERE department = 'Legal';


SELECT
	count(id) AS department_count,
	department 
FROM employees
GROUP BY department --Anything IN the GROUP BY can be IN the SELECT
ORDER BY department_count DESC; 


-- Find the number of employees from each country
SELECT 
	count(id) AS country_count,
	country
FROM employees 
GROUP BY country 
ORDER BY country_count DESC;


-- Find the number of employees from each country and department and put in order of country 
SELECT 
	count(id) AS country_department_count,
	country,
	department 
FROM employees 
GROUP BY country, department  
ORDER BY country;


-- Find how many employees in each department that work either 0.25 or 0.5 fte hours
SELECT 
	count(id) AS employee_count_department_hours,
	department,
	fte_hours
FROM employees
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department, fte_hours
ORDER BY department ;


-- Seel how NULL affects counts
-- Gotcha...COUNTS can exist without a GROUP BY if NO OTHER COLUMN IS PRESENT
SELECT
	count(id),
	count(first_name),
	count(*) --BIIIIIIIIG GOTCHA 
FROM employees ;


-- Find the longest serving employee in each department 
SELECT
	NOW() - min(start_date) AS time_served,
	department,
	first_name,
	last_name,
	ROUND(EXTRACT (DAY FROM NOW() - min(start_date))/365) AS years_served
FROM employees
GROUP BY department, first_name, last_name
ORDER BY department, time_served DESC NULLS LAST;


/*
 * 1. "How many employees in each department are enrolled in the pension scheme?"
 * 2. "Perform a breakdown by country of the number of employees that do not have a stored first name."
 */

-- 1.
SELECT 
	count(id) AS employees_in_pension_scheme,
	department 
FROM employees 
WHERE pension_enrol IS TRUE
GROUP BY department;


-- 2.
SELECT 
	count(id) AS employees_without_first_name,
	country
FROM employees 
WHERE first_name IS NULL 
GROUP BY country;


-- Show those departments in which at least 40 employees work either 0.25 or 0.5 fte hours
-- 'WHERE' clause for 'GROUP BY' is called 'HAVING'. ONLY WORKS WITH AGGREGATES
SELECT 
	count(id),
	department 
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5
GROUP BY department
HAVING count(id) >= 40;


-- Show any countries
-- which the minimum salary
-- amoungst pension enrolled employees
-- is less than 21000 dollars
SELECT
	country,
	min(salary),
	department 
FROM employees
WHERE pension_enrol IS TRUE
--AND salary < 21000
GROUP BY country, department 
HAVING min(salary) < 21000
ORDER BY min(salary), country, department; --NOTE: ORDER BY IS usually simi TO GROUP BY 


-- Show any departments in which the earliest start date amongst grade 1 employees is prior to 1991
SELECT 
	department,
	min(start_date) AS min_start_date
FROM employees 
WHERE grade = 1
GROUP BY department
HAVING min(start_date) < '1991-01-01'
ORDER BY min(start_date);


-- Find all the employees in Japan who earn over the company-wide average salary
SELECT *
FROM employees 
WHERE country = 'Japan'
AND salary > (
				SELECT avg(salary)
				FROM employees 
			);

		
-- Find all employees in Legal who earn less than the average salary in the same department		
SELECT *
FROM employees 
WHERE department = 'Legal'
AND salary < (
				SELECT avg(salary)
				FROM employees 
				WHERE department = 'Legal'
			);


-- Find the employee in Legal who earns the least per country
SELECT
	count(id),
	country,
	salary 
FROM employees 
WHERE department = 'Legal'
AND salary < (
				SELECT avg(salary)
				FROM employees 
				WHERE department = 'Legal'
			)
GROUP BY country, salary
ORDER BY salary, country;

		

		








	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	