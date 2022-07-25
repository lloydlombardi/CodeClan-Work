/*
* Manipulating Returned Data
* 
* specifying column aliases using AS
* use the DISTINCT() funciton
* use some aggregate funcitons
* sort records
* limit number of records returned
*/


-- we can manipulate the data that is returned by a query by 
-- altering the SELECT statement 

SELECT 
	id,
	first_name,
	last_name
FROM employees 
WHERE department = 'Accounting';

-- Column Aliases

-- can we get a list of all employees with their first name and last name combined together
-- into one field (column) called 'full_name'

SELECT
	first_name, 
	last_name, 
	concat(first_name, ' ', last_name) AS full_name
FROM employees; 

/*
 * Task
 * 
 * Add a WHERE clause to the query above to filter out any rows that don't have both a first and second name.
 */

SELECT
	first_name, 
	last_name, 
	concat(first_name, ' ', last_name) AS full_name
FROM employees
WHERE (first_name IS NOT NULL) OR (last_name IS NOT NULL); 

-- aliases are good because they are more informative than the default

/*
 * DISTINCT()
 */

-- The company's problem:

-- Our database might be out of date! There's been recent restructuring,
-- we should now have six departments in the corp.
-- How many depts do employees currently belong to?

SELECT
	DISTINCT(department)
FROM employees 
-- all the different values within the dept column


/*
 * Aggregate functions
 */

-- How many employees started work for omni corp in 2001?

SELECT 
	count(*) AS started_in_2001
FROM employees 
WHERE start_date BETWEEN '2001-01-01' AND '2001-12-31';


/*
 * Other Aggregates:
 * 
 * SUM() ---- sum of a col
 * AVG() ---- mean of a col
 * MIN() ---- min value of a col
 * MAX() ---- max value of a col
 */

/*
 * Task
 * 
 * Design queries using aggregate functions and what you have learned so far.
 * 
 * 1. What are the max and min salaries of all employees?
 * 2. What is the average salary of employees in the HR dept?
 * 3. How much does the corp spend on the salaries of employees hired in 2018/
 */

-- 1. 
SELECT 
	MIN(salary) AS min_salary,
	MAX(salary) AS max_salary
FROM employees;

-- 2.
SELECT 
	AVG(salary) AS avg_HR_salary
FROM employees 
WHERE department = 'Human Resources';

-- 3.
SELECT 
	SUM(salary) AS total_salary
FROM employees 
WHERE start_date BETWEEN '2018-01-01' AND '2018-12-31';

/*
 * Sorting the reults
 */

-- ORDER BY

-- sorts the return of a query either - DESC, or ASC 
-- ORDER BY comes after WHERE 

-- Get a table of the employee's details for the emplyee who earns the min salary

SELECT *
FROM employees 
WHERE salary IS NOT NULL 
ORDER BY salary ASC
LIMIT 1;
-- limit the query result with LIMIT x

SELECT *
FROM employees 
WHERE salary IS NOT NULL 
ORDER BY salary DESC
LIMIT 1;

-- if we want to put NULLS at the end of the sorted list, use NULLS LAST
SELECT *
FROM employees 
ORDER BY salary DESC NULLS LAST 
LIMIT 1;

/*
 * We can perform multi-level sorts (sorts on multiple columns)
 */

-- get a table with employee detailes, ordered by fte hours (highest first) and alphabetically by last name  

SELECT * 
FROM employees 
ORDER BY 
	fte_hours DESC NULLS LAST ,
	last_name ASC NULLS LAST;

/*
 * Write queries to answer the following questions using the operators introduced in this section.
 * 
 * 1. “Get the details of the longest-serving employee of the corporation.”
 * 2. “Get the details of the highest paid employee of the corporation in Libya.”
 */


-- 1.
SELECT *
FROM employees 
ORDER BY start_date ASC 
LIMIT 1;

-- 2.
SELECT *
FROM employees 
WHERE country = 'Libya'
ORDER BY salary DESC NULLS LAST
LIMIT 1;

-- A note on TIES 
-- ties can happen when ordering, eg. 2 employees started on the same date 
-- LIMIT 1 (would only return 1 row) even if there was a tie 

-- write a first query to find the max value in a COLUMN 
-- use this result in the WHERE clause of a second query to find all rows with that value 

-- Get a table of all employees who work in the alphabetically first country

SELECT 
	country 
FROM employees 
ORDER BY country
LIMIT 1;

SELECT *
FROM employees 
WHERE country = 'Afghanistan';

-- SQL gotcha
-- order of definition != order of execution

SELECT 
	id,
	first_name,
	last_name,
	concat(first_name, ' ', last_name) AS full_name
FROM employees 
WHERE concat(first_name, ' ', last_name) LIKE 'A%'; 






