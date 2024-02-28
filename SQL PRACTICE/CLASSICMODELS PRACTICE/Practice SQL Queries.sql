-- Find the customers details who are from USA.
SELECT * from customers
WHERE country="USA";

-- Find the customers whose postal code is missing.
SELECT * from customers
WHERE postalCode is NULL;

-- Find the customers whose postal code and state are missing
SELECT * from customers
WHERE postalCode is NULL and state is NULL;

-- Find customers who don’t have any credit limit
SELECT * from customers
where creditLimit=0;

-- Find customers who are from one of the countries USA, France, Norway.
SELECT * from customers
where country in("USA", "Norway", "France");

-- Find all the customers whose customernumber is from 100 to 150.
SELECT * from customers
where customerNumber between 100 and 150;

-- Find all the customer details who has the highest credit limit.
SELECT * from customers
order by creditLimit desc
limit 1;

-- Find the customers details whose name start with A
SELECT * from customers
where customerName like "A%";

-- Find count of customers whose name end with ‘.’
select count(customerName) from customers
where customerName like "%.";

--  Find highest, lowest, average and sum of creditlimit.
select max(creditlimit) as Highest_Creditlimit, min(creditlimit) as Lowest_Creditlimit, avg(creditlimit) as average_Creditlimit,
sum(creditLimit) as Sum
from customers;

-- Find customers who have placed at least 1 order
select * from customers;
select * from orders;
select * from orderdetails;
select * from employees;
 
 SELECT * from customers
 where customerNumber in (select customerNumber from orders);
 
 
 --  Find customers who have not ordered anything
  SELECT * from customers
 where customerNumber not in (select customerNumber from orders);
 
 -- Find the no. of orders from each country
 SELECT count(distinct o.orderNumber), c.country from customers c
 left join orders o
 on c.customerNumber= o.customerNumber
 group by country;
 
 -- find the details of top 5 customers who have placed more no of orders
 select * from customers c
 inner join
( select count(orderNumber) cnt , customerNumber from orders
 group by customerNumber
 order by cnt desc
 limit 5) x
 on c.customerNumber=x.customerNumber;

-- Find out which employee is responsible for the most no of orders
 Select * from employees e 
inner join 
(
select xy.salesrepemployeenumber, count(xy.ordernumber) from 
(
 select c.salesrepemployeenumber, o.orderNumber from orders o
 left join customers c
on o.customerNumber = c.customerNumber
) xy 
) ABC
on e.employeenumber = abc.salesrepemployeenumber
;

-- Find out which customer has placed the most valuable order.

select x.value1,c.customerNumber, c.customerName  from customers c inner join
(select (od.quantityOrdered*od.priceEach) value1 , o.customerNumber from orders o
left join orderdetails od 
on o.orderNumber = od.orderNumber
order by value1 desc
limit 1) x
on c.customerNumber=x.customerNumber;

-- or --

select * from customers where customerNumber=
(Select customerNumber from 
(select (od.quantityOrdered*od.priceEach) value1 , o.customerNumber from orders o
left join orderdetails od 
on o.orderNumber = od.orderNumber
order by value1 desc
limit 1) xy);


-- Find the top 5 most valuable orders and the customer details who placed the order
select x.value1,c.*  from customers c inner join
(select (od.quantityOrdered*od.priceEach) value1 , o.customerNumber from orders o
left join orderdetails od 
on o.orderNumber = od.orderNumber
order by value1 desc
limit 5) x
on c.customerNumber=x.customerNumber;

-- Rank the performance of employees based on the number of orders
select xy.salesrepemployeenumber, dense_rank() over (order by xy.cnt desc) from
(select  c.salesRepEmployeeNumber, count(o.orderNumber) cnt from customers c
left join orders o
on c.customerNumber=o.customerNumber
group by c.salesrepemployeenumber) xy;

--  Calculate the orders distribution by month and by year.
select month(orderdate) m, year(orderdate) y, count(orderNumber) cnt from orders 
group by m,y ;

-- Find the no. of days taken to ship each order. And find the average shipping days
select ordernumber, datediff(shippeddate,orderdate) from orders ;
select avg(datediff(shippeddate,orderdate)) from orders;

-- Find the customer details who have placed an order and then cancelled it.
select * from customers c inner join
(select customerNumber from orders
where status= "cancelled") v
on c.customernumber=v.customernumber ;

-- . Calculate Orders distribution by product category
select p.productLine, count(distinct od.orderNumber) cnt  from orderdetails od
left join products p
on od.productCode= p.productCode 
group by productLine
order by cnt desc;









