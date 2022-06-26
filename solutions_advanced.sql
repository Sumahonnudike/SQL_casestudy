-- 32 --
-- We want to send all of our high-value customers a special VIP gift. We're defining high-value customers as those 
-- who've made at least 1 order with a total value (not including the discount) equal to $10,000 or more. We only want
--  to consider orders made in the year 1998
 
mysql>  select c.customer_id as cus, c.company_name as nam, o.order_id as ordid, sum(od.quantity*od.unit_price) as amount
                from customers c
            join orders o on o.customer_id = c.customer_id
               join order_details od on o.order_id = od.order_id
                where order_date between '19980101' and '19981231'
                group by cus, nam, ordid
                having amount > 10000
                  order by amount desc;
+-------+------------------------------+-------+---------------+
| cus   | nam                          | ordid | amount        |
+-------+------------------------------+-------+---------------+
| QUICK | QUICK-Stop                   | 10865 |         17250 |
| SAVEA | Save-a-lot Markets           | 11030 |  16321.900088 |
| HANAR | Hanari Carnes                | 10981 |         15810 |
| KOENE | Königlich Essen              | 10817 |  11490.699936 |
| RATTC | Rattlesnake Canyon Grocery   | 10889 |         11380 |
| HUNGO | Hungry Owl All-Night Grocers | 10897 | 10835.2400584 |
+-------+------------------------------+-------+---------------+
6 rows in set (0.01 sec)

-- 33  --
-- High-value customers - total orders The manager has changed his mind. Instead of requiring that customers have at least one individual orders totaling $10,000 or more, he wants to define high-value customers as those who have orders totaling $15,000 or more in 1998. How would you change the answer to the problem above?

mysql>   select c.customer_id, c.company_name, o.order_id, sum(od.quantity*od.unit_price) as totamount
             from orders o
          join customers c on o.customer_id = c.customer_id
           join order_details od on o.order_id = od.order_id
        where order_date between '19980101' and '19981231'
            group by c.customer_id
            having totamount > 15000
                order by totamount desc;
+-------------+------------------------------+----------+--------------------+
| customer_id | company_name                 | order_id | totamount          |
+-------------+------------------------------+----------+--------------------+
| SAVEA       | Save-a-lot Markets           |    10815 | 42806.250035080004 |
| ERNSH       | Ernst Handel                 |    10836 |      42598.8999409 |
| QUICK       | QUICK-Stop                   |    10845 |      40526.9899245 |
| HANAR       | Hanari Carnes                |    10886 |     24238.04997655 |
| HUNGO       | Hungry Owl All-Night Grocers |    10897 |      22796.3401198 |
| RATTC       | Rattlesnake Canyon Grocery   |    10820 |     21725.59992846 |
| KOENE       | Königlich Essen              |    10817 | 20204.949930000002 |
| FOLKO       | Folk och fä HB               |    10824 | 15973.850057340002 |
| WHITC       | White Clover Markets         |    10861 |     15278.89996402 |
+-------------+------------------------------+----------+--------------------+
9 rows in set (0.00 sec)

-- 34 --
-- High-value customers - with discount Change the above query to use the discount when calculating high-value customers. Order by the total amount which includes the discount

mysql>  select c.customer_id, c.company_name, o.order_id, sum(od.quantity*od.unit_price*(1-discount)) as totAfterAmount,
      sum(od.quantity*od.unit_price) as totBeforeAmount
                  from customers c
              join orders o on o.customer_id = c.customer_id
               join order_details od on o.order_id = od.order_id
             where order_date between '19980101' and '19981231'
                 group by c.customer_id
                having totAfterAmount > 10000
                     order by totAfterAmount desc;
+-------------+------------------------------+----------+--------------------+--------------------+
| customer_id | company_name                 | order_id | totAfterAmount     | totBeforeAmount    |
+-------------+------------------------------+----------+--------------------+--------------------+
| ERNSH       | Ernst Handel                 |    10836 |   41210.6498964076 |      42598.8999409 |
| QUICK       | QUICK-Stop                   |    10845 |  37217.31490021799 |      40526.9899245 |
| SAVEA       | Save-a-lot Markets           |    10815 |   36310.1099945153 | 42806.250035080004 |
| HANAR       | Hanari Carnes                |    10886 | 23821.199968201003 |     24238.04997655 |
| RATTC       | Rattlesnake Canyon Grocery   |    10820 | 21238.270428372158 |     21725.59992846 |
| HUNGO       | Hungry Owl All-Night Grocers |    10897 | 20402.120101386306 |      22796.3401198 |
| KOENE       | Königlich Essen              |    10817 |  19582.77391606296 | 20204.949930000002 |
| WHITC       | White Clover Markets         |    10861 |     15278.89996402 |     15278.89996402 |
| FOLKO       | Folk och fä HB               |    10824 | 13644.067535056201 | 15973.850057340002 |
| SUPRD       | Suprêmes délices             |    10841 |   11644.6000307315 |      11862.5000336 |
| BOTTM       | Bottom-Dollar Markets        |    10918 | 11338.549950200002 | 12227.399949600001 |
+-------------+------------------------------+----------+--------------------+--------------------+
11 rows in set (0.00 sec)

-- 35 --
-- At the end of the month, salespeople are likely to try much harder to get orders, to meet their month-end quotas. Show all orders made -- on the last day of the month. Order by EmployeeID and OrderID

mysql> select employee_id, order_id, order_date from orders where order_date 
in (select distinct last_day(order_date) from orders) order by employee_id, order_id;
+-------------+----------+---------------------+
| employee_id | order_id | order_date          |
+-------------+----------+---------------------+
|           1 |    10461 | 1997-02-28 00:00:00 |
|           1 |    10616 | 1997-07-31 00:00:00 |
|           2 |    10583 | 1997-06-30 00:00:00 |
|           2 |    10686 | 1997-09-30 00:00:00 |
|           2 |    10989 | 1998-03-31 00:00:00 |
|           2 |    11060 | 1998-04-30 00:00:00 |
|           3 |    10432 | 1997-01-31 00:00:00 |
|           3 |    10806 | 1997-12-31 00:00:00 |
|           3 |    10988 | 1998-03-31 00:00:00 |
|           3 |    11063 | 1998-04-30 00:00:00 |
|           4 |    10343 | 1996-10-31 00:00:00 |
|           4 |    10522 | 1997-04-30 00:00:00 |
|           4 |    10584 | 1997-06-30 00:00:00 |
|           4 |    10617 | 1997-07-31 00:00:00 |
|           4 |    10725 | 1997-10-31 00:00:00 |
|           4 |    10807 | 1997-12-31 00:00:00 |
|           4 |    11061 | 1998-04-30 00:00:00 |
|           4 |    11062 | 1998-04-30 00:00:00 |
|           5 |    10269 | 1996-07-31 00:00:00 |
|           6 |    10317 | 1996-09-30 00:00:00 |
|           7 |    10490 | 1997-03-31 00:00:00 |
|           8 |    10399 | 1996-12-31 00:00:00 |
|           8 |    10460 | 1997-02-28 00:00:00 |
|           8 |    10491 | 1997-03-31 00:00:00 |
|           8 |    10987 | 1998-03-31 00:00:00 |
|           9 |    10687 | 1997-09-30 00:00:00 |
+-------------+----------+---------------------+
26 rows in set (0.00 sec)


-- 36 --
-- Orders with many line items. Show the 10 orders with the most line items, in order of total line items

mysql> select order_id, count(order_id) as totItems from order_details group by order_id order by count(order_id) desc limit 10;
+----------+----------+
| order_id | totItems |
+----------+----------+
|    11077 |       25 |
|    10979 |        6 |
|    10657 |        6 |
|    10847 |        6 |
|    10393 |        5 |
|    10294 |        5 |
|    10324 |        5 |
|    10273 |        5 |
|    10337 |        5 |
|    10360 |        5 |
+----------+----------+
10 rows in set (0.02 sec)

--37 --
-- Orders - random assortment The Northwind mobile app developers would now like to just get a random assortment of orders for beta testing on their app. Show a random set of 2% of all orders. 
 
mysql> select order_id from orders where rand() < 0.02;
+----------+
| order_id |
+----------+
|    10776 |
|    10471 |
|    10686 |
|    10781 |
|    10433 |
|    10903 |
|    10347 |
|    10628 |
|    10749 |
|    10864 |
|    10507 |
|    10560 |
|    10845 |
|    10957 |
|    10837 |
+----------+
15 rows in set (0.00 sec)

-- 38 --
-- Orders - accidental double-entry Janet Leverling, one of the salespeople, has come to you with a request. She thinks that she  accidentally double-entered a line item on an order, with a different ProductID, but the same quantity. She remembers that the quantity was 60 or more. Show all the OrderIDs with line items that match this,

mysql> select ordeR_id,  quantity, count(*) as totprod  From order_details where quantity >= 60   group by order_id, quantity having totprod = 2;
+----------+----------+---------+
| ordeR_id | quantity | totprod |
+----------+----------+---------+
|    10263 |       60 |       2 |
|    10263 |       65 |       2 |
|    10658 |       70 |       2 |
|    10990 |       65 |       2 |
|    11030 |      100 |       2 |
+----------+----------+---------+
5 rows in set (0.00 sec)

---39 --
-- Orders - accidental double-entry details Based on the previous question, we now want to show details of the order, for orders that match the above criteria.

mysql> select distinct od.order_id, product_id , unit_price,od.quantity, discount from order_details od join
     (select  ordeR_id, quantity , count(*) as totprod  From order_details where quantity >= 60   group by order_id, quantity having totprod = 2) b
     on od.order_id = b.order_id order by od.order_id, od.quantity;
+----------+------------+------------+----------+--------------+
| order_id | product_id | unit_price | quantity | discount     |
+----------+------------+------------+----------+--------------+
|    10263 |         16 | 13.8999996 |       60 |         0.25 |
|    10263 |         30 | 20.7000008 |       60 |         0.25 |
|    10263 |         24 |  3.5999999 |       65 |            0 |
|    10263 |         74 |          8 |       65 |         0.25 |
|    10658 |         60 |         34 |       55 | 0.0500000007 |
|    10658 |         21 |         10 |       60 |            0 |
|    10658 |         40 | 18.3999996 |       70 | 0.0500000007 |
|    10658 |         77 |         13 |       70 | 0.0500000007 |
|    10990 |         34 |         14 |       60 |  0.150000006 |
|    10990 |         21 |         10 |       65 |            0 |
|    10990 |         55 |         24 |       65 |  0.150000006 |
|    10990 |         61 |       28.5 |       66 |  0.150000006 |
|    11030 |         29 | 123.790001 |       60 |         0.25 |
|    11030 |          5 | 21.3500004 |       70 |            0 |
|    11030 |          2 |         19 |      100 |         0.25 |
|    11030 |         59 |         55 |      100 |         0.25 |
+----------+------------+------------+----------+--------------+
16 rows in set (0.00 sec)

mysql> with ordersgt60 as
     (select   ordeR_id, quantity , count(*) as totprod  From order_details where quantity >= 60   group by order_id, quantity having totprod = 2)
     select  order_id, product_id, quantity , unit_price, discount from order_Details
     where order_id in (select distinct order_id from ordersgt60);
+----------+------------+----------+------------+--------------+
| order_id | product_id | quantity | unit_price | discount     |
+----------+------------+----------+------------+--------------+
|    10263 |         16 |       60 | 13.8999996 |         0.25 |
|    10263 |         24 |       65 |  3.5999999 |            0 |
|    10263 |         30 |       60 | 20.7000008 |         0.25 |
|    10263 |         74 |       65 |          8 |         0.25 |
|    10658 |         21 |       60 |         10 |            0 |
|    10658 |         40 |       70 | 18.3999996 | 0.0500000007 |
|    10658 |         60 |       55 |         34 | 0.0500000007 |
|    10658 |         77 |       70 |         13 | 0.0500000007 |
|    10990 |         21 |       65 |         10 |            0 |
|    10990 |         34 |       60 |         14 |  0.150000006 |
|    10990 |         55 |       65 |         24 |  0.150000006 |
|    10990 |         61 |       66 |       28.5 |  0.150000006 |
|    11030 |          2 |      100 |         19 |         0.25 |
|    11030 |          5 |       70 | 21.3500004 |            0 |
|    11030 |         29 |       60 | 123.790001 |         0.25 |
|    11030 |         59 |      100 |         55 |         0.25 |
+----------+------------+----------+------------+--------------+
16 rows in set (0.00 sec)

-- 40 --
-- Orders - accidental double-entry details, derived table Here's another way of getting the same results as in the previous problem, using a derived table instead of a CTE. However, there's a bug in this SQL. It returns 20 rows instead of 16. Correct the SQL.

mysql> Select Order_Details.Order_ID ,Product_ID ,Unit_Price ,Quantity ,Discount From Order_Details
     Join ( Select distinct Order_ID From Order_Details Where Quantity >= 60
     Group By Order_ID, Quantity Having Count(*) > 1 ) PotentialProblemOrders
     on PotentialProblemOrders.Order_ID = Order_Details.Order_ID Order by Order_ID, Product_ID;
+----------+------------+------------+----------+--------------+
| Order_ID | Product_ID | Unit_Price | Quantity | Discount     |
+----------+------------+------------+----------+--------------+
|    10263 |         16 | 13.8999996 |       60 |         0.25 |
|    10263 |         24 |  3.5999999 |       65 |            0 |
|    10263 |         30 | 20.7000008 |       60 |         0.25 |
|    10263 |         74 |          8 |       65 |         0.25 |
|    10658 |         21 |         10 |       60 |            0 |
|    10658 |         40 | 18.3999996 |       70 | 0.0500000007 |
|    10658 |         60 |         34 |       55 | 0.0500000007 |
|    10658 |         77 |         13 |       70 | 0.0500000007 |
|    10990 |         21 |         10 |       65 |            0 |
|    10990 |         34 |         14 |       60 |  0.150000006 |
|    10990 |         55 |         24 |       65 |  0.150000006 |
|    10990 |         61 |       28.5 |       66 |  0.150000006 |
|    11030 |          2 |         19 |      100 |         0.25 |
|    11030 |          5 | 21.3500004 |       70 |            0 |
|    11030 |         29 | 123.790001 |       60 |         0.25 |
|    11030 |         59 |         55 |      100 |         0.25 |
+----------+------------+------------+----------+--------------+
16 rows in set (0.00 sec)

-- 41 --
-- Late orders Some customers are complaining about their orders arriving late. Which orders are late?

mysql> select order_id, order_date, required_date, shipped_date from orders where shipped_date >= required_date order by order_date;
+----------+---------------------+---------------+--------------+
| order_id | order_date          | required_date | shipped_date |
+----------+---------------------+---------------+--------------+
|    10264 | 1996-07-24 00:00:00 | 1996-08-21    | 1996-08-23   |
|    10271 | 1996-08-01 00:00:00 | 1996-08-29    | 1996-08-30   |
|    10280 | 1996-08-14 00:00:00 | 1996-09-11    | 1996-09-12   |
|    10302 | 1996-09-10 00:00:00 | 1996-10-08    | 1996-10-09   |
|    10309 | 1996-09-19 00:00:00 | 1996-10-17    | 1996-10-23   |
|    10380 | 1996-12-12 00:00:00 | 1997-01-09    | 1997-01-16   |
|    10423 | 1997-01-23 00:00:00 | 1997-02-06    | 1997-02-24   |
|    10427 | 1997-01-27 00:00:00 | 1997-02-24    | 1997-03-03   |
|    10433 | 1997-02-03 00:00:00 | 1997-03-03    | 1997-03-04   |
|    10451 | 1997-02-19 00:00:00 | 1997-03-05    | 1997-03-12   |
|    10483 | 1997-03-24 00:00:00 | 1997-04-21    | 1997-04-25   |
|    10515 | 1997-04-23 00:00:00 | 1997-05-07    | 1997-05-23   |
|    10523 | 1997-05-01 00:00:00 | 1997-05-29    | 1997-05-30   |
|    10545 | 1997-05-22 00:00:00 | 1997-06-19    | 1997-06-26   |
|    10578 | 1997-06-24 00:00:00 | 1997-07-22    | 1997-07-25   |
|    10593 | 1997-07-09 00:00:00 | 1997-08-06    | 1997-08-13   |
|    10596 | 1997-07-11 00:00:00 | 1997-08-08    | 1997-08-12   |
|    10660 | 1997-09-08 00:00:00 | 1997-10-06    | 1997-10-15   |
|    10663 | 1997-09-10 00:00:00 | 1997-09-24    | 1997-10-03   |
|    10687 | 1997-09-30 00:00:00 | 1997-10-28    | 1997-10-30   |
|    10705 | 1997-10-15 00:00:00 | 1997-11-12    | 1997-11-18   |
|    10709 | 1997-10-17 00:00:00 | 1997-11-14    | 1997-11-20   |
|    10726 | 1997-11-03 00:00:00 | 1997-11-17    | 1997-12-05   |
|    10727 | 1997-11-03 00:00:00 | 1997-12-01    | 1997-12-05   |
|    10749 | 1997-11-20 00:00:00 | 1997-12-18    | 1997-12-19   |
|    10777 | 1997-12-15 00:00:00 | 1997-12-29    | 1998-01-21   |
|    10779 | 1997-12-16 00:00:00 | 1998-01-13    | 1998-01-14   |
|    10788 | 1997-12-22 00:00:00 | 1998-01-19    | 1998-01-19   |
|    10807 | 1997-12-31 00:00:00 | 1998-01-28    | 1998-01-30   |
|    10816 | 1998-01-06 00:00:00 | 1998-02-03    | 1998-02-04   |
|    10827 | 1998-01-12 00:00:00 | 1998-01-26    | 1998-02-06   |
|    10828 | 1998-01-13 00:00:00 | 1998-01-27    | 1998-02-04   |
|    10847 | 1998-01-22 00:00:00 | 1998-02-05    | 1998-02-10   |
|    10924 | 1998-03-04 00:00:00 | 1998-04-01    | 1998-04-08   |
|    10927 | 1998-03-05 00:00:00 | 1998-04-02    | 1998-04-08   |
|    10960 | 1998-03-19 00:00:00 | 1998-04-02    | 1998-04-08   |
|    10970 | 1998-03-24 00:00:00 | 1998-04-07    | 1998-04-24   |
|    10978 | 1998-03-26 00:00:00 | 1998-04-23    | 1998-04-23   |
|    10998 | 1998-04-03 00:00:00 | 1998-04-17    | 1998-04-17   |
+----------+---------------------+---------------+--------------+
39 rows in set (0.00 sec)


-- 42 --
-- Late orders - which employees? Some salespeople have more orders arriving late than others. Maybe they're not following up on the order process, and need more training. Which salespeople have the most orders arriving late

mysql> select e.employee_id, last_name, count(*) as lateCnt from  employees e
     join orders o
     on o.employee_id = e.employee_id
     where shipped_date >= required_date
     group by employee_id
     order by lateCnt desc;
+-------------+-----------+---------+
| employee_id | last_name | lateCnt |
+-------------+-----------+---------+
|           4 | Peacock   |      10 |
|           3 | Leverling |       5 |
|           8 | Callahan  |       5 |
|           9 | Dodsworth |       5 |
|           2 | Fuller    |       4 |
|           7 | King      |       4 |
|           1 | Davolio   |       3 |
|           6 | Suyama    |       3 |
+-------------+-----------+---------+
8 rows in set (0.00 sec)

-- 43 --
-- Late orders vs. total orders Andrew, the VP of sales, has been doing some more thinking some more about the problem of late orders. He realizes that just looking at the number of orders arriving late for each salesperson isn't a good idea. It needs to be compared against the total number of orders per salesperson. Return results like the following

mysql> with lateOrders as (select e.employee_id as empid, last_name, count(*) as lateCnt from  employees e
          join orders o
          on o.employee_id = e.employee_id
          where shipped_date >= required_date
          group by o.employee_id)
        select lateOrders.empid, lateOrders.last_name, count(*) , lateOrders.lateCnt from
        orders join lateOrders on orders.employee_id = lateOrders.empid group by orders.employee_id;
+-------+-----------+----------+---------+
| empid | last_name | count(*) | lateCnt |
+-------+-----------+----------+---------+
|     1 | Davolio   |      123 |       3 |
|     2 | Fuller    |       96 |       4 |
|     3 | Leverling |      127 |       5 |
|     4 | Peacock   |      156 |      10 |
|     6 | Suyama    |       67 |       3 |
|     7 | King      |       72 |       4 |
|     8 | Callahan  |      104 |       5 |
|     9 | Dodsworth |       43 |       5 |
+-------+-----------+----------+---------+
8 rows in set (0.00 sec)

mysql> select a.emp1, a.last_name, b.totCnt, a.lateCnt
     from
     (select e.employee_id emp1, last_name, count(*) as lateCnt from  employees e
          join orders o
        on o.employee_id = e.employee_id
         where shipped_date >= required_date
          group by e.employee_id) a
       join
      ( select e.employee_id emp2, last_name, count(*) as totCnt from  employees e
          join orders o
        on o.employee_id = e.employee_id
           group by e.employee_id) b
          on a.emp1 = b.emp2;
+------+-----------+--------+---------+
| emp1 | last_name | totCnt | lateCnt |
+------+-----------+--------+---------+
|    1 | Davolio   |    123 |       3 |
|    2 | Fuller    |     96 |       4 |
|    3 | Leverling |    127 |       5 |
|    4 | Peacock   |    156 |      10 |
|    6 | Suyama    |     67 |       3 |
|    7 | King      |     72 |       4 |
|    8 | Callahan  |    104 |       5 |
|    9 | Dodsworth |     43 |       5 |
+------+-----------+--------+---------+
8 rows in set (0.00 sec)

-- 44 --
-- Late orders vs. total orders - missing employee There's an employee missing in the answer from the problem above. Fix the SQL to show all employees who have taken orders

mysql> select b.emp2, b.last_name, b.totCnt, a.lateCnt
          from
       ( select e.employee_id emp2, last_name, count(*) as totCnt from  employees e
               join orders o
             on o.employee_id = e.employee_id
                group by e.employee_id) b
       left join
          (select e.employee_id emp1, last_name, count(*) as lateCnt from  employees e
               join orders o
             on o.employee_id = e.employee_id
              where shipped_date >= required_date
               group by e.employee_id) a
                    on a.emp1 = b.emp2;
+------+-----------+--------+---------+
| emp2 | last_name | totCnt | lateCnt |
+------+-----------+--------+---------+
|    1 | Davolio   |    123 |       3 |
|    2 | Fuller    |     96 |       4 |
|    3 | Leverling |    127 |       5 |
|    4 | Peacock   |    156 |      10 |
|    5 | Buchanan  |     42 |    NULL |
|    6 | Suyama    |     67 |       3 |
|    7 | King      |     72 |       4 |
|    8 | Callahan  |    104 |       5 |
|    9 | Dodsworth |     43 |       5 |
+------+-----------+--------+---------+
9 rows in set (0.00 sec)

-- 45 --
-- Late orders vs. total orders - fix null Continuing on the answer for above query, let's fix the results for row 5 - Buchanan. He should have a 0 instead of a Null in LateOrders.

mysql> select b.emp2, b.last_name, b.totCnt, ifnull(a.lateCnt,0)
               from
            ( select e.employee_id emp2, last_name, count(*) as totCnt from  employees e
                    join orders o
                  on o.employee_id = e.employee_id
                     group by e.employee_id) b
            left join
               (select e.employee_id emp1, last_name, count(*) as lateCnt from  employees e
                    join orders o
                  on o.employee_id = e.employee_id
                   where shipped_date >= required_date
                    group by e.employee_id) a
                         on a.emp1 = b.emp2;
+------+-----------+--------+---------------------+
| emp2 | last_name | totCnt | ifnull(a.lateCnt,0) |
+------+-----------+--------+---------------------+
|    1 | Davolio   |    123 |                   3 |
|    2 | Fuller    |     96 |                   4 |
|    3 | Leverling |    127 |                   5 |
|    4 | Peacock   |    156 |                  10 |
|    5 | Buchanan  |     42 |                   0 |
|    6 | Suyama    |     67 |                   3 |
|    7 | King      |     72 |                   4 |
|    8 | Callahan  |    104 |                   5 |
|    9 | Dodsworth |     43 |                   5 |
+------+-----------+--------+---------------------+
9 rows in set (0.00 sec)

-- 46 --
-- Late orders vs. total orders - percentage Now we want to get the percentage of late orders over total orders

mysql> select b.emp2, b.last_name, b.totCnt, ifnull(a.lateCnt,0), ifnull(a.lateCnt,0)/b.totCnt as percLateOrders
                    from
                 ( select e.employee_id emp2, last_name, count(*) as totCnt from  employees e
                         join orders o
                       on o.employee_id = e.employee_id
                          group by e.employee_id) b
                 left join
                    (select e.employee_id emp1, last_name, count(*) as lateCnt from  employees e
                         join orders o
                       on o.employee_id = e.employee_id
                        where shipped_date >= required_date
                         group by e.employee_id) a
                              on a.emp1 = b.emp2;
+------+-----------+--------+---------------------+----------------+
| emp2 | last_name | totCnt | ifnull(a.lateCnt,0) | percLateOrders |
+------+-----------+--------+---------------------+----------------+
|    1 | Davolio   |    123 |                   3 |         0.0244 |
|    2 | Fuller    |     96 |                   4 |         0.0417 |
|    3 | Leverling |    127 |                   5 |         0.0394 |
|    4 | Peacock   |    156 |                  10 |         0.0641 |
|    5 | Buchanan  |     42 |                   0 |         0.0000 |
|    6 | Suyama    |     67 |                   3 |         0.0448 |
|    7 | King      |     72 |                   4 |         0.0556 |
|    8 | Callahan  |    104 |                   5 |         0.0481 |
|    9 | Dodsworth |     43 |                   5 |         0.1163 |
+------+-----------+--------+---------------------+----------------+
9 rows in set (0.01 sec)

-- 47 --
-- Late orders vs. total orders - fix decimal So now for the PercentageLateOrders, we get a decimal value like we should. But to make the output easier to read, let's cut the PercentLateOrders off at 2 digits to the right of the decimal point.

 mysql> select b.emp2, b.last_name, b.totCnt, ifnull(a.lateCnt,0), round(ifnull(a.lateCnt,0)/b.totCnt,2)  as percLateOrders
    ->                     from
    ->                  ( select e.employee_id emp2, last_name, count(*) as totCnt from  employees e
    ->                          join orders o
    ->                        on o.employee_id = e.employee_id
    ->                           group by e.employee_id) b
    ->                  left join
    ->                     (select e.employee_id emp1, last_name, count(*) as lateCnt from  employees e
    ->                          join orders o
    ->                        on o.employee_id = e.employee_id
    ->                         where shipped_date >= required_date
    ->                          group by e.employee_id) a
    ->                               on a.emp1 = b.emp2;
+------+-----------+--------+---------------------+----------------+
| emp2 | last_name | totCnt | ifnull(a.lateCnt,0) | percLateOrders |
+------+-----------+--------+---------------------+----------------+
|    1 | Davolio   |    123 |                   3 |           0.02 |
|    2 | Fuller    |     96 |                   4 |           0.04 |
|    3 | Leverling |    127 |                   5 |           0.04 |
|    4 | Peacock   |    156 |                  10 |           0.06 |
|    5 | Buchanan  |     42 |                   0 |           0.00 |
|    6 | Suyama    |     67 |                   3 |           0.04 |
|    7 | King      |     72 |                   4 |           0.06 |
|    8 | Callahan  |    104 |                   5 |           0.05 |
|    9 | Dodsworth |     43 |                   5 |           0.12 |
+------+-----------+--------+---------------------+----------------+
9 rows in set (0.00 sec)


-- 48 --
-- Andrew Fuller, the VP of sales at Northwind, would like to do a sales campaign for existing customers. He'd like to categorize customers into groups, based on how much they ordered in 2016. Then, depending on which group the customer is in, he will target the customer with different sales materials. The customer grouping categories are 0 to 1,000, 1,000 to 5,000, 5,000 to 10,000, and over 10,000. A good starting point for this query is the answer from the problem “High-value customers - total orders. We don’t want to show customers who don’t have any orders in 2016

mysql> with cte as( 
select c.customer_id as cus, c.company_name as nam, o.order_id as ordid, ROUND(sum(od.quantity*od.unit_price),2) as amt
                from customers c 
            join orders o on o.customer_id = c.customer_id 
               join order_details od on o.order_id = od.order_id 
                where order_date between '19980101' and '19981231' 
                group by cus, nam 
                  ) 
select cus, nam, amt, 
   case  
      when amt between 0 and 1000 then 'Low'  
	 when amt Between 1000  and 5000 then 'Medium' 
      when amt Between 5000  and 10000 then 'High' 
	  when amt > 10000 then 'Very High'  end  customerGroup 
	  from cte 
	  order by nam;
+-------+------------------------------------+----------+---------------+
| cus   | nam                                | amt      | customerGroup |
+-------+------------------------------------+----------+---------------+
| ALFKI | Alfreds Futterkiste                |   2302.2 | Medium        |
| ANATR | Ana Trujillo Emparedados y helados |    514.4 | Low           |
| ANTON | Antonio Moreno Taquería            |      660 | Low           |
| AROUT | Around the Horn                    |   5838.5 | High          |
| BSBEV | B's Beverages                      |     2431 | Medium        |
| BERGS | Berglunds snabbköp                 |  8110.55 | High          |
| BLAUS | Blauer See Delikatessen            |     2160 | Medium        |
| BLONP | Blondesddsl père et fils           |      730 | Low           |
| BOLID | Bólido Comidas preparadas          |      280 | Low           |
| BONAP | Bon app'                           |   7185.9 | High          |
| BOTTM | Bottom-Dollar Markets              |  12227.4 | Very High     |
| CACTU | Cactus Comidas para llevar         |   1576.8 | Medium        |
| CHOPS | Chop-suey Chinese                  |   4429.4 | Medium        |
| COMMI | Comércio Mineiro                   |   513.75 | Low           |
| CONSH | Consolidated Holdings              |    931.5 | Low           |
| WANDK | Die Wandernde Kuh                  |     1564 | Medium        |
| DRACD | Drachenblut Delikatessen           |  2809.61 | Medium        |
| DUMON | Du monde entier                    |    860.1 | Low           |
| EASTC | Eastern Connection                 |  9569.31 | High          |
| ERNSH | Ernst Handel                       |  42598.9 | Very High     |
| FOLKO | Folk och fä HB                     | 15973.85 | Very High     |
| FRANR | France restauration                |  2252.06 | Medium        |
| FRANS | Franchi S.p.A.                     |     1296 | Medium        |
| FRANK | Frankenversand                     |     5587 | High          |
| FURIB | Furia Bacalhau e Frutos do Mar     |       68 | Low           |
| GALED | Galería del gastrónomo             |    207.5 | Low           |
| GODOS | Godos Cocina Típica                |  7064.05 | High          |
| GOURL | Gourmet Lanchonetes                |      497 | Low           |
| GREAL | Great Lakes Food Market            | 10562.58 | Very High     |
| HANAR | Hanari Carnes                      | 24238.05 | Very High     |
| HILAA | HILARION-Abastos                   |   6132.3 | High          |
| HUNGO | Hungry Owl All-Night Grocers       | 22796.34 | Very High     |
| ISLAT | Island Trading                     |   2684.6 | Medium        |
| KOENE | Königlich Essen                    | 20204.95 | Very High     |
| LACOR | La corne d'abondance               |  1992.05 | Medium        |
| LAMAI | La maison d'Asie                   |  1549.95 | Medium        |
| LAUGB | Laughing Bacchus Wine Cellars      |      187 | Low           |
| LEHMS | Lehmanns Marktstand                |  3342.85 | Medium        |
| LETSS | Let's Stop N Shop                  |   1450.6 | Medium        |
| LILAS | LILA-Supermercado                  |  5994.06 | High          |
| LINOD | LINO-Delicateses                   |  10085.6 | Very High     |
| LONEP | Lonesome Pine Restaurant           |   1709.4 | Medium        |
| MAGAA | Magazzini Alimentari Riuniti       |     1693 | Medium        |
| MAISD | Maison Dewey                       |  4746.58 | Medium        |
| MORGK | Morgenstern Gesundkost             |      245 | Low           |
| NORTS | North/South                        |       45 | Low           |
| OCEAN | Océano Atlántico Ltda.             |     3031 | Medium        |
| OLDWO | Old World Delicatessen             |  5337.65 | High          |
| OTTIK | Ottilies Käseladen                 |   3012.7 | Medium        |
| PERIC | Pericles Comidas clásicas          |     1496 | Medium        |
| PICCO | Piccolo und mehr                   |  4393.75 | Medium        |
| PRINI | Princesa Isabel Vinhos             |   2633.9 | Medium        |
| QUEDE | Que Delícia                        |   1353.6 | Medium        |
| QUEEN | Queen Cozinha                      |  7007.65 | High          |
| QUICK | QUICK-Stop                         | 40526.99 | Very High     |
| RANCH | Rancho grande                      |   1694.7 | Medium        |
| RATTC | Rattlesnake Canyon Grocery         |  21725.6 | Very High     |
| REGGC | Reggiani Caseifici                 |     4263 | Medium        |
| RICAR | Ricardo Adocicados                 |     7312 | High          |
| RICSU | Richter Supermarkt                 |   5497.9 | High          |
| ROMEY | Romero y tomillo                   |   726.89 | Low           |
| SANTG | Santé Gourmet                      |  3976.75 | Medium        |
| SAVEA | Save-a-lot Markets                 | 42806.25 | Very High     |
| SEVES | Seven Seas Imports                 |     1630 | Medium        |
| SIMOB | Simons bistro                      |    244.3 | Low           |
| SPECD | Spécialités du monde               |     2371 | Medium        |
| SPLIR | Split Rail Beer & Ale              |     1117 | Medium        |
| SUPRD | Suprêmes délices                   |  11862.5 | Very High     |
| THEBI | The Big Cheese                     |     69.6 | Low           |
| THECR | The Cracker Box                    |      326 | Low           |
| TOMSP | Toms Spezialitäten                 |    910.4 | Low           |
| TORTU | Tortuga Restaurante                |   1874.5 | Medium        |
| TRADH | Tradiçao Hipermercados             |  4401.62 | Medium        |
| TRAIH | Trail's Head Gourmet Provisioners  |    237.9 | Low           |
| VAFFE | Vaffeljernet                       |   4333.5 | Medium        |
| VICTE | Victuailles en stock               |     3022 | Medium        |
| WARTH | Wartian Herkku                     |      300 | Low           |
| WELLI | Wellington Importadora             |     1245 | Medium        |
| WHITC | White Clover Markets               |  15278.9 | Very High     |
| WILMK | Wilman Kala                        |     1987 | Medium        |
| WOLZA | Wolski  Zajazd                     |   1865.1 | Medium        |
+-------+------------------------------------+----------+---------------+
81 rows in set (0.01 sec)

-- 49 --
-- Customer grouping - fix null There's a bug with the answer for the previous question. The CustomerGroup value for one of the rows is null. Fix the SQL so that there are no nulls in the CustomerGroup field

mysql> with cte as( 
select c.customer_id as cus, c.company_name as nam, o.order_id as ordid, ROUND(sum(od.quantity*od.unit_price),2) as amt
                from customers c 
            join orders o on o.customer_id = c.customer_id 
               join order_details od on o.order_id = od.order_id 
                where order_date between '19980101' and '19981231' 
                group by cus, nam 
                  ) 
select cus, nam, amt, 
   case  
      when amt  >=0 and amt < 1000 then 'Low'  
	 when amt  >=1000  and amt < 5000 then 'Medium' 
      when amt >=5000  and amt < 10000 then 'High' 
	  when amt >= 10000 then 'Very High'  end  customerGroup 
	  from cte 
	  order by nam;
+-------+------------------------------------+----------+---------------+
| cus   | nam                                | amt      | customerGroup |
+-------+------------------------------------+----------+---------------+
| ALFKI | Alfreds Futterkiste                |   2302.2 | Medium        |
| ANATR | Ana Trujillo Emparedados y helados |    514.4 | Low           |
| ANTON | Antonio Moreno Taquería            |      660 | Low           |
| AROUT | Around the Horn                    |   5838.5 | High          |
| BSBEV | B's Beverages                      |     2431 | Medium        |
| BERGS | Berglunds snabbköp                 |  8110.55 | High          |
| BLAUS | Blauer See Delikatessen            |     2160 | Medium        |
| BLONP | Blondesddsl père et fils           |      730 | Low           |
| BOLID | Bólido Comidas preparadas          |      280 | Low           |
| BONAP | Bon app'                           |   7185.9 | High          |
| BOTTM | Bottom-Dollar Markets              |  12227.4 | Very High     |
| CACTU | Cactus Comidas para llevar         |   1576.8 | Medium        |
| CHOPS | Chop-suey Chinese                  |   4429.4 | Medium        |
| COMMI | Comércio Mineiro                   |   513.75 | Low           |
| CONSH | Consolidated Holdings              |    931.5 | Low           |
| WANDK | Die Wandernde Kuh                  |     1564 | Medium        |
| DRACD | Drachenblut Delikatessen           |  2809.61 | Medium        |
| DUMON | Du monde entier                    |    860.1 | Low           |
| EASTC | Eastern Connection                 |  9569.31 | High          |
| ERNSH | Ernst Handel                       |  42598.9 | Very High     |
| FOLKO | Folk och fä HB                     | 15973.85 | Very High     |
| FRANR | France restauration                |  2252.06 | Medium        |
| FRANS | Franchi S.p.A.                     |     1296 | Medium        |
| FRANK | Frankenversand                     |     5587 | High          |
| FURIB | Furia Bacalhau e Frutos do Mar     |       68 | Low           |
| GALED | Galería del gastrónomo             |    207.5 | Low           |
| GODOS | Godos Cocina Típica                |  7064.05 | High          |
| GOURL | Gourmet Lanchonetes                |      497 | Low           |
| GREAL | Great Lakes Food Market            | 10562.58 | Very High     |
| HANAR | Hanari Carnes                      | 24238.05 | Very High     |
| HILAA | HILARION-Abastos                   |   6132.3 | High          |
| HUNGO | Hungry Owl All-Night Grocers       | 22796.34 | Very High     |
| ISLAT | Island Trading                     |   2684.6 | Medium        |
| KOENE | Königlich Essen                    | 20204.95 | Very High     |
| LACOR | La corne d'abondance               |  1992.05 | Medium        |
| LAMAI | La maison d'Asie                   |  1549.95 | Medium        |
| LAUGB | Laughing Bacchus Wine Cellars      |      187 | Low           |
| LEHMS | Lehmanns Marktstand                |  3342.85 | Medium        |
| LETSS | Let's Stop N Shop                  |   1450.6 | Medium        |
| LILAS | LILA-Supermercado                  |  5994.06 | High          |
| LINOD | LINO-Delicateses                   |  10085.6 | Very High     |
| LONEP | Lonesome Pine Restaurant           |   1709.4 | Medium        |
| MAGAA | Magazzini Alimentari Riuniti       |     1693 | Medium        |
| MAISD | Maison Dewey                       |  4746.58 | Medium        |
| MORGK | Morgenstern Gesundkost             |      245 | Low           |
| NORTS | North/South                        |       45 | Low           |
| OCEAN | Océano Atlántico Ltda.             |     3031 | Medium        |
| OLDWO | Old World Delicatessen             |  5337.65 | High          |
| OTTIK | Ottilies Käseladen                 |   3012.7 | Medium        |
| PERIC | Pericles Comidas clásicas          |     1496 | Medium        |
| PICCO | Piccolo und mehr                   |  4393.75 | Medium        |
| PRINI | Princesa Isabel Vinhos             |   2633.9 | Medium        |
| QUEDE | Que Delícia                        |   1353.6 | Medium        |
| QUEEN | Queen Cozinha                      |  7007.65 | High          |
| QUICK | QUICK-Stop                         | 40526.99 | Very High     |
| RANCH | Rancho grande                      |   1694.7 | Medium        |
| RATTC | Rattlesnake Canyon Grocery         |  21725.6 | Very High     |
| REGGC | Reggiani Caseifici                 |     4263 | Medium        |
| RICAR | Ricardo Adocicados                 |     7312 | High          |
| RICSU | Richter Supermarkt                 |   5497.9 | High          |
| ROMEY | Romero y tomillo                   |   726.89 | Low           |
| SANTG | Santé Gourmet                      |  3976.75 | Medium        |
| SAVEA | Save-a-lot Markets                 | 42806.25 | Very High     |
| SEVES | Seven Seas Imports                 |     1630 | Medium        |
| SIMOB | Simons bistro                      |    244.3 | Low           |
| SPECD | Spécialités du monde               |     2371 | Medium        |
| SPLIR | Split Rail Beer & Ale              |     1117 | Medium        |
| SUPRD | Suprêmes délices                   |  11862.5 | Very High     |
| THEBI | The Big Cheese                     |     69.6 | Low           |
| THECR | The Cracker Box                    |      326 | Low           |
| TOMSP | Toms Spezialitäten                 |    910.4 | Low           |
| TORTU | Tortuga Restaurante                |   1874.5 | Medium        |
| TRADH | Tradiçao Hipermercados             |  4401.62 | Medium        |
| TRAIH | Trail's Head Gourmet Provisioners  |    237.9 | Low           |
| VAFFE | Vaffeljernet                       |   4333.5 | Medium        |
| VICTE | Victuailles en stock               |     3022 | Medium        |
| WARTH | Wartian Herkku                     |      300 | Low           |
| WELLI | Wellington Importadora             |     1245 | Medium        |
| WHITC | White Clover Markets               |  15278.9 | Very High     |
| WILMK | Wilman Kala                        |     1987 | Medium        |
| WOLZA | Wolski  Zajazd                     |   1865.1 | Medium        |
+-------+------------------------------------+----------+---------------+
81 rows in set (0.01 sec)

-- 50 --
-- Customer grouping with percentage Based on the above query, show all the defined CustomerGroups, and the percentage in each. Sort by the total in each group, in descending order.

mysql>  with totcte as (
      with cte as( 
select c.customer_id as cus, c.company_name as nam, o.order_id as ordid, ROUND(sum(od.quantity*od.unit_price),2) as amt
                from customers c 
            join orders o on o.customer_id = c.customer_id 
               join order_details od on o.order_id = od.order_id 
                where order_date between '19980101' and '19981231' 
                group by cus, nam 
                  ) 
select cus, nam, amt, 
   case  
      when amt between 0 and 1000 then 'Low'  
	 when amt Between 1000  and 5000 then 'Medium' 
      when amt Between 5000  and 10000 then 'High' 
	  when amt > 10000 then 'Very High'  end  customerGroup 
	  from cte )
      select customergroup, count(*) as totalCnt , count(*)  / sum(count(*)) Over() as 'Percentage'
      from totcte 
      group by customergroup;
+---------------+----------+------------+
| customerGroup | totalCnt | Percentage |
+---------------+----------+------------+
| High          |       12 |     0.1481 |
| Medium        |       36 |     0.4444 |
| Low           |       20 |     0.2469 |
| Very High     |       13 |     0.1605 |
+---------------+----------+------------+
4 rows in set (0.01 sec)

-- 51 --
-- Customer grouping - flexible Andrew, the VP of Sales is still thinking about how best to group customers, and define low, medium, high, and very high value customers. He now wants complete flexibility in grouping the customers, based on the dollar amount they've ordered. He doesn’t want to have to edit SQL in order to change the boundaries of the customer groups. How would you write the SQL? There's a table called CustomerGroupThreshold that you will need to use. Use only orders from 1998.
mysql>
  CREATE TABLE `customerthreshold` (
  `rangebottom` int DEFAULT NULL,
  `rangetop` int DEFAULT NULL,
  `customergroup` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='customerthreshhold';
insert into customerthreshold values (0,1000,'Low');
insert into customerthreshold values (1000,5000,'Medium');
insert into customerthreshold values (5000,10000,'High');
insert into customerthreshold values (10000,999999,'Very High');
with Orders1998 as 
( Select Customers.Customer_ID ,Customers.Company_Name , SUM(Quantity * Unit_Price) TotalOrderAmount
 From Customers Join Orders on Orders.Customer_ID = Customers.Customer_ID 
 Join Order_Details on Orders.Order_ID = Order_Details.Order_ID 
 Where Order_Date >= '19980101' and Order_Date < '19990101'
 Group by Customers.Customer_ID ,Customers.Company_Name )
 Select Customer_ID ,Company_Name ,TotalOrderAmount ,CustomerGroup
 from Orders1998 Join customerthreshold 
 on Orders1998.TotalOrderAmount between customerthreshold.RangeBottom and customerthreshold.RangeTop
 Order by Customer_ID;

+-------------+------------------------------------+--------------------+---------------+
| Customer_ID | Company_Name                       | TotalOrderAmount   | CustomerGroup |
+-------------+------------------------------------+--------------------+---------------+
| ALFKI       | Alfreds Futterkiste                | 2302.1999969999997 | Medium        |
| ANATR       | Ana Trujillo Emparedados y helados |  514.3999906700001 | Low           |
| ANTON       | Antonio Moreno Taquería            |                660 | Low           |
| AROUT       | Around the Horn                    |             5838.5 | High          |
| BERGS       | Berglunds snabbköp                 |      8110.54990875 | High          |
| BLAUS       | Blauer See Delikatessen            |               2160 | Medium        |
| BLONP       | Blondesddsl père et fils           |                730 | Low           |
| BOLID       | Bólido Comidas preparadas          |                280 | Low           |
| BONAP       | Bon app'                           |       7185.9000077 | High          |
| BOTTM       | Bottom-Dollar Markets              | 12227.399949600001 | Very High     |
| BSBEV       | B's Beverages                      |               2431 | Medium        |
| CACTU       | Cactus Comidas para llevar         |        1576.799988 | Medium        |
| CHOPS       | Chop-suey Chinese                  |       4429.4000534 | Medium        |
| COMMI       | Comércio Mineiro                   |         513.750012 | Low           |
| CONSH       | Consolidated Holdings              |         931.500012 | Low           |
| DRACD       | Drachenblut Delikatessen           |      2809.60997458 | Medium        |
| DUMON       | Du monde entier                    |       860.09999468 | Low           |
| EASTC       | Eastern Connection                 |  9569.309973200001 | High          |
| ERNSH       | Ernst Handel                       |      42598.8999409 | Very High     |
| FOLKO       | Folk och fä HB                     | 15973.850057340002 | Very High     |
| FRANK       | Frankenversand                     |  5586.999983850001 | High          |
| FRANR       | France restauration                |        2252.060014 | Medium        |
| FRANS       | Franchi S.p.A.                     |               1296 | Medium        |
| FURIB       | Furia Bacalhau e Frutos do Mar     |                 68 | Low           |
| GALED       | Galería del gastrónomo             |              207.5 | Low           |
| GODOS       | Godos Cocina Típica                | 7064.0499672000005 | High          |
| GOURL       | Gourmet Lanchonetes                |                497 | Low           |
| GREAL       | Great Lakes Food Market            |       10562.579986 | Very High     |
| HANAR       | Hanari Carnes                      |     24238.04997655 | Very High     |
| HILAA       | HILARION-Abastos                   |      6132.29993148 | High          |
| HUNGO       | Hungry Owl All-Night Grocers       |      22796.3401198 | Very High     |
| ISLAT       | Island Trading                     |       2684.5999984 | Medium        |
| KOENE       | Königlich Essen                    | 20204.949930000002 | Very High     |
| LACOR       | La corne d'abondance               |      1992.05001022 | Medium        |
| LAMAI       | La maison d'Asie                   |       1549.9500128 | Medium        |
| LAUGB       | Laughing Bacchus Wine Cellars      |                187 | Low           |
| LEHMS       | Lehmanns Marktstand                |        3342.850015 | Medium        |
| LETSS       | Let's Stop N Shop                  |       1450.5999904 | Medium        |
| LILAS       | LILA-Supermercado                  | 5994.0599938000005 | High          |
| LINOD       | LINO-Delicateses                   |     10085.59997811 | Very High     |
| LONEP       | Lonesome Pine Restaurant           |       1709.3999976 | Medium        |
| MAGAA       | Magazzini Alimentari Riuniti       | 1692.9999923999999 | Medium        |
| MAISD       | Maison Dewey                       | 4746.5799978000005 | Medium        |
| MORGK       | Morgenstern Gesundkost             |                245 | Low           |
| NORTS       | North/South                        |                 45 | Low           |
| OCEAN       | Océano Atlántico Ltda.             |        3031.000004 | Medium        |
| OLDWO       | Old World Delicatessen             |       5337.6500376 | High          |
| OTTIK       | Ottilies Käseladen                 |       3012.6999852 | Medium        |
| PERIC       | Pericles Comidas clásicas          |               1496 | Medium        |
| PICCO       | Piccolo und mehr                   |            4393.75 | Medium        |
| PRINI       | Princesa Isabel Vinhos             | 2633.9000100000003 | Medium        |
| QUEDE       | Que Delícia                        |      1353.59999848 | Medium        |
| QUEEN       | Queen Cozinha                      |        7007.649978 | High          |
| QUICK       | QUICK-Stop                         |      40526.9899245 | Very High     |
| RANCH       | Rancho grande                      |       1694.7000048 | Medium        |
| RATTC       | Rattlesnake Canyon Grocery         |     21725.59992846 | Very High     |
| REGGC       | Reggiani Caseifici                 |         4262.99996 | Medium        |
| RICAR       | Ricardo Adocicados                 |        7312.000024 | High          |
| RICSU       | Richter Supermarkt                 |      5497.89994172 | High          |
| ROMEY       | Romero y tomillo                   |  726.8899994000001 | Low           |
| SANTG       | Santé Gourmet                      |      3976.75000072 | Medium        |
| SAVEA       | Save-a-lot Markets                 | 42806.250035080004 | Very High     |
| SEVES       | Seven Seas Imports                 |               1630 | Medium        |
| SIMOB       | Simons bistro                      | 244.30001120000003 | Low           |
| SPECD       | Spécialités du monde               |               2371 | Medium        |
| SPLIR       | Split Rail Beer & Ale              |        1117.000015 | Medium        |
| SUPRD       | Suprêmes délices                   |      11862.5000336 | Very High     |
| THEBI       | The Big Cheese                     |         69.5999984 | Low           |
| THECR       | The Cracker Box                    |         325.999996 | Low           |
| TOMSP       | Toms Spezialitäten                 |       910.39999772 | Low           |
| TORTU       | Tortuga Restaurante                |       1874.4999981 | Medium        |
| TRADH       | Tradiçao Hipermercados             |  4401.619984000001 | Medium        |
| TRAIH       | Trail's Head Gourmet Provisioners  |        237.8999976 | Low           |
| VAFFE       | Vaffeljernet                       |         4333.50006 | Medium        |
| VICTE       | Victuailles en stock               |       3021.9999924 | Medium        |
| WANDK       | Die Wandernde Kuh                  |               1564 | Medium        |
| WARTH       | Wartian Herkku                     |                300 | Low           |
| WELLI       | Wellington Importadora             |               1245 | Medium        |
| WHITC       | White Clover Markets               |     15278.89996402 | Very High     |
| WILMK       | Wilman Kala                        | 1986.9999804200002 | Medium        |
| WOLZA       | Wolski  Zajazd                     |       1865.0999904 | Medium        |
+-------------+------------------------------------+--------------------+---------------+
-- 52 --
-- Countries with suppliers or customers Some Northwind employees are planning a business trip, and would like to visit as many suppliers and customers as possible. For their planning, they’d like to see a list of all countries where suppliers and/or customers are based.

mysql>  select distinct country from customers 
      union
      select distinct country from suppliers;
+-------------+
| country     |
+-------------+
| Argentina   |
| Australia   |
| Austria     |
| Belgium     |
| Brazil      |
| Canada      |
| Denmark     |
| Finland     |
| France      |
| Germany     |
| Ireland     |
| Italy       |
| Japan       |
| Mexico      |
| Netherlands |
| Norway      |
| Poland      |
| Portugal    |
| Singapore   |
| Spain       |
| Sweden      |
| Switzerland |
| UK          |
| USA         |
| Venezuela   |
+-------------+
25 rows in set (0.01 sec)

-- 53 --
-- Countries with suppliers or customers, version 2 The employees going on the business trip don’t want just a raw list of countries, they want more details.

mysql>  select scon supplier_Country, ccon customer_country from
  ( (SELECT DISTINCT c.country ccon
       FROM customers c
       WHERE NOT EXISTS (SELECT *
                                FROM suppliers s
                                WHERE s.country = c.country)) a
		left join
   (  SELECT    s.country scon
       FROM suppliers s
       WHERE NOT EXISTS (SELECT *
                                FROM customers c
                                WHERE s.country = c.country)) b
                                on a.ccon=b.scon)
                                union
	(select  scon supplier_Country, ccon customer_country from
   (SELECT DISTINCT c.country ccon
       FROM customers c
       WHERE NOT EXISTS (SELECT *
                                FROM suppliers s
                                WHERE s.country = c.country)) a
		right join
   (  SELECT    s.country scon
       FROM suppliers s
       WHERE NOT EXISTS (SELECT *
                                FROM customers c
                                WHERE s.country = c.country)) b
                                on a.ccon=b.scon)
     union                           
	(select distinct customers.country supplier_Country, customers.country customer_country from customers
    join suppliers on customers.country  = suppliers.country)
	ORDER BY 
  CASE WHEN customer_country is null then 0   else 1 END ; 
  
  +------------------+------------------+
| supplier_Country | customer_country |
+------------------+------------------+
| Japan            | NULL             |
| Australia        | NULL             |
| Singapore        | NULL             |
| Netherlands      | NULL             |
| NULL             | Mexico           |
| NULL             | Argentina        |
| NULL             | Switzerland      |
| NULL             | Austria          |
| NULL             | Portugal         |
| NULL             | Venezuela        |
| NULL             | Ireland          |
| NULL             | Belgium          |
| NULL             | Poland           |
| Germany          | Germany          |
| UK               | UK               |
| Sweden           | Sweden           |
| France           | France           |
| Spain            | Spain            |
| Canada           | Canada           |
| Brazil           | Brazil           |
| Italy            | Italy            |
| USA              | USA              |
| Norway           | Norway           |
| Denmark          | Denmark          |
| Finland          | Finland          |
+------------------+------------------+
25 rows in set (0.00 sec)

-- 54 --
-- Countries with suppliers or customers - version 3 The output of the above is improved, but it’s still not ideal What we’d really like to see is the country name, the total suppliers, and the total customers

mysql> with allcountries as
         (select distinct suppliers.country from suppliers
     union
      select distinct customers.country from customers),
       totcusts as 
      (select  customers.country, count(*) as  ccnt from customers group by country),
       totsupp as 
     ( select  suppliers.country, count(*) as scnt from suppliers group by country)
     select allcountries.country, ifnull(totsupp.scnt,0) as Suppliers, ifnull(totcusts.ccnt,0) as Customers  from
     allcountries
     left join totcusts on allcountries.country = totcusts.country 
     left join totsupp on allcountries.country = totsupp.country
     order by allcountries.country;
	 +-------------+-----------+-----------+
| country     | Suppliers | Customers |
+-------------+-----------+-----------+
| Argentina   |         0 |         3 |
| Australia   |         2 |         0 |
| Austria     |         0 |         2 |
| Belgium     |         0 |         2 |
| Brazil      |         1 |         9 |
| Canada      |         2 |         3 |
| Denmark     |         1 |         2 |
| Finland     |         1 |         2 |
| France      |         3 |        11 |
| Germany     |         3 |        11 |
| Ireland     |         0 |         1 |
| Italy       |         2 |         3 |
| Japan       |         2 |         0 |
| Mexico      |         0 |         5 |
| Netherlands |         1 |         0 |
| Norway      |         1 |         1 |
| Poland      |         0 |         1 |
| Portugal    |         0 |         2 |
| Singapore   |         1 |         0 |
| Spain       |         1 |         5 |
| Sweden      |         2 |         2 |
| Switzerland |         0 |         2 |
| UK          |         2 |         7 |
| USA         |         4 |        13 |
| Venezuela   |         0 |         4 |
+-------------+-----------+-----------+
25 rows in set (0.00 sec)

-- 55 --Looking at the Orders table—we’d like to show details for each order that was the first in that particular country, ordered by OrderID. So, we need one row per ShipCountry, and CustomerID, OrderID, and OrderDate should be of the first order from that country

mysql>  with cte as     
(Select Ship_Country ,Customer_ID ,Order_ID ,Order_Date ,
 Row_Number() over (Partition by Ship_Country Order by Ship_Country, Order_ID)   orderRank
 from orders )
 select Ship_Country ,Customer_ID ,Order_ID ,Order_Date  From cte where orderRank =1
 order by Ship_Country ,Order_ID;
 
+--------------+-------------+----------+---------------------+
| Ship_Country | Customer_ID | Order_ID | Order_Date          |
+--------------+-------------+----------+---------------------+
| Argentina    | OCEAN       |    10409 | 1997-01-09 00:00:00 |
| Austria      | ERNSH       |    10258 | 1996-07-17 00:00:00 |
| Belgium      | SUPRD       |    10252 | 1996-07-09 00:00:00 |
| Brazil       | HANAR       |    10250 | 1996-07-08 00:00:00 |
| Canada       | MEREP       |    10332 | 1996-10-17 00:00:00 |
| Denmark      | SIMOB       |    10341 | 1996-10-29 00:00:00 |
| Finland      | WARTH       |    10266 | 1996-07-26 00:00:00 |
| France       | VINET       |    10248 | 1996-07-04 00:00:00 |
| Germany      | TOMSP       |    10249 | 1996-07-05 00:00:00 |
| Ireland      | HUNGO       |    10298 | 1996-09-05 00:00:00 |
| Italy        | MAGAA       |    10275 | 1996-08-07 00:00:00 |
| Mexico       | CENTC       |    10259 | 1996-07-18 00:00:00 |
| Norway       | SANTG       |    10387 | 1996-12-18 00:00:00 |
| Poland       | WOLZA       |    10374 | 1996-12-05 00:00:00 |
| Portugal     | FURIB       |    10328 | 1996-10-14 00:00:00 |
| Spain        | ROMEY       |    10281 | 1996-08-14 00:00:00 |
| Sweden       | FOLKO       |    10264 | 1996-07-24 00:00:00 |
| Switzerland  | CHOPS       |    10254 | 1996-07-11 00:00:00 |
| UK           | BSBEV       |    10289 | 1996-08-26 00:00:00 |
| USA          | RATTC       |    10262 | 1996-07-22 00:00:00 |
| Venezuela    | HILAA       |    10257 | 1996-07-16 00:00:00 |
+--------------+-------------+----------+---------------------+
21 rows in set (0.00 sec)

-- 56 --
-- Customers with multiple orders in 5 day period There are some customers for whom freight is a major expense when ordering from Northwind. However, by batching up their orders, and making one larger order instead of multiple smaller orders in a short period of time, they could reduce their freight costs significantly. Show those customers who have made more than 1 order in a 5 day period. The sales people will use this to help customers reduce their costs.

mysql> Select firstOrder.customer_id , firstOrder.Order_id firstOrderId, firstOrder.Order_date firstOrderDate  ,
  NextOrder.Order_id NextOrderID , NextOrder.Order_Date  NextOrderDate,
   datediff( nextOrder.Order_Date, firstOrder.Order_Date) DaysBetween
  from Orders firstOrder 
  join Orders NextOrder on firstOrder.Customer_ID = NextOrder.Customer_ID 
  where firstOrder.Order_ID < NextOrder.Order_ID 
  and datediff( NextOrder.Order_date, firstOrder.Order_Date) <= 5
  Order by firstOrder.Customer_ID ,firstOrder.Order_ID;

+-------------+--------------+---------------------+-------------+---------------------+-------------+
| customer_id | firstOrderId | firstOrderDate      | NextOrderID | NextOrderDate       | DaysBetween |
+-------------+--------------+---------------------+-------------+---------------------+-------------+
| ANTON       |        10677 | 1997-09-22 00:00:00 |       10682 | 1997-09-25 00:00:00 |           3 |
| AROUT       |        10741 | 1997-11-14 00:00:00 |       10743 | 1997-11-17 00:00:00 |           3 |
| BERGS       |        10278 | 1996-08-12 00:00:00 |       10280 | 1996-08-14 00:00:00 |           2 |
| BERGS       |        10444 | 1997-02-12 00:00:00 |       10445 | 1997-02-13 00:00:00 |           1 |
| BERGS       |        10866 | 1998-02-03 00:00:00 |       10875 | 1998-02-06 00:00:00 |           3 |
| BONAP       |        10730 | 1997-11-05 00:00:00 |       10732 | 1997-11-06 00:00:00 |           1 |
| BONAP       |        10871 | 1998-02-05 00:00:00 |       10876 | 1998-02-09 00:00:00 |           4 |
| BONAP       |        10932 | 1998-03-06 00:00:00 |       10940 | 1998-03-11 00:00:00 |           5 |
| BOTTM       |        10410 | 1997-01-10 00:00:00 |       10411 | 1997-01-10 00:00:00 |           0 |
| BOTTM       |        10944 | 1998-03-12 00:00:00 |       10949 | 1998-03-13 00:00:00 |           1 |
| BOTTM       |        10975 | 1998-03-25 00:00:00 |       10982 | 1998-03-27 00:00:00 |           2 |
| BOTTM       |        11045 | 1998-04-23 00:00:00 |       11048 | 1998-04-24 00:00:00 |           1 |
| BSBEV       |        10538 | 1997-05-15 00:00:00 |       10539 | 1997-05-16 00:00:00 |           1 |
| BSBEV       |        10943 | 1998-03-11 00:00:00 |       10947 | 1998-03-13 00:00:00 |           2 |
| EASTC       |        11047 | 1998-04-24 00:00:00 |       11056 | 1998-04-28 00:00:00 |           4 |
| ERNSH       |        10402 | 1997-01-02 00:00:00 |       10403 | 1997-01-03 00:00:00 |           1 |
| ERNSH       |        10771 | 1997-12-10 00:00:00 |       10773 | 1997-12-11 00:00:00 |           1 |
| ERNSH       |        10771 | 1997-12-10 00:00:00 |       10776 | 1997-12-15 00:00:00 |           5 |
| ERNSH       |        10773 | 1997-12-11 00:00:00 |       10776 | 1997-12-15 00:00:00 |           4 |
| ERNSH       |        10968 | 1998-03-23 00:00:00 |       10979 | 1998-03-26 00:00:00 |           3 |
| ERNSH       |        11008 | 1998-04-08 00:00:00 |       11017 | 1998-04-13 00:00:00 |           5 |
| FOLKO       |        10977 | 1998-03-26 00:00:00 |       10980 | 1998-03-27 00:00:00 |           1 |
| FOLKO       |        10980 | 1998-03-27 00:00:00 |       10993 | 1998-04-01 00:00:00 |           5 |
| FOLKO       |        10993 | 1998-04-01 00:00:00 |       11001 | 1998-04-06 00:00:00 |           5 |
| FRANK       |        10670 | 1997-09-16 00:00:00 |       10675 | 1997-09-19 00:00:00 |           3 |
| GODOS       |        10872 | 1998-02-05 00:00:00 |       10874 | 1998-02-06 00:00:00 |           1 |
| GREAL       |        10616 | 1997-07-31 00:00:00 |       10617 | 1997-07-31 00:00:00 |           0 |
| HANAR       |        10250 | 1996-07-08 00:00:00 |       10253 | 1996-07-10 00:00:00 |           2 |
| HANAR       |        10922 | 1998-03-03 00:00:00 |       10925 | 1998-03-04 00:00:00 |           1 |
| HILAA       |        10486 | 1997-03-26 00:00:00 |       10490 | 1997-03-31 00:00:00 |           5 |
| HILAA       |        10957 | 1998-03-18 00:00:00 |       10960 | 1998-03-19 00:00:00 |           1 |
| ISLAT       |        10315 | 1996-09-26 00:00:00 |       10318 | 1996-10-01 00:00:00 |           5 |
| ISLAT       |        10318 | 1996-10-01 00:00:00 |       10321 | 1996-10-03 00:00:00 |           2 |
| KOENE       |        10323 | 1996-10-07 00:00:00 |       10325 | 1996-10-09 00:00:00 |           2 |
| KOENE       |        10456 | 1997-02-25 00:00:00 |       10457 | 1997-02-25 00:00:00 |           0 |
| LACOR       |        10972 | 1998-03-24 00:00:00 |       10973 | 1998-03-24 00:00:00 |           0 |
| LEHMS       |        10534 | 1997-05-12 00:00:00 |       10536 | 1997-05-14 00:00:00 |           2 |
| LEHMS       |        10592 | 1997-07-08 00:00:00 |       10593 | 1997-07-09 00:00:00 |           1 |
| LILAS       |        11065 | 1998-05-01 00:00:00 |       11071 | 1998-05-05 00:00:00 |           4 |
| LINOD       |        10838 | 1998-01-19 00:00:00 |       10840 | 1998-01-19 00:00:00 |           0 |
| LONEP       |        10662 | 1997-09-09 00:00:00 |       10665 | 1997-09-11 00:00:00 |           2 |
| MAISD       |        10892 | 1998-02-17 00:00:00 |       10896 | 1998-02-19 00:00:00 |           2 |
| MEREP       |        10618 | 1997-08-01 00:00:00 |       10619 | 1997-08-04 00:00:00 |           3 |
| QUEEN       |        10913 | 1998-02-26 00:00:00 |       10914 | 1998-02-27 00:00:00 |           1 |
| QUICK       |        10285 | 1996-08-20 00:00:00 |       10286 | 1996-08-21 00:00:00 |           1 |
| QUICK       |        10691 | 1997-10-03 00:00:00 |       10694 | 1997-10-06 00:00:00 |           3 |
| QUICK       |        10991 | 1998-04-01 00:00:00 |       10996 | 1998-04-02 00:00:00 |           1 |
| RATTC       |        10314 | 1996-09-25 00:00:00 |       10316 | 1996-09-27 00:00:00 |           2 |
| RICSU       |        10751 | 1997-11-24 00:00:00 |       10758 | 1997-11-28 00:00:00 |           4 |
| ROMEY       |        10281 | 1996-08-14 00:00:00 |       10282 | 1996-08-15 00:00:00 |           1 |
| SAVEA       |        10393 | 1996-12-25 00:00:00 |       10398 | 1996-12-30 00:00:00 |           5 |
| SAVEA       |        10603 | 1997-07-18 00:00:00 |       10607 | 1997-07-22 00:00:00 |           4 |
| SAVEA       |        10711 | 1997-10-21 00:00:00 |       10713 | 1997-10-22 00:00:00 |           1 |
| SAVEA       |        10711 | 1997-10-21 00:00:00 |       10714 | 1997-10-22 00:00:00 |           1 |
| SAVEA       |        10713 | 1997-10-22 00:00:00 |       10714 | 1997-10-22 00:00:00 |           0 |
| SAVEA       |        10983 | 1998-03-27 00:00:00 |       10984 | 1998-03-30 00:00:00 |           3 |
| SAVEA       |        11030 | 1998-04-17 00:00:00 |       11031 | 1998-04-17 00:00:00 |           0 |
| SEVES       |        10800 | 1997-12-26 00:00:00 |       10804 | 1997-12-30 00:00:00 |           4 |
| SUPRD       |        10841 | 1998-01-20 00:00:00 |       10846 | 1998-01-22 00:00:00 |           2 |
| SUPRD       |        11035 | 1998-04-20 00:00:00 |       11038 | 1998-04-21 00:00:00 |           1 |
| TRADH       |        10830 | 1998-01-13 00:00:00 |       10834 | 1998-01-15 00:00:00 |           2 |
| TRADH       |        10834 | 1998-01-15 00:00:00 |       10839 | 1998-01-19 00:00:00 |           4 |
| TRAIH       |        10574 | 1997-06-19 00:00:00 |       10577 | 1997-06-23 00:00:00 |           4 |
| VICTE       |        10806 | 1997-12-31 00:00:00 |       10814 | 1998-01-05 00:00:00 |           5 |
| VICTE       |        10843 | 1998-01-21 00:00:00 |       10850 | 1998-01-23 00:00:00 |           2 |
| VINET       |        10737 | 1997-11-11 00:00:00 |       10739 | 1997-11-12 00:00:00 |           1 |
| WARTH       |        10412 | 1997-01-13 00:00:00 |       10416 | 1997-01-16 00:00:00 |           3 |
| WELLI       |        10803 | 1997-12-30 00:00:00 |       10809 | 1998-01-01 00:00:00 |           2 |
| WELLI       |        10900 | 1998-02-20 00:00:00 |       10905 | 1998-02-24 00:00:00 |           4 |
| WHITC       |        10693 | 1997-10-06 00:00:00 |       10696 | 1997-10-08 00:00:00 |           2 |
| WILMK       |        10873 | 1998-02-06 00:00:00 |       10879 | 1998-02-10 00:00:00 |           4 |
+-------------+--------------+---------------------+-------------+---------------------+-------------+
71 rows in set (0.01 sec)

-- 57 --
-- same 56 question but by using lead function

mysql> With NextOrderDate as 
( Select Customer_ID ,Order_Date ,Lead(OrderDate,1) OVER (Partition by Customer_ID order by Customer_ID, Order_Date) nextOrder_Date) From Orders )Select Customer_ID ,Order_Date ,NextOrder_Date ,dateDiff (nextOrder_Date, Order_Date) DaysBetweenOrders From NextOrderDate Where DateDiff ( NextOrder_Date, Order_Date) <= 5;

+-------------+---------------------+---------------------+-------------------+
| Customer_ID | Order_Date          | NextOrder_Date      | DaysBetweenOrders |
+-------------+---------------------+---------------------+-------------------+
| ANTON       | 1997-09-22 00:00:00 | 1997-09-25 00:00:00 |                 3 |
| AROUT       | 1997-11-14 00:00:00 | 1997-11-17 00:00:00 |                 3 |
| BERGS       | 1996-08-12 00:00:00 | 1996-08-14 00:00:00 |                 2 |
| BERGS       | 1997-02-12 00:00:00 | 1997-02-13 00:00:00 |                 1 |
| BERGS       | 1998-02-03 00:00:00 | 1998-02-06 00:00:00 |                 3 |
| BONAP       | 1997-11-05 00:00:00 | 1997-11-06 00:00:00 |                 1 |
| BONAP       | 1998-02-05 00:00:00 | 1998-02-09 00:00:00 |                 4 |
| BONAP       | 1998-03-06 00:00:00 | 1998-03-11 00:00:00 |                 5 |
| BOTTM       | 1997-01-10 00:00:00 | 1997-01-10 00:00:00 |                 0 |
| BOTTM       | 1998-03-12 00:00:00 | 1998-03-13 00:00:00 |                 1 |
| BOTTM       | 1998-03-25 00:00:00 | 1998-03-27 00:00:00 |                 2 |
| BOTTM       | 1998-04-23 00:00:00 | 1998-04-24 00:00:00 |                 1 |
| BSBEV       | 1997-05-15 00:00:00 | 1997-05-16 00:00:00 |                 1 |
| BSBEV       | 1998-03-11 00:00:00 | 1998-03-13 00:00:00 |                 2 |
| EASTC       | 1998-04-24 00:00:00 | 1998-04-28 00:00:00 |                 4 |
| ERNSH       | 1997-01-02 00:00:00 | 1997-01-03 00:00:00 |                 1 |
| ERNSH       | 1997-12-10 00:00:00 | 1997-12-11 00:00:00 |                 1 |
| ERNSH       | 1997-12-11 00:00:00 | 1997-12-15 00:00:00 |                 4 |
| ERNSH       | 1998-03-23 00:00:00 | 1998-03-26 00:00:00 |                 3 |
| ERNSH       | 1998-04-08 00:00:00 | 1998-04-13 00:00:00 |                 5 |
| FOLKO       | 1998-03-26 00:00:00 | 1998-03-27 00:00:00 |                 1 |
| FOLKO       | 1998-03-27 00:00:00 | 1998-04-01 00:00:00 |                 5 |
| FOLKO       | 1998-04-01 00:00:00 | 1998-04-06 00:00:00 |                 5 |
| FRANK       | 1997-09-16 00:00:00 | 1997-09-19 00:00:00 |                 3 |
| GODOS       | 1998-02-05 00:00:00 | 1998-02-06 00:00:00 |                 1 |
| GREAL       | 1997-07-31 00:00:00 | 1997-07-31 00:00:00 |                 0 |
| HANAR       | 1996-07-08 00:00:00 | 1996-07-10 00:00:00 |                 2 |
| HANAR       | 1998-03-03 00:00:00 | 1998-03-04 00:00:00 |                 1 |
| HILAA       | 1997-03-26 00:00:00 | 1997-03-31 00:00:00 |                 5 |
| HILAA       | 1998-03-18 00:00:00 | 1998-03-19 00:00:00 |                 1 |
| ISLAT       | 1996-09-26 00:00:00 | 1996-10-01 00:00:00 |                 5 |
| ISLAT       | 1996-10-01 00:00:00 | 1996-10-03 00:00:00 |                 2 |
| KOENE       | 1996-10-07 00:00:00 | 1996-10-09 00:00:00 |                 2 |
| KOENE       | 1997-02-25 00:00:00 | 1997-02-25 00:00:00 |                 0 |
| LACOR       | 1998-03-24 00:00:00 | 1998-03-24 00:00:00 |                 0 |
| LEHMS       | 1997-05-12 00:00:00 | 1997-05-14 00:00:00 |                 2 |
| LEHMS       | 1997-07-08 00:00:00 | 1997-07-09 00:00:00 |                 1 |
| LILAS       | 1998-05-01 00:00:00 | 1998-05-05 00:00:00 |                 4 |
| LINOD       | 1998-01-19 00:00:00 | 1998-01-19 00:00:00 |                 0 |
| LONEP       | 1997-09-09 00:00:00 | 1997-09-11 00:00:00 |                 2 |
| MAISD       | 1998-02-17 00:00:00 | 1998-02-19 00:00:00 |                 2 |
| MEREP       | 1997-08-01 00:00:00 | 1997-08-04 00:00:00 |                 3 |
| QUEEN       | 1998-02-26 00:00:00 | 1998-02-27 00:00:00 |                 1 |
| QUICK       | 1996-08-20 00:00:00 | 1996-08-21 00:00:00 |                 1 |
| QUICK       | 1997-10-03 00:00:00 | 1997-10-06 00:00:00 |                 3 |
| QUICK       | 1998-04-01 00:00:00 | 1998-04-02 00:00:00 |                 1 |
| RATTC       | 1996-09-25 00:00:00 | 1996-09-27 00:00:00 |                 2 |
| RICSU       | 1997-11-24 00:00:00 | 1997-11-28 00:00:00 |                 4 |
| ROMEY       | 1996-08-14 00:00:00 | 1996-08-15 00:00:00 |                 1 |
| SAVEA       | 1996-12-25 00:00:00 | 1996-12-30 00:00:00 |                 5 |
| SAVEA       | 1997-07-18 00:00:00 | 1997-07-22 00:00:00 |                 4 |
| SAVEA       | 1997-10-21 00:00:00 | 1997-10-22 00:00:00 |                 1 |
| SAVEA       | 1997-10-22 00:00:00 | 1997-10-22 00:00:00 |                 0 |
| SAVEA       | 1998-03-27 00:00:00 | 1998-03-30 00:00:00 |                 3 |
| SAVEA       | 1998-04-17 00:00:00 | 1998-04-17 00:00:00 |                 0 |
| SEVES       | 1997-12-26 00:00:00 | 1997-12-30 00:00:00 |                 4 |
| SUPRD       | 1998-01-20 00:00:00 | 1998-01-22 00:00:00 |                 2 |
| SUPRD       | 1998-04-20 00:00:00 | 1998-04-21 00:00:00 |                 1 |
| TRADH       | 1998-01-13 00:00:00 | 1998-01-15 00:00:00 |                 2 |
| TRADH       | 1998-01-15 00:00:00 | 1998-01-19 00:00:00 |                 4 |
| TRAIH       | 1997-06-19 00:00:00 | 1997-06-23 00:00:00 |                 4 |
| VICTE       | 1997-12-31 00:00:00 | 1998-01-05 00:00:00 |                 5 |
| VICTE       | 1998-01-21 00:00:00 | 1998-01-23 00:00:00 |                 2 |
| VINET       | 1997-11-11 00:00:00 | 1997-11-12 00:00:00 |                 1 |
| WARTH       | 1997-01-13 00:00:00 | 1997-01-16 00:00:00 |                 3 |
| WELLI       | 1997-12-30 00:00:00 | 1998-01-01 00:00:00 |                 2 |
| WELLI       | 1998-02-20 00:00:00 | 1998-02-24 00:00:00 |                 4 |
| WHITC       | 1997-10-06 00:00:00 | 1997-10-08 00:00:00 |                 2 |
| WILMK       | 1998-02-06 00:00:00 | 1998-02-10 00:00:00 |                 4 |
+-------------+---------------------+---------------------+-------------------+
69 rows in set (0.01 sec)