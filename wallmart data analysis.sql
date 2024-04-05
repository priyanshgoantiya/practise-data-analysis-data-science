create database wallmartsalesanalysis;
create table sales(
Invoice_ID	varchar(30) primary key,
Branch varchar(5),
City varchar(20),
Customer_type	varchar(30),
Gender	varchar(20),
Product_line	varchar(100),
Unit_price	decimal(10,2),
Quantity int,
Tax  float(6,4),
Total	decimal(10,2),
Date	date,
Time	timestamp,
Payment	decimal(10,2),
cogs	decimal(10,2),
gross_margin_percentage	float(11,9),
gross_income	decimal(10,2),
Rating 	float(2,1));
drop table sales;


select * from `walmartsalesdata.csv`;

-- ---------------------------------------------------------------------------------------------------------
-- ------------------------- FEATURE ENGGINEERING--------------------------------------------------------
-- time of date 
select 
     Time,
     (case
          when Time between "00:00:00" and "12:00:00" then 'good morning'
          when Time between "12:00:00" and "16:00:00" then 'good afternoon'
          else 'evening'
          end
          ) as time_of_date

 from `walmartsalesdata.csv`;

alter table `walmartsalesdata.csv`
add time_of_date varchar(20);

set sql_safe_updates=0;

update `walmartsalesdata.csv`
set time_of_date =  (case
          when Time between "00:00:00" and "12:00:00" then 'good morning'
          when Time between "12:00:00" and "16:00:00" then 'good afternoon'
          else 'evening'
          end
          );

-- day of each dates

select Date,dayname(Date) as day_name
from `walmartsalesdata.csv`;

alter table `walmartsalesdata.csv`
add day_name varchar(20);

update `walmartsalesdata.csv` 
set day_name = dayname(Date);

-- month of each date 
select Date ,monthname(Date) as month_name
from `walmartsalesdata.csv`;

alter table `walmartsalesdata.csv`
add month_name varchar(20);

update `walmartsalesdata.csv` 
set month_name =monthname(Date);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------
select distinct(Branch)
from `walmartsalesdata.csv`;

select distinct(City) , Branch
from `walmartsalesdata.csv`;

-- ----------------------- products--------------------------------------
ALTER TABLE `walmartsalesdata.csv` CHANGE COLUMN `Product line` Productline VARCHAR(100);

select * from `walmartsalesdata.csv`;
select distinct(Productline)
from `walmartsalesdata.csv`;

select Payment , count(Payment) as cnt 
from `walmartsalesdata.csv`
group by Payment
order by cnt desc;

select Productline , count(Productline) as cnt 
from `walmartsalesdata.csv`
group by Productline
order by cnt desc;


select month_name , sum(Total)
from `walmartsalesdata.csv`
group by month_name;

select month_name , max(cogs) as sum
from `walmartsalesdata.csv`
group by month_name;

select productline , max(Total) as R
from `walmartsalesdata.csv`
group by productline
order by R desc;

select City , max(Total) as r
from `walmartsalesdata.csv`
group by City 
order by r desc;

ALTER TABLE `walmartsalesdata.csv` CHANGE COLUMN `Tax 5%` tax_pct FLOAT(6,4) NOT NULL;
select productline , max(tax_pct) as VAT
from `walmartsalesdata.csv`
group by productline
order by VAT desc;

select * from `walmartsalesdata.csv`;

select Branch , sum(Quantity) as qnt
from `walmartsalesdata.csv`
group by branch
having   qnt > (select avg(quantity) from `walmartsalesdata.csv`)
order by qnt desc;

select Branch , sum(Quantity) as qnt
from `walmartsalesdata.csv`
group by branch;


select Gender , max(productline) as max 
from `walmartsalesdata.csv`
group by Gender 
order by max desc;

select Gender , productline , count(Gender) as max 
from `walmartsalesdata.csv`
group by Gender , productline
order by max desc;

select  productline , avg(Rating) as avg
from `walmartsalesdata.csv`
group by  productline 
order by avg desc;

select * from `walmartsalesdata.csv`;
select Productline , Total
						(case
                        when Total > (select avg(Total) from `walmartsalesdata.csv` as sub)  then 'good'
                        else 'BAD'
                        end ) as sales_ealuation 
                        
from `walmartsalesdata.csv`;


-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------sales------------------------------------------------------------------------------------------
select day_name ,time_of_date,count(Quantity) as cnt
from `walmartsalesdata.csv`
group by day_name ,time_of_date
order by cnt desc;

alter table `walmartsalesdata.csv` change column `Customer type`  Customer_type varchar(20) ;
select Customer_type, sum(Total) as cnt 
from `walmartsalesdata.csv`
group by Customer_type 
order by cnt desc;

select  City ,max(tax_pct/ 0.05 * cogs) 
from `walmartsalesdata.csv`
group by City;

select Customer_type , max(0.05 * cogs)
from `walmartsalesdata.csv`
group by Customer_type;

-- ------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------customer------------------------------------------------------------------------------------------
select distinct(Customer_type) 
from `walmartsalesdata.csv`;

select distinct(Payment) 
from `walmartsalesdata.csv`;

select max(Customer_type)
from `walmartsalesdata.csv`;

select Customer_type , count(*)
from `walmartsalesdata.csv`
group by Customer_type;

select Gender , count(*) max
from`walmartsalesdata.csv`
group by Gender
order by max desc;


select  Branch ,Gender , count(*) as cnt
from`walmartsalesdata.csv`
group by  Gender ,Branch 
order by Branch desc;

select time_of_date , avg(rating) as avg
from `walmartsalesdata.csv`
group by time_of_date
order by avg desc;

select time_of_date , Branch , count(rating) as cnt
from `walmartsalesdata.csv`
group by time_of_date , Branch
order by cnt desc;

select day_name , avg(rating) as R
from `walmartsalesdata.csv`
group by day_name
order by R desc;

select day_name , Branch , avg(rating) as R
from `walmartsalesdata.csv`
group by day_name , Branch 
order by Branch desc;
