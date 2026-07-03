select * from C1;

--1 Find the total number of customers in the bank.
select count(*) from C1;

--2 Find all customers whose monthly income is greater than ₹50,000.
select Customer_ID from C1 where Customer_ID>50000

--3 How many customers have churned?
SELECT COUNT(*) AS CHURNED_CUSTOMERS
FROM C1 
where Churn_status= 1;

--4 Show all customers from Mumbai.
select * from C1 
WHERE  
CITY='MUMBAI';

--5 Average Monthly Income
SELECT AVG(Monthly_Income) as AVG_BALANCE
from C1;

--6 Top 10 High-Risk Customers
SELECT TOP 10 CUSTOMER_ID, Estimated_Churn_Risk FROM C1
ORDER BY Estimated_Churn_Risk DESC;

--7 City-wise Customer Count
SELECT CITY ,COUNT(*) AS CUSTOMER_COUNT FROM C1 group by city;

--8 Average Credit Score by City
SELECT city , AVG(credit_score) as avg_credit_score
from C1
group by City;

--9 Cities with More Than 500 Customers
select City,
COUNT(*) AS TOTAL_CUSTOMERS
FROM C1
group by City 
HAVING COUNT(*)>500 ;

--10 Customers Above Average Income (Subquery)
SELECT CUSTOMER_ID ,Monthly_Income from c1 
where monthly_income>(
select avg(monthly_income) from c1);

--11 Customers with Highest Credit Score
SELECT *
FROM c1
WHERE Credit_Score =
(
    SELECT MAX(Credit_Score)
    FROM c1
);
--12 Churn Risk Classification (CASE)
SELECT Customer_ID,Estimated_churn_risk,
Case 
           WHEN Estimated_Churn_Risk >= 70 THEN 'High Risk'
           WHEN Estimated_Churn_Risk >= 40 THEN 'Medium Risk'
           ELSE 'Low Risk' 
                  END AS Risk_Category
FROM C1;

--13 Show customers sorted by income
SELECT * FROM C1 ORDER BY MONTHLY_INCOME DESC;

--14 Cities with average income above 60000:
SELECT CITY ,AVG(MONTHLY_INCOME) AS AVG_INCOME_CITYWISE
FROM C1
GROUP BY CITY 
HAVING AVG(MONTHLY_INCOME)>60000;

--15 INNER JOIN
SELECT A.CUSTOMER_ID,A.CITY,B.CHURN_STATUS FROM 
C1 A  INNER JOIN
C1 B ON A.Customer_ID= B.Customer_ID;

--16 Customers with maximum credit score
SELECT * FROM C1
WHERE
CREDIT_SCORE =(
SELECT MAX(CREDIT_SCORE) 
FROM C1);

--17 Customers with minimum churn risk
SELECT * FROM C1
WHERE ESTIMATED_CHURN_RISK =(
SELECT MIN(ESTIMATED_CHURN_RISK)
FROM C1);

--18 Customers having income above city average
SELECT CUSTOMER_ID ,CITY ,MONTHLY_INCOME FROM C1 B1
WHERE MONTHLY_INCOME >(
SELECT AVG(MONTHLY_INCOME) FROM C1 B2
WHERE  B1.CITY= B2.CITY);

--19 Customers with credit score below average
SELECT * FROM C1 
WHERE Credit_Score <(
SELECT AVG(CREDIT_SCORE) FROM C1);

--20 Top income customer
SELECT CUSTOMER_ID,MONTHLY_INCOME FROM C1 WHERE 
MONTHLY_INCOME= (
SELECT MAX(MONTHLY_INCOME) FROM C1);

--21 Cities with above-average churn risk
SELECT City,
       AVG(Estimated_Churn_Risk) AS Avg_Churn_Risk
FROM C1
GROUP BY City
HAVING AVG(Estimated_Churn_Risk) >
(
    SELECT AVG(Estimated_Churn_Risk)
    FROM C1
);
--22 Customers having more transactions than average
SELECT * FROM C1
WHERE Number_of_Transactions>(
SELECT AVG(Number_of_Transactions)
FROM C1);

--23 High-income and low-credit customers
SELECT * FROM C1 
WHERE MONTHLY_INCOME >
(SELECT AVG(MONTHLY_INCOME)
FROM C1
)
AND CREDIT_SCORE <(
SELECT AVG(CREDIT_SCORE)
FROM C1);

--24 Customers above average UPI spend
SELECT * FROM C1
WHERE Avg_UPI_Spend >(
SELECT AVG(Avg_UPI_Spend)
FROM C1);

--25 Second Highest Income
SELECT MAX(MONTHLY_INCOME)
FROM C1 WHERE
MONTHLY_INCOME <(
SELECT MAX(MONTHLY_INCOME) AS SECOND_HIGHEST 
FROM C1);

--26 Customers with highest balance in each city
SELECT CITY ,AVG_MONTHLY_BALANCE,CUSTOMER_ID FROM  C1 B1 
WHERE Avg_Monthly_Balance =(
SELECT MAX(Avg_Monthly_Balance)
FROM C1 B2 
WHERE B1.CITY=B2.CITY);

--27 Customers with churn risk above city average
SELECT CITY ,CUSTOMER_ID,Estimated_Churn_Risk FROM C1 AS B1
WHERE Estimated_Churn_Risk >(
SELECT AVG(Estimated_Churn_Risk) FROM C1 B2
WHERE B1.CITY=B2.CITY);

--28 Customers with reward points above average
SELECT CUSTOMER_ID ,Reward_Points_Used FROM C1 
WHERE REWARD_POINTS_USED >(
SELECT AVG(REWARD_POINTS_USED) FROM C1);

--29 Customers with income equal to highest income
SELECT CUSTOMER_ID,MONTHLY_INCOME FROM C1 WHERE 
MONTHLY_INCOME = (
SELECT TOP 1 MONTHLY_INCOME FROM C1
ORDER BY  MONTHLY_INCOME  DESC);

--30 Self Join (Using the Same Table)
-- Find customers from the same city
SELECT A.Customer_ID,
       A.City,
       B.Customer_ID
FROM C1 A
INNER JOIN C1 B
ON A.City = B.City
AND A.Customer_ID <> B.Customer_ID;

--31 Assign Row Number Based on Income
--Give each customer a unique rank based on Monthly_Income
select customer_id,monthly_income,
row_number() over(order by monthly_income desc) as rn
from c1;

--32 Rank Customers by Credit Score
--Rank customers according to Credit_Score.
select customer_id,Credit_Score ,
rank() over( order by credit_score desc)
from c1;

--33 Dense Rank by Income
select customer_id,monthly_income ,
dense_rank() over(order by monthly_income desc) as dn
from c1;

--34 Find top 3 highest-income customers from every city.
WITH CTE AS
(
SELECT Customer_ID,
       City,
       Monthly_Income,
       DENSE_RANK() OVER
       (
          PARTITION BY City
          ORDER BY Monthly_Income DESC
       ) AS RankNo
FROM C1
)
SELECT *
FROM CTE
WHERE RankNo <= 3;

--35 Previous Customer Income (LAG)
--Show previous customer's income.

select customer_id,monthly_income,
LAG(MONTHLY_INCOME) OVER(ORDER BY CUSTOMER_ID)
AS PREVIOUS_INCOME
FROM C1;

--36 Next Customer Income (LEAD)
--Show next customer's income.

SELECT CUSTOMER_ID,MONTHLY_INCOME ,
LEAD(MONTHLY_INCOME) OVER(ORDER BY CUSTOMER_ID)
AS NEXT_INCOME
FROM C1;

--37 Income Difference from Previous Customer
--Calculate income difference with previous customer.

SELECT CUSTOMER_ID,MONTHLY_INCOME,
MONTHLY_INCOME -
LAG(MONTHLY_INCOME) OVER(ORDER BY CUSTOMER_ID)
AS DIFFERENCE FROM C1;

--38 Running Total of Monthly Income
--Calculate cumulative income.

SELECT CUSTOMER_ID,MONTHLY_INCOME,
SUM(MONTHLY_INCOME) OVER( ORDER BY CUSTOMER_ID) AS RUNNING_TOTAL
FROM C1;

--39 Average Income by City
--Show each customer's income and city average.

SELECT CUSTOMER_ID ,CITY,MONTHLY_INCOME,
AVG(MONTHLY_INCOME) 
OVER (PARTITION BY CITY ) AS AVG_INCOME
FROM C1;

--40 Maximum Income in Each City
--Show highest income within each city.

SELECT Customer_ID,
       City,
       Monthly_Income,
       MAX(Monthly_Income)
       OVER(PARTITION BY City)
       AS Max_City_Income
FROM C1;


-- 41 Minimum Credit Score by City
--Find lowest credit score within each city.
SELECT Customer_ID,
       City,
       Credit_Score,
       MIN(Credit_Score)
       OVER(PARTITION BY City)
       AS Min_Credit_Score
FROM C1;

--42 Quartile Analysis Using NTILE
--Divide customers into 4 income groups.

SELECT Customer_ID,
       Monthly_Income,
       NTILE(4)
       OVER(ORDER BY Monthly_Income)
       AS Income_Quartile
FROM C1;

--43 Percent Rank
--Calculate percentile ranking of income.
SELECT Customer_ID,
       Monthly_Income,
       PERCENT_RANK()
       OVER(ORDER BY Monthly_Income)
       AS PercentRank
FROM C1;

--44 Cumulative Churn Risk by City
--Calculate cumulative churn risk within each city.

SELECT Customer_ID,
       City,
       Estimated_Churn_Risk,
       SUM(Estimated_Churn_Risk)
       OVER
       (
         PARTITION BY City
         ORDER BY Customer_ID
       ) AS Running_Churn_Risk
FROM C1;

--45 Compare Customer Income with City Average
--Find customers earning above city average.

SELECT *
FROM
(
    SELECT Customer_ID,
           City,
           Monthly_Income,
           AVG(Monthly_Income)
           OVER(PARTITION BY City) AS CityAvg
    FROM C1
) X
WHERE Monthly_Income > CityAvg;

--46 Top 3 Highest Income Customers in Each City

WITH IncomeRank AS
(
SELECT Customer_ID,
       City,
       Monthly_Income,

       DENSE_RANK() OVER
       (
          PARTITION BY City
          ORDER BY Monthly_Income DESC
       ) AS RankNo

FROM C1
)

SELECT *
FROM IncomeRank
WHERE RankNo <= 3;

--47 Rank Customers by Credit Score
WITH RANKCUST AS
(
select customer_id,credit_score ,
RANK() OVER (ORDER by credit_score desc )as creditrank
from c1 
)
select * from rankcust;

--48 Customers Above City Average Income
WITH AVGINCOMEE AS
(
SELECT CUSTOMER_ID,CITY,MONTHLY_INCOME,
AVG(MONTHLY_INCOME)
OVER(PARTITION BY CITY)
AS AVERAGE 
FROM C1 
)

SELECT * FROM AVGINCOMEE 
WHERE MONTHLY_INCOME > AVERAGE;

--49 Churn Risk Ranking per City

WITH CHURNRISK AS 
(
SELECT CUSTOMER_ID,ESTIMATED_CHURN_RISK,CITY ,
RANK() OVER ( PARTITION BY CITY ORDER BY ESTIMATED_CHURN_RISK DESC)
AS CITYCHURN
FROM C1
)
 
SELECT * FROM CHURNRISK;

--50 Find Customers with Income Higher Than Previous Customer

WITH COMPAREINCOME AS 
(
SELECT CUSTOMER_ID,MONTHLY_INCOME,

LAG(MONTHLY_INCOME) OVER (ORDER BY CUSTOMER_ID)
AS PREVINCOME
FROM C1
)
SELECT *
FROM CompareIncome
WHERE Monthly_Income > PrevIncome;

--51 High Income Customers

WITH HIGHINCOME AS
(
SELECT CUSTOMER_ID,MONTHLY_INCOME 
FROM C1 
WHERE MONTHLY_INCOME >50000
)
SELECT * FROM HIGHINCOME;


--52 Customers From Specific City

WITH MUMBAICUST AS
(
SELECT CUSTOMER_ID,CITY FROM C1
WHERE CITY='MUMBAI'
)
SELECT * FROM MUMBAICUST;

--53 Calculate average monthly income city-wise.
WITH CityIncome AS
(
SELECT City,
       AVG(Monthly_Income) AS AvgIncome
FROM C1
GROUP BY City
)

SELECT *
FROM CityIncome;

--54 Count Customers Per City

WITH CustomerCount AS
(
SELECT City,
       COUNT(*) AS TotalCustomers
FROM C1
GROUP BY City
)

SELECT *
FROM CustomerCount;

--55 Customers Above Average Income

WITH AVGINCOME AS 
(
SELECT AVG(MONTHLY_INCOME) AS AVGSAL FROM C1
)
SELECT Customer_ID,
       Monthly_Income
FROM C1, AVGINCOME 
WHERE Monthly_Income > AvgSal;

--56 Customers Having Approved Loans

WITH APPROVEDLOANS AS 
(
SELECT CUSTOMER_ID,LOAN_STATUS FROM C1
WHERE LOAN_STATUS ='APPROVED'
)
SELECT * FROM APPROVEDLOANS;

-- 57 Customers With More Than 20 Transactions 

WITH FREQUENTCUST AS(
SELECT CUSTOMER_ID ,NUMBER_OF_TRANSACTIONS FROM C1
WHERE NUMBER_OF_TRANSACTIONS >20
)
SELECT * FROM FREQUENTCUST;

--58 Create procedure to find customers with churn risk above 70.
GO

CREATE PROCEDURE GetHighRiskCustomers
AS
BEGIN
SELECT *
FROM C1;
END;

GO

--59 High Risk Customer Detection (Most Important)
--Purpose: Identify customers likely to leave.

GO

CREATE PROCEDURE HighRiskCustomers
AS
BEGIN

SELECT Customer_ID,
       Estimated_Churn_Risk,
       Credit_Score

FROM C1

WHERE Estimated_Churn_Risk > 70;

END;

GO

EXEC HighRiskCustomers;

--60 Customer Search by City (Parameterized)
--Purpose: Analyze customers location-wise.
GO
CREATE PROCEDURE GetCustomersByCity
@CityName VARCHAR(50)

AS
BEGIN

SELECT Customer_ID,
       City,
       Monthly_Income

FROM C1

WHERE City=@CityName;

END;
GO

EXEC GetCustomersByCity 'Mumbai';

--61 Churn Candidate Detection (Business Procedure)
--Purpose: Find customers likely to churn.

GO

CREATE PROCEDURE ChurnCandidates
AS
BEGIN

SELECT Customer_ID,
       Credit_Score,
       Estimated_Churn_Risk,
       Mobile_App_Login_Freq

FROM C1

WHERE Credit_Score < 650
AND Estimated_Churn_Risk > 70
AND Mobile_App_Login_Freq < 5;

END;

GO

EXEC ChurnCandidates;

--62 Income-Based Customer Segmentation
--Purpose: Filter customers using parameters.

GO

CREATE PROCEDURE IncomeFilter
@Income FLOAT

AS
BEGIN

SELECT Customer_ID,
       Monthly_Income

FROM C1

WHERE Monthly_Income > @Income;

END;

GO
EXEC IncomeFilter 50000;

--63 City-wise Customer Summary
--Purpose: Management reporting.

GO

CREATE PROCEDURE CustomerCountCity
AS
BEGIN

SELECT City,
       COUNT(*) AS TotalCustomers

FROM C1

GROUP BY City;

END;

GO

EXEC CustomerCountCity;

--64 Churn Summary Dashboard Procedure
--Purpose: Reporting for management.

GO

CREATE PROCEDURE ChurnSummary
AS
BEGIN

SELECT Churn_Status,
       COUNT(*) AS TotalCustomers

FROM C1

GROUP BY Churn_Status;

END;

GO

exec ChurnSummary;

--65 High Risk Customers View ⭐
--Purpose: Identify customers likely to churn.
GO

CREATE VIEW HighRiskCustomers1
AS

SELECT Customer_ID,
       Estimated_Churn_Risk,
       Credit_Score,
       City

FROM C1

WHERE Estimated_Churn_Risk > 70;

GO

SELECT *
FROM HighRiskCustomers1;

--66 Churn Candidate View 
--Purpose: Find customers requiring retention action.

GO

CREATE VIEW ChurnCandidates1
AS

SELECT Customer_ID,
       Credit_Score,
       Estimated_Churn_Risk,
       Mobile_App_Login_Freq

FROM C1

WHERE Credit_Score < 650
AND Estimated_Churn_Risk > 70
AND Mobile_App_Login_Freq < 5;

GO

SELECT *
FROM ChurnCandidates1;

--67 Financial Profile View
--Purpose: Customer financial summary.

GO

CREATE VIEW FinancialProfile
AS

SELECT Customer_ID,
       Monthly_Income,
       Avg_Monthly_Balance,
       Credit_Score

FROM C1;

GO

SELECT * FROM FINANCIALPROFILE;

--68 City-wise Income Summary View
--Purpose: Reporting and analytics.

GO

CREATE VIEW CityIncomeSummary
AS

SELECT City,
       AVG(Monthly_Income) AS AvgIncome,
       COUNT(*) AS Customers

FROM C1

GROUP BY City;

GO
SELECT *
FROM CityIncomeSummary;


--69 Loan Analysis View
--Purpose: Analyze loan customers.

GO

CREATE VIEW LoanAnalysis
AS

SELECT Customer_ID,
       Loan_Status,
       Credit_Score,
       Monthly_Income

FROM C1;

GO
SELECT *
FROM LoanAnalysis;

--70 . Digital Engagement View 

--Purpose: Analyze digital banking behavior.

GO

CREATE VIEW DigitalEngagement
AS

SELECT Customer_ID,
       Mobile_App_Login_Freq,
       UPI_Transactions,
       Digital_Engagement_Score

FROM C1;

GO

SELECT *
FROM DigitalEngagement;



select Occupation, MONTHLY_INCOME from C1;

UPDATE C1
SET Monthly_Income = ABS(CHECKSUM(NEWID())) % 10000 + 5000
WHERE Occupation = 'Student'
AND Monthly_Income > 15000;

select Occupation, MONTHLY_INCOME from C1;


-- Update retired incomes
UPDATE C1
SET Monthly_Income = ABS(CHECKSUM(NEWID())) % 25000 + 10000
WHERE Occupation = 'Retired'
AND Monthly_Income > 35000;

select Occupation, MONTHLY_INCOME from C1;

SELECT Occupation,
       AVG(Monthly_Income) AS Avg_Income,
       MIN(Monthly_Income) AS Min_Income,
       MAX(Monthly_Income) AS Max_Income
FROM C1
GROUP BY Occupation
ORDER BY Avg_Income DESC;



CREATE TABLE Customer_Demographics (
    Customer_ID INT PRIMARY KEY,
    Age INT,
    Gender VARCHAR(20),
    City VARCHAR(50),
    Occupation VARCHAR(50),
    Account_Type VARCHAR(20),
    Account_Tenure_Years INT
);

INSERT INTO Customer_Demographics
SELECT
    Customer_ID,
    Age,
    Gender,
    City,
    Occupation,
    Account_Type,
    Account_Tenure_Years
FROM C1;

select * from  Customer_Demographics;


CREATE TABLE Customer_Financials (
    Customer_ID INT PRIMARY KEY,
    Monthly_Income DECIMAL(12,2),
    Avg_Monthly_Balance DECIMAL(12,2),
    Credit_Score INT,
    Number_of_Transactions INT,
    Last_Transaction_Days_Ago INT,
    Credit_Card_Utilization DECIMAL(5,2),
    Avg_UPI_Spend DECIMAL(10,2),
    UPI_Transactions INT,
    Reward_Points_Used DECIMAL(10,2),
    Loan_Applied VARCHAR(10),
    Loan_Status VARCHAR(20)
);

INSERT INTO Customer_Financials
SELECT
    Customer_ID,
    Monthly_Income,
    Avg_Monthly_Balance,
    Credit_Score,
    Number_of_Transactions,
    Last_Transaction_Days_Ago,
    Credit_Card_Utilization,
    Avg_UPI_Spend,
    UPI_Transactions,
    Reward_Points_Used,
    Loan_Applied,
    Loan_Status
FROM C1;

select * from Customer_Financials;

CREATE TABLE Customer_Churn (
    Customer_ID INT PRIMARY KEY,
    Digital_Engagement_Score INT,
    Mobile_App_Login_Freq INT,
    Internet_Banking_Active VARCHAR(10),
    Complaint_Count INT,
    Financial_Stress_Score INT,
    Estimated_Churn_Risk INT,
    Churn_Status VARCHAR(10),
    Retention_Recommendation VARCHAR(100),
    Competitor_Bank_Usage VARCHAR(10)
);

INSERT INTO Customer_Churn
SELECT
    Customer_ID,
    Digital_Engagement_Score,
    Mobile_App_Login_Freq,
    Internet_Banking_Active,
    Complaint_Count,
    Financial_Stress_Score,
    Estimated_Churn_Risk,
    Churn_Status,
    Retention_Recommendation,
    Competitor_Bank_Usage
FROM C1;

select * from  Customer_Churn;



ALTER TABLE Customer_Financials
ADD CONSTRAINT FK_Financials
FOREIGN KEY (Customer_ID)
REFERENCES Customer_Demographics(Customer_ID);


ALTER TABLE Customer_Churn
ADD CONSTRAINT FK_Churn
FOREIGN KEY (Customer_ID)
REFERENCES Customer_Demographics(Customer_ID);

SELECT TOP 5 * FROM Customer_Demographics;

SELECT TOP 5 * FROM Customer_Financials;

SELECT TOP 5 * FROM Customer_Churn;

---JOINS---
--- Q1: Full customer profile with churn status

SELECT
    D.Customer_ID,D.Age,D.City,
    D.Occupation,F.Monthly_Income,
    F.Credit_Score,F.Avg_Monthly_Balance,
    C.Churn_Status,
    C.Estimated_Churn_Risk
FROM Customer_Demographics D
INNER JOIN Customer_Financials F
    ON D.Customer_ID = F.Customer_ID
INNER JOIN Customer_Churn C
    ON D.Customer_ID = C.Customer_ID
ORDER BY C.Estimated_Churn_Risk DESC;


--2 Show customers whose churn risk is above 70 along with income and credit score.

SELECT d.customer_id,d.city,d.occupation ,
f.monthly_income,f.credit_score ,c.estimated_churn_risk
FROM Customer_Demographics d
INNER JOIN Customer_Financials f
    ON d.Customer_ID = f.Customer_ID
INNER JOIN Customer_Churn C
    ON d.Customer_ID = c.Customer_ID
    where c.Estimated_Churn_Risk>70
    order by c.Estimated_Churn_Risk desc;

--3 Find customers who have demographic records but no financial record.
SELECT
    D.Customer_ID,
    D.City
FROM Customer_Demographics D
LEFT JOIN Customer_Financials F
ON D.Customer_ID = F.Customer_ID
WHERE F.Customer_ID IS NULL;

--4 List all customers along with financial details wherever available.
SELECT
    D.Customer_ID,
    D.City,
    F.Monthly_Income,
    F.Credit_Score
FROM Customer_Demographics D
LEFT JOIN Customer_Financials F
ON D.Customer_ID = F.Customer_ID;

--5 Find financial records that do not have matching demographic information.
SELECT
    F.Customer_ID,
    F.Monthly_Income
FROM Customer_Demographics D
RIGHT JOIN Customer_Financials F
ON D.Customer_ID = F.Customer_ID
WHERE D.Customer_ID IS NULL;

--6 Show all financial records and matching customer information.
SELECT
    D.City,
    F.Monthly_Income,
    F.Credit_Score
FROM Customer_Demographics D
RIGHT JOIN Customer_Financials F
ON D.Customer_ID = F.Customer_ID;

--6 Find customers from the same city
SELECT
    A.Customer_ID,
    B.Customer_ID,
    A.City
FROM Customer_Demographics A
INNER JOIN Customer_Demographics B
ON A.City = B.City
AND A.Customer_ID <> B.Customer_ID;

--7 Find customers having the same occupation.
SELECT
    A.Customer_ID,
    B.Customer_ID,
    A.Occupation
FROM Customer_Demographics A
INNER JOIN Customer_Demographics B
ON A.Occupation = B.Occupation
AND A.Customer_ID <> B.Customer_ID;

--8 Generate all possible combinations of cities and loan statuses.
SELECT
    D.City,
    F.Loan_Status
FROM Customer_Demographics D
CROSS JOIN Customer_Financials F;

