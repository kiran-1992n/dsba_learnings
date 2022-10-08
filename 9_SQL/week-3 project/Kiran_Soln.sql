-- 1. Write a query to display customer full name with their title (Mr/Ms), both first name and last name are in upper case, 
-- customer email id, customer creation date and display customer’s category after applying below categorization rules: i) IF customer creation 
-- date Year <2005 Then Category A ii) IF customer creation date Year >=2005 and <2011 Then Category B iii)IF customer creation date Year>= 2011 
-- Then Category C Hint: Use CASE statement, no permanent change in table required. [NOTE: TABLES to be used - ONLINE_CUSTOMER TABLE]

SELECT CASE WHEN CUSTOMER_GENDER ='M' THEN concat('Mr. ' , UPPER(concat(CUSTOMER_FNAME, ' ', CUSTOMER_LNAME)))
	WHEN CUSTOMER_GENDER ='F' THEN concat('Ms. ' , UPPER(concat(CUSTOMER_FNAME, ' ', CUSTOMER_LNAME))) END AS CUSTOMER_NAME
,CUSTOMER_EMAIL ,CUSTOMER_CREATION_DATE ,
CASE WHEN YEAR(CUSTOMER_CREATION_DATE)<2005 THEN 'A' 
	WHEN YEAR(CUSTOMER_CREATION_DATE)>=2005 and YEAR(CUSTOMER_CREATION_DATE)<2011 THEN 'B' 
	WHEN YEAR(CUSTOMER_CREATION_DATE)>=2011 THEN 'C' END AS Customer_Category
FROM ONLINE_CUSTOMER ;


-- 2. Write a query to display the following information for the products, which have not been sold: product_id, product_desc, 
-- product_quantity_avail, product_price, inventory values (product_quantity_avail*product_price), New_Price after applying discount 
-- as per below criteria. Sort the output with respect to decreasing value of Inventory_Value. 
-- i) IF Product Price > 200,000 then apply 20% discount ii) IF Product Price > 100,000 then apply 15% discount 
-- iii) IF Product Price =< 100,000 then apply 10% discount # Hint: Use CASE statement, no permanent change in table required. 
-- [NOTE: TABLES to be used - PRODUCT, ORDER_ITEMS TABLE]

SELECT p.product_id, p.product_desc, p.product_quantity_avail, p.product_price,
p.product_quantity_avail*p.product_price AS Inventory_Value
,CASE WHEN p.product_price > 200000 then p.product_price*0.2 
WHEN p.product_price > 100000 then p.product_price*0.15
WHEN p.product_price <= 100000 then p.product_price*0.1 END AS New_Price
FROM PRODUCT p
INNER JOIN ORDER_ITEMS o ON p.PRODUCT_ID=o.PRODUCT_ID
WHERE p.product_quantity_avail > 0
ORDER BY p.product_quantity_avail*p.product_price DESC ;


-- 3. Write a query to display Product_class_code, Product_class_description, Count of Product type in each productclass, 
-- Inventory Value (p.product_quantity_avail*p.product_price). Information should be displayed for only those product_class_code 
-- which have more than 1,00,000. Inventory Value. Sort the output with respect to decreasing value of Inventory_Value. 
-- [NOTE: TABLES to be used - PRODUCT_CLASS, PRODUCT_CLASS_CODE]


SELECT p.Product_class_code,pc.Product_class_desc as Product_class_description, 
Count(p.Product_class_code) AS Count_PRODUCT_TYPE, p.product_quantity_avail*p.product_price AS Inventory_Value
FROM PRODUCT p
INNER JOIN PRODUCT_CLASS pc ON p.PRODUCT_CLASS_CODE=pc.PRODUCT_CLASS_CODE
GROUP BY p.Product_class_code,Product_class_desc,p.product_quantity_avail,p.product_price
HAVING p.product_quantity_avail*p.product_price > 100000 
ORDER BY p.product_quantity_avail*p.product_price DESC;


-- 4. Write a query to display customer_id, full name, customer_email, customer_phone and country of customers who have cancelled 
-- all the orders placed by them (USE SUB-QUERY)[NOTE: TABLES to be used - ONLINE_CUSTOMER, ADDRESSS, OREDER_HEARDER]

SELECT OC.CUSTOMER_ID, concat(OC.CUSTOMER_FNAME , ' ' , OC.CUSTOMER_LNAME) AS FULL_NAME, CUSTOMER_EMAIL, CUSTOMER_PHONE, A.COUNTRY 
FROM ADDRESS A
INNER JOIN ONLINE_CUSTOMER OC ON A.ADDRESS_ID=OC.ADDRESS_ID
where OC.CUSTOMER_ID in (select oh.CUSTOMER_ID from ORDER_HEADER oh 
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
where ORDER_STATUS='Cancelled' and oh.CUSTOMER_ID not in(
select oh.CUSTOMER_ID from ORDER_HEADER oh 
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID
where ORDER_STATUS!='Cancelled'
));

-- 5. Write a query to display Shipper name, City to which it is catering, num of customer catered by the shipper in the city and number 
-- of consignments delivered to that city for Shipper DHL [NOTE: TABLES to be used - SHIPPER,ONLINE_CUSTOMER, ADDRESSS, ORDER_HEARDER]

SELECT S.SHIPPER_NAME,A.CITY,COUNT(OC.CUSTOMER_ID) Number_Customer
FROM ADDRESS A
INNER JOIN ONLINE_CUSTOMER OC ON A.ADDRESS_ID=OC.ADDRESS_ID
INNER JOIN ORDER_HEADER OH ON OC.CUSTOMER_ID=OH.CUSTOMER_ID 
INNER JOIN SHIPPER S ON S.SHIPPER_ID =OH.SHIPPER_ID
where S.SHIPPER_NAME = 'DHL';

-- 6. Write a query to display product_id, product_desc, product_quantity_avail, quantity sold, quantity available and show inventory Status 
-- of products as below as per below condition: a. For Electronics and Computer categories, if sales till date is Zero then show 
-- 'No Sales in past, give discount to reduce inventory', if inventory quantity is less than 10% of quantity sold,show 
-- 'Low inventory, need to add inventory', if inventory quantity is less than 50% of quantity sold, show 
-- 'Medium inventory, need to add some inventory', if inventory quantity is more or equal to 50% of quantity sold, show 
-- 'Sufficient inventory' b. For Mobiles and Watches categories, if sales till date is Zero then show 
-- 'No Sales in past, give discount to reduce inventory', if inventory quantity is less than 20% of quantity sold, show 
-- 'Low inventory, need to add inventory', if inventory quantity is less than 60% of quantity sold, show 
-- 'Medium inventory, need to add some inventory', if inventory quantity is more or equal to 60% of quantity sold, show 
-- 'Sufficient inventory' c. Rest of the categories, if sales till date is Zero then show 'No Sales in past, give discount to reduce inventory', 
-- if inventory quantity is less than 30% of quantity sold, show 'Low inventory, need to add inventory', 
-- if inventory quantity is less than 70% of quantity sold, show 'Medium inventory, need to add some inventory', 
-- if inventory quantity is more or equal to 70% of quantity sold, show 'Sufficient inventory' 
-- (USE SUB-QUERY) -- [NOTE: TABLES to be used - PRODUCT, PRODUCT_CLASS, ORDER_HEADER]

SELECT
  p.product_id,
  p.product_desc,
  p.product_quantity_avail,
  OI.PRODUCT_QUANTITY AS quantity_sold,(p.product_quantity_avail - OI.PRODUCT_QUANTITY) AS quantity_Available,
  CASE WHEN PRODUCT_CLASS_DESC IN ('Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) = 0 THEN 'No Sales in past, give discount to reduce inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) < OI.PRODUCT_QUANTITY * 0.1 THEN 'Low inventory, need to add inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) < OI.PRODUCT_QUANTITY * 0.5 THEN 'Medium inventory, need to add some inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) >= OI.PRODUCT_QUANTITY * 0.5 THEN 'Sufficient inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Mobiles', 'Watches')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) = 0 THEN 'No Sales in past, give discount to reduce inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Mobiles', 'Watches')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) < OI.PRODUCT_QUANTITY * 0.2 THEN 'Low inventory, need to add inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Mobiles', 'Watches')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) < OI.PRODUCT_QUANTITY * 0.6 THEN 'Medium inventory, need to add some inventory' 
	WHEN PRODUCT_CLASS_DESC IN ('Mobiles', 'Watches')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) >= OI.PRODUCT_QUANTITY * 0.6 THEN 'Sufficient inventory' 
	WHEN PRODUCT_CLASS_DESC NOT IN ('Mobiles', 'Watches', 'Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) = 0 THEN 'No Sales in past, give discount to reduce inventory' 
	WHEN PRODUCT_CLASS_DESC NOT IN ('Mobiles', 'Watches', 'Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) < OI.PRODUCT_QUANTITY * 0.3 THEN 'Low inventory, need to add inventory' 
	WHEN PRODUCT_CLASS_DESC NOT IN ('Mobiles', 'Watches', 'Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) < OI.PRODUCT_QUANTITY * 0.7 THEN 'Medium inventory, need to add some inventory' 
	WHEN PRODUCT_CLASS_DESC NOT IN ('Mobiles', 'Watches', 'Electronics', 'Computer')
		and (p.product_quantity_avail - OI.PRODUCT_QUANTITY) >= OI.PRODUCT_QUANTITY * 0.7 THEN 'Sufficient inventory' END AS inventory_Status
FROM
  PRODUCT p
  INNER JOIN PRODUCT_CLASS pc ON p.PRODUCT_CLASS_CODE = pc.PRODUCT_CLASS_CODE
  INNER JOIN ORDER_ITEMS OI ON p.PRODUCT_ID = OI.PRODUCT_ID
  INNER JOIN ORDER_HEADER OH ON OI.ORDER_ID = OH.ORDER_ID;

-- 7. Write a query to display order_id and volume of the biggest order (in terms of volume) that can fit in carton id 10 
-- [NOTE: TABLES to be used - CARTON, ORDER_ITEMS, PRODUCT]

SELECT ORDER_ID,p.LEN*p.WIDTH*p.HEIGHT AS Volume_of_Order 
FROM PRODUCT p
INNER JOIN ORDER_ITEMS o ON p.PRODUCT_ID=o.PRODUCT_ID
where p.LEN*p.WIDTH*p.HEIGHT <= (select p.LEN*p.WIDTH*p.HEIGHT from carton p where p.CARTON_ID =10);

-- 8. Write a query to display customer id, customer full name, total quantity and total value (quantity*price) shipped where mode of payment is 
-- Cash and customer last name starts with 'G' --[NOTE: TABLES to be used - ONLINE_CUSTOMER, ORDER_ITEMS, PRODUCT, ORDER_HEADER]

SELECT OC.CUSTOMER_ID ,CONCAT(CUSTOMER_FNAME ,' ',CUSTOMER_LNAME) as Full_Name,SUM(p.PRODUCT_QUANTITY_AVAIL) as total_quantity
,SUM(p.PRODUCT_QUANTITY_AVAIL*p.product_price) as total_quantity_Shipped
FROM PRODUCT p
INNER JOIN ORDER_ITEMS OI ON p.PRODUCT_ID =OI.PRODUCT_ID 
INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID =OI.ORDER_ID
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID 
WHERE PAYMENT_MODE ='Cash' and CUSTOMER_LNAME like 'G%'
GROUP BY OC.CUSTOMER_ID ,CUSTOMER_FNAME,CUSTOMER_LNAME;

-- 9. Write a query to display product_id, product_desc and total quantity of products which are sold together with product id 201 and are not 
-- shipped to city Bangalore and New Delhi. Display the output in descending order with respect to the tot_qty. 
-- (USE SUB-QUERY) -- [NOTE: TABLES to be used - order_items, product,order_head, online_customer, address]

SELECT p.PRODUCT_ID,p.PRODUCT_DESC ,SUM(PRODUCT_QUANTITY) AS Total_Quantity
FROM PRODUCT p
INNER JOIN ORDER_ITEMS OI ON p.PRODUCT_ID =OI.PRODUCT_ID 
INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID =OI.ORDER_ID
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID 
where OC.ADDRESS_ID not in (select ADDRESS_ID from ADDRESS where 
CITY NOT IN ('Bangalore','New Delhi')) and p.PRODUCT_ID =201
GROUP BY p.PRODUCT_ID,p.PRODUCT_DESC
ORDER BY 3 DESC;


--10. Write a query to display the order_id,customer_id and customer fullname, total quantity of products 
-- shipped for order ids which are even and shipped to address where pincode is not starting with "5" 
-- [NOTE: TABLES to be used - online_customer,Order_header, order_items,address]

SELECT OH.order_id,OH.customer_id,CONCAT(CUSTOMER_FNAME , ' ', CUSTOMER_LNAME) as customer_fullname, SUM(PRODUCT_QUANTITY) AS Total_Quantity
from  ORDER_ITEMS OI 
INNER JOIN ORDER_HEADER OH ON OH.ORDER_ID =OI.ORDER_ID
INNER JOIN ONLINE_CUSTOMER OC ON OC.CUSTOMER_ID=OH.CUSTOMER_ID 
INNER JOIN ADDRESS A ON A.ADDRESS_ID=OC.ADDRESS_ID
WHERE OH.ORDER_ID%2=0 AND PINCODE NOT LIKE '5%'
GROUP BY OH.order_id,OH.customer_id,CUSTOMER_FNAME,CUSTOMER_LNAME;

