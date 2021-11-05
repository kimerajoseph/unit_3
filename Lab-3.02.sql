USE sakila;

-- QUESTION 1
--  How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT 
	COUNT(i.film_id) 
FROM sakila.inventory i
	JOIN 
		sakila.film f
	USING (film_id) 
WHERE f.title = 'Hunchback Impossible';

-- QUESTION 2
-- List all films whose length is longer than the average of all the films.
SELECT film_id, title, length  FROM sakila.film
WHERE length > (SELECT AVG(length) AS AVG_LEN FROM sakila.film)
ORDER BY length DESC;

-- QUESTION 3
-- Use subqueries to display all actors who appear in the film Alone Trip.

select * from sakila.actor
where actor_id in (Select actor_id from sakila.film_actor
where film_id in (select film_id from sakila.film
where title = 'Alone Trip'))
order by last_name asc;

-- INNER JOIN IS SIMPLER
SELECT 
	f.title, f.film_id,a.first_name, a.last_name 
FROM 
	sakila.film f 
	JOIN 
		sakila.film_actor fa 
		USING (film_id)
	JOIN 
		sakila.actor a 
		ON a.actor_id = fa.actor_id
WHERE f.title = 'Alone Trip';

-- QUESTION 4
-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.

SELECT 
	film_id, title, description 
FROM film 
WHERE 
	film_id in (SELECT film_id FROM film_category WHERE category_id in (SELECT category_id FROM category WHERE name = 'family'));

-- QUESTION 5
-- Get name and email from customers from Canada using subqueries. 
-- CUSTOMER ADDREESS CITY COUNTRY
SELECT 
	cu.customer_id,cu.first_name,cu.last_name,cu.email,co.country 
FROM 
	sakila.customer cu 
	JOIN 
		sakila.address a 
		USING (address_id)
	JOIN
		sakila.city c 
		ON a.city_id = c.city_id
	JOIN 
		sakila.country co 
		ON c.country_id = co.country_id
WHERE co.country = 'Canada';

-- USING SUBQUERRY
-- SUBQUERRIES ARE SO CONVOLUTED

SELECT customer_id,first_name, last_name, email FROM customer WHERE address_id IN
(SELECT address_id FROM address WHERE city_id IN
(SELECT city_id FROM city WHERE country_id IN
(SELECT country_id FROM country WHERE country = 'Canada'))); 

-- QUESTION 6
-- Which are films starred by the most prolific actor? 

-- GETTING ACTOR OR ACTRESS WITH THE MOST FILM
SELECT 
	a.actor_id, a.first_name, a.last_name, COUNT(a.actor_id) AS film_num 
FROM 
	sakila.actor a 
	JOIN 
		sakila.film_actor fa 
		USING(actor_id)
	JOIN 
		sakila.film f 
		ON f.film_id = fa.film_id 
	GROUP BY
		fa.actor_id
ORDER BY film_num DESC;

-- FIND ALL FILMS STARRED IN BY GINA DEGENERES WITH actor_id = 107
SELECT film_id,title, description FROM film WHERE film_id IN
(SELECT film_id FROM film WHERE film_id IN
(SELECT film_id FROM film_actor WHERE actor_id = 107)); 

-- QUESTION 7
-- Films rented by most profitable customer. 
SELECT 
	r.customer_id,cu.first_name, cu.last_name, SUM(p.amount) AS money_spent 
FROM 
	sakila.customer cu 
	JOIN 
		sakila.rental r
		USING (customer_id)
	JOIN 
		sakila.payment p 
		ON r.customer_id = p.customer_id
GROUP BY r.customer_id
ORDER BY money_spent DESC
LIMIT 5;

-- MOST PROFITABLE CUSTOMER IS KARL SEAL WITH CUSTOMER_ID = 526
SELECT film_id, title, description FROM film WHERE film_id IN 
(SELECT film_id FROM INVENTORY WHERE inventory_id IN (
SELECT inventory_id FROM rental WHERE customer_id IN (
SELECT customer_id FROM customer WHERE customer_id = 526 )));

-- QUESTION 8
-- Customers who spent more than the average payments.
SELECT 
	customer_id, first_name,last_name,SUM(amount) AS sum_spent 
FROM 
	customer
	JOIN 
		sakila.payment 
			USING (customer_id)
	GROUP BY 
		customer_id
	HAVING sum(amount) > (SELECT avg(total_payment) FROM (SELECT customer_id, SUM(amount) as total_payment FROM payment
	GROUP BY customer_id) eddie_is_cool)
ORDER BY SUM(amount) DESC;
