
--PART 1
--1) All animation movies released between 2017 and 2019 with rate more than 1, alphabetical

select f.title
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id
where c.name = 'Animation'
  and f.release_year between 2017 and 2019
  and f.rental_rate > 1
order by f.title;


--here is selected the an animation movies which is released between 20127 and 2019, and rental_rate higher than 1

--2) The revenue earned by each rental store after March 2017 (columns: address and address2 – as one column, revenue)
SELECT 
  CONCAT(a.address, ' ', COALESCE(a.address2, '')) AS full_address,
  SUM(p.amount) AS revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN store s ON i.store_id = s.store_id
JOIN address a ON s.address_id = a.address_id
WHERE p.payment_date > '2017-03-31'
GROUP BY full_address
ORDER BY revenue DESC;

select * from sales_by_store sbs ;
select  * from store;

--3)Top-5 actors by number of movies (released after 2015) they took part in (columns: first_name, last_name, number_of_movies, sorted by number_of_movies in descending order)

select 
  a.first_name, 
  a.last_name, 
  count(fa.film_id) as number_of_movies
from actor a
join film_actor fa on a.actor_id = fa.actor_id
join film f on fa.film_id = f.film_id
where f.release_year > 2015
group by a.actor_id, a.first_name, a.last_name
order by number_of_movies desc
limit 5;



--4) Number of Drama, Travel, Documentary per year (columns: release_year, number_of_drama_movies, number_of_travel_movies, number_of_documentary_movies), sorted by release year in descending order. Dealing with NULL values is encouraged)

select 
    f.release_year, 
    count(case when c.name = 'Drama' then fc.film_id end) as number_of_drama_movies,
    count(case when c.name = 'Travel' then fc.film_id end) as number_of_travel_movies,
    count(case when c.name = 'Documentary' then fc.film_id end) as number_of_documentary_movies
from film_category fc
inner join film f on f.film_id = fc.film_id
inner join category c on fc.category_id = c.category_id
group by f.release_year
order by f.release_year desc;



-- PART 2
-- 1)Which three employees generated the most revenue in 2017? They should be awarded a bonus for their outstanding performance. 

select 
  s.first_name, 
  s.last_name, 
  sum(p.amount) as revenue
from payment p
join staff s on p.staff_id = s.staff_id
where extract(year from p.payment_date) = 2017
group by s.staff_id, s.first_name, s.last_name
order by revenue desc
limit 3;


-- 2)Which 5 movies were rented more than others (number of rentals), and what's the expected age of the audience for these movies? To determine expected age please use 'Motion Picture Association film rating system from film;

select f.title, count(r.rental_id) as rented_qty,f.rating from inventory i 
inner join film f 
on f.film_id = i.film_id
inner join rental r 
on r.inventory_id = i.inventory_id
group by f.title,f.rating
order by rented_qty  desc
limit 5; -- here is calculated top 5 films, the expected age of audience is in range of 8-17

-- PART 3 Which actors/actresses didn't act for a longer period of time than the others? 
-- V1) gap between the latest release_year and current year per each actor

select 
  a.actor_id,  
  a.first_name, 
  a.last_name, 
  coalesce(max(f.release_year), 0) as last_movie_year,  -- Handle NULL by returning 0 if no movies exist
  extract(year from current_date) - coalesce(max(f.release_year), extract(year from current_date)) as gap_since_last_movie  -- Handle gap calculation, assume 0 if no movies exist
from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
left join film f on fa.film_id = f.film_id -- Use LEFT JOIN to include actors even without films
group by a.actor_id, a.first_name, a.last_name
order by gap_since_last_movie desc
limit 5;


--V2) gaps between sequential films per each actor

select 
  fa1.actor_id, 
  a.first_name, 
  a.last_name, 
  max(f2.release_year - f1.release_year) as max_gap
from film_actor fa1
inner join film f1 on fa1.film_id = f1.film_id
inner join actor a on fa1.actor_id = a.actor_id
inner join film_actor fa2 on fa1.actor_id = fa2.actor_id
inner join film f2 on fa2.film_id = f2.film_id
where f2.release_year > f1.release_year
group by fa1.actor_id, a.first_name, a.last_name
order by max_gap desc
limit 5;
	




