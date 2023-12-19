/* 
Creating a Customer Summary Report

In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

Step 1: Create a View
First, create a view that summarizes rental information for each customer. 
The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

Step 2: Create a Temporary Table
Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

Step 3: Create a CTE and the Customer Summary Report
Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
The CTE should include the customer's name, email address, rental count, and total amount paid.

Next, using the CTE, create the query to generate the final customer summary report, 
which should include: customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.*/

USE sakila;

-- Step 1 --

CREATE VIEW sakila.customer_info AS (
  SELECT c.customer_id, c.first_name, c.email, count(r.rental_id) rental_count
  FROM customer c
  left join rental r on c.customer_id = r.customer_id
  group by 1,2,3
);

-- DROP VIEW sakila.customer_info; 

SELECT * from sakila.customer_info; 

-- Step 2 --

CREATE TEMPORARY TABLE total_paid AS (
  SELECT c.customer_id, sum(p.amount) total_paid from sakila.customer_info c
  LEFT JOIN payment p on c.customer_id = p.customer_id
  GROUP BY 1 );

  -- DROP TABLE sakila.total_paid; 
  
  select * from total_paid; 
  
  
-- Step 3 --

WITH CustomerSummary as (
SELECT 
	c.customer_id,
	c.first_name,
	c.email,
	c.rental_count,
	t.total_paid
FROM customer_info c
LEFT JOIN total_paid t on c.customer_id = t.customer_id)

SELECT *, total_paid/rental_count as average
FROM CustomerSummary; 


