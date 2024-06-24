CREATE DATABASE Task;
GO

USE Task;
GO

--TASK 1:
-- Creating Projects table
CREATE TABLE Projects (
    Task_ID INT PRIMARY KEY,
    Start_Date DATE,
    End_Date DATE
);

INSERT INTO Projects (Task_ID, Start_Date, End_Date) VALUES
(1, '2015-10-28', '2015-10-29'),
(2, '2015-10-30', '2015-10-31'),
(3, '2015-10-13', '2015-10-15'),
(4, '2015-10-01', '2015-10-04');


WITH ProjectGroups AS (
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) - 
        ROW_NUMBER() OVER (ORDER BY End_Date) AS ProjectGroup
    FROM 
        Projects
)
SELECT 
    MIN(Start_Date) AS Project_Start_Date,
    MAX(End_Date) AS Project_End_Date
FROM 
    ProjectGroups
GROUP BY 
    ProjectGroup
ORDER BY 
    DATEDIFF(day, MIN(Start_Date), MAX(End_Date)), MIN(Start_Date);

-- TASK 2:

CREATE TABLE Students (
    ID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL
);

CREATE TABLE Friends (
    ID INT PRIMARY KEY,
    Friend_ID INT NOT NULL,
    FOREIGN KEY (ID) REFERENCES Students(ID),
    FOREIGN KEY (Friend_ID) REFERENCES Students(ID)
);

CREATE TABLE Packages (
    ID INT PRIMARY KEY,
    Salary FLOAT NOT NULL
);


INSERT INTO Students (ID, Name) VALUES
(1, 'Ashley'),
(2, 'Samantha'),
(3, 'Julio'),
(4, 'Scarlet');

INSERT INTO Friends (ID, Friend_ID) VALUES
(2, 4),
(3, 4),
(4, 2);

INSERT INTO Packages (ID, Salary) VALUES
(1, 10.50),
(2, 10.00),
(3, 12.00),
(4, 15.00);


SELECT 
    s.Name
FROM 
    Students s
JOIN 
    Friends f ON s.ID = f.ID
JOIN 
    Packages sp ON s.ID = sp.ID
JOIN 
    Packages fp ON f.Friend_ID = fp.ID
WHERE 
    fp.Salary > sp.Salary
ORDER BY 
    fp.Salary;

-- TASK 3:

CREATE TABLE Functions (
    X INT,
    Y INT
);

INSERT INTO Functions (X, Y) VALUES
(20, 20),
(20, 20),
(20, 21),
(23, 22),
(22, 23),
(21, 20);


SELECT DISTINCT
    f1.X, f1.Y
FROM 
    Functions f1
JOIN 
    Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE 
    f1.X < f1.Y
ORDER BY 
    f1.X, f1.Y;


-- TASK 4:

-- Create the Contests table
CREATE TABLE Contest (
    contest_id VARCHAR(255),
    hacker_id INT,
    name VARCHAR(255)
);

-- Insert data into Contests table
INSERT INTO Contest (contest_id, hacker_id, name) VALUES 
('664D6', 17973, 'Rose'),
('66556', 79153, 'Angela'),
('94BZ8', 80275, 'Frank');

-- Create the Colleges table
CREATE TABLE College (
    college_id INT,
    contest_id VARCHAR(255)
);

-- Insert data into Colleges table
INSERT INTO College (college_id, contest_id) VALUES 
(11219, '66406'),
(32473, '66556'),
(56685, '72974');

-- Create the Challenges table
CREATE TABLE Challenges (
    challenge_id VARCHAR(255),
    college_id INT
);

-- Insert data into Challenges table
INSERT INTO Challenges (challenge_id, college_id) VALUES 
('47127', 11219),
('18765', 11219),
('32473', 66556),
('60292', 32473),
('72974', 56685);

-- Create the View_Stats table
CREATE TABLE View_Stats (
    challenge_id VARCHAR(255),
    total_views INT,
    total_unique_views INT
);

-- Insert data into View_Stats table
INSERT INTO View_Stats (challenge_id, total_views, total_unique_views) VALUES 
('47127', 26, 19),
('47127', 15, 14),
('18765', 43, 10),
('18765', 72, 13),
('75516', 85, 17),
('60292', 11, 10),
('72974', 41, 15),
('75516', 75, 11);

-- Create the Submission_Stats table
CREATE TABLE Submission_Stats (
    challenge_id VARCHAR(255),
    total_submissions INT,
    total_accepted_submissions INT
);

-- Insert data into Submission_Stats table
INSERT INTO Submission_Stats (challenge_id, total_submissions, total_accepted_submissions) VALUES 
('75516', 34, 12),
('47127', 27, 10),
('47127', 56, 18),
('75516', 74, 12),
('75516', 83, 8),
('72974', 68, 24),
('72974', 82, 14),
('47127', 28, 11);


-- Create the CTE to aggregate data for each contest
WITH ChallengeStats AS (
    SELECT
        col.contest_id,
        SUM(ISNULL(vs.total_views, 0)) AS total_views,
        SUM(ISNULL(vs.total_unique_views, 0)) AS total_unique_views,
        SUM(ISNULL(ss.total_submissions, 0)) AS total_submissions,
        SUM(ISNULL(ss.total_accepted_submissions, 0)) AS total_accepted_submissions
    FROM College col
    JOIN Challenges ch ON col.college_id = ch.college_id
    LEFT JOIN View_Stats vs ON ch.challenge_id = vs.challenge_id
    LEFT JOIN Submission_Stats ss ON ch.challenge_id = ss.challenge_id
    GROUP BY col.contest_id
)
SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    ISNULL(cs.total_submissions, 0) AS total_submissions,
    ISNULL(cs.total_accepted_submissions, 0) AS total_accepted_submissions,
    ISNULL(cs.total_views, 0) AS total_views,
    ISNULL(cs.total_unique_views, 0) AS total_unique_views
FROM Contest c
LEFT JOIN ChallengeStats cs ON c.contest_id = cs.contest_id
WHERE 
    ISNULL(cs.total_submissions, 0) > 0 OR
    ISNULL(cs.total_accepted_submissions, 0) > 0 OR
    ISNULL(cs.total_views, 0) > 0 OR
    ISNULL(cs.total_unique_views, 0) > 0
ORDER BY c.contest_id;


-- TASK 5;
-- Creating the Hackers table
CREATE TABLE Hackers (
    hacker_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100)
);

-- Creating the Submissions table
CREATE TABLE Submissions (
    submission_date DATE,
    submission_id VARCHAR(20) PRIMARY KEY,
    hacker_id VARCHAR(20),
    score INT,
    FOREIGN KEY (hacker_id) REFERENCES Hackers(hacker_id)
);

-- Inserting values into Hackers table
INSERT INTO Hackers (hacker_id, name) VALUES ('15758', 'Rose');
INSERT INTO Hackers (hacker_id, name) VALUES ('20703', 'Angela');
INSERT INTO Hackers (hacker_id, name) VALUES ('36396', 'Frank');
INSERT INTO Hackers (hacker_id, name) VALUES ('38289', 'Patrick');
INSERT INTO Hackers (hacker_id, name) VALUES ('44065', 'Lisa');
INSERT INTO Hackers (hacker_id, name) VALUES ('53473', 'Kimberly');
INSERT INTO Hackers (hacker_id, name) VALUES ('62529', 'Bonnie');
INSERT INTO Hackers (hacker_id, name) VALUES ('79722', 'Michael');

-- Inserting values into Submissions table
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-01', '8494', '20703', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-01', '22403', '53473', 15);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-01', '23965', '79722', 60);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-01', '30173', '36396', 70);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-02', '34928', '20703', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-02', '38740', '15758', 60);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-02', '42769', '79722', 25);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-02', '44364', '79722', 60);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-03', '45440', '20703', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-03', '49050', '36396', 70);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-03', '50273', '79722', 5);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-04', '50344', '20703', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-04', '51360', '44065', 90);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-04', '54404', '53473', 65);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-04', '61533', '79722', 45);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-05', '72852', '20703', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-05', '74546', '38289', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-05', '76487', '62529', 0);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-05', '82439', '36396', 10);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-05', '90006', '36396', 40);
INSERT INTO Submissions (submission_date, submission_id, hacker_id, score) VALUES ('2016-03-06', '90404', '20703', 0);

-- SQL Query to get the desired output
WITH DailySubmissions AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(*) AS submission_count
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
MaxSubmissionsPerDay AS (
    SELECT 
        submission_date,
        hacker_id,
        submission_count
    FROM (
        SELECT 
            submission_date,
            hacker_id,
            submission_count,
            RANK() OVER (PARTITION BY submission_date ORDER BY submission_count DESC, hacker_id) AS rnk
        FROM DailySubmissions
    ) AS ranked
    WHERE rnk = 1
),
UniqueHackersPerDay AS (
    SELECT 
        submission_date,
        COUNT(DISTINCT hacker_id) AS unique_hacker_count
    FROM Submissions
    GROUP BY submission_date
)
SELECT 
    u.submission_date,
    u.unique_hacker_count,
    m.hacker_id,
    h.name
FROM UniqueHackersPerDay u
JOIN MaxSubmissionsPerDay m ON u.submission_date = m.submission_date
JOIN Hackers h ON m.hacker_id = h.hacker_id
ORDER BY u.submission_date;


-- TASK 6:

CREATE TABLE STATION (
    ID INT PRIMARY KEY,
    CITY VARCHAR(21),
    STATE CHAR(2),
    LAT_N FLOAT,
    LONG_W FLOAT
);

-- Inserting sample data into the STATION table
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (1, 'New York', 'NY', 40.7128, 74.0060);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (2, 'Los Angeles', 'CA', 34.0522, 118.2437);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (3, 'Chicago', 'IL', 41.8781, 87.6298);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (4, 'Houston', 'TX', 29.7604, 95.3698);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (5, 'Phoenix', 'AZ', 33.4484, 112.0740);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (6, 'Philadelphia', 'PA', 39.9526, 75.1652);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (7, 'San Antonio', 'TX', 29.4241, 98.4936);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (8, 'San Diego', 'CA', 32.7157, 117.1611);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (9, 'Dallas', 'TX', 32.7767, 96.7970);
INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES (10, 'San Jose', 'CA', 37.3382, 121.8863);

-- Query to calculate the Manhattan Distance
SELECT ROUND(ABS(MIN_LAT_N.LAT_N - MAX_LAT_N.LAT_N) + ABS(MIN_LONG_W.LONG_W - MAX_LONG_W.LONG_W), 4) AS ManhattanDistance
FROM 
    (SELECT TOP 1 LAT_N FROM STATION ORDER BY LAT_N ASC) AS MIN_LAT_N,
    (SELECT TOP 1 LAT_N FROM STATION ORDER BY LAT_N DESC) AS MAX_LAT_N,
    (SELECT TOP 1 LONG_W FROM STATION ORDER BY LONG_W ASC) AS MIN_LONG_W,
    (SELECT TOP 1 LONG_W FROM STATION ORDER BY LONG_W DESC) AS MAX_LONG_W;

-- TASK 7:

-- Create a numbers table with numbers from 2 to 1000
WITH Numbers AS (
    SELECT TOP (999) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + 1 AS num
    FROM master..spt_values
)
-- Select prime numbers using the Sieve of Eratosthenes algorithm
SELECT STRING_AGG(CAST(num AS VARCHAR(10)), '&') AS prime_numbers
FROM (
    SELECT DISTINCT n.num
    FROM Numbers n
    LEFT JOIN Numbers d ON d.num <= SQRT(n.num) AND n.num % d.num = 0
    WHERE d.num IS NULL
    AND n.num <= 1000
    AND n.num > 1
) AS primes;


-- TASK 8:


-- Create OCCUPATIONS table
CREATE TABLE OCCUPATIONS (
    Name VARCHAR(50),
    Occupation VARCHAR(20)
);

-- Insert sample data into OCCUPATIONS table
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jenny', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ashley', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Meera', 'Singer');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Jane', 'Actor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Samantha', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Christeen', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Priya', 'Singer');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Julia', 'Doctor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Ketty', 'Professor');
INSERT INTO OCCUPATIONS (Name, Occupation) VALUES ('Maria', 'Actor');


-- Query to pivot the Occupation column
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name ELSE NULL END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name ELSE NULL END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name ELSE NULL END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name ELSE NULL END) AS Actor
FROM (
    SELECT Name, Occupation,
           ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
) AS pivoted
GROUP BY rn
ORDER BY rn;



-- TASK 9:

CREATE TABLE BST (
    N INTEGER,
    P INTEGER
);

INSERT INTO BST (N, P) VALUES (5, NULL);   -- Node 5 is Root
INSERT INTO BST (N, P) VALUES (8, 5);      -- Node 3 is Leaf
INSERT INTO BST (N, P) VALUES (2, 5);      -- Node 6 is Leaf
INSERT INTO BST (N, P) VALUES (3, 2);      -- Node 3 is Leaf
INSERT INTO BST (N, P) VALUES (1, 2);      -- Node 1 is Leaf
INSERT INTO BST (N, P) VALUES (9, 8);
INSERT INTO BST (N, P) VALUES (6, 8);

SELECT 
    N,
    CASE 
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS Node_Type
FROM BST
ORDER BY N;


-- TASK 10:

CREATE TABLE Company (
    company_code INT PRIMARY KEY,
    founder VARCHAR(100)
);

CREATE TABLE Lead_Manager (
    company_code INT,
    lead_manager_code INT
);

CREATE TABLE Senior_Manager (
    company_code INT,
    senior_manager_code INT
);

CREATE TABLE Manager (
    company_code INT,
    manager_code INT
);

CREATE TABLE Employee (
    company_code INT,
    employee_code INT
);

INSERT INTO Company (company_code, founder) VALUES
(1, 'Alice'),
(2, 'Bob');

INSERT INTO Lead_Manager (company_code, lead_manager_code) VALUES
(1, 101),
(2, 102);

INSERT INTO Senior_Manager (company_code, senior_manager_code) VALUES
(1, 201),
(2, 202);

INSERT INTO Manager (company_code, manager_code) VALUES
(1, 301),
(2, 302);

INSERT INTO Employee (company_code, employee_code) VALUES
(1, 401),
(2, 402);



WITH LeadManagerCount AS (
    SELECT company_code, COUNT(DISTINCT lead_manager_code) AS total_lead_managers
    FROM Lead_Manager
    GROUP BY company_code
),
SeniorManagerCount AS (
    SELECT company_code, COUNT(DISTINCT senior_manager_code) AS total_senior_managers
    FROM Senior_Manager
    GROUP BY company_code
),
ManagerCount AS (
    SELECT company_code, COUNT(DISTINCT manager_code) AS total_managers
    FROM Manager
    GROUP BY company_code
),
EmployeeCount AS (
    SELECT company_code, COUNT(DISTINCT employee_code) AS total_employees
    FROM Employee
    GROUP BY company_code
)
SELECT C.company_code, 
       C.founder, 
       COALESCE(LM.total_lead_managers, 0) AS total_lead_managers,
       COALESCE(SM.total_senior_managers, 0) AS total_senior_managers,
       COALESCE(M.total_managers, 0) AS total_managers,
       COALESCE(E.total_employees, 0) AS total_employees
FROM Company C
LEFT JOIN LeadManagerCount LM ON C.company_code = LM.company_code
LEFT JOIN SeniorManagerCount SM ON C.company_code = SM.company_code
LEFT JOIN ManagerCount M ON C.company_code = M.company_code
LEFT JOIN EmployeeCount E ON C.company_code = E.company_code
ORDER BY C.company_code;


-- TASK 11:


SELECT S1.Name
FROM Students S1
JOIN Friends F ON S1.ID = F.ID
JOIN Packages P1 ON S1.ID = P1.ID
JOIN Packages P2 ON F.Friend_ID = P2.ID
WHERE P2.Salary > P1.Salary
ORDER BY P2.Salary;

-- TASK 12:
CREATE TABLE JobCosts (
    JobFamily VARCHAR(255),
    Location VARCHAR(50),
    Cost DECIMAL(10, 2)
);

INSERT INTO JobCosts (JobFamily, Location, Cost) VALUES
('Engineering', 'India', 10000.00),
('Engineering', 'International', 15000.00),
('Marketing', 'India', 5000.00),
('Marketing', 'International', 7000.00),
('Sales', 'India', 8000.00),
('Sales', 'International', 12000.00),
('HR', 'India', 6000.00),
('HR', 'International', 9000.00);

WITH TotalCosts AS (
    SELECT 
        JobFamily,
        SUM(CASE WHEN Location = 'India' THEN Cost ELSE 0 END) AS TotalCostIndia,
        SUM(CASE WHEN Location = 'International' THEN Cost ELSE 0 END) AS TotalCostInternational
    FROM JobCosts
    GROUP BY JobFamily
),
Percentages AS (
    SELECT
        JobFamily,
        TotalCostIndia,
        TotalCostInternational,
        (TotalCostIndia / (TotalCostIndia + TotalCostInternational) * 100) AS IndiaPercentage,
        (TotalCostInternational / (TotalCostIndia + TotalCostInternational) * 100) AS InternationalPercentage
    FROM TotalCosts
)
SELECT 
    JobFamily,
    IndiaPercentage,
    InternationalPercentage
FROM Percentages;

-- TASK 13:

CREATE TABLE BUFinancials (
    BU VARCHAR(255),
    Location VARCHAR(50),
    Cost DECIMAL(10, 2),
    Revenue DECIMAL(10, 2),
    Month DATE
);

INSERT INTO BUFinancials (BU, Location, Cost, Revenue, Month) VALUES
('Engineering', 'India', 10000.00, 20000.00, '2023-01-01'),
('Engineering', 'International', 15000.00, 25000.00, '2023-01-01'),
('Marketing', 'India', 5000.00, 12000.00, '2023-01-01'),
('Marketing', 'International', 7000.00, 15000.00, '2023-01-01'),
('Sales', 'India', 8000.00, 18000.00, '2023-01-01'),
('Sales', 'International', 12000.00, 22000.00, '2023-01-01'),
('HR', 'India', 6000.00, 14000.00, '2023-01-01'),
('HR', 'International', 9000.00, 17000.00, '2023-01-01'),
('Engineering', 'India', 12000.00, 22000.00, '2023-02-01'),
('Engineering', 'International', 16000.00, 27000.00, '2023-02-01'),
('Marketing', 'India', 5500.00, 13000.00, '2023-02-01'),
('Marketing', 'International', 7500.00, 16000.00, '2023-02-01'),
('Sales', 'India', 8500.00, 19000.00, '2023-02-01'),
('Sales', 'International', 12500.00, 23000.00, '2023-02-01'),
('HR', 'India', 6500.00, 15000.00, '2023-02-01'),
('HR', 'International', 9500.00, 18000.00, '2023-02-01');

WITH MonthlyTotals AS (
    SELECT
        BU,
        FORMAT(Month, 'yyyy-MM') AS MonthYear,
        SUM(Cost) AS TotalCost,
        SUM(Revenue) AS TotalRevenue
    FROM BUFinancials
    GROUP BY BU, FORMAT(Month, 'yyyy-MM')
),
Ratios AS (
    SELECT
        BU,
        MonthYear,
        TotalCost,
        TotalRevenue,
        (TotalCost / TotalRevenue) * 100 AS CostRevenueRatio
    FROM MonthlyTotals
)
SELECT 
    BU,
    MonthYear,
    TotalCost,
    TotalRevenue,
    CostRevenueRatio
FROM Ratios
ORDER BY BU, MonthYear;


-- TASK 14:

CREATE TABLE Employees (
    EmployeeID INT,
    SubBand VARCHAR(50)
);

INSERT INTO Employees (EmployeeID, SubBand) VALUES
(1, 'A1'),
(2, 'A1'),
(3, 'A2'),
(4, 'A2'),
(5, 'A2'),
(6, 'B1'),
(7, 'B1'),
(8, 'B1'),
(9, 'B2'),
(10, 'C1');


-- Calculate total headcount first
DECLARE @TotalHeadcount INT;
SELECT @TotalHeadcount = COUNT(*) FROM Employees;

-- Query to get headcount and percentage for each sub-band
SELECT 
    SubBand,
    COUNT(*) AS Headcount,
    (COUNT(*) * 100.0 / @TotalHeadcount) AS Percentage
FROM Employees
GROUP BY SubBand;


-- TASK 15:

CREATE TABLE Emply (
    EmployeeID INT,
    Name VARCHAR(255),
    Salary DECIMAL(10, 2)
);

INSERT INTO Emply(EmployeeID, Name, Salary) VALUES
(1, 'Alice', 50000.00),
(2, 'Bob', 60000.00),
(3, 'Charlie', 70000.00),
(4, 'David', 80000.00),
(5, 'Eve', 90000.00),
(6, 'Frank', 100000.00),
(7, 'Grace', 110000.00),
(8, 'Heidi', 120000.00);

WITH RankedEmply AS (
    SELECT 
        EmployeeID, 
        Name, 
        Salary, 
        ROW_NUMBER() OVER (PARTITION BY Salary ORDER BY Salary DESC) AS Rank
    FROM Emply
)
SELECT 
    EmployeeID, 
    Name, 
    Salary 
FROM RankedEmply 
WHERE Rank <= 5;


-- task 16:

CREATE TABLE Swaps (
    ID INT PRIMARY KEY,
    A INT,
    B INT
);

INSERT INTO Swaps (ID, A, B) VALUES
(1, 5, 10),
(2, 15, 20);

UPDATE Swaps
SET A = A + B,
    B = A - B,
    A = A - B;

 -- TASK 17:

CREATE LOGIN new_user WITH PASSWORD = 'StrongPassword123!';

USE Task;
CREATE USER new_user FOR LOGIN new_user;

ALTER ROLE db_owner ADD MEMBER new_user;

-- task 18:

CREATE TABLE EmployeeCosts (
    EmployeeID INT,
    BU VARCHAR(255),
    Cost DECIMAL(10, 2),
    Month DATE
);

INSERT INTO EmployeeCosts (EmployeeID, BU, Cost, Month) VALUES
(1, 'Engineering', 5000.00, '2023-01-01'),
(2, 'Engineering', 7000.00, '2023-01-01'),
(3, 'Engineering', 6000.00, '2023-02-01'),
(4, 'Marketing', 4000.00, '2023-01-01'),
(5, 'Marketing', 5000.00, '2023-02-01'),
(6, 'Marketing', 6000.00, '2023-02-01');


-- Step 1: Calculate total cost per BU and Month
WITH TotalCosts AS (
    SELECT 
        BU,
        FORMAT(Month, 'yyyy-MM') AS MonthYear,
        SUM(Cost) AS TotalCost
    FROM 
        EmployeeCosts
    GROUP BY 
        BU, FORMAT(Month, 'yyyy-MM')
)
-- Step 2: Calculate weighted average cost
SELECT 
    e.BU,
    FORMAT(e.Month, 'yyyy-MM') AS MonthYear,
    SUM(e.Cost * 1.0 / t.TotalCost) * 100 AS WeightedAverageCost
FROM 
    EmployeeCosts e
JOIN 
    TotalCosts t
ON 
    e.BU = t.BU AND FORMAT(e.Month, 'yyyy-MM') = t.MonthYear
GROUP BY 
    e.BU, FORMAT(e.Month, 'yyyy-MM'), t.TotalCost;


-- TASK 19:

SELECT 
    AVG(CAST(REPLACE(CAST(Salary AS VARCHAR(20)), '0', '') AS DECIMAL(10, 2))) AS MiscalculatedAverage
FROM 
    Emply;

SELECT 
    AVG(Salary) AS ActualAverage
FROM 
    Emply;


WITH Salaries AS (
    SELECT 
        AVG(CAST(REPLACE(CAST(Salary AS VARCHAR(20)), '0', '') AS DECIMAL(10, 2))) AS MiscalculatedAverage,
        AVG(Salary) AS ActualAverage
    FROM 
        Emply
)
SELECT 
    CEILING(ActualAverage - MiscalculatedAverage) AS RoundedError
FROM 
    Salaries;

-- TASK 20:

CREATE TABLE SourceTable (
    ID INT PRIMARY KEY,
    Column1 VARCHAR(255),
    Column2 INT,
    Column3 DATE
);

CREATE TABLE DestinationTable (
    ID INT PRIMARY KEY,
    Column1 VARCHAR(255),
    Column2 INT,
    Column3 DATE
);

INSERT INTO SourceTable (ID, Column1, Column2, Column3)
VALUES
    (1, 'Data1', 10, '2023-01-01'),
    (2, 'Data2', 20, '2023-02-01'),
    (3, 'Data3', 30, '2023-03-01');


MERGE INTO DestinationTable AS dest
USING SourceTable AS src
ON (dest.ID = src.ID)  -- Assuming ID is the primary key and unique
WHEN NOT MATCHED BY TARGET THEN
    INSERT (ID, Column1, Column2, Column3)
    VALUES (src.ID, src.Column1, src.Column2, src.Column3);

