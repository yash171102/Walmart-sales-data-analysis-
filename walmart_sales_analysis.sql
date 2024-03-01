/*CREATING DATABASE FOR SALES ANALYSIS */
CREATE DATABASE Walmartsales;
USE Walmartsales;
/*CREATING TABLE UNDER DATABASE*/
CREATE TABLE SALES(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);
INSERT INTO SALES(invoice_id,branch,city,customer_type, gender,product_line,unit_price,quantity,tax_pct,total,date,time,payment,cogs,gross_margin_pct,gross_income,rating)
VALUES(750-67-8428,'A','Yangon','Member','Female','Health and beauty',74.69,7,26.1415,548.9715,'2019-01-05','13:08:00','Ewallet',522.83,4.761904762,26.1415,9.1);
select * from SALES ;
/*IMPORT THE DATA WITH THE HELP OF IMPORT FUNCTION FROM CSV FILE AFETR ADDING ONE ROW */
-- Data cleaning
SELECT
	*
FROM sales;


-- Add the time_of_day column
SELECT
	time,
	(CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END) AS time_of_day
FROM sales;
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
    END
);
-- Add day_name column
SELECT
	date,
	DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);


-- Add month_name column
SELECT
	date,
	MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

/*How many unique cities does the data have?*/
SELECT 
	DISTINCT city
FROM sales;
/* ANSWER = 3*/
/* In which city is each branch?*/
SELECT 
	DISTINCT city,
    branch
FROM sales
ORDER BY BRANCH ASC;
/* ANSWER = A,B,C */
 /*How many unique product lines does the data have?*/
SELECT
	COUNT(DISTINCT(product_line))
FROM sales;
/* ASNWER = 6 */

/* What is the most selling product line*/
SELECT
	SUM(quantity) as qty,
    product_line
FROM sales
GROUP BY product_line
ORDER BY qty DESC;
/* ANSWER = ELECTRONICS ACCESORIES*/
-- What is the total revenue by month
SELECT
	month_name AS month,
	SUM(total) AS total_revenue
FROM sales
GROUP BY month_name 
ORDER BY total_revenue DESC;
-- ANSWER JANUARY WITH HIGHEST REVENUE

-- What month had the largest COGS?
SELECT cogs , month_name  FROM SALES;
SELECT
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name 
ORDER BY cogs DESC;
-- JANUARY WITH LARGEST COGS
-- What product line had the largest revenue?
SELECT product_line,total from sales;
SELECT 
	product_line,
	SUM(total) as total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;
-- ANSWER HIGHEST REVENUE IS FOOD AND BEVERAGES

-- What is the city with the largest revenue?
SELECT
	branch,
	city,
	SUM(total) AS total_revenue
FROM sales
GROUP BY city, branch 
ORDER BY total_revenue DESC;
-- ANSWER HIGHEST REVENUE IS NAYPYITAW
-- What product line had the largest VAT?
SELECT
	product_line,
	AVG(tax_pct) as avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;
-- ANSWER HIGHEST VAT IN HOME AND LIFESTYLE
-- Fetch each product line and add a column to those product 
-- line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	AVG(quantity) AS avg_qnty
FROM sales;

SELECT
	product_line,
	CASE
		WHEN AVG(quantity) > 6 THEN "Good"
        ELSE "Bad"
    END AS remark
FROM sales
GROUP BY product_line;
-- ANSWER EVERY PRODUCT LINE HAS BAD REMARK 

-- SELECT AVG(QUANTITY) FROM SALES 
-- WHERE PRODUCT_LINE= "HEALTH AND BEAUTY"

-- Which branch sold more products than average product sold?
SELECT 
	branch, 
    SUM(quantity) AS qnty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);
-- ANSWER A BRANCH SOLD HIGHEST NUMBER OF PRODUCT
-- What is the most common product line by gender
SELECT
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;
-- ANSWER THE MOST COMMON PRODUCT LINE IS FASHION  AND ACCESORIES FOR FEMALES 

-- What is the average rating of each product line
SELECT
	ROUND(AVG(rating), 2) as avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;
-- ANSWER HIGHEST PRODUCT RATING IS FOR FOOD AND BEVERAGES
-- How many unique customer types does the data have?
SELECT
	DISTINCT customer_type
FROM sales;
-- answer NORMAL AND member type
-- How many unique payment methods does the data have?
SELECT
	DISTINCT payment
FROM sales;
-- ANSWER THREE TYPES

-- What is the most common customer type?
SELECT
	customer_type,
	count(*) as count
FROM sales
GROUP BY customer_type
ORDER BY count DESC;
-- MEMBER
-- Which customer type buys the most?
SELECT
	customer_type,
    COUNT(*)
FROM sales
GROUP BY customer_type;
-- MEMBER

-- What is the gender of most of the customers?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
GROUP BY gender
ORDER BY gender_cnt DESC;
-- MALE
-- What is the gender distribution per branch?
SELECT
	gender,
	COUNT(*) as gender_cnt
FROM sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;
-- Which time of the day do customers give most ratings?
SELECT
	time_of_day,
	AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;
-- ANSWER AFTERNOON
-- Number of sales made in each time of the day per weekday 
SELECT
	time_of_day,
	COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday"
GROUP BY time_of_day 
ORDER BY total_sales DESC;
-- ANSWER EVENING
-- Evenings experience most sales, the stores are 
-- filled during the evening hours

-- Which of the customer types brings the most revenue?
SELECT 
       CUSTOMER_TYPE,
       SUM(TOTAL) AS CNT1_REVENUE FROM SALES
       GROUP BY CUSTOMER_TYPE
       ORDER BY CNT1_REVENUE DESC;
-- ANSWER MEMBER 
-- Which city has the largest tax/VAT percent?
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;
-- ANSWER NAYPYITW
-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(tax_pct) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
-- ANSWER MEMBER
SELECT SUM(TOTAL) FROM SALES
WHERE  DAY_NAME = "WEDNESDAY" AND PRODUCT_LINE=(SELECT MAX(PRODUCT_LINE) FROM SALES);
-- 7906.0380

SELECT SUM(TOTAL) FROM SALES
WHERE  DAY_NAME = "MONDAY" AND PRODUCT_LINE=(SELECT MAX(PRODUCT_LINE) FROM SALES);
-- 4401.6210



SELECT SUM(TOTAL) FROM SALES
WHERE  DAY_NAME = "TUESDAY" AND PRODUCT_LINE=(SELECT MAX(PRODUCT_LINE) FROM SALES);
-- 7831.4250

SELECT SUM(TOTAL) FROM SALES
WHERE  DAY_NAME = "THURSDAY" AND PRODUCT_LINE=(SELECT MAX(PRODUCT_LINE) FROM SALES);
-- 7831.4250

SELECT SUM(TOTAL) FROM SALES
WHERE  DAY_NAME = "FRIDAY" AND PRODUCT_LINE=(SELECT MAX(PRODUCT_LINE) FROM SALES);
-- 9680.6325

SELECT SUM(TOTAL) FROM SALES
WHERE  DAY_NAME = "SATURDAY" AND PRODUCT_LINE=(SELECT MAX(PRODUCT_LINE) FROM SALES);
-- 9603.6325

SELECT * FROM SALES;
SELECT MAX(QUANTITY) FROM SALES;
SELECT * FROM SALES
WHERE QUANTITY = 10 
HAVING UNIT_PRICE>70;
SELECT DAY_NAME,MAX(TOTAL) FROM SALES
WHERE PRODUCT_LINE = (SELECT MAX(PRODUCT_LINE) FROM SALES)
GROUP BY DAY_NAME;
SELECT * FROM sales




-- 7132.8180











