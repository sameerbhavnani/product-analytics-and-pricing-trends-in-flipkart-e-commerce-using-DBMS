-- ============================================================================
-- E-COMMERCE DATABASE ANALYSIS QUERIES
-- ============================================================================
-- This document contains SQL queries for analyzing e-commerce data
-- across multiple dimensions: orders, products, customers, and reviews
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1. IDENTIFY ORDER HOTSPOTS
-- ----------------------------------------------------------------------------
-- Purpose: Find the City with the Highest Number of Orders
-- Use Case: Identify geographic areas with highest demand for logistics optimization

SELECT City, Order_Count
FROM (
    SELECT C.City, COUNT(O.Order_ID) AS Order_Count
    FROM ORDER1 O
    JOIN CUSTOMERS1 C ON O.Customer_ID = C.Customer_ID
    GROUP BY C.City
    ORDER BY Order_Count DESC
) WHERE ROWNUM = 1;


-- ----------------------------------------------------------------------------
-- 2. ANALYZE PURCHASE BEHAVIOR
-- ----------------------------------------------------------------------------
-- Purpose: Find the Most Frequently Purchased Quantity in Customer Orders
-- Use Case: Understand typical order sizes to optimize inventory and packaging

SELECT Quantity, Frequency
FROM (
    SELECT Quantity, COUNT(*) AS Frequency
    FROM ORDER_DETAILS1
    GROUP BY Quantity
    ORDER BY Frequency DESC
) WHERE ROWNUM = 1;


-- ----------------------------------------------------------------------------
-- 3. IDENTIFY TOP PERFORMING PRODUCTS
-- ----------------------------------------------------------------------------
-- Purpose: Find the Top 5 Best-Selling Products Based on Quantity Sold
-- Use Case: Focus marketing efforts and inventory management on top performers

SELECT Product_Name, Total_Sold
FROM (
    SELECT P.Product_Name, SUM(OD.Quantity) AS Total_Sold
    FROM ORDER_DETAILS1 OD
    JOIN PRODUCT1 P ON OD.Product_ID = P.Product_ID
    GROUP BY P.Product_Name
    ORDER BY Total_Sold DESC
) WHERE ROWNUM <= 5;


-- ----------------------------------------------------------------------------
-- 4. TRACK SHORT-TERM SALES
-- ----------------------------------------------------------------------------
-- Purpose: Find the Total Number of Products Sold in the Last Month
-- Use Case: Monitor recent sales performance and identify short-term trends

SELECT SUM(OD.Quantity) AS Total_Products_Sold
FROM ORDER_DETAILS1 OD
JOIN ORDER1 O ON OD.Order_ID = O.Order_ID
WHERE O.Order_Date >= ADD_MONTHS(SYSDATE, -1);


-- ----------------------------------------------------------------------------
-- 5. MONITOR ANNUAL TRENDS
-- ----------------------------------------------------------------------------
-- Purpose: Analyze the Monthly Trend in Order Volume Over the Last Year
-- Use Case: Identify seasonal patterns and plan inventory/marketing accordingly

SELECT TO_CHAR(O.Order_Date, 'YYYY-MM') AS Month, COUNT(O.Order_ID) AS Order_Count
FROM ORDER1 O
WHERE O.Order_Date >= ADD_MONTHS(SYSDATE, -12)
GROUP BY TO_CHAR(O.Order_Date, 'YYYY-MM')
ORDER BY Month;


-- ----------------------------------------------------------------------------
-- 6. EVALUATE CUSTOMER SATISFACTION
-- ----------------------------------------------------------------------------
-- Purpose: Identify the Highest-Rated Product Based on Customer Reviews
-- Use Case: Highlight top-quality products for promotional campaigns

SELECT Product_Name, Avg_Rating
FROM (
    SELECT P.Product_Name, AVG(R.Rating) AS Avg_Rating
    FROM REVIEWS1 R
    JOIN PRODUCT1 P ON R.Product_ID = P.Product_ID
    GROUP BY P.Product_Name
    ORDER BY Avg_Rating DESC
) WHERE ROWNUM = 1;


-- ----------------------------------------------------------------------------
-- 7. IDENTIFY FREQUENT REVIEWERS
-- ----------------------------------------------------------------------------
-- Purpose: Identify Customers Who Have Submitted the Most Reviews
-- Use Case: Engage with active reviewers for feedback and loyalty programs

SELECT Customer_Name, Review_Count 
FROM (
    SELECT C.NAME AS Customer_Name, COUNT(R.REVIEW_ID) AS Review_Count
    FROM CUSTOMERS1 C
    JOIN REVIEWS1 R ON C.CUSTOMER_ID = R.CUSTOMER_ID
    GROUP BY C.NAME
    ORDER BY Review_Count DESC
) WHERE ROWNUM = 1;


-- ----------------------------------------------------------------------------
-- 8. DATA QUALITY CHECK
-- ----------------------------------------------------------------------------
-- Purpose: Find Orders That Lack Corresponding Payment Details
-- Use Case: Identify data integrity issues and incomplete transactions

SELECT O.Order_ID, O.Customer_ID, O.Order_Date
FROM ORDER1 O
LEFT JOIN PAYMENTS1 P ON O.Order_ID = P.Order_ID
WHERE P.Payment_ID IS NULL;


-- ============================================================================
-- END OF DOCUMENT
-- ============================================================================