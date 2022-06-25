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

mysql> select store_id, category_id, count(inventory.film_id) , sum(replacement_cost) as totReplacementCost, avg(replacement_Cost) as avgREplacementCost from inventory 
 join film_Category on inventory.film_id = film_Category.film_id 
 join film on inventory.film_id = film.film_id  
 group by store_id, category_id 
 order by  store_id, category_id ;
 
+----------+-------------+--------------------------+--------------------+--------------------+
| store_id | category_id | count(inventory.film_id) | totReplacementCost | avgREplacementCost |
+----------+-------------+--------------------------+--------------------+--------------------+
|        1 |           1 |                      169 |            3581.31 |          21.191183 |
|        1 |           2 |                      161 |            3282.39 |          20.387516 |
|        1 |           3 |                      129 |            2578.71 |          19.990000 |
|        1 |           4 |                      131 |            2700.69 |          20.615954 |
|        1 |           5 |                      142 |            2760.58 |          19.440704 |
|        1 |           6 |                      130 |            2694.70 |          20.728462 |
|        1 |           7 |                      162 |            3553.38 |          21.934444 |
|        1 |           8 |                      157 |            3224.43 |          20.537771 |
|        1 |           9 |                      153 |            2839.47 |          18.558627 |
|        1 |          10 |                      128 |            2704.72 |          21.130625 |
|        1 |          11 |                      112 |            2211.88 |          19.748929 |
|        1 |          12 |                      122 |            2352.78 |          19.285082 |
|        1 |          13 |                      148 |            2851.52 |          19.267027 |
|        1 |          14 |                      149 |            3247.51 |          21.795369 |
|        1 |          15 |                      163 |            3354.37 |          20.578957 |
|        1 |          16 |                      114 |            2266.86 |          19.884737 |
|        2 |           1 |                      143 |            3074.57 |          21.500490 |
|        2 |           2 |                      174 |            3479.26 |          19.995747 |
|        2 |           3 |                      140 |            2730.60 |          19.504286 |
|        2 |           4 |                      139 |            2959.61 |          21.292158 |
|        2 |           5 |                      127 |            2396.73 |          18.871890 |
|        2 |           6 |                      164 |            3369.36 |          20.544878 |
|        2 |           7 |                      138 |            2961.62 |          21.461014 |
|        2 |           8 |                      153 |            2985.47 |          19.512876 |
|        2 |           9 |                      147 |            2739.53 |          18.636259 |
|        2 |          10 |                      148 |            3074.52 |          20.773784 |
|        2 |          11 |                      136 |            2660.64 |          19.563529 |
|        2 |          12 |                      110 |            2089.90 |          18.999091 |
|        2 |          13 |                      127 |            2543.73 |          20.029370 |
|        2 |          14 |                      163 |            3340.37 |          20.493067 |
|        2 |          15 |                      181 |            3746.19 |          20.697182 |
|        2 |          16 |                      121 |            2263.79 |          18.709008 |
+----------+-------------+--------------------------+--------------------+--------------------+
32 rows in set (0.02 sec)


/*
5.	We want to make sure you folks have a good handle on who your customers are. Please provide a list 
of all customer names, which store they go to, whether or not they are currently active, 
and their full addresses – street address, city, and country. 
*/

mysql> select customer_id, store_id, concat(first_name," ",last_name) as name, active, 
a.address, a.address2, a.district,a.postal_code, c.city, ct.country 
from customer cu join address a on address_id = a.address_id  
	join city c on a.city_id = c.city_id 
	join country ct on c.country_id = ct.country_id ;

+-------------+----------+--------------------+--------+----------------------------------+----------+-------------------+-------------+----------------------+----------------+
| customer_id | store_id | name               | active | address                          | address2 | district          | postal_code | city                 | country        |
+-------------+----------+--------------------+--------+----------------------------------+----------+-------------------+-------------+----------------------+----------------+
|         218 |        1 | VERA MCCOY         |      1 | 1168 Najafabad Parkway           |          | Kabol             | 40301       | Kabul                | Afghanistan    |
|         441 |        1 | MARIO CHEATHAM     |      1 | 1924 Shimonoseki Drive           |          | Batna             | 52625       | Batna                | Algeria        |
|          69 |        2 | JUDY GRAY          |      1 | 1031 Daugavpils Parkway          |          | Bchar             | 59025       | Bchar                | Algeria        |
|         176 |        1 | JUNE CARROLL       |      1 | 757 Rustenburg Avenue            |          | Skikda            | 89668       | Skikda               | Algeria        |
|         320 |        2 | ANTHONY SCHWAB     |      1 | 1892 Nabereznyje Telny Lane      |          | Tutuila           | 28396       | Tafuna               | American Samoa |
.....
.....
.....

559 rows in set (0.00 sec)



/*
6.	We would like to understand how much your customers are spending with you, and also to know 
who your most valuable customers are. Please pull together a list of customer names, their total 
lifetime rentals, and the sum of all payments you have collected from them. It would be great to 
see this ordered on total lifetime value, with the most valuable customers at the top of the list. 
*/

mysql>     select customer.customer_id,  concat(first_name," ",last_name) as name,    
 count(inventory.film_id) as cntRentalFilms, sum(amount) as totPaymentAmt         
 from customer        
 join  rental on customer.customer_id = rental.customer_id       
 join payment on customer.customer_id = payment.customer_id       
 join inventory on rental.inventory_id = inventory.inventory_id       
 join film on  film.film_id = inventory.film_id       
 group by customer_id        
 order by count(inventory.film_id;

+-------------+-------------------+----------------+---------------+
| customer_id | name              | cntRentalFilms | totPaymentAmt |
+-------------+-------------------+----------------+---------------+
|         148 | ELEANOR HUNT      |           2116 |       9960.84 |
|         526 | KARL SEAL         |           2025 |       9969.75 |
|         236 | MARCIA DEAN       |           1764 |       7374.36 |
|         144 | CLARA SHAW        |           1764 |       8214.36 |
|          75 | TAMMY SANDERS     |           1681 |       6379.19 |
|         197 | SUE PETERS        |           1600 |       6184.00 |
|         469 | WESLEY BULL       |           1600 |       7104.00 |
|         137 | RHONDA KENNEDY    |           1521 |       7589.79 |
|         178 | MARION SNYDER     |           1521 |       7589.79 |
|         468 | TIM CARY          |           1521 |       6848.79 |
|         295 | DAISY BATES       |           1444 |       6179.56 |
|           5 | ELIZABETH BROWN   |           1444 |       5495.56 |
|         410 | CURTIS IRBY       |           1444 |       6369.56 |
|         459 | TOMMY COLLAZO     |           1444 |       7091.56 |
|         257 | MARSHA DOUGLAS    |           1369 |       5610.31 |
|         198 | ELSIE KELLEY      |           1369 |       5240.31 |
|         176 | JUNE CARROLL      |           1369 |       6424.31 |
|         366 | BRANDON HUEY      |           1369 |       5647.31 |
|         354 | JUSTIN NGO        |           1296 |       4667.04 |
|         439 | ALEXANDER FENNELL |           1296 |       5459.04 |
|         267 | MARGIE WADE       |           1296 |       5747.04 |
|         380 | RUSSELL BRINSON   |           1296 |       4919.04 |
|         348 | ROGER QUINTANILLA |           1296 |       5279.04 |
|          29 | ANGELA HERNANDEZ  |           1296 |       5063.04 |
...
..
..
..
+-------------+-----------------------+----------------+---------------+
599 rows in set (1.06 sec)
    
/*
7. My partner and I would like to get to know your board of advisors and any current investors.
Could you please provide a list of advisor and investor names in one table? 
Could you please note whether they are an investor or an advisor, and for the investors, 
it would be good to include which company they work with. 
*/

mysql> select 
		advisor_id as entity_id,first_name,		last_name,	"advisor" as entity,"" as company_name
		from advisor
	   union 
	   select 
		investor_id as entity_id, first_name,	last_name,	"investor" as entity,	company_name
		from investor;

+-----------+------------+-------------+----------+-------------------------+
| entity_id | first_name | last_name   | entity   | company_name            |
+-----------+------------+-------------+----------+-------------------------+
|         1 | Barry      | Beenthere   | advisor  |                         |
|         2 | Cindy      | Smartypants | advisor  |                         |
|         3 | Mary       | Moneybags   | advisor  |                         |
|         4 | Walter     | White       | advisor  |                         |
|         1 | Montgomery | Burns       | investor | Springfield Syndicators |
|         2 | Anthony    | Stark       | investor | Iron Investors          |
|         3 | William    | Wonka       | investor | Chocolate Ventures      |
+-----------+------------+-------------+----------+-------------------------+
7 rows in set (0.00 sec)


/*
8. We're interested in how well you have covered the most-awarded actors. 
Of all the actors with three types of awards, for what % of them do we carry a film?
And how about for actors with two types of awards? Same questions. 
Finally, how about actors with just one award? 
*/
mysql>SELECT actor_id , concat(first_name,' ', last_name) as name , awards,  
	count(*) * 100.0 / sum(count(*)) Over() as 'award Percentage' 
	FROM actor_award 
	where awards like'%Emmy, Oscar, Tony%'  and   actor_id is not null 
	GROUP BY actor_id;

+----------+-----------------+--------------------+------------------+
| actor_id | name            | awards             | award Percentage |
+----------+-----------------+--------------------+------------------+
|       12 | KARL BERRY      | Emmy, Oscar, Tony  |         25.00000 |
|       21 | KIRSTEN PALTROW | Emmy, Oscar, Tony  |         25.00000 |
|       51 | GARY PHOENIX    | Emmy, Oscar, Tony  |         25.00000 |
|      123 | JULIANNE DENCH  | Emmy, Oscar, Tony  |         25.00000 |
+----------+-----------------+--------------------+------------------+
4 rows in set (0.00 sec)

mysql> SELECT actor_id ,concat(first_name,' ', last_name) as name,  awards, 
 count(*) * 100.0 / sum(count(*)) Over() as 'award Percentage' 
FROM actor_award 
 where awards like'%Emmy, Oscar'  and   actor_id is not null 
 GROUP BY actor_id;

+----------+----------------------+-------------+------------------+
| actor_id | name                 | awards      | award Percentage |
+----------+----------------------+-------------+------------------+
|        1 | PENELOPE GUINESS     | Emmy, Oscar |          3.84615 |
|       18 | DAN TORN             | Emmy, Oscar |          3.84615 |
|       27 | JULIA MCQUEEN        | Emmy, Oscar |          3.84615 |
|       35 | JUDY DEAN            | Emmy, Oscar |          3.84615 |
|       37 | VAL BOLGER           | Emmy, Oscar |          3.84615 |
|       52 | CARMEN HUNT          | Emmy, Oscar |          3.84615 |
|       57 | JUDE CRUISE          | Emmy, Oscar |          3.84615 |
|       65 | ANGELA HUDSON        | Emmy, Oscar |          3.84615 |
|       70 | MICHELLE MCCONAUGHEY | Emmy, Oscar |          3.84615 |
|       72 | SEAN WILLIAMS        | Emmy, Oscar |          3.84615 |
|       75 | BURT POSEY           | Emmy, Oscar |          3.84615 |
|       83 | BEN WILLIS           | Emmy, Oscar |          3.84615 |
|       98 | CHRIS BRIDGES        | Emmy, Oscar |          3.84615 |
|      102 | WALTER TORN          | Emmy, Oscar |          3.84615 |
|      109 | SYLVESTER DERN       | Emmy, Oscar |          3.84615 |
|      110 | SUSAN DAVIS          | Emmy, Oscar |          3.84615 |
|      111 | CAMERON ZELLWEGER    | Emmy, Oscar |          3.84615 |
|      116 | DAN STREEP           | Emmy, Oscar |          3.84615 |
|      117 | RENEE TRACY          | Emmy, Oscar |          3.84615 |
|      119 | WARREN JACKMAN       | Emmy, Oscar |          3.84615 |
|      129 | DARYL CRAWFORD       | Emmy, Oscar |          3.84615 |
|      145 | KIM ALLEN            | Emmy, Oscar |          3.84615 |
|      172 | GROUCHO WILLIAMS     | Emmy, Oscar |          3.84615 |
|      174 | MICHAEL BENING       | Emmy, Oscar |          3.84615 |
|      185 | MICHAEL BOLGER       | Emmy, Oscar |          3.84615 |
|      186 | JULIA ZELLWEGER      | Emmy, Oscar |          3.84615 |
+----------+----------------------+-------------+------------------+
26 rows in set (0.00 sec)

mysql> SELECT actor_id ,concat(first_name,' ', last_name) as name,  awards, 
 count(*) * 100.0 / sum(count(*)) Over() as 'award Percentage' 
FROM actor_award 
 where awards like'%Emmy, Oscar'  and   actor_id is not null 
 GROUP BY actor_id;
 
+----------+---------------------+--------+------------------+
| actor_id | name                | awards | award Percentage |
+----------+---------------------+--------+------------------+
|        2 | NICK WAHLBERG       | Emmy   |          5.26316 |
|        5 | JOHNNY LOLLOBRIGIDA | Emmy   |          5.26316 |
|       11 | ZERO CAGE           | Emmy   |          5.26316 |
|       14 | VIVIEN BERGEN       | Emmy   |          5.26316 |
|       53 | MENA TEMPLE         | Emmy   |          5.26316 |
|       81 | SCARLETT DAMON      | Emmy   |          5.26316 |
|       91 | CHRISTOPHER BERRY   | Emmy   |          5.26316 |
|       92 | KIRSTEN AKROYD      | Emmy   |          5.26316 |
|       93 | ELLEN PRESLEY       | Emmy   |          5.26316 |
|      100 | SPENCER DEPP        | Emmy   |          5.26316 |
|      115 | HARRISON BALE       | Emmy   |          5.26316 |
|      126 | FRANCES TOMEI       | Emmy   |          5.26316 |
|      128 | CATE MCQUEEN        | Emmy   |          5.26316 |
|      140 | WHOOPI HURT         | Emmy   |          5.26316 |
|      157 | GRETA MALDEN        | Emmy   |          5.26316 |
|      166 | NICK DEGENERES      | Emmy   |          5.26316 |
|      169 | KENNETH HOFFMAN     | Emmy   |          5.26316 |
|      177 | GENE MCKELLEN       | Emmy   |          5.26316 |
|      192 | JOHN SUVARI         | Emmy   |          5.26316 |
+----------+---------------------+--------+------------------+
19 rows in set (0.00 sec)