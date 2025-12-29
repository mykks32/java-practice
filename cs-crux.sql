CREATE TABLE Employee (
    EmpId INT PRIMARY KEY,
    Name VARCHAR(50),
    Age INT,
    Department VARCHAR(10),
    Salary DECIMAL(10,2),
    JoinDate DATE,
    City VARCHAR(20)
);

INSERT INTO Employee (EmpID, Name, Age, Department, Salary, JoinDate, City) VALUES (1, 'Alice', 28, 'HR', 50000, '2021-01-15', 'New York'),
                                                                                   (2, 'Bob', 35, 'IT', 75000, '2019-03-10', 'San Francisco'),
                                                                                   (3, 'Charlie', 30, 'Finance', 60000, '2020-06-20', 'Chicago'),
                                                                                   (4, 'David', 40, 'IT', 80000, '2018-09-01', 'San Francisco'),
                                                                                   (5, 'Eva', 25, 'HR', 45000, '2022-11-05', 'New York'),
                                                                                   (6, 'Frank', 32, 'Finance', 65000, '2020-12-15', 'Chicago'),
                                                                                   (7, 'Grace', 29, 'IT', 70000, '2021-05-22', 'San Francisco'),
                                                                                   (8, 'Hannah', 27, 'HR', 48000, '2022-02-10', 'New York');


-- Get Newer Employee
SELECT
    Department,
    COUNT(*) as emp_count,
    AVG(Salary) as avg_salary
FROM (
    SELECT
        Department,
        Salary
    FROM
        employee
    WHERE
        JoinDate > '2020-01-21'
     ) AS recent_employee
GROUP BY Department;


-- CTE
WITH
    department_stats
        AS (SELECT
                Department,
                COUNT(*)
                    AS EMP_COUNT,
                AVG(Salary) as Avg_Salary
            FROM Employee
            GROUP BY Department
        ),
    highpaying_depts
        AS
        (
            SELECT
                Department
            FROM
                department_stats
            WHERE Avg_Salary > 45000
        )
SELECT
    e.Name,
    e.Salary,
    e.Department
FROM
    Employee e
WHERE
    e.Department IN (
        SELECT Department from highpaying_depts
        )
ORDER BY e.Salary DESC;


-- Altering Table
ALTER TABLE Employee
    ADD ManagerID INT;

UPDATE Employee SET ManagerID = NULL WHERE EmpID = 1;

UPDATE Employee SET ManagerID = 1 WHERE EmpID IN (2,3);
UPDATE Employee SET ManagerID = 2 WHERE EmpID IN (4,7);
UPDATE Employee SET ManagerID = 3 WHERE EmpID IN (6);
UPDATE Employee SET ManagerID = 1 WHERE EmpID IN (5,8);

-- Alice
--  ├─ Bob
--  │   ├─ David
--  │   └─ Grace
--  ├─ Charlie
--  │   └─ Frank
--  ├─ Eva
--  └─ Hannah

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT
        EmpId,
        Name,
        ManagerID,
        1 AS LEVEL
    FROM Employee
    WHERE
        Employee.ManagerID IS NULL

    UNION ALL

    SELECT
        e.EmpId,
        e.Name,
        e.ManagerID,
        eh.LEVEL + 1
    FROM Employee e
    JOIN EmployeeHierarchy eh
        ON e.ManagerID = eh.EmpId
)
SELECT * FROM EmployeeHierarchy
ORDER BY Level, EmpId;


-- window function

select Name, Department, Salary,
       AVG(Salary) over (PARTITION BY Department) As DeptAvgSalary
From Employee;

-- Row Number
SELECT
    Name,
    Department,
    Salary,
    ROW_NUMBER() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
        ) AS rn
FROM Employee;

-- Rank
SELECT
    Name,
    Department,
    Salary,
    RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
        ) AS rank
FROM Employee;

-- Dense Rank
SELECT
    Name,
    Department,
    Salary,
    DENSE_RANK() OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
        ) AS dense_rank
FROM Employee;

--Ntile
SELECT
    Name,
    Salary,
    NTILE(4) OVER (ORDER BY Salary DESC) AS salary_quartile
FROM Employee;

-- Aggregate Window Function
--sum() over()
SELECT
    Name,
    Department,
    Salary,
    SUM(Salary) OVER (PARTITION BY Department) AS DeptTotalSalary
FROM Employee;

-- avg() over()
SELECT
    Name,
    JoinDate,
    Salary,
    AVG(Salary) OVER (
        ORDER BY JoinDate
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS MovingAvgSalary
FROM Employee;

-- value window function
-- Lag()
SELECT
    Name,
    JoinDate,
    Salary,
    LAG(Salary) OVER (ORDER BY JoinDate) AS PrevSalary
FROM Employee;

--lead()
SELECT
    Name,
    JoinDate,
    Salary,
    LEAD(Salary) OVER (ORDER BY JoinDate) AS NextSalary
FROM Employee;

-- first_value()/last_value()
SELECT
    Name,
    Department,
    Salary,
    FIRST_VALUE(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary DESC
        ) AS HighestInDept
FROM Employee;

-- lastValue
SELECT
    Name,
    Department,
    Salary,
    LAST_VALUE(Salary) OVER (
        PARTITION BY Department
        ORDER BY Salary
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        )
FROM Employee;


-- Real Questions
-- Top 2 Salary per department
SELECT *
FROM (
         SELECT
             Name,
             Department,
             Salary,
             DENSE_RANK() OVER (
                 PARTITION BY Department
                 ORDER BY Salary DESC
                 ) AS rnk
         FROM Employee
     ) t
WHERE rnk <= 2;

-- Salary Difference from Average
SELECT
    Name,
    Department,
    Salary,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromAvg
FROM Employee;

-- Employee more than department average
SELECT *
FROM (
    SELECT
        Name,
        Department,
        Salary,
        AVG(Salary) Over (PARTITION BY Department ) As AverSalary
    FROM Employee
) as E WHERE E.Salary > AverSalary