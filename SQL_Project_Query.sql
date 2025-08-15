-- SQL_Retail_Sales_Analysis_Project
create database if not exists sql_project_p1;
select * from retail_data;
select * from retail_data limit 10;
select count(*) from retail_data;
ALTER TABLE retail_data
RENAME COLUMN ï»¿transactions_id TO transactions_id;
select * from retail_data;
SELECT *
FROM retail_data
WHERE transactions_id IS NULL
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null 
or
 gender is null
or 
age is null
or 
category is null
or 
quantiy is null
or
 price_per_unit is null
or
 cogs is null
or
 total_sale is null
 ;
-- Data Exploration

-- How many sales we have ?
select count(*) from retail_data;

-- How many uniuque customer we have ?
select count(distinct customer_id) as 'tot_cust' from retail_data; 

-- How many category are there ?
select distinct category from retail_data;

-- Data Analysis & Business Key Problem & Answer
-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select * from retail_data where sale_date = '2022-11-05';

/* Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and 
the quantity sold is more than 4 in the month of Nov-2022 */

select * from retail_data where category = 'Clothing' and 
					DATE_FORMAT(sale_date,'%Y-%m') = '2022-11' and 
                    quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category,sum(total_sale) as net_sale,count(*) as total_orders from retail_data group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age)) as AVG_age from retail_data where category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_data where total_sale > 1000 ;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select category, gender ,count(*) as total_transactions from retail_data group by category, gender order by category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
with cte as
(
select year(sale_date) as Yr ,month(sale_date) as Mn ,avg(total_sale) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rnk
from retail_data group by Yr,Mn
) 
select * from cte where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select distinct customer_id,sum(total_sale) as tot_sale from retail_data group by customer_id order by tot_sale desc limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select category , count(distinct customer_id) as unique_customers from retail_data group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select * from retail_data;
WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN HOUR(sale_time) < 12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_data
)
SELECT 
    shift,
    COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY shift;

-- End of Project