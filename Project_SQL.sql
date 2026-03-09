-- SQL RETAIL SALES ANALYSIS
CREATE DATABASE SQLPROJECT;
USE SQLPROJECT;

DROP TABLE IF EXISTS Retail_sales;
CREATE TABLE Retail_sales (
	transactions_id	INT PRIMARY KEY, 
    sale_date DATE,
    sale_time TIME,	
    customer_id	INT,
    gender VARCHAR(10),
    age	INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,	
    total_sale FLOAT
)
SELECT * FROM Retail_sales;

SELECT COUNT(*) FROM Retail_sales;

-- Identify all the NULL Vales from the Table and Delete them (Data Cleaning)
DELETE FROM Retail_sales
WHERE 
	transactions_id IS NULL
    OR
	sale_date IS NULL
    OR
    sale_time IS NULL
    OR
    customer_id	IS NULL
    OR
    gender IS NULL
    OR
    age	IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(transactions_id) AS total_sales FROM Retail_sales;

-- How many Unique Customers are there?
SELECT COUNT(DISTINCT customer_id) AS Unique_customers FROM Retail_sales;

-- Define types of category
SELECT DISTINCT category FROM Retail_sales;


-- DATA ANALYSIS ( BUSINESS KEY PROBLERMS)

-- Q. Retrieve all col for sales made on '2022-11-05'
SELECT * FROM Retail_sales
WHERE sale_date = '2022-11-05';

-- Q.Retrieve all transactions where category is 'Clothing' and Quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM Retail_sales
WHERE category = 'Clothing' AND 
quantity >= 4 AND
sale_date BETWEEN '2022-11-01' AND '2022-11-30' ;

-- Q. Calculate the total sales for each category
SELECT category,SUM(total_sale) AS total_sales
FROM Retail_sales
GROUP BY category;

-- Q. Find Average age of customers who purchased item from 'Beauty' Category
SELECT ROUND(AVG(age),2) AS Avg_age FROM Retail_sales
WHERE category = 'Beauty';

-- Q. Find all transactions where total sales is greater than 1000
SELECT * FROM Retail_sales 
WHERE total_sale >1000;

-- Q. Find total number of transactions made by each gender in each category 
SELECT COUNT(transactions_id),gender,category FROM Retail_sales
GROUP BY gender,category
ORDER BY category;

-- Q. Calculate avg sales in each month . Fint out best selling month in each year 
SELECT * FROM
    (SELECT 
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		ROUND(AVG(total_sale),2) AS Avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY  ROUND(AVG(total_sale),2) DESC ) AS Ranking
	FROM Retail_sales
	GROUP BY 1,2) AS t1
WHERE Ranking = 1;

-- Find TOP 5 customers based on the Highest total Sales 
SELECT customer_id,SUM(total_sale) FROM Retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC
LIMIT 5;

-- Find Number of unique customers who purchased items from each category
SELECT COUNT(DISTINCT customer_id), category FROM Retail_sales
GROUP BY category ;

-- Create each shift and Number of orders (ex. Morning <= 12, Afternoon 13-17 , and Evening >17)
WITH hourly_shift 
AS 
(
SELECT 
	CASE 
    WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning Shift'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon Shift'
    ELSE 'Evening Shift'
    END AS shift 
FROM Retail_sales
) 
SELECT shift , COUNT(*) AS Total_orders
FROM hourly_shift
GROUP BY shift;

-- END