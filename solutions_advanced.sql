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
