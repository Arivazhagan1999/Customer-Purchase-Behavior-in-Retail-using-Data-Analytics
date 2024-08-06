-- ---------------------------------------------------- --- 
-- Q1. Retrieve all details of customers who have placed orders --
Select *
From customers
Join orders 
On customers.customer_id = orders.customer_id;
-- ---------------------------------------------------- --- 
-- Q2. Calculate the total sales for each store. --
Select s.store_id, s.store_name,
Round(Sum(oi.list_price * oi.quantity),2) AS total_sales
From orders o
Join order_items oi 
On o.order_id = oi.order_id
Join stores s 
On o.store_id = s.store_id
Group by s.store_id, s.store_name;
-- ---------------------------------------------------- --- 
-- Q3. Find the products that have never been ordered. --
Select product_id, product_name
From products
Where product_id 
Not in (Select product_id From order_items);
-- ---------------------------------------------------- --- 
-- Q4. Retrieve the names and email addresses of staff along with the names of their managers. --
Select 
st.first_name AS staff_first_name,
st.last_name AS staff_last_name,
st.email AS staff_email,
ma.first_name AS manager_first_name,
ma.last_name AS manager_last_name
From staffs st
Join staffs ma ON st.manager_id = ma.staff_id;
-- ---------------------------------------------------- --- 
-- Q5. Rank stores based on their total sales. --
Select s.store_id, s.store_name,
ROUND(SUM(oi.list_price * oi.quantity), 2) AS total_sales,
Rank() Over (Order By Sum(oi.list_price * oi.quantity) Desc) as sales_rank
From orders o
Join order_items oi 
on o.order_id = oi.order_id
Join stores s 
on o.store_id = s.store_id
Group by s.store_id, s.store_name
Order by sales_rank;
-- ---------------------------------------------------- --- 
-- Q6. Calculate the number of days each order took to ship. --
Select order_id, order_date,shipped_date,
datediff(shipped_date, order_date) AS days_to_ship
From orders;
-- ---------------------------------------------------- --- 
-- Q7. Categorize orders based on their status. --
Select 
    order_id,
    order_date,
    order_status,
    Case 
        When order_status = 1 Then 'Recived'
        When order_status = 2 Then 'Processing'
        When order_status = 3 Then 'Shipped'
        When order_status = 4 Then 'Delivered'
        When order_status = 5 Then 'Cancelled'
        Else 'Other'
    End as status_category
From orders;
-- ---------------------------------------------------- --- 
-- Q8. Retrieve all orders along with the product names and the store names. --
Select 
o.order_id,
o.order_date,
p.product_name,
s.store_name
From orders o
Join 
order_items oi 
on o.order_id = oi.order_id
Join 
products p 
ON oi.product_id = p.product_id
Join 
stores s 
On o.store_id = s.store_id;
-- ---------------------------------------------------- --- 
-- Q9. Create a temporary table to store intermediate sales calculations.--
Create View view_store_sales as
Select 
s.store_id,
s.store_name,
Round(SUM(oi.list_price * oi.quantity),2) as total_sales
From orders o
Join order_items oi 
on o.order_id = oi.order_id
Join stores s 
on o.store_id = s.store_id
Group By s.store_id, s.store_name;