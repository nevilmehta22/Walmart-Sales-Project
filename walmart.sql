DROP TABLE IF EXISTS walmart;

-- Create Table called "walmart"
CREATE TABLE walmart(
	invoice_id VARCHAR(15) PRIMARY KEY,
	branch VARCHAR(2),
	city VARCHAR(15),	
	customer_type VARCHAR(10),
	gender VARCHAR(10),
	product_line VARCHAR(25),	
	unit_price FLOAT,	
	quantity INT,	
	tax_5percent FLOAT,
	purchase_total FLOAT,	
	purchase_date DATE,	 
	purchase_time TIME,	
	payment VARCHAR(15),
	cogs FLOAT,	
	gross_margin_percentage	FLOAT,
	gross_income FLOAT,
	rating FLOAT
);

-- Import Data and then check

SELECT * FROM walmart;

-- Check for total no.of rows present

SELECT COUNT(*) FROM walmart;

-- Check for Null values if present

SELECT * FROM walmart
WHERE 
	    invoice_id	IS NULL
	    OR
		branch IS NULL
	    OR	
		city IS NULL
	    OR	
		customer_type IS NULL
	    OR	
		gender IS NULL
	    OR	
		product_line IS NULL
	    OR	
		unit_price IS NULL
	    OR	
		quantity IS NULL
	    OR	
		tax_5percent IS NULL
	    OR	
		purchase_total IS NULL
	    OR	
		purchase_date IS NULL
	    OR	
		purchase_time IS NULL
	    OR	
		payment IS NULL
	    OR	
		cogs IS NULL
	    OR	
		gross_margin_percentage IS NULL
	    OR
		gross_income IS NULL
	    OR	
		rating IS NULL;

---------------------------------------------------------- Exploring the Data----------------------------------------------------------------------------------------------------------------------------------------------

-- Total Sales
SELECT COUNT(*) AS total_sales FROM walmart;

-- Exploring Branches
SELECT COUNT(DISTINCT(branch)) AS total_branches FROM walmart;
SELECT DISTINCT(branch) AS branches FROM walmart;

-- Exploring Cities
SELECT COUNT(DISTINCT(city)) AS total_cities FROM walmart;
SELECT DISTINCT(city) AS cities FROM walmart;

-- Exploring Customer
SELECT COUNT(DISTINCT(customer_type)) AS total_customers FROM walmart;
SELECT DISTINCT(customer_type) AS customers FROM walmart;

-- Exploring Gender
SELECT COUNT(DISTINCT(gender)) AS total_genders FROM walmart;
SELECT DISTINCT(gender) AS genders FROM walmart;

-- Exploring Product_Lines
SELECT COUNT(DISTINCT(product_line)) AS total_product_lines FROM walmart;
SELECT DISTINCT(product_line) AS product_lines FROM walmart;

-- Exploring unit_price
CREATE VIEW unit_price_summary AS
SELECT 
    MIN(unit_price) AS min_unit_price,
    MAX(unit_price) AS max_unit_price,
    AVG(unit_price) AS avg_unit_price
FROM walmart;

SELECT * FROM unit_price_summary;

-- Exploring Quantity
CREATE VIEW quantity_summary AS
SELECT 
    MIN(quantity) AS min_quantity,
    MAX(quantity) AS max_quantity
FROM walmart;

SELECT * FROM quantity_summary;

-- Exploring purchase_date
CREATE VIEW date_summary AS
SELECT 
    MIN(purchase_date) AS start_date,
    MAX(purchase_date) AS end_date
FROM walmart;

SELECT * FROM date_summary;

-- Exploring purchase_time
CREATE VIEW time_summary AS
SELECT 
    MIN(purchase_time) AS start_time,
    MAX(purchase_time) AS end_time
FROM walmart;

SELECT * FROM time_summary;

-- Exploring Payment_modes
SELECT COUNT(DISTINCT(payment)) AS total_payment_modes FROM walmart;
SELECT DISTINCT(payment) AS payment_modes FROM walmart;

-- Exploring purchase_total
CREATE VIEW purchase_total_summary AS
SELECT 
    MIN(purchase_total) AS min_purchase,
    MAX(purchase_total) AS max_purchase,
	AVG(purchase_total) AS avg_purchase_total
FROM walmart;

SELECT * FROM purchase_total_summary

-- Exploring cogs
CREATE VIEW cogs_summary AS
SELECT 
    MIN(cogs) AS min_cogs,
    MAX(cogs) AS max_cogs,
	AVG(cogs) AS avg_cogs
FROM walmart;

SELECT * FROM cogs_summary

-- Exploring gross_income
CREATE VIEW income_summary AS
SELECT 
    MIN(gross_income) AS min_income,
    MAX(gross_income) AS max_income,
	AVG(gross_income) AS avg_income
FROM walmart;

SELECT * FROM income_summary

-- Exploring rating_summary
CREATE VIEW rating_summary AS
SELECT 
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
	AVG(rating) AS avg_rating
FROM walmart;

SELECT * FROM rating_summary

------------------------------------------------- Internship Questions--------------------------------------------------------------------

-- 1.  Retrieve all columns for sales made in a specific branch (e.g., Branch 'A').

SELECT * FROM walmart
WHERE branch = 'A'

-- 2. Find the total sales for each product line.

SELECT product_line, 
       round(SUM(purchase_total::numeric),2) as total_sales
FROM walmart
GROUP BY product_line

-- 3. List all sales transactions where the payment method was 'Cash'.

SELECT * 
FROM walmart
WHERE payment = 'Cash'

-- 4.  Calculate the total gross income generated in each city. 

SELECT city, 
       round(SUM(gross_income::numeric),2)
FROM walmart
GROUP BY city

-- 5. Find the average rating given by customers in each branch. 

SELECT branch, 
       round(AVG(rating::numeric),2)
FROM walmart
GROUP BY branch

-- 6. Determine the total quantity of each product line sold.

SELECT product_line, 
       SUM(quantity)
FROM walmart
GROUP BY product_line

-- 7. List the top 5 products by unit price. 

SELECT product_line, unit_price
FROM walmart
ORDER BY unit_price DESC limit 5;

-- 8. Find sales transactions with a gross income greater than 30.

SELECT * 
FROM walmart
WHERE gross_income > 30

-- 9.  Retrieve sales transactions that occurred on weekends.
	
SELECT * , TO_CHAR(purchase_date, 'FMDay') AS weekday_name
FROM walmart
WHERE  TRIM(TO_CHAR(purchase_date, 'Day')) = 'Saturday' 
	  OR TRIM(TO_CHAR(purchase_date, 'Day')) = 'Sunday';

-- 10.  Calculate the total sales and gross income for each month. 

SELECT EXTRACT(MONTH FROM purchase_date) as Month, 
       ROUND(SUM(purchase_total::numeric),2) as total_sales,
	   ROUND(SUM(gross_income::numeric), 2) as gross_income
FROM walmart
GROUP BY 1
ORDER BY 1
	
-- 11.  Find the number of sales transactions that occurred after 6 PM.

SELECT * 
FROM walmart
WHERE  (EXTRACT(HOUR FROM purchase_time)*60+EXTRACT(MINUTE FROM purchase_time)) > 1080;

-- 12.  List the sales transactions that have a higher total than the average total of all transactions.

SELECT * 
FROM walmart
WHERE purchase_total > (SELECT 
	                    AVG(purchase_total) AS avg_purchase_total
                        FROM walmart)

-- 13. Calculate the cumulative gross income for each branch by date. 

SELECT branch,
       purchase_date,
       gross_income,
       ROUND(SUM(gross_income) OVER (PARTITION BY branch ORDER BY purchase_date, gross_income)::numeric, 2) AS cumulative_income
FROM walmart
ORDER BY branch, purchase_date;
    	
-- 14. Find the total cogs for each customer type in each city.

SELECT city, 
       customer_type,
       ROUND(SUM(cogs::numeric), 2) as total_cogs
FROM walmart
GROUP BY 1, 2
ORDER BY 1, 2