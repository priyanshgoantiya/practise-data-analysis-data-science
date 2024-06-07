
-- 1. head -> tail -> sample

select * from laptopdata
order by price
limit 5;

select * from laptopdata
order by price desc
limit 5;

select * from laptopdata
order by rand()
limit 5;

-- 2. for numerical cols
-- - 8 number summary[count,min,max,mean,std,q1,q2,q3]

SELECT COUNT(price) AS count,
    MIN(price) AS min_price,
    MAX(price) AS max_price,
    AVG(price) AS avg_price,
    STD(price) AS std_price
from  laptopdata;

SELECT 	
    MIN(CASE WHEN ntile_group = 2 THEN `price` END) AS q1,
    MIN(CASE WHEN ntile_group = 3 THEN `price` END) AS median,
    MIN(CASE WHEN ntile_group = 4 THEN `price` END) AS q3
FROM
    (SELECT `price`,
            NTILE(4) OVER (ORDER BY `price`) AS ntile_group
     FROM `laptopdata`) AS subquery;


-- - missing values

select * from laptopdata
where price is null;
-- - outliers
with outliers as( select 
                        min(case when ntile_group = 2 then price end) as q1,
						min(case when ntile_group = 4 then price end) as q3
                        from ( select * , ntile(4) over(order by price ) as ntile_group from laptopdata) as subquery)

select id.*
from laptopdata as id
join (  select q1 -(1.5*(q3-q1))  as lower_limit, q3 +(1.5*(q3-q1))  as upper_limit
from outliers ) as outlier_limit 
on id.price  between outlier_limit.lower_limit and  outlier_limit.upper_limit;

-- →> horizontal/vertical histograms
select t.buckets,repeat('$',count(*)/5) from (SELECT price,
    CASE
    WHEN price BETWEEN 0 AND 25000 then '0-25k'
    WHEN price BETWEEN 25000 AND 50000 THEN '25-50k'
    WHEN price BETWEEN 50000 AND 75000 THEN '50-75k'
    WHEN price BETWEEN 75000 AND 100000 THEN  '75-100k'
    WHEN price BETWEEN 100000 AND 150000 THEN  '100-150k'
    WHEN price BETWEEN 150000 AND 200000 THEN  '150-200k'
     WHEN price BETWEEN 200000 AND 250000 THEN  '200-250k'
    WHEN price BETWEEN 250000 AND 300000 THEN '250-300k'
    WHEN price BETWEEN 300000 AND 350000 then  '300-350k'
    WHEN price > 350000 then '>350' end as 'buckets'
FROM laptopdata) as t
group by t.buckets;


SELECT
    REPEAT('*', SUM(CASE WHEN price BETWEEN 0 AND 25000 THEN 1 ELSE 0 END)/10) AS '0-25k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 25000 AND 50000 THEN 1 ELSE 0 END)/10) AS '25-50k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 50000 AND 75000 THEN 1 ELSE 0 END)) AS '50-75k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 75000 AND 100000 THEN 1 ELSE 0 END)) AS '75-100k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 100000 AND 150000 THEN 1 ELSE 0 END)) AS '100-150k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 150000 AND 200000 THEN 1 ELSE 0 END)) AS '150-200k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 200000 AND 250000 THEN 1 ELSE 0 END)) AS '200-250k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 250000 AND 300000 THEN 1 ELSE 0 END)) AS '250-300k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 300000 AND 350000 THEN 1 ELSE 0 END)) AS '300-350k',
    REPEAT('*', SUM(CASE WHEN price BETWEEN 350000 AND 400000 THEN 1 ELSE 0 END)) AS '350-400k'
FROM laptopdata;


-- 3. for categorical cols
-- -value counts -> pie chart
select OpSys,count(OpSys)
from laptopdata
group by OpSys;

select Company,count(Company)
from laptopdata
group by Company;

select TypeName,count(TypeName)
from laptopdata
group by TypeName;

select Weight,count(Weight)
from laptopdata
group by Weight;

SELECT touchscreen, COUNT(*) AS `count` 
FROM laptopdata
GROUP BY touchscreen;




-- 4. numerical - numerical
-- - side by side 8 number analysis--
-- - scatterplot
-- - correlation
select cpu_speed,price
from laptopdata;

SELECT
    (COUNT(*) * SUM(Ram * Price) - SUM(Ram) * SUM(Price)) /
    (SQRT((COUNT(*) * SUM(Ram * Ram) - SUM(Ram) * SUM(Ram)) *
          (COUNT(*) * SUM(Price * Price) - SUM(Price) * SUM(Price))))
    AS correlation_coefficient
FROM laptopdata;


SELECT
    (COUNT(*) * SUM(cpu_speed* Price) - SUM(cpu_speed) * SUM(Price)) /
    (SQRT((COUNT(*) * SUM(cpu_speed* cpu_speed) - SUM(cpu_speed) * SUM(cpu_speed)) *
          (COUNT(*) * SUM(Price * Price) - SUM(Price) * SUM(Price))))
    AS correlation_coefficient
FROM laptopdata;

-- 5. categorical-categorical
-- - contigency table -> stacked bar chart
select company, sum(case when  touchscreen=1 then 1 else 0 end ) as 'yes_touchscreen',
sum(case when  touchscreen=0 then 1 else 0 end ) as 'yes_touchscreen'
from laptopdata
group by company;

select distinct cpu_brand
from laptopdata;

select company, sum(case when cpu_brand ='intel' then 1 else 0 end ) as 'intel',
sum(case when  cpu_brand='AMD' then 1 else 0 end ) as 'AMD',
sum(case when  cpu_brand='samsung' then 1 else 0 end ) as 'samgung'
from laptopdata
group by company;
-- 6. numerical-categorical
select company ,min(price),max(price) ,avg(price) , std(price)
from laptopdata
group by company;

-- -missing value
CREATE TEMPORARY TABLE temp_laptopdata AS
SELECT *,
       ROW_NUMBER() OVER () AS rn
FROM laptopdata;
update laptopdata
set price = null
where (Company, TypeName) IN (
    SELECT Company, TypeName
    FROM temp_laptopdata
    WHERE rn <= 10
);
select * from laptopdata
where price is null;
-- fill misssing values
update laptopdata as a
join (select company,avg(price) as pr from laptopdata
where price is not null
group by company ) as b
on a.company=b.company
set a.price=b.pr
where price is null;



select count(*)from laptopdata
where price is null;



select * from laptopdata;
-- 9. feature engineering
-- - ppi
alter table laptopdata
add column ppi int;

update laptopdata
set ppi=  sqrt(power(resolution_width,2) + power(resolution_height,2)) / Inches;

select * from laptopdata;

SELECT 
    COUNT(ppi) AS count,
    MIN(ppi) AS min_ppi,
    MAX(ppi) AS max_ppi,
    AVG(ppi) AS avg_ppi,
    STD(ppi) AS std_ppi
FROM 
    laptopdata;
SELECT 
    MIN(CASE WHEN ntile_group = 2 THEN `ppi` END) AS q1,
    MIN(CASE WHEN ntile_group = 3 THEN `ppi` END) AS median,
    MIN(CASE WHEN ntile_group = 4 THEN `ppi` END) AS q3
FROM
    (SELECT `ppi`,
            NTILE(4) OVER (ORDER BY `ppi`) AS ntile_group
     FROM `laptopdata`) AS subquery;

-- - screen price_bracket
alter table laptopdata
add column screen_size varchar(256) after inches;

select *, case 
               when ntile(3) over(order by inches) =1 then 'small'
               when ntile(3) over(order by inches) =2 then 'medium'
               else 'large' end as 'type'

from laptopdata;

update laptopdata
set screen_size=case 
               when inches <=14.0 then 'small'
               when inches >=14.0 and inches <=17.0 then 'medium'
               else 'large' end ;
select * from laptopdata;

select screen_size,avg(price) 
from laptopdata
group by screen_size
order by avg(price) desc;
-- 10. one hot encoding
select distinct gpu_brand
from laptopdata;
select gpu_brand,
case when gpu_brand='intel' then 1 else 0 end as 'intel',
case when gpu_brand='nvidia' then 1 else 0 end as 'nvidia',
case when gpu_brand='amd' then 1 else 0 end as 'amd',
case when gpu_brand='ARM' then 1 else 0 end as 'ARM'
from laptopdata;

