USE sakila;
SELECT * FROM sakila.staff;
ALTER TABLE sakila.staff DROP COLUMN picture;
SELECT * FROM sakila.customer WHERE first_name = "TAMMY";

-- QUESTION 2
-- username and password left empty
INSERT INTO 
	sakila.staff 
VALUES (3,'TAMMY','SANDERS',79,'', 'TAMMY.SANDERS@sakilacustomer.org',2,1,'','',NOW());

-- QUESTION 3
-- Rental duration for the movie is 6 days
INSERT INTO 
	sakila.rental (rental_date,inventory_id,customer_id,return_date,staff_id,last_update)
VALUES (NOW(),1,130,dateadd(dd, 6,getdate()),1,'2006-02-15 05:03:42');

-- QUERRYING AND GETTING DETAILS FROM VARIOUS TABLES
select customer_id from sakila.customer
where first_name = 'CHARLOTTE' and last_name = 'HUNTER';
select * from sakila.film where title = 'Academy Dinosaur';
select * from sakila.inventory where film_id = 1;

