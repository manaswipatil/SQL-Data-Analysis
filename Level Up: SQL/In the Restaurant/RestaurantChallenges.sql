/**********In the Restaurant**********/
/*************************************/



/*****************************************/
-- Create invitations for a party
/*****************************************/

  SELECT FirstName, LastName, Email
FROM Customers
ORDER BY LastName;

/*****************************************/
-- Create a table to store information
/*****************************************/

CREATE TABLE PartyAttendees
  ( CustomerID INTEGER,
    PartySize INTEGER);

/*****************************************/
-- Print a Menu
/*****************************************/
-- Create reports that will be used to make three menus.

-- Create a report with all the items sorted by price (lowest to highest).
SELECT * 
FROM Dishes
ORDER BY Price ASC;

-- Create a report showing appetizers and beverages.
SELECT *
FROM Dishes
WHERE Type IN ('Appetizer','Beverage');

-- Create a report with all items except beverages.
SELECT *
FROM Dishes
WHERE Type != 'Beverage';

/*****************************************/
-- Sign a cutomer up for your loyalty program
/*****************************************/

-- Add a customer to the restaurant's loyalty program.

-- Use the following information to create a record:
-- Anna Smith (asmith@samoca.org)
-- 479 Lapis Dr., Memphis, TN
-- Phone: (555) 555-1212; Birthday: July 21, 1973


INSERT INTO Customers (FirstName, LastName, Email, Address, City, State, Phone, Birthday)
VALUES ('Anna', 'Smith', 'asmith@samoca.org',
'479 Lapis Dr', 'Memphis', 'TN', '555-555-1212',
'1973-07-21')
;

SELECT * FROM Customers
ORDER BY CustomerID DESC
;

/*****************************************/
-- Update a customer's personal information
/*****************************************/


