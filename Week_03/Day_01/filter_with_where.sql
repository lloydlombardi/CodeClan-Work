/*
 * Filtering with WHERE
 */


SELECT *
FROM employees 
WHERE id = 12;

SELECT *
FROM pay_details 
WHERE id = 35;

SELECT *
FROM employees 
WHERE department = 'Legal' OR team_id = 5;

/*
* Comparison Operators
* 
*  != not equal to 
*  = equal to
*  > greater than
*  < less than
*  <= less than or equal to 
*  >= greater than or equal to
*/

-- Find all the employees who work 0.5 full-time
-- equivalent hours or MORE 

SELECT *
FROM employees 
WHERE fte_hours >= 0.5;

/*
 * Task - Find all the employees not based in Brazil
 */

SELECT *
FROM employees 
WHERE country != 'Brazil';

/*
 * AND & OR
 */

-- Find all employees in China who started working for omni corp in 2019

SELECT *
FROM employees 
WHERE (country = 'China') AND (start_date >= '2019-01-01' AND start_date <= '2019-12-31');

-- Be wary of the order of evaluation

-- Find all the employees in China who either started working for omni corp from 2019 onwards, or are enrolled in the pension scheme

SELECT *
FROM employees 
WHERE country = 'China' AND (start_date >= '2019-01-01'
OR pension_enrol = TRUE);

/*
 *  BETWEEN, NOT & IN
 * 
 * These let you specify a range of values
 */

-- Find all employees who work between 0.25 and 0.5 fte hours
-- (inclusive)

SELECT *
FROM employees 
WHERE fte_hours BETWEEN 0.25 AND 0.5;
-- can think of this as >= lower range AND <= higher range

-- Find all employees who started working for omni in years other than 2017

SELECT *
FROM employees 
WHERE start_date NOT BETWEEN '2017-01-01' AND '2017-12-31';

-- Things to note:
-- BETWEEN is inclusive

-- Find all employees NOT based in Spain, SA, Ireland or Germany

SELECT *
FROM employees 
WHERE country IN ('Spain', 'South Africa', 'Ireland', 'Germany')

-- Find all employees NOT based in Spain, SA, Ireland or Germany

SELECT *
FROM employees 
WHERE country NOT IN ('Spain', 'South Africa', 'Ireland', 'Germany')

-- Task: Find all employees who started work at Omni in 2016, who for 0.5 fte hours or greater

SELECT *
FROM employees 
WHERE (start_date BETWEEN '2016-01-01' AND '2016-12-31') AND (fte_hours >= 0.5);

/*
 * LIKE, wildcards and regex
 */

-- Your manager comes to you and says:

/*
 * I was talking with a colleague from Greece last month.
 * I can't remember the last name excatly. 
 * I think it began with "Mc..."
 * Can you find them?
 */

SELECT *
FROM employees 
WHERE (country = 'Greece') AND (last_name LIKE 'Mc%');

/*
 * Wildcards
 * 
 * % matches zero or more
 * _ a single character
 */

-- can pop wildcards anywhere inside the pattern
-- below finds all employees, last name containing the phrase 'ere'
SELECT *
FROM employees 
WHERE last_name LIKE '%ere%'; 

/*
 * LIKE is case sensitive
 */

SELECT *
FROM employees 
WHERE last_name LIKE 'D%';

-- can use ILIKE to be insensitive to upper/lower case letters

SELECT *
FROM employees 
WHERE last_name ILIKE 'D%';

-- can use ~ to define a regex pattern match

-- Find all employees for whome the second letter of their last name 
-- is 'r' or 's' and the third letter is 'a' or 'o'

-- ^ anchors the start of the string
-- . matches any character
-- [rs] second letter is r or s
-- [ao] third letter is a or o 
SELECT *
FROM employees 
WHERE last_name ~ '^.[rs][ao]';

/*
 * regex tweaks
 * 
 *  ~  ---- define a regex
 *  ~* ---- define a case-insensitive regex
 * !~  ---- define a negative regex (case sensitive does not match)
 * !~* ---- define a case-insensitive negative regex
 */


/*
 * IS NULL
 */

-- We need to ensure our employee records are up to date.
-- Find all employees who do not have a listed email address

SELECT *
FROM employees 
WHERE email IS NULL;

-- little gotcha: colunm IS NULL, not column = NULL

















