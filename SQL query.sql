SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE customer_id IS NULL

SELECT * FROM retail_sales
WHERE gender IS NULL

SELECT * FROM retail_sales
WHERE age IS NULL

SELECT * FROM retail_sales
WHERE category IS NULL

SELECT * FROM retail_sales
WHERE quantiy IS NULL

SELECT * FROM retail_sales
WHERE price_per_unit IS NULL

SELECT * FROM retail_sales
WHERE cogs IS NULL

DATA CLEANING

DELETE FROM retail_sales
WHERE
transactions_id IS NULL
OR
sale_date IS NULL
OR
sale_time IS NULL
OR
customer_id IS NULL
OR
gender IS NULL
OR
age IS NULL
OR
category IS NULL
OR
quantiy IS NULL
OR
price_per_unit IS NULL
OR
cogs IS NULL
OR 
total_sale is NULL;

--DATA EXPLORATION

--How many sales we have?
SELECT COUNT(*) as total_sale FROM reatil_sales

-- how many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

SELECT DISTINCT category FROM retail_sales

my analysis and findings
Q1: Retrieve all sales made on '2022-11-05'
Q2: Retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in Nov 2022
Q3: Calculate the total sales (total_sale) for each category
Q4: Find the average age of customers who purchased items from the 'Beauty' category
Q5: Retrieve all transactions where total_sale is greater than 1000
Q6: Find the total number of transactions (transaction_id) made by each gender in each category
Q7: Calculate the average sale for each month and find the best-selling month in each year
Q8: Find the top 5 customers based on the highest total sales
Q9: Find the number of unique customers who purchased items from each category
Q10: Create each shift and count the number of orders (Morning <=12, Afternoon Between 12 & 17, Evening >17)



Retrieve all sales made on '2022-11-05'

SELECT*
FROM retail_sales
WHERE sale_date = '2022-11-05';


Q2: Retrieve all transactions where the category is 'Clothing' and the quantiy sold is more than 10 in Nov 2022

SELECT
    *
FROM retail_sales
WHERE category = 'Clothing'
   AND
     to_char(sale_date,'yyyy-MM')= '2022-11'
	 AND
	 quantiy >= 4
GROUP BY 1


Q3: Calculate the total sales (total_sale) for each category

SELECT 
     category,
     SUM(total_sale) as net_sale,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY 1


Q4: Find the average age of customers who purchased items from the 'Beauty' category


SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


Q5: Retrieve all transactions where total_sale is greater than 1000

SELECT * FROM retail_sales
WHERE total_sale > 1000


Q6: Find the total number of transactions (transaction_id) made by each gender in each category

SELECT 
      category,
	  gender,
	  COUNT(*) as total_trans
FROM retail_sales
GROUP 
BY
category,
	  gender


Q7: Calculate the average sale for each month and find the best-selling month in each year

SELECT
      year,
	  month,
   avg_sale
FROM
(
SELECT 
    EXTRACT(YEAR FROM sale_date)as year,
	EXTRACT(MONTH FROM sale_date)as month,
	AVG(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1

--ORDER BY 1,3 DESC


Q8: Find the top 5 customers based on the highest total sales

SELECT 
    customer_id,
    SUM(total_sale) as total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
	  

Q9: Find the number of unique customers who purchased items from each category

SELECT 
    category,
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category


Q10: Create each shift and count the number of orders (Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT*,
     CASE
	 WHEN EXTRACT (HOUR FROM sale_time) < 12 THEN 'morning'
	 WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
     ELSE 'EVENING'
  END as shift
  FROM retail_sales
  )
  SELECT 
  shift,
  COUNT(*) as total_orders
  FROM hourly_sale
  GROUP BY shift

  END OF PROJECT

  SELECT 