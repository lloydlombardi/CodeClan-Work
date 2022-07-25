/*
* This is a multiline
* comment
*/

--This is an inline comment

--Get me a table of all the animals' information 

-- SELECT = columns to select.
-- FROM = table / entity to select from
-- * = any column
-- ; = end of query 
-- control + enter to run

SELECT *
FROM animals;

-- READ operation

-- Get me a table of information about animal with id 2

SELECT *
FROM animals 
WHERE id = 2;

-- Task: Get a table of information about Ernest the Snake

SELECT *
FROM animals 
WHERE species = 'Snake' AND name = 'Ernest';

-- Same as above but using primary key

SELECT *
FROM animals
WHERE id = 7;




