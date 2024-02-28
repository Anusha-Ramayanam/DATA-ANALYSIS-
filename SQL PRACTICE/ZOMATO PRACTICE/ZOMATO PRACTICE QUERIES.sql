drop table if exists goldusers_signup;
CREATE TABLE goldusers_signup(userid integer,gold_signup_date date); 

INSERT INTO goldusers_signup(userid,gold_signup_date) 
 VALUES (1,'09-22-2017'),
(3,'04-21-2017');

drop table if exists users;
CREATE TABLE users(userid integer,signup_date date); 

INSERT INTO users(userid,signup_date) 
 VALUES (1,'09-02-2014'),
(2,'01-15-2015'),
(3,'04-11-2014');

drop table if exists sales;
CREATE TABLE sales(userid integer,created_date date,product_id integer); 

INSERT INTO sales(userid,created_date,product_id) 
 VALUES (1,'04-19-2017',2),
(3,'12-18-2019',1),
(2,'07-20-2020',3),
(1,'10-23-2019',2),
(1,'03-19-2018',3),
(3,'12-20-2016',2),
(1,'11-09-2016',1),
(1,'05-20-2016',3),
(2,'09-24-2017',1),
(1,'03-11-2017',2),
(1,'03-11-2016',1),
(3,'11-10-2016',1),
(3,'12-07-2017',2),
(3,'12-15-2016',2),
(2,'11-08-2017',2),
(2,'09-10-2018',3);


drop table if exists product;
CREATE TABLE product(product_id integer,product_name text,price integer); 

INSERT INTO product(product_id,product_name,price) 
 VALUES
(1,'p1',980),
(2,'p2',870),
(3,'p3',330);

select * from sales;
select * from product;
select * from goldusers_signup;
select * from users;

-- WHAT IS THE TOTAL AMOUNT EACH CUSTOMER SPENT ON ZOMATO
SELECT a.userid,SUM(b.price)Total_Amount FROM sales a
INNER JOIN product b
ON a.product_id=b.product_id
GROUP BY a.userid;

--HOW MANY DAYS EACH CUSTOMER VISITED ZOMATO
SELECT userid,COUNT(DISTINCT created_date)Number_of_Days
FROM sales
GROUP BY userid;

-- WHAT WAS THE FIRST PRODUCT NAME PURCHASED BY EACH CUSTOMER
SELECT d.userid,d.product_name FROM
(SELECT c.*,
RANK()OVER(PARTITION BY userid ORDER BY created_date) Rnk
FROM
(SELECT a.*,b.product_name FROM sales a
INNER JOIN product b
ON a.product_id=b.product_id)c)d
WHERE Rnk=1;

-- WHAT IS THE MOST PURCHASED ITEM ON THE MENU AND HOW MANY TIMES IT WAS PURCHASED BY ALL CUSTOMERS
SELECT userid,COUNT(product_id)Cnt FROM sales 
WHERE product_id=
(SELECT TOP 1 product_id FROM sales
GROUP BY product_id
ORDER BY COUNT(product_id) DESC)
GROUP BY userid;

-- WHICH ITEM WAS THE MOST POPULAR FOR EACH CUSTOMER
SELECT b.userid,b.product_id,b.Cnt FROM
(SELECT *, RANK()OVER(PARTITION BY userid ORDER BY Cnt DESC)Rnk FROM
(SELECT userid,product_id,COUNT(product_id) Cnt FROM sales
GROUP BY userid,product_id)a)b
WHERE Rnk=1

-- WHICH ITEM WAS FIRST PURCHASED BY THE CUSTOMER AFTER BECOMING GOLD MEMBER
SELECT d.userid,d.product_id FROM
(SELECT c.*, RANK()OVER(PARTITION BY userid ORDER BY created_date)Rnk FROM
(SELECT a.userid,a.product_id,a.created_date,b.gold_signup_date FROM sales a
INNER JOIN goldusers_signup b
ON a.userid=b.userid and created_date>=gold_signup_date)c)d
WHERE Rnk=1

-- WHICH ITEM WAS PURCHASED BY THE CUSTOMER JUST BEFORE BECOMING GOLD MEMBER
SELECT d.userid,d.product_id FROM
(SELECT c.*, RANK()OVER(PARTITION BY userid ORDER BY created_date DESC)Rnk FROM
(SELECT a.userid,a.product_id,a.created_date,b.gold_signup_date FROM sales a
INNER JOIN goldusers_signup b
ON a.userid=b.userid and created_date<gold_signup_date)c)d
WHERE Rnk=1

-- WHAT ARE TOTAL ORDERS AND AMOUNT SPENT BY EACH CUSTOMER BEFORE THEY BECOME A GOLD MEMBER
SELECT e.userid, COUNT(e.product_id)Total_orders, SUM(e.price)Amount_Spent FROM
(SELECT c.*,d.price FROM
(SELECT a.userid,a.product_id,a.created_date,b.gold_signup_date FROM sales a
INNER JOIN goldusers_signup b
ON a.userid=b.userid and created_date<gold_signup_date)c
INNER JOIN product d
ON c.product_id=d.product_id)e
GROUP BY e.userid;

/*IF BUYING EACH PRODUCT GENERATES POINTS FOR EG: 5RS=1ZOMATO POINT AND EACH PRODUCT HAS DIFFERENT PURCHASING POINTS
FOR P1 5RS=1 ZOMATO POINT
P2 10RS=5 ZOMATO POINTS
P3 5RS=1 ZOMATO POINT*/

-- CALCULATE POINTS COLLECTED BY EACH CUSTOMERS AND FOR WHICH PRODUCT MOST POINTS HAVE BEEN GIVEN TILL NOW

SELECT e.userid, SUM(e.Zomato_Points)*2.5 Total_amount FROM
(SELECT d.*, price/Points_Ref Zomato_Points FROM
(SELECT c.*, CASE WHEN product_id=1 THEN 5 
                 WHEN product_id=2 THEN 2
				 WHEN product_id=3 THEN 5
				 ELSE 0
		    END Points_Ref FROM
(SELECT a.*,b.price FROM sales a
INNER JOIN product b
ON a.product_id=b.product_id)c)d)e
GROUP BY userid;

SELECT * FROM
(SELECT e.*, RANK()OVER(ORDER BY Zomato_points DESC)Rnk FROM
(SELECT d.product_id, SUM(Amount/Points_Ref) Zomato_points FROM
(SELECT c.userid,c.product_id,SUM(price) Amount,CASE WHEN product_id=1 THEN 5 
                                  WHEN product_id=2 THEN 2
				                  WHEN product_id=3 THEN 5
				                  ELSE 0
		                          END Points_Ref FROM
(SELECT a.*,b.price FROM sales a
INNER JOIN product b
ON a.product_id=b.product_id)c
GROUP BY userid,product_id)d
GROUP BY product_id)e)f
WHERE Rnk=1;

/* IN THE FIRST YEAR AFTER A CUSTOMER JOIN THE GOLD MEMBERSHIP INCLUDING JOINING DATE IRRESPECTIVE OF
WHAT CUSTOMER HAS PURCHASED THEY EARN 5 ZOMATO POINTS FOR EVERY 10RS SPENT*/

-- WHICH CUSTOMER EARNED MORE POINTS AND HOW MANY POINTS WERE EARNED DURING FIRST YEAR
/*1ZP=2rs
0.5ZP=1rs*/
SELECT * FROM
(SELECT *, RANK()OVER(ORDER BY Zomato_Points DESC) Rnk FROM
(SELECT c.*,d.price*0.5 Zomato_Points FROM
(SELECT a.userid,a.product_id,a.created_date,b.gold_signup_date FROM sales a
INNER JOIN goldusers_signup b
ON a.userid=b.userid and created_date>=gold_signup_date AND created_date<=DATEADD(YEAR,1,gold_signup_date))c
INNER JOIN product d
ON c.product_id=d.product_id)e)f
WHERE Rnk=1

-- RANK ALL THE TRANSACTIONS OF THE CUSTOMERS
SELECT *,RANK()OVER(PARTITION BY userid ORDER BY created_date)Rnk FROM sales;

-- RANK ALL THE TRANSACTIONS OF EACH MEMBER WHENEVER THEY ARE A GOLD MEMBER AND MARK EVERY NON-GOLD TRANSACTION AS NA
SELECT d.userid,d.product_id,d.created_date,d.gold_signup_date,
            CASE WHEN Rnk=0 THEN 'NA' 
            ELSE Rnk 
			END Rnkk FROM
(SELECT c.*, CAST((CASE WHEN gold_signup_date IS NULL THEN 0
             ELSE RANK()OVER(PARTITION BY userid ORDER BY created_date DESC)
			 END) AS VARCHAR) Rnk
			 FROM
(SELECT a.userid,a.product_id,a.created_date,b.gold_signup_date FROM sales a
LEFT JOIN goldusers_signup b
ON a.userid=b.userid and created_date>=gold_signup_date)c)d;
