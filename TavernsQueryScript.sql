--Drop Tables in correct order
DROP TABLE IF EXISTS basementRats, levels, supplyReceived, inventory, supplySales;
DROP TABLE IF EXISTS sales, guests, supplies, services, taverns, users;
DROP TABLE IF EXISTS class, guestStatus, servicesStatus, locations, roles;

-- locations table
-- INDEPENDENT table
DROP TABLE IF EXISTS [locations];

CREATE TABLE [locations] (
ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
locationName varchar(250) NOT NULL
);

INSERT INTO [locations] (locationName)
VALUES ('Houston'), ('Austin'), ('Dallas'), ('Galveston'), ('San Antonio');

--roles table
-- INDEPENDENT table
DROP TABLE IF EXISTS [roles];

CREATE TABLE [roles] (
ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
roleName VARCHAR(250) NOT NULL,
description VARCHAR(250) NOT NULL
);

INSERT INTO [roles] (roleName, description)
VALUES ('owner', 'owner of tavern'),
('manager', 'oversees all aspects of tavern'),
('concierge', 'answering guest inquires'),
('chef', 'head of the kitchen'),
('server', 'serves the guests');

--users table
-- Depends on roles tables - FK
DROP TABLE IF EXISTS [users];

CREATE TABLE [users] (
--ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
ID INT NOT NULL IDENTITY(1,1),
userName VARCHAR(250) NOT NULL,
--roleId INT NOT NULL FOREIGN KEY REFERENCES roles(ID)
roleId INT NOT NULL
);
--adding PK and FK using Alter Table
ALTER TABLE [users] ADD PRIMARY KEY (ID)
ALTER TABLE [users] ADD FOREIGN KEY (roleId) REFERENCES roles(ID)

INSERT INTO [users] (userName, roleId)
VALUES ('Mandalorian', 1),
('Cara Dune', 3),
('Moff Gideon', 5),
('Grogu', 2),
('Greef Karga', 4);

--taverns table
-- Depends on locations table and users table - FK
DROP TABLE IF EXISTS [taverns];

CREATE TABLE [taverns] (
--ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
ID int NOT NULL IDENTITY(1,1),
tavernName VARCHAR(250) NOT NULL,
--locationId INT NOT NULL FOREIGN KEY REFERENCES locations(ID),
locationId INT NOT NULL,
--ownerId INT NOT NULL FOREIGN KEY REFERENCES users(ID),
ownerId INT NOT NULL,
numberOfFloors INT NOT NULL
);
--adding PK and FK using Alter Table
ALTER TABLE [taverns] ADD PRIMARY KEY (ID)
ALTER TABLE [taverns] ADD FOREIGN KEY (locationId) REFERENCES locations(ID)
ALTER TABLE [taverns] ADD FOREIGN KEY (ownerId) REFERENCES users(ID)

INSERT INTO [taverns] (tavernName, locationId, ownerId, numberOfFloors)
VALUES ('Red Lion', 5, 1, 2),
('Crown', 4, 2, 3),
('Royal Oak', 3, 3, 4),
('White Hart', 2, 4, 2),
('Swan', 1, 5, 2);

--basementRats table
-- Depends on locations taverns table - FK
DROP TABLE IF EXISTS [basementRats];

CREATE TABLE [basementRats] (
ID int NOT NULL PRIMARY KEY IDENTITY(1,1),
ratsName varchar(250) NOT NULL,
tavernId INT NOT NULL FOREIGN KEY REFERENCES taverns(ID)
);

-- how to avoid duplication or redundant data?
INSERT INTO [basementRats] (ratsName, tavernId)
VALUES ('Aristorat', 3),
('Cheesewiz', 5),
('Basil Ratbone', 2),
('Cheesewiz', 5),
('Catnip', 4),
('Cheeseball', 1),
('Cheesewiz', 5);

--supplies table
--INDEPENDANT table
DROP TABLE IF EXISTS [supplies];

CREATE TABLE [supplies] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
beerName VARCHAR(250) NOT NULL,
unit VARCHAR(250) NOT NULL
);

INSERT INTO [supplies] (beerName, unit)
VALUES ('American Pale Ale', 'Grenade 7oz Bottles'),
('India Pale Ale', 'Stubby 12oz Bottles'),
('Stout', 'Longneck 12oz Bottles'),
('Wheat Beer', 'British 500ml Bottles'),
('Lager', 'Bomber 650ml Bottles')

--suppliesReceived table
--Depends on supplies table and taverns table - FK
DROP TABLE IF EXISTS [supplyReceived];

CREATE TABLE [supplyReceived] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
supplyId INT NOT NULL FOREIGN KEY REFERENCES supplies(ID),
tavernId INT NOT NULL FOREIGN KEY REFERENCES taverns(ID),
cost MONEY NOT NULL,
amountReceived MONEY NOT NULL,
dateReceived DATE NOT NULL  
);

INSERT INTO [supplyReceived] (supplyId, tavernId, cost, amountReceived, dateReceived)
VALUES (1, 3, $50.00, $25.00, '01/11/2021'),
(3, 2, $60.00, $35.00, '01/10/2021'),
(5, 5, $70.00, $15.00, '01/09/2021'),
(2, 4, $80.00, $55.00, '01/08/2021'),
(4, 1, $90.00, $75.00, '01/07/2021');

--inventory table
--Depends on supplies table and taverns table - FK
DROP TABLE IF EXISTS [inventory];

CREATE TABLE [inventory] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
supplyId INT NOT NULL FOREIGN KEY REFERENCES supplies(ID),
tavernId INT NOT NULL FOREIGN KEY REFERENCES taverns(ID),
dateUpdated DATE NOT NULL,
currentCount INT NOT NULL
);

INSERT INTO [inventory] (supplyId, tavernId, dateUpdated, currentCount)
VALUES (5, 1, '01/15/2021', 40),
(4, 2, '01/15/2021', 50),
(3, 3, '01/15/2021', 60),
(2, 4, '01/15/2021', 70),
(1, 5, '01/15/2021', 20);

--servicesStatus
--Independent Table
DROP TABLE IF EXISTS [servicesStatus]

CREATE TABLE [servicesStatus] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
status VARCHAR(250) NOT NULL
);

INSERT INTO [servicesStatus] (status)
VALUES ('active'), ('inactive'), ('out of stock'), ('discontinued');

--services table
--Depends on servicesStatus table and taverns table - FK
DROP TABLE IF EXISTS [services]

CREATE TABLE [services] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
serviceName VARCHAR(250) NOT NULL,
statusId INT NOT NULL FOREIGN KEY REFERENCES servicesStatus(ID),
tavernId INT NOT NULL FOREIGN KEY REFERENCES taverns(ID)
);

INSERT INTO [services] (serviceName, statusId, tavernId)
VALUES ('Pool', 2, 4),
('Weapon Sharpening', 1, 3),
('Pet Grooming', 4, 2),
('Gas', 3, 1),
('Drinks', 3, 5)

--sales table
--Depends on services table and taverns table - FK
DROP TABLE IF EXISTS [sales]

CREATE TABLE [sales] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
servicesId INT NOT NULL FOREIGN KEY REFERENCES services(ID),
guest VARCHAR(250) NOT NULL,
price MONEY NOT NULL,
purchasedDate DATE NOT NULL,
purchasedAmount MONEY NOT NULL,
tavernId INT NOT NULL FOREIGN KEY REFERENCES taverns(ID)
);

INSERT INTO [sales] (servicesId, guest, price, purchasedDate, purchasedAmount, tavernId)
VALUES (1, 'Agnes Doyle', $30.00, '01/02/2021', $45.00, 3),
(3, 'Patti Flores', $10.00, '01/02/2021', $25.00, 1),
(5, 'Marsha Black', $40.00, '01/02/2021', $75.00, 5),
(2, 'Lindsey Robbins ', $60.00, '01/02/2021', $85.00, 4),
(4, 'Albert Vega ', $70.00, '01/02/2021', $95.00, 2);

--guestStatus table
--independent table - constraint to allow only - sick, fine, hangry, raging and placid
DROP TABLE IF EXISTS [guestStatus]

CREATE TABLE [guestStatus] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
status VARCHAR(250) NOT NULL,
CONSTRAINT chk_status CHECK (status IN ('sick', 'fine', 'hangry', 'raging', 'placid'))
);

INSERT INTO [guestStatus] (status)
VALUES ('sick'), ('fine'), ('hangry'), ('raging'), ('placid');

--class table
--independent table
DROP TABLE IF EXISTS [class]

CREATE TABLE [class] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
className VARCHAR(250) NOT NULL 
);

INSERT INTO [class] (className)
VALUES ('fighter'), ('tank'), ('mage'), ('summoner'), ('bard')

--guests table
--depends on taverns table, guestStatus table and class table
DROP TABLE IF EXISTS [guests]

CREATE TABLE [guests] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
tavernId INT NOT NULL FOREIGN KEY REFERENCES taverns(ID),
guestName VARCHAR(250) NOT NULL,
notes VARCHAR(250) NOT NULL,
birthday DATE NOT NULL,
cakeday DATE NOT NULL,
guestStatusId INT NOT NULL FOREIGN KEY REFERENCES guestStatus(ID),
classId INT NOT NULL FOREIGN KEY REFERENCES class(ID)
);

INSERT INTO [guests] (tavernId, guestName, notes, birthday, cakeday, guestStatusId, classId)
VALUES (3, 'Agnes Doyle', 'likes oshizushi', '01/01/1980', '01/01/2021', 3, 5 ),
(4, 'Patti Flores', 'likes californial roll', '02/01/1980', '01/02/2021', 4, 4 ),
(1, 'Marsha Black', 'likes nare zushi', '03/01/1980', '01/03/2021', 1, 3 ),
(2, 'Lindsey Robbins', 'likes makizushi', '04/01/1980', '01/04/2021', 2, 2 ),
(5, 'Albert Vega', 'likes tuna roll', '05/01/1980', '01/05/2021', 5, 1 );

--levels table
--depends on guests table and class table
DROP TABLE IF EXISTS [levels]

CREATE TABLE [levels] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
guestId INT NOT NULL FOREIGN KEY REFERENCES guests(ID),
classId INT NOT NULL FOREIGN KEY REFERENCES class(ID)
);

INSERT INTO [levels] (guestId, classId)
VALUES (1, 5), (2, 4), (3, 3), (4, 2), (5, 1);

--Insertion Failure
--The INSERT statement conflicted with the FOREIGN KEY constraint
--INSERT INTO [levels] (guestId, classId)
--VALUES (6, 5)



--Supply-Sales table
--depends on sales table and supplies table
DROP TABLE IF EXISTS [supplySales];

CREATE TABLE [supplySales] (
ID INT NOT NULL PRIMARY KEY IDENTITY(1,1),
salesID INT NOT NULL FOREIGN KEY REFERENCES sales(ID),
supplyID INT NOT NULL FOREIGN KEY REFERENCES supplies(ID)
);

INSERT INTO [supplySales] (salesId, supplyID)
VALUES (1, 5), (2, 4), (3, 3), (4, 2), (5, 1);