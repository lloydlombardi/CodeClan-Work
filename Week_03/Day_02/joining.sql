/*
 * Joins in Postgresql
*/


/*
 * ONE TO ONE - 1 person has 1 NI number
 * 
 * ONE TO MANY - 1 diet can have many animals
 * 
 * MANY TO MANY - 1 animal could have MANY keepers, 1 keeper could have MANY animals
 * 
 * If you see more than 1 FK in a table/Entity Relationship Diagram, it generlly denotes a MANY TO MANY JOIN table
*/

/*
 * INNER JOIN implies at LEAST a 1-1 or 1-MANY
*/


SELECT 
	animals.*,
	diets.*
FROM 
	animals 
INNER JOIN 
	diets ON animals.diet_id = diets.id;

-- Using aliases:
-- Only select name, species and diet_type
SELECT 
	A.name,
	A.species,
	D.diet_type 
FROM 
	animals AS A 
INNER JOIN 
	diets AS D ON A.diet_id = D.id;


-- Include age columns for animals older than 4
SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type 
FROM 
	animals AS A 
INNER JOIN 
	diets AS D ON A.diet_id = D.id
WHERE 
	A.age > 4;


-- count the animals in the zoo by their group by diet type
SELECT
	count(A.id),
	D.diet_type 
FROM 
	animals AS A
INNER JOIN 
	diets AS D ON A.diet_id = D.id 
GROUP BY 
	D.diet_type ;


-- modify the above to return all HERBIVORES only
SELECT
	count(A.id),
	A.species,
	D.diet_type 
FROM 
	animals AS A
INNER JOIN 
	diets AS D ON A.diet_id = D.id
WHERE 
	D.diet_type = 'herbivore'
GROUP BY 
	A.species, D.diet_type ;


/*
 * LEFT JOIN
 * 
 * Brings back ALL records on LEFT and any matching records on RIGHT (if any)
 */
SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type 
FROM 
	animals AS A 
LEFT JOIN 
	diets AS D ON A.diet_id = D.id;


/*
 * RIGHT JOIN
 * 
 * Brings back ALL records on RIGHT and any matching records on RIGHT (if any)
 */
SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type 
FROM 
	animals AS A 
RIGHT JOIN 
	diets AS D ON A.diet_id = D.id;


-- Return how many animals follow each diet type, including any diets which no animals follow
SELECT 
	count(A.id),
	D.diet_type 
FROM 
	animals AS A 
RIGHT JOIN 
	diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type ;


-- Return how many animals have a matching diet, including those with NO diet
SELECT 
	count(A.id),
	D.diet_type 
FROM 
	animals AS A 
LEFT JOIN 
	diets AS D ON A.diet_id = D.id
GROUP BY D.diet_type ;


/*
 * FULL JOIN
 * 
 * Brings back ALL records on BOTH sides
 * 
 * USE WITH CAUTION
 */
SELECT 
	A.name,
	A.species,
	A.age,
	D.diet_type 
FROM 
	animals AS A 
FULL JOIN 
	diets AS D ON A.diet_id = D.id;


-- Get a rota for the keepers and the animals they look after,
-- order first by animal name, then by DAY 
SELECT
	A."name" AS animal_name,
	A.species,
	CS."day",
	K."name" AS keeper_name
FROM 
	animals AS A
INNER JOIN 
	care_schedule AS CS ON A.id = CS.animal_id 
INNER JOIN 
	keepers AS K ON K.id = CS.keeper_id
ORDER BY 
	A.name, CS."day" ;


-- For the above change to show me the keeper for Ernest the snake
SELECT
	A."name" AS animal_name,
	A.species,
	CS."day",
	K."name" AS keeper_name
FROM 
	animals AS A
INNER JOIN 
	care_schedule AS CS ON A.id = CS.animal_id 
INNER JOIN 
	keepers AS K ON K.id = CS.keeper_id
WHERE 
	(A."name"  = 'Ernest') AND (A.species = 'Snake')
ORDER BY 
	A.name, CS."day" ;


-- Various animals on various tours around the zoo.

--JOIN table = animals_tours
-- Identify the join table linking the animals and tours table and reacquaint yourself with its contents.
-- Obtain a table showing animal name and species, the tour name on which they feature(d), along with the start date and end date (if
-- stored) of their involvement. Order the table by tour name, and then by animal name. 
SELECT
	A."name" AS animal_name,
	A.species,
	T."name" AS tour_name,
	AT.start_date,
	AT.end_date
FROM 
	animals AS A
INNER JOIN 
	animals_tours AS AT ON A.id = AT.animal_id
INNER JOIN 
	tours AS T ON T.id = AT.tour_id
ORDER BY 
	tour_name, animal_name;



-- Modify above to check with dates and NULLS 
-- [Harder] - can you limit the table to just those animals currently featuring on tours. Perhaps the NOW() function might help?
-- Assume an animal with a start date in the past and either no stored end date or an end date in the future is currently active on a tour.
SELECT
	A."name" AS animal_name,
	A.species,
	T."name" AS tour_name,
	AT.start_date,
	AT.end_date
FROM 
	animals AS A
INNER JOIN 
	animals_tours AS AT ON A.id = AT.animal_id
INNER JOIN 
	tours AS T ON T.id = AT.tour_id
WHERE 
	AT.start_date <= NOW() AND 
	(AT.end_date >= NOW() OR 
	AT.end_date IS NULL) 
ORDER BY 
	tour_name, animal_name;


/*
 * SELF JOINS
 */

-- Self join the keeper table to add the managers names into a column
SELECT 
	keepers.name AS keeper_name,
	managers.name AS manager_name
FROM 
	keepers 
INNER JOIN 
	keepers AS managers ON keepers.manager_id = managers.id;


/*
 * OPTIONALS
 * 
 * UNION
 * UNION ALL
 */

-- Union
SELECT *
FROM 
	animals 
UNION 
SELECT * 
FROM 
	animals ;

-- Union All
SELECT *
FROM 
	animals 
UNION ALL 
SELECT * 
FROM 
	animals ;





















































