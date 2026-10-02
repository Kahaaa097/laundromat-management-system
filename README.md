# Laundromat Management System

## Project Overview
This project develops a relational database for managing the operations of a laundromat. The database stores and manages information related to customers, orders, packages, services, payments, staff, and washing machines. The project demonstrates the use of SQL for both **database management** and **business analysis**, providing insights that can support operational monitoring and decision-making.
## Database Operations
### 1. Create a New Customer Order
**Business Scenario:**
A customer creates a new laundry order.
```sql
INSERT INTO CUSTOMERORDER (orderID, customerID, OrderNote, OrderStatus)
VALUES ('O000001', 'C1234', 'Giặt nhẹ nhàng, ưu tiên giao sớm', 'pending');
```

This operation demonstrates how a new order can be added to the database.
### 2. Delete a Package
**Business Scenario:**
Remove a specific package from an order.
```sql
DELETE FROM PACKAGE
WHERE packID = 'P000001';
```

### 3. Update Order Status
**Business Scenario:**
Update an order from `processing` to `done` after the laundry process has been completed.
```sql
UPDATE CUSTOMERORDER
SET OrderStatus = 'done'
WHERE orderID = 'O000001';
```

# Business Insights & SQL Analysis
The database can also be used to answer practical operational questions and generate business insights.
### 4. Monthly Revenue Analysis
**Business Question:**
How much revenue does the laundromat generate each month?
```sql
SELECT 
    YEAR(DateTime) AS Year,
    MONTH(DateTime) AS Month,
    SUM(Amount) AS TotalRevenue
FROM PAYMENT
GROUP BY YEAR(DateTime), MONTH(DateTime)
ORDER BY Year, Month;
```

**Business Insight:**
This analysis helps monitor revenue trends over time and identify months with higher or lower business performance.
### 5. Revenue by Service Category
**Business Question:**
Which laundry services generate the highest revenue?
```sql
SELECT 
    S.ServiceName,
    SUM(P.Amount) AS TotalRevenue
FROM PAYMENTDETAIL PD
JOIN PAYMENT P 
    ON PD.paymentID = P.paymentID
JOIN CUSTOMERORDER CO 
    ON PD.orderID = CO.orderID
JOIN PACKAGE PK 
    ON CO.orderID = PK.orderID
JOIN SERVICE S 
    ON PK.serviceID = S.serviceID
WHERE P.DateTime BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY S.ServiceName
ORDER BY TotalRevenue DESC;
```

**Business Insight:**
The results help identify high-revenue services and provide information for service promotion and pricing decisions.
### 6. Staff Performance by Number of Orders
**Business Question:**
How many orders has each staff member handled?
```sql
SELECT 
    ST.StaffName,
    COUNT(OH.orderID) AS OrdersHandled
FROM STAFF ST
JOIN ORDERHANDLING OH 
    ON ST.staffID = OH.staffID
GROUP BY ST.StaffName
ORDER BY OrdersHandled DESC;
```

**Business Insight:**
This query provides an overview of workload distribution among staff members.
### 7. Staff Productivity by Weight Handled
**Business Question:**
What is the total weight of laundry handled by each staff member?

```sql
SELECT 
    ST.StaffName,
    SUM(PK.Weight) AS TotalWeightHandled
FROM STAFF ST
JOIN ORDERHANDLING OH 
    ON ST.staffID = OH.staffID
JOIN PACKAGE PK 
    ON OH.orderID = PK.orderID
GROUP BY ST.StaffName
ORDER BY TotalWeightHandled DESC;
```

**Business Insight:**
The analysis measures staff workload based on the total weight of laundry processed.

### 8. Washing Machine Utilization
**Business Question:**
How many packages and how much laundry weight are processed by each washing machine?
```sql
SELECT 
    M.machineID,
    M.Brand,
    M.Model,
    COUNT(PK.packID) AS TotalPackages,
    SUM(PK.Weight) AS TotalWeight
FROM MACHINE M
JOIN PACKAGE PK 
    ON M.machineID = PK.machineID
GROUP BY M.machineID, M.Brand, M.Model
ORDER BY TotalWeight DESC;
```

**Business Insight:**
This information helps compare machine workloads and supports maintenance planning and capacity management.
### 9. Top Customers by Order Frequency
**Business Question:**
Which customers use the laundromat most frequently?

```sql
SELECT 
    C.CusName,
    C.Phone,
    COUNT(CO.orderID) AS OrdersCount
FROM CUSTOMER C
JOIN CUSTOMERORDER CO 
    ON C.customerID = CO.customerID
GROUP BY C.CusName, C.Phone
ORDER BY OrdersCount DESC;
```

**Business Insight:**
The results help identify frequent customers who may be targeted through loyalty programs and personalized promotions.
### 10. Orders by Service and Status
**Business Question:**
How many completed orders are associated with each laundry service?
```sql
SELECT 
    S.ServiceName,
    CO.OrderStatus,
    COUNT(CO.orderID) AS OrdersCount
FROM CUSTOMERORDER CO
JOIN PACKAGE PK 
    ON CO.orderID = PK.orderID
JOIN SERVICE S 
    ON PK.serviceID = S.serviceID
WHERE CO.OrderStatus = 'done'
GROUP BY S.ServiceName, CO.OrderStatus
ORDER BY OrdersCount DESC;
```

**Business Insight:**
This analysis provides an overview of completed orders by service type and can help managers monitor service demand.
## Key SQL Concepts Demonstrated
* `INSERT`, `UPDATE`, and `DELETE`
* `SELECT` and filtering with `WHERE`
* `INNER JOIN`
* `GROUP BY`
* Aggregate functions: `COUNT()`, `SUM()`
* Date functions: `YEAR()`, `MONTH()`
* Sorting with `ORDER BY`
* Business-oriented data analysis
* Operational performance analysis
* Customer behavior analysis
