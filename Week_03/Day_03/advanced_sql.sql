/*
 * Advanced SQL Topics
*/

/*
 * Create your own function 
 * 
 * can help when performing the same/similar tasks often.
 * 
 * you may not be allowed to create functions!!
 * 
 * depends on your DB permissions
 * 
 * omni user _cannot_ create functions
 * 
 * functions are attached to databases
 * 
 * NEED TO KNOW HOW FUNCTIONS WORK AHEAD OF TIME
*/


-- 1. use the keywork CREATE [OR REPLACE is optional] to start defining your FUNCTION
-- 2. give the function a name = percent_change
-- 3. specify the arguments of your function AND their datatypes
-- 4. specify  the datatype of the RESULT 
-- 5. write the code for the FUNCTION  
-- 6. additional things: specify the language = SQL
-- 7. IMMUTABLE means can't be changed
CREATE OR REPLACE FUNCTION 
percent_change(new_value NUMERIC, old_value NUMERIC, decimals INT DEFAULT 2)
RETURNS NUMERIC AS 
    'SELECT ROUND(100 * (new_value - old_value) / old_value, decimals);'
LANGUAGE SQL
IMMUTABLE
RETURNS NULL ON NULL INPUT;

-- test the function
SELECT
	percent_change(50,40),
	percent_change(100, 99, 4);


/*
 * Legal salaries are increasing by $1000 next year.
 * Show the percent change for each employee's salary in Legal
 */
SELECT
	id,
	first_name,
	last_name,
	salary,
	salary + 1000 AS new_salary,
	percent_change(salary + 1000, salary, 2)
FROM 
	employees 
WHERE 
	department = 'Legal'
ORDER BY 
	percent_change DESC NULLS LAST;

/*
 * make_badge function
 */

-- function code:
CREATE OR REPLACE FUNCTION public.make_badge(field_a text, field_b text, field_c text)
 RETURNS character varying
 LANGUAGE sql
 IMMUTABLE STRICT
AS $function$SELECT concat(field_a, ' ', field_b, ' - ', field_c);$function$
;

-- using the function
SELECT
	make_badge(first_name, last_name, department) AS badge
FROM employees ;



/*
 * Investigsting Query Performance
 * 
 * maybe a queries taking a surprisingly long amount of time to run
 * 
 * Interview Questions:
 * 	- How would you speed up a slow running query?
 *
 */

-- get a table of department avg salaries for employees working in listed countries

EXPLAIN ANALYSE -- shows how long the query AND operations took
SELECT
	department,
	avg(salary) 
FROM 
	employees 
WHERE 
	country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY 
	department  
ORDER BY 
	avg(salary);

-- how can we speed up a query?
-- 		index coulmn(s)!
-- 		index columns run behind-the-scence lookup ways of finding rows using the index column

-- searching a phone book

-- 1.	start at the start and go through each page until we find 'Lloyd Lombardi'
-- 		look at all 'A's', 'B's',...'L's' until we found 'Lloyd Lombardi'
-- 		[default behaviour]

-- OR 

-- 2. 	use an index
-- 		go directly to 'L' and look there
--		(index scan) 

-- let's use employees_indexed
-- this was created with employees and indexes by countries

EXPLAIN ANALYSE 
SELECT
	department,
	avg(salary)
FROM 
	employees_indexed
WHERE 
	country IN ('Germany', 'France', 'Italy', 'Spain')
GROUP BY 
	department  
ORDER BY 
	avg(salary);

-- drawbacks to indexing:
--	1. storage (less of an issue these days)
--	2. slows down other CRUD operations (insert, update, delete)

/*
 * Common Table Expressions
 * 
 * we can create temp tables before the start of our query and access them like tables in the database 
 */

/*
 * Find all the employees in the Legal dept that earn less than the mean salary of people in the same dept
 */

-- without CTEs
SELECT *
FROM 
	employees 
WHERE 
	department = 'Legal' AND
	salary < (
		SELECT avg(salary)
		FROM employees 
		WHERE department = 'Legal'); 

/*
 * common tables allow you to specify this temp table
 * created in our subquery as table in the database
 */

-- with CTEs
WITH dep_average AS (
	SELECT avg(salary)
	FROM employees 
	WHERE department = 'Legal') 	
SELECT *
FROM dep_average
WHERE 
	department = 'Legal' AND
	salary < (
		SELECT avg_salary
		FROM dep_average);


/*
 * find all the employees in Legal who earn less than the mean salary
 * and work fewer than the mean fte hours
 */

-- without CTEs

SELECT * 
FROM 
	employees 
WHERE
	department = 'Legal' AND 
	salary < (
		SELECT avg(salary)
		FROM employees 
		WHERE department = 'Legal') AND 
	fte_hours < (
		SELECT avg(fte_hours)
		FROM employees
		WHERE department = 'Legal');
	
-- with CTE

WITH dep_average AS (
	SELECT 
		avg(salary) AS avg_salary,
		avg(fte_hours) AS avg_fte
	FROM 
		employees 
	WHERE 
		department = 'Legal')
	SELECT * 
	FROM 
		employees 
	WHERE 
		department = 'Legal' AND  
		salary < (
				SELECT avg_salary
				FROM dep_average) AND 
		fte_hours < (
				SELECT avg_fte
				FROM dep_average);
		


/*
 * get a table with each employee's
 * - first name
 * - last name
 * - department
 * - country
 * - salary
 * - comparison of their salary vs that of country they work in, and department they work in 
 */

-- without CTE 
	-- 1. get the average salary for each dept 
	-- 2. get the average salary for each country
	-- 3. 2 joining operations 
	-- 4. using these average values calculate each employee's ratio

-- 1.
WITH dep_avgs AS (
	SELECT
		department,
		avg(salary) AS avg_salary_department
	FROM
		employees 
	GROUP BY 
		department),
-- 2. 
	country_avgs AS (
	SELECT
		country,
		avg(salary) AS avg_salary_country
	FROM 
		employees 
	GROUP BY 
		country)
SELECT 
	e.first_name,
	e.last_name,
	e.department,
	e.country,
	e.salary,
	dep_a.avg_salary_department,
	c_a.avg_salary_country,
	ROUND(e.salary / dep_a.avg_salary_department, 2) AS dep_ratio, -- 4. 
	ROUND(e.salary / c_a.avg_salary_country, 2) AS country_ratio   -- 4. 
FROM 
	employees AS e
-- 3. 
INNER JOIN 
	dep_avgs AS dep_a ON e.department = dep_a.department
INNER JOIN
	country_avgs AS c_a ON e.country = c_a.country;



/*
 * Window Functions
 */

/*
 * show for each employee their salary together with the min and 
 * max salaries of employees in their department
 */


-- This gives an error as can't filter and add new columns like this
SELECT
	*,
	avg(salary)
FROM 
	employees 
GROUP BY
	department;


-- Window function: OVER
-- this acts like a GROUP BY function within the SELECT
SELECT
	first_name,
	last_name,
	department,
	salary,
	min(salary) OVER (PARTITION BY department),
	max(salary) OVER (PARTITION BY department)
FROM 
	employees;


-- common tables
WITH dep_avgs AS( 
	SELECT 
		min(salary) AS min_salary,
		max(salary) AS max_salary,
		department 
	FROM 
		employees 
	GROUP BY 
		department)
SELECT 
	e.first_name,
	e.last_name,
	e.salary,
	e.department,
	dep_a.min_salary,
	dep_a.max_salary
FROM 
	employees AS e
INNER JOIN 
	dep_avgs AS dep_a ON e.department = dep_a.department;
























