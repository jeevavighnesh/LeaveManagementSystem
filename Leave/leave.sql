DROP TABLE IF EXISTS Roles;
CREATE TABLE Roles
(
	RoleId TINYINT PRIMARY KEY,
	Role CHAR(3) NOT NULL
);

INSERT INTO Roles VALUES (1,'DIR'), (2,'MGR'), (3,'EMP'), (4,'TRA');

DROP TABLE IF EXISTS LeaveSeed;
CREATE TABLE LeaveSeed(
	Id TINYINT PRIMARY KEY,
	LeaveType CHAR(2) NOT NULL,
	Decription VARCHAR(20) NOT NULL,
	State VARCHAR(10) NOT NULL
);
INSERT INTO LeaveSeed VALUES (1, 'PL', 'Paid Leave', 'Active'), (2, 'CL', 'Casual Leave', 'Active'), (3, 'SL', 'Sick Leave', 'Active');

DROP TABLE IF EXISTS EmployeeLeavePolicy;
CREATE TABLE EmployeeLeavePolicy
(
	PolicyId TINYINT PRIMARY KEY,
	RoleId TINYINT NOT NULL,
	LeaveTypeId TINYINT NOT NULL,
	NoOfDays TINYINT NOT NULL,
	CONSTRAINT k_lpol FOREIGN KEY (RoleId) REFERENCES Roles(RoleId),
	CONSTRAINT k_lid FOREIGN KEY (LeaveTypeId) REFERENCES LeaveSeed(Id)
);

INSERT INTO EmployeeLeavePolicy
VALUES
(1, 1, 1, 24),
(2, 1, 2, 24), 
(3, 1, 3, 18), 
(4, 2, 1, 18), 
(5, 2, 2, 18), 
(6, 2, 3, 9), 
(7, 3, 1, 12),
(8, 3, 2, 12), 
(9, 3, 3, 6), 
(10, 4, 1, 6),
(11, 4, 2, 6),
(12, 4, 3, 3);

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee
(
	EId INT PRIMARY KEY,
	RoleId TINYINT NOT NULL,
	EmployeeName VARCHAR(20) NOT NULL,
	CONSTRAINT k_emp FOREIGN KEY (RoleId) REFERENCES Roles(RoleId) 
);
INSERT INTO Employee VALUES (1, 1, 'Imran'), (2, 3, 'Vikki'), (3, 2, 'Jyothi'), (4, 3, 'Subbu'), (5, 4, 'Aynna');

DROP TABLE IF EXISTS EmployeeLeaveTransaction;
CREATE TABLE EmployeeLeaveTransaction
(
	RecordId SERIAL,
	EmployeeId INT NOT NULL,
	LeaveTypeId TINYINT NOT NULL,
	DateOfLeave DATE NOT NULL,
	Reason VARCHAR(250),
	TransactionTime TIMESTAMP,
	State VARCHAR(10) NOT NULL,
	CONSTRAINT lr FOREIGN KEY (EmployeeId) REFERENCES Employee(EId)
);
DESCRIBE EmployeeLeaveTransaction;



DROP TABLE IF EXISTS RevatureHolidays;
CREATE TABLE RevatureHolidays
(
	HolidayId SERIAL,
	Holidate DATE NOT NULL,
	Holiday VARCHAR(17) NOT NULL
);

INSERT INTO RevatureHolidays (Holidate, Holiday) VALUES
("2017-01-13", "Bhogi"),
("2017-01-26", "Republic day"),
("2017-04-14", "Tamil New Year"),
("2017-05-01", "May day"),
("2017-08-15","Independence day"),
("2017-08-25", "Ganesh Chadurthi"),
("2017-09-29", "Pooja Holiday"),
("2017-10-02", "Gandhi Jayanthi"),
("2017-10-18", "Deepavali"),
("2017-12-25", "Christmas");

DROP TABLE IF EXISTS Configuration;
CREATE TABLE Configuration
(
	Weekend VARCHAR(8)
);
INSERT INTO Configuration VALUES ("Sunday"),("Saturday");