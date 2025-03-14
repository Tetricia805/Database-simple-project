--Creating a database
CREATE DATABASE Car_Wash;
USE Car_Wash;

--drop the database
DROP DATABASE Car_Wash;

-- Creating Customer Table
-- Stores basic customer information with auto-incrementing ID
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_Name VARCHAR(50) NOT NULL,
    Telephone_Number VARCHAR(20) UNIQUE,
    Email VARCHAR(50) UNIQUE
);
DESC Customer;

ALTER TABLE Customer ADD Loyalty_Points INT DEFAULT 0;

-- Creating Vehicle Table
-- Links vehicles to customers through Customer_ID foreign key
-- One customer can have multiple vehicles
CREATE TABLE Vehicle (
    Vehicle_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Make VARCHAR(30) NOT NULL,
    Model VARCHAR(30) NOT NULL,
    License_Plate VARCHAR(15) UNIQUE NOT NULL,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE 
);
--on delete cascade
DESC Vehicle;

-- Creating Employee Table
-- Stores employee data with salary constraints (between 10,000 and 40,000)
CREATE TABLE Employee (
    Employee_ID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(50) NOT NULL,
    Telephone_Number VARCHAR(20) UNIQUE,
    Hire_Date DATE,
    Salary DECIMAL(8,2) CHECK (Salary BETWEEN 10000 AND 40000)
);
DESC Employee;

ALTER TABLE employee ADD COLUMN Age INT;

ALTER TABLE employee ADD CONSTRAINT check_age CHECK(Age > 18);

SELECT CONSTRAINT_NAME, CONSTRAINT_TYPE, TABLE_NAME FROM information_schema.TABLE_CONSTRAINTS WHERE `TABLE_NAME`='Employee'  

-- Creating Service Table
-- Defines available car wash services with their prices
CREATE TABLE Service (
    Service_ID INT PRIMARY KEY AUTO_INCREMENT,
    Service_Name VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0)
);
DESC Service;

-- Creating Transactions Table 
-- Central table that connects customers, vehicles, services, and employees
-- Stores the actual business transactions
CREATE TABLE Transactions (
    Transactions_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Vehicle_ID INT NOT NULL,
    Service_ID INT NOT NULL,
    Transaction_Date DATE NOT NULL,
    Amount_Paid DECIMAL(9,2) CHECK (Amount_Paid > 0),
    Employee_ID INT NOT NULL, 
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID),
    FOREIGN KEY (Vehicle_ID) REFERENCES Vehicle(Vehicle_ID),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID),
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID)
);
DESC Transactions;

-- Creating Loyalty Table
-- This table tracks customer loyalty points and their reward status
CREATE TABLE Loyalty (
    Loyalty_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL UNIQUE,
    Total_Points INT DEFAULT 0 CHECK (Total_Points >= 0),
    Reward_Status ENUM('Bronze', 'Silver', 'Gold', 'Platinum') DEFAULT 'Bronze',
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE
);

DESC loyalty;
-- Updating Customer Table to remove redundant Loyalty_Points column
ALTER TABLE Customer DROP COLUMN Loyalty_Points;

-- Creating Feedback Table
-- Stores customer feedback, ratings, and employee interactions
CREATE TABLE Feedback (
    Feedback_ID INT PRIMARY KEY AUTO_INCREMENT,
    Customer_ID INT NOT NULL,
    Employee_ID INT NOT NULL,
    Service_ID INT NOT NULL,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    Feedback_Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Customer_ID) REFERENCES Customer(Customer_ID) ON DELETE CASCADE,
    FOREIGN KEY (Employee_ID) REFERENCES Employee(Employee_ID),
    FOREIGN KEY (Service_ID) REFERENCES Service(Service_ID) ON DELETE CASCADE
);

-- Updating the Transactions Table to add a Feedback_ID reference (optional)
ALTER TABLE Transactions ADD COLUMN Feedback_ID INT UNIQUE;
ALTER TABLE Transactions ADD FOREIGN KEY (Feedback_ID) REFERENCES Feedback(Feedback_ID) ON DELETE SET NULL;

-- inserting data into the above created tables
-- Inserting Data into Customer
INSERT INTO Customer (Customer_Name, Telephone_Number, Email) VALUES
('Teopista Tetricia', '0740515377', 'tetricia@email.com'),
('N Isaac', '0765432180', 'nisaac@email.com'),
('O Nobert', '0789012342', 'onobert@yahoo.com'),
('Tendo C', '0750126459', 'tendoc@email.com'),
('David Brown', '0789017316', 'bruyce@email.com');

SELECT * FROM customer;

-- Inserting Data into Vehicle (Now with Customer_ID)
INSERT INTO Vehicle (Customer_ID, Make, Model, License_Plate) VALUES
(1, 'Toyota', 'Corolla', 'ABC123'),
(2, 'Honda', 'Civic', 'XYZ456'),
(3, 'Ford', 'Focus', 'LMN789'),
(4, 'Chevrolet', 'Malibu', 'DEF321'),
(5, 'Nissan', 'Altima', 'UVW654');

SELECT * FROM vehicle;

-- Inserting Data into Employee
INSERT INTO Employee (Name, Telephone_Number, Hire_Date, Salary) VALUES
('Tetricia GL ', '1112223333', '2022-01-15', 39000),
('Okidi N', '4445556666', '2021-11-10', 25000),
('Nabasa I', '7778889999', '2023-03-05', 19000),
('Mutumba B', '2223334444', '2020-09-20', 11000),
('Calvin T', '5556667777', '2019-06-25', 15000);

SELECT * FROM employee;

UPDATE employee set Age = 20 WHERE Employee_ID = 1;
UPDATE employee set Age = 28 WHERE Employee_ID = 3;
UPDATE employee set Age = 42 WHERE Employee_ID = 2;
UPDATE employee set Age = 35 WHERE Employee_ID = 5;
UPDATE employee set Age = 60 WHERE Employee_ID = 4;

-- The following code wont run because the check constraint for age is voilated
INSERT INTO Employee (Name, Telephone_Number, Hire_Date, Salary, Age) VALUES
('Natamba Enock ', '1222223333', '2022-01-25', 39000, 17);


-- Inserting Data into Service
INSERT INTO Service (Service_Name, Price) VALUES
('Basic Wash', 15.00),
('Deluxe Wash', 25.00),
('Wax & Polish', 50.00),
('Interior Cleaning', 40.00),
('Full Detailing', 100.00);

SELECT * FROM service;

-- Inserting Data into Transactions (Now with proper column mapping)
INSERT INTO Transactions (Customer_ID, Vehicle_ID, Service_ID, Transaction_Date, Amount_Paid, Employee_ID) VALUES
(1, 1, 1, '2024-02-01', 25.00, 1),
(2, 2, 2, '2024-02-05', 40.00, 2),
(3, 3, 3, '2024-02-10', 100.00, 3),
(4, 4, 4, '2024-02-15', 15.00, 4),
(5, 5, 5, '2024-02-20', 50.00, 5);

SELECT * FROM transactions;

-- Inserting Sample Data into Loyalty Table
INSERT INTO Loyalty (Customer_ID, Total_Points, Reward_Status) VALUES
(1, 50, 'Silver'),
(2, 120, 'Gold'),
(3, 200, 'Platinum'),
(4, 30, 'Bronze'),
(5, 90, 'Silver');

SELECT * FROM Loyalty;

-- Inserting Sample Data into Feedback Table
INSERT INTO Feedback (Customer_ID, Employee_ID, Service_ID, Rating, Comments) VALUES
(1, 1, 1, 5, 'Great service! My car looks brand new.'),
(2, 2, 2, 4, 'Good job, but took a bit longer than expected.'),
(3, 3, 3, 3, 'Average service, could be better.'),
(4, 4, 4, 5, 'Fantastic experience, highly recommend!'),
(5, 5, 5, 4, 'Satisfied with the results.');

SELECT * FROM Feedback;

-- Updating Transactions Table to link Feedback
UPDATE Transactions SET Feedback_ID = 1 WHERE Transactions_ID = 1;
UPDATE Transactions SET Feedback_ID = 2 WHERE Transactions_ID = 2;
UPDATE Transactions SET Feedback_ID = 3 WHERE Transactions_ID = 3;
UPDATE Transactions SET Feedback_ID = 4 WHERE Transactions_ID = 4;
UPDATE Transactions SET Feedback_ID = 5 WHERE Transactions_ID = 5;

SELECT * FROM Transactions;

ALTER TABLE Customer MODIFY COLUMN Customer_Name VARCHAR(100);

ALTER TABLE Customer CHANGE Telephone_Number Phone_Number VARCHAR(20);

-- Views for Reports

-- Customer_Transactions View
-- Q: show the customer's-friendly summary of all transactions made?
-- A: This view joins customer data with their vehicles and services purchased,
-- making it easy to generate customer receipts or transaction histories
CREATE VIEW Customer_Transactions AS
SELECT 
    c.Customer_Name, v.Make, v.Model, s.Service_Name, t.Transaction_Date, t.Amount_Paid
FROM Transactions t
JOIN Customer c ON t.Customer_ID = c.Customer_ID
JOIN Vehicle v ON t.Vehicle_ID = v.Vehicle_ID
JOIN Service s ON t.Service_ID = s.Service_ID;

SELECT * FROM customer_transactions;

-- Employee_Services View
-- Q: How can management track which services each employee performs most often?
-- A: This view counts the number of each service type performed by each employee,
-- useful for employee performance reviews or specialization assignments
CREATE VIEW Employee_Services AS
SELECT 
    e.Name AS Employee_Name, s.Service_Name, COUNT(t.Transactions_ID) AS Services_Handled
FROM Transactions t
JOIN Employee e ON t.Employee_ID = e.Employee_ID
JOIN Service s ON t.Service_ID = s.Service_ID
GROUP BY e.Name, s.Service_Name;
SELECT * FROM employee_services;


-- Different types of JOIN demonstrations (here we demonstrated the use of different kinds of joins)
-- Natural_Join View
-- Q: How can we match transactions with their corresponding service details?
-- A: This NATURAL JOIN connects transactions with services based on matching column names (Service_ID),
-- showing complete transaction data with service details
CREATE VIEW Natural_Join AS
SELECT * FROM Transactions NATURAL JOIN Service;
SELECT * FROM natural_join;

-- Left_Join View
-- Q: How can we see all customers and their transaction history, even if they haven't made a purchase?
-- A: This LEFT JOIN ensures all customers are included in the results, even those without transactions,
-- providing a complete customer database with their transaction history
CREATE VIEW Left_Join AS
SELECT c.Customer_Name, v.Make, v.Model, t.Transaction_Date, s.Service_Name, t.Amount_Paid
FROM Customer c
LEFT JOIN Transactions t ON c.Customer_ID = t.Customer_ID
LEFT JOIN Vehicle v ON t.Vehicle_ID = v.Vehicle_ID
LEFT JOIN Service s ON t.Service_ID = s.Service_ID;

SELECT * FROM left_join;

-- Right_Join1 View
-- Q: How can we see all services and when they were performed, even if an employee is no longer with us?
-- A: This RIGHT JOIN prioritizes the service and transaction data, including all services
-- even if the employee information is missing
CREATE VIEW Right_Join1 AS
SELECT e.Name, s.Service_Name, t.Transaction_Date, t.Amount_Paid
FROM Employee e
RIGHT JOIN Transactions t ON e.Employee_ID = t.Employee_ID
RIGHT JOIN Service s ON t.Service_ID = s.Service_ID;

SELECT * FROM right_join1;

-- Full_Join View
-- Q: How can we see a complete business overview with all entities, even if there are no relationships between them?
-- A: This FULL JOIN (simulated in MySQL using UNION of LEFT and RIGHT JOINs) shows all customers, vehicles, 
-- services and employees whether or not they're connected to transactions,
-- providing a complete business overview
CREATE VIEW Full_Join AS
SELECT c.Customer_Name, v.Make, v.Model, s.Service_Name, t.Transaction_Date, e.Name AS Employee_Name, t.Amount_Paid
FROM Customer c
LEFT JOIN Transactions t ON c.Customer_ID = t.Customer_ID
LEFT JOIN Vehicle v ON t.Vehicle_ID = v.Vehicle_ID
LEFT JOIN Service s ON t.Service_ID = s.Service_ID
LEFT JOIN Employee e ON t.Employee_ID = e.Employee_ID
UNION
SELECT c.Customer_Name, v.Make, v.Model, s.Service_Name, t.Transaction_Date, e.Name AS Employee_Name, t.Amount_Paid
FROM Customer c
RIGHT JOIN Transactions t ON c.Customer_ID = t.Customer_ID
RIGHT JOIN Vehicle v ON t.Vehicle_ID = v.Vehicle_ID
RIGHT JOIN Service s ON t.Service_ID = s.Service_ID
RIGHT JOIN Employee e ON t.Employee_ID = e.Employee_ID;

SELECT * FROM full_join;

-- CASE Conditional Statements
-- Categorizing customers based on spending
-- Q: How can we identify and classify customers by their spending habits?
SELECT 
    c.Customer_Name,
    t.Amount_Paid,
    CASE 
        WHEN t.Amount_Paid > 50 THEN 'High Spender'
        WHEN t.Amount_Paid BETWEEN 20 AND 50 THEN 'Moderate Spender'
        ELSE 'Low Spender'
    END AS Spending_Category
FROM Customer c
JOIN Transactions t ON c.Customer_ID = t.Customer_ID;

-- Applying conditional salary updates
-- Q: How can we give targeted raises to employees based on their current salary brackets?
UPDATE Employee
SET Salary = 
    CASE 
        WHEN Salary < 15000 THEN Salary + 2000
        WHEN Salary BETWEEN 15000 AND 30000 THEN Salary + 1000
        ELSE Salary
    END;

-- Creating a View for Customer Loyalty Overview
CREATE VIEW Customer_Loyalty AS
SELECT 
    c.Customer_Name, l.Total_Points, l.Reward_Status
FROM Customer c
JOIN Loyalty l ON c.Customer_ID = l.Customer_ID;

SELECT * FROM Customer_Loyalty;

-- Creating a View for Service Ratings and Employee Performance
CREATE VIEW Service_Feedback AS
SELECT 
    e.Name AS Employee_Name, 
    s.Service_Name, 
    f.Rating, 
    f.Comments, 
    f.Feedback_Date
FROM Feedback f
JOIN Employee e ON f.Employee_ID = e.Employee_ID
JOIN Service s ON f.Service_ID = s.Service_ID;

SELECT * FROM Service_Feedback;
-- Removing old transactions
-- Q: How do we clean up our database by removing outdated transaction records?
DELETE FROM Transactions
WHERE Transaction_Date < '2023-01-01';


--drop the database
DROP DATABASE Car_Wash;


-- calculate the total amount of money





a






