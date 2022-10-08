-- 1)List Top 3 products based on QuantityAvailable. (productid, productname, QuantityAvailable )

select productid, productname, QuantityAvailable from products order by QuantityAvailable desc limit 3 ;

-- 2)Display EmailId of those customers who have done more than ten purchases. (EmailId, Total_Transactions)

select pd.Emailid, 
sum(pd.quantitypurchased * p.price) as TotalTransaction
from purchasedetails pd
inner join products p  
on pd.productid = p.productid
group by emailid
having count(purchaseid) > 10;

-- 3) List the Total QuantityAvailable category wise in descending order. (Name of the category, QuantityAvailable) 

select c.categoryname,sum(p.quantityavailable) as TotalQuantityAvailable 
from products p inner join categories c
on p.categoryid = c.categoryid
group by c.categoryid
order by TotalQuantityAvailable desc;

-- 4) Display ProductId, ProductName, CategoryName, Total_Purchased_Quantity for the product which has been sold maximum in terms of quantity?

select 
pd.productid, p.productname, c.categoryname, sum(quantitypurchased) as TotalPurchasedQuantity
from purchasedetails pd
inner join products p  
on pd.productid = p.productid
inner join categories c 
on p.categoryid = c.categoryid
group by pd.productid
order by sum(quantitypurchased) desc limit 1;

-- 5) Display the number of male and female customers in fastkart.

select Gender,count(*) as NuberOfCustomers
from users
where Roleid = (select Roleid from roles where Rolename = 'Customer')
group by Gender;

-- 6. Display ProductId, ProductName, Price and Item_Classes of all the products where Item_Classes are as follows: 
-- If the price of an item is less than 2,000 then “Affordable”, 
-- If the price of an item is in between 2,000 and 50,000 then “High End Stuff”, 
-- If the price of an item is more than 50,000 then “Luxury”.

select 
productid, productname, price,
CASE 
WHEN price < 2000 Then "Affordable"
WHEN price >= 2000 and price <= 5000 Then "High End Stuff"
WHEN price > 5000 Then "Luxury" 
END 
as Item_Classes 
from products;

-- 7) Write a query to display ProductId, ProductName, CategoryName, Old_Price(price) and New_Price as per the following criteria 
-- a. If the category is “Motors”, decrease the price by 3000 
-- b. If the category is “Electronics”, increase the price by 50 
-- c. If the category is “Fashion”, increase the price by 150 For the rest of the categories price remains same. 
-- Hint: Use case statement, there should be no permanent change done in table/DB.

 
select 
p.productid, p.productname, c.categoryname ,p.price as Old_Price,
CASE
WHEN c.categoryname = 'Motors' Then p.price - 3000
WHEN c.categoryname ='Electronics' THEN p.price + 50
WHEN c.categoryname ='Fashion' THEN p.price + 150
ELSE p.price
END
AS New_Price
from products p inner join categories c
on p.categoryid = c.categoryid;

-- 8. Display the percentage of females present among all Users. (Round up to 2 decimal places) Add “%” sign while displaying the percentage. 

select 
Gender, count(*) as NumberOfUsers, 
concat(cast(count(*) * 100 / (SELECT count(*) FROM users) as DECIMAL(10, 2)), '%') as PercentageOfUsers
from users
where gender = 'F'
group by gender;

-- 9) Display the average balance for both card types for those records only where CVVNumber > 333 and NameOnCard ends with the alphabet “e”. 

select
CardType, Avg(Balance) as 'Average Balance'
from carddetails
where CVVNumber > 333 and NameOnCard like '%e'
group by CardType;

-- 10) What is the 2nd most valuable item available which does not belong to the “Motor” category.
--  Value of an item = Price * QuantityAvailable. Display ProductName, CategoryName, value.

select * from 
	(select 
		p.productname, p.price , p.quantityavailable,
		c.categoryname, p.price * p.quantityavailable as ValueOfItem
	from products p inner join categories c
	on p.categoryid = c.categoryid
	where c.categoryname != 'Motors'
	order by ValueOfItem desc limit 2) AS MyTable 
ORDER BY ValueOfItem ASC limit 1;