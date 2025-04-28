create database sql_projects;

use sql_projects;
DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);


select * from retail_sales ;

select count(distinct customer_id) from retail_sales;

-- Data Cleaning
delete from retail_sales
where 
transactions_id is null
or 
sale_date is null
or 
sale_time is null
or 
customer_id is null
or 
gender is null
or 
category is null
or 
quantity is null
or 
price_per_unit is null
or 
cogs is null
or 
total_sale is null

;



-- Data Exploration

-- How many Sales we have
select count(*) from retail_sales;

-- How many Unique customer we have
select count(distinct customer_id) from retail_sales;

-- How many categories we have
select count(distinct category) from retail_sales;

-- Data Analysis & Business Key Problems

-- Write a SQL query to retrieve all columns for sales made on '2022-11-05:
select * from retail_sales 
where sale_date = '2022-11-05';

-- Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:

select * from retail_sales
where category = 'Clothing'
and quantity >= 4 
and year(sale_date) = '2022'
and month(sale_date) = '11';


-- Write a SQL query to calculate the total sales (total_sale) for each category.:
select category, sum(total_sale) as total_sale, count(*) as order_count from retail_sales
group by category;

-- Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
select round(avg(age),2) from retail_sales
where category ='Beauty';

-- Write a SQL query to find all transactions where the total_sale is greater than 1000
select * from retail_sales
where total_sale > 1000;

-- Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select gender,category, count(transactions_id) from retail_sales
group by gender, category
order by category;

-- Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
with cte as (select month(sale_date) as sale_month, year(sale_date) as sale_year, avg(total_sale) as avg_sale,
rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rnk  from retail_sales
group by sale_year, sale_month
order by avg_sale desc
)

select sale_month, sale_year, avg_sale from cte
where rnk = 1;


-- **Write a SQL query to find the top 5 customers based on the highest total sales **:
select customer_id, sum(total_sale) as total_sales from retail_sales
group by customer_id
order by total_sales desc
limit 5
;

-- Write a SQL query to find the number of unique customers who purchased items from each category.:
select category,count(distinct customer_id) as unique_customers from retail_sales
group by category;


-- Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17
select 
case
when hour(sale_time) < 12 then 'Morning'
when hour(sale_time) between 12 and 17 then 'Afternoon' 
else 'Evening' end as Sale_times, count(*)
 from retail_sales
 group by Sale_times
 
;
