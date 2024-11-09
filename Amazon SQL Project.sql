CREATE TABLE review_table (
	review_id INT,
	user_id INT,
	submit_date TIMESTAMP,
	product_id INT,
	stars INT
);

INSERT INTO review_table (review_id, user_id,submit_date,product_id,stars)
			VALUES(6171,123, '2022-06-08 00:00:00',50001,4),
					(7802,265,'2022-06-10 00:00:00',69852,4),
					(5293, 362, '2022-06-18 00:00:00',50001,3),
					(6352,192,'2022-07-26 00:00:00',69852,3),
					(4517,981,'2022-07-05 00:00:00', 69852, 2 );

SELECT * FROM review_table

-- creating the table and putting the necessary constraints
	
CREATE TABLE product_spend (
	category VARCHAR,
	product VARCHAR,
	user_id INT,
	spend REAL,
	transaction_date TIMESTAMP
);

--- We are inserting provided data into the table created above

INSERT INTO product_spend( category, product, user_id, spend, transaction_date)
			VALUES('appliance', 'refrigerator', 165, 246.00, '2021-12-26 12:00:00'),
					('appliance', 'refrigerator', 123, 299.99, '2022-03-02 12:00:00'),
					('appliance', 'washing machine',123, 219.80, '2022-03-02 12:00:00'),
					('electronics','vacuum',178, 152.00, '2022-04-05 12:00:00'),
					('electronics','wireless headset',156,249.90,'2022-07-08 12:00:00'),
					('electronics', 'vacuum', 145, 189.00,'2022-07-15 12:00:00');

SELECT * FROM product_spend;



/* Question 1.
Given a table of product reviews, calculate the average review rating for each product for every month. The output should list the month
as (as a numerical value), product id, and the average star rating rounded to twodecimal places. Sort the result by month and
then by product_id. */

SELECT 
		EXTRACT(MONTH FROM submit_date) AS MONTH,  --extracting just the month from the submit_date
		product_id, 
		ROUND(AVG(stars),2) AS avg_star_rating    ---using round to round up our output into 2 decimal places
FROM review_table
GROUP BY 
		EXTRACT(MONTH FROM submit_date), product_id
ORDER BY
		MONTH,product_id;



/* Question 2.
Find the top two highest-grossing products in each category for the year 2022 from a table product_spend.
Output should include the category, product, and total spend.*/

WITH product_category_spend AS (        --using the CTE to create a temporal table
	SELECT
		category,
		product,
		SUM(spend) total_spend
	FROM
		product_spend
	WHERE transaction_date >= '2022-01-01'
	AND transaction_date <= '2022-12-31'
	GROUP BY category, product
),
ranked_spend AS (      --using the window function 'rank' to assign a rank to each row within partition 
	                  --based on the order of total_spend          
	SELECT
		category,
		product,
		total_spend,
		RANK() OVER (PARTITION BY category ORDER BY total_spend DESC) AS rank_order
	FROM product_category_spend
)
SELECT
	category,
	product,
	total_spend
FROM
	ranked_spend
WHERE rank_order <= 2
ORDER BY category, rank_order;