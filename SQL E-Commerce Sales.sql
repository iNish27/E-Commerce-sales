Create database ECommerce;
show tables;
select * from customers;
select * from products;
select * from orders;
select * from order_details;

# Total Revenue Per Month

Select date_format(OrderDate, '%y-%m') as Month, 
sum(TotalAmount) as TotalRevenue
from Orders 
Group by month 
order by Month;

# Top 5 best-selling products by quantity

Select products.ProductName, sum(order_details.Quantity) as totalQuantitySold
from order_details Inner Join products
on order_details.ProductID = products.ProductID
Group by products.ProductName
order by totalQuantitySold desc
Limit 5;

# Average order value per customer

# 1. Querry

Select avg(orders.TotalAmount) as AverageOrderValue, customers.Name
from customers inner join orders
on orders.CustomerID = customers.CustomerID
group by customers.Name
order by AverageOrdervalue desc;

# 2. Query

SELECT 
  c.CustomerID,
  c.Name,
  COUNT(o.OrderID) AS TotalOrders,
  SUM(o.TotalAmount) AS TotalSpent,
  ROUND(SUM(o.TotalAmount) / COUNT(o.OrderID), 2) AS AvgOrderValue
FROM 
  customers c
JOIN 
  orders o ON c.CustomerID = o.CustomerID
GROUP BY 
  c.CustomerID, c.Name
ORDER BY 
  AvgOrderValue DESC;

# Gender-based revenue contribution

Select customers.Gender, Sum(orders.TotalAmount) as TotalRevenue
from customers inner join orders
on customers.CustomerID = orders.CustomerID
group by customers.Gender;

# Running total of sales per category

Select products.ProductName, products.Category,
order_details.Quantity * order_details.UnitPrice as SalesAmount,
sum(order_details.Quantity * order_details.UnitPrice)
over (partition by products.Category Order by products.ProductName) as RunningTotal
from order_details inner Join products on
products.ProductID = order_details.ProductID;

# Products never sold

SELECT 
  p.ProductID,
  p.ProductName
FROM 
  products p
LEFT JOIN 
  order_details od ON p.ProductID = od.ProductID
WHERE 
  od.ProductID IS NULL;
  
# Use RANK() to find top customers by spending

Select customers.Name as CustomerName, customers.CustomerID,
sum(orders.TotalAmount) as TotalSpending,
Rank () over (order by sum(orders.TotalAmount) desc) as SpendingRank
from customers inner join orders on 
customers.CustomerID = orders.CustomerID
group by 
customers.CustomerID, customers.Name
order by 
SpendingRank;

# Use a CTE to calculate average monthly revenue

WITH cteAvgMonthlyRevenue AS (
  SELECT 
    DATE_FORMAT(OrderDate, '%y-%m') AS Month, 
    AVG(TotalAmount) AS AverageRevenue
  FROM 
    orders
  GROUP BY 
    DATE_FORMAT(OrderDate, '%y-%m')
)
SELECT * FROM cteAvgMonthlyRevenue;





