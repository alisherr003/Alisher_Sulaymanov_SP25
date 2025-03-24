
--PART 1
--1) All animation movies released between 2017 and 2019 with rate more than 1, alphabetical
select title from film 
where rental_rate >1 and release_year between 2017 and 2019;
--here is selected the movies which is released between 20127 and 2019, and rental_rate higher than 1

--2) The revenue earned by each rental store after March 2017 (columns: address and address2 – as one column, revenue)


--3)Top-5 actors by number of movies (released after 2015) they took part in (columns: first_name, last_name, number_of_movies, sorted by number_of_movies in descending order)
select   a.first_name, a.last_name, count(fa.film_id) as number_of_movies  from film_actor fa 
inner join actor a 
on a.actor_id = fa.actor_id
group by a.first_name,a.last_name
order by number_of_movies desc
limit 5; -- TOP 5 Actors by number of movies and their name.

--4) Number of Drama, Travel, Documentary per year (columns: release_year, number_of_drama_movies, number_of_travel_movies, number_of_documentary_movies), sorted by release year in descending order. Dealing with NULL values is encouraged)
select 
    f.release_year, 
    count(case when fc.category_id = 7 then fc.film_id end) as number_of_drama_movies,
    count(case when fc.category_id = 6 then fc.film_id end) as number_of_travel_movies,
    count(case when fc.category_id = 16 then fc.film_id end) as number_of_documentary_movies
from film_category fc
inner join film f on f.film_id = fc.film_id
group by  f.release_year
order by f.release_year desc; -- Here is selected three categories of film per year. 

-- PART 2
-- 1)Which three employees generated the most revenue in 2017? They should be awarded a bonus for their outstanding performance. 
select staff_id, sum(amount) as revenue from payment 
where extract(year from payment_date) = 2017
group by staff_id 
order by revenue desc
limit 3; -- here is selected top 3 employees for annual bonus

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
select a.actor_id,  a.first_name, a.last_name, max(f.release_year) as last_movie_year, 
       extract(year from current_date) - max(f.release_year) as gap_since_last_movie
from film_actor fa
inner join film f on fa.film_id = f.film_id
inner join actor a on fa.actor_id = a.actor_id
group by a.actor_id, a.first_name, a.last_name
order by gap_since_last_movie desc
limit 5; -- here is calculated the gap between last movie of actor and current date

--V2) gaps between sequential films per each actor
select fa1.actor_id, a.first_name, a.last_name, max(f2.release_year - f1.release_year) as max_gap
from film_actor fa1
inner join film f1 on fa1.film_id = f1.film_id
inner join actor a on fa1.actor_id = a.actor_id
inner join film_actor fa2 on fa1.actor_id = fa2.actor_id
inner join film f2 on fa2.film_id = f2.film_id
where f2.release_year > f1.release_year
group by fa1.actor_id, a.first_name, a.last_name
order by max_gap desc
limit 5; -- here is we used self join and calculated the gap between last two movies of actors, top5




