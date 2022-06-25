/* 
1. My partner and I want to come by each of the stores in person and meet the managers. 
Please send over the managers’ names at each store, with the full address 
of each property (street address, district, city, and country please).  
*/ 

mysql> select sr.store_id, sr.manager_staff_id, sf.first_name, sf.last_name, a.address, a.address2, a.district,a.postal_code, 
	c.city, ct.country from store sr 
	join staff sf on sr.manager_staff_id = sf.staff_id 
	join address a on sf.address_id = a.address_id  
	join city c on a.city_id = c.city_id 
	join country ct on c.country_id = ct.country_id 
	order by sr.store_id, sr.manager_staff_id;
	
+----------+------------------+------------+-----------+----------------------+----------+----------+-------------+------------+-----------+
| store_id | manager_staff_id | first_name | last_name | address              | address2 | district | postal_code | city       | country   |
+----------+------------------+------------+-----------+----------------------+----------+----------+-------------+------------+-----------+
|        1 |                1 | Mike       | Hillyer   | 23 Workhaven Lane    | NULL     | Alberta  |             | Lethbridge | Canada    |
|        2 |                2 | Jon        | Stephens  | 1411 Lillydale Drive | NULL     | QLD      |             | Woodridge  | Australia |
+----------+------------------+------------+-----------+----------------------+----------+----------+-------------+------------+-----------+
2 rows in set (0.00 sec)


	
/*
2.	I would like to get a better understanding of all of the inventory that would come along with the business. 
Please pull together a list of each inventory item you have stocked, including the store_id number, 
the inventory_id, the name of the film, the film’s rating, its rental rate and replacement cost. 
*/

select store_id, inventory_id, film_id, title, rating, rental_rate, replacement_cost
from inventory 
join film on inventory.film_id = film.film_id 
order by inventory_id, store_id, film_id;

mysql> select store_id, inventory_id, inventory.film_id, title, rating, rental_rate, replacement_cost 
from inventory  join film on inventory.film_id = film.film_id 
order by inventory_id, store_id, inventory.film_id limit 100;


+----------+--------------+---------+---------------------+--------+-------------+------------------+
| store_id | inventory_id | film_id | title               | rating | rental_rate | replacement_cost |
+----------+--------------+---------+---------------------+--------+-------------+------------------+
|        1 |            1 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        1 |            2 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        1 |            3 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        1 |            4 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        2 |            5 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        2 |            6 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        2 |            7 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        2 |            8 |       1 | ACADEMY DINOSAUR    | PG     |        0.99 |            20.99 |
|        2 |            9 |       2 | ACE GOLDFINGER      | G      |        4.99 |            12.99 |
|        2 |           10 |       2 | ACE GOLDFINGER      | G      |        4.99 |            12.99 |
|        2 |           11 |       2 | ACE GOLDFINGER      | G      |        4.99 |            12.99 |
|        2 |           12 |       3 | ADAPTATION HOLES    | NC-17  |        2.99 |            18.99 |
|        2 |           13 |       3 | ADAPTATION HOLES    | NC-17  |        2.99 |            18.99 |
|        2 |           14 |       3 | ADAPTATION HOLES    | NC-17  |        2.99 |            18.99 |
|        2 |           15 |       3 | ADAPTATION HOLES    | NC-17  |        2.99 |            18.99 |
|        1 |           16 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        1 |           17 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        1 |           18 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        1 |           19 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        2 |           20 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        2 |           21 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        2 |           22 |       4 | AFFAIR PREJUDICE    | G      |        2.99 |            26.99 |
|        2 |           23 |       5 | AFRICAN EGG         | G      |        2.99 |            22.99 |
|        2 |           24 |       5 | AFRICAN EGG         | G      |        2.99 |            22.99 |
|        2 |           25 |       5 | AFRICAN EGG         | G      |        2.99 |            22.99 |
|        1 |           26 |       6 | AGENT TRUMAN        | PG     |        2.99 |            17.99 |
|        1 |           27 |       6 | AGENT TRUMAN        | PG     |        2.99 |            17.99 |
|        1 |           28 |       6 | AGENT TRUMAN        | PG     |        2.99 |            17.99 |
|        2 |           29 |       6 | AGENT TRUMAN        | PG     |        2.99 |            17.99 |
|        2 |           30 |       6 | AGENT TRUMAN        | PG     |        2.99 |            17.99 |
|        2 |           31 |       6 | AGENT TRUMAN        | PG     |        2.99 |            17.99 |
|        1 |           32 |       7 | AIRPLANE SIERRA     | PG-13  |        4.99 |            28.99 |
|        1 |           33 |       7 | AIRPLANE SIERRA     | PG-13  |        4.99 |            28.99 |
|        2 |           34 |       7 | AIRPLANE SIERRA     | PG-13  |        4.99 |            28.99 |
|        2 |           35 |       7 | AIRPLANE SIERRA     | PG-13  |        4.99 |            28.99 |

...
...
...

+----------+--------------+---------+-----------------------------+--------+-------------+------------------+
4581 rows in set (0.04 sec)


/* 
3.	From the same list of films you just pulled, please roll that data up and provide a summary level overview 
of your inventory. We would like to know how many inventory items you have with each rating at each store. 
*/

mysql> select store_id, rating, count(inventory_id) as totFilms from inventory  
join film on inventory.film_id = film.film_id 
group by store_id, rating
 order by  store_id, rating ;
 
+----------+--------+----------+
| store_id | rating | totFilms |
+----------+--------+----------+
|        1 | G      |      394 |
|        1 | PG     |      444 |
|        1 | PG-13  |      525 |
|        1 | R      |      442 |
|        1 | NC-17  |      465 |
|        2 | G      |      397 |
|        2 | PG     |      480 |
|        2 | PG-13  |      493 |
|        2 | R      |      462 |
|        2 | NC-17  |      479 |
+----------+--------+----------+
10 rows in set (0.01 sec)


/* 
4. Similarly, we want to understand how diversified the inventory is in terms of replacement cost. We want to 
see how big of a hit it would be if a certain category of film became unpopular at a certain store.
We would like to see the number of films, as well as the average replacement cost, and total replacement cost, 
sliced by store and film category. 
*/ 












/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/












/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/












    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/











/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/

