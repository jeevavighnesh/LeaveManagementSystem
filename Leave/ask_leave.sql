DROP PROCEDURE IF EXISTS AskLeave;
DELIMITER !
CREATE PROCEDURE AskLeave(EmpId INT, LeaveTypeIdParm TINYINT, StartDate DATE, EndDate DATE)
BEGIN
SET @TempDate=StartDate;
SET @DOL = 0;
IF StartDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
OR
EndDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
THEN
	IF CURDATE() <= StartDate AND StartDate<=EndDate
	THEN
		IF EmpId IN (SELECT EId FROM Employee)
		THEN
			WHILE @TempDate <= EndDate
			DO
				IF DAYNAME(@TempDate) NOT IN (SELECT Weekend FROM Configuration) 
				AND 
				@TempDate NOT IN (SELECT Holidate FROM RevatureHolidays)
				AND
				@TempDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
				THEN
					SET @DOL = @DOL + 1;
				END IF;
				SET @TempDate = DATE_ADD(@TempDate, INTERVAL 1 DAY);
			END WHILE;
			SET @TempDate = StartDate;
			IF @DOL > 0
			THEN
				WHILE @TempDate <= EndDate
				DO
					IF DAYNAME(@TempDate) NOT IN (SELECT Weekend FROM Configuration)
					AND
					@TempDate NOT IN (SELECT Holidate FROM RevatureHolidays)
					AND
					@TempDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
					THEN
						START TRANSACTION;
						SET autocommit=0;
						CALL EmployeeTransactionInsert(EmpId, LeaveTypeIdParm, @TempDate, @DOL); # Working Fine
						COMMIT;
					END IF;
					SET @TempDate = DATE_ADD(@TempDate, INTERVAL 1 DAY);
				END WHILE;
				SELECT cmmt(EmpId, LeaveTypeIdParm, @DOL); # Perfect//Fine NOW
			ELSE
				SELECT CONCAT("Leave requested Between ", StartDate, " and ", EndDate,
				" was already a HOLIDAY or You Have been Granted for it previously");
			END IF;
		ELSE
			SELECT "You are Not from our company BruH!!!!";
		END IF;
	ELSE
		SELECT "!!!!Are you sane mate!!!!";
	END IF;
ELSE
	SELECT "Those Days were already been approved mate if your checking the status!!!!";
END IF;
END !
DELIMITER ;

CALL AskLeave(1, 1, '2017/01/11', '2017/01/23');
SELECT * FROM Employeeleavetransaction;


DROP FUNCTION IF EXISTS cmmt;
DELIMITER !
CREATE FUNCTION cmmt(EmpId INT, LeaveTypeIdParm TINYINT, DOL INT)
RETURNS VARCHAR(100)
BEGIN
	IF DOL <= ((SELECT NoOfDays FROM EmployeeLeavePolicy WHERE RoleId = (SELECT RoleId FROM Employee WHERE EId = EmpId) AND LeaveTypeId = LeaveTypeIdParm)
		- (SELECT COUNT(*) FROM EmployeeLeaveTransaction WHERE EmpId = EmployeeId AND LeaveTypeId = LeaveTypeIdParm))
	THEN
		RETURN CONCAT("Your ", (SELECT Decription FROM LeaveSeed WHERE Id=LeaveTypeIdParm)," Has Been Granted For ", 
			DOL, " Days and You have got ", 
			((SELECT NoOfDays FROM EmployeeLeavePolicy WHERE RoleId = (SELECT RoleId FROM Employee WHERE EId = EmpId) AND LeaveTypeId = LeaveTypeIdParm)
		- (SELECT COUNT(*) FROM EmployeeLeaveTransaction WHERE EmpId = EmployeeId AND LeaveTypeId = LeaveTypeIdParm)), 
			" more");
	ELSE
		RETURN "!!!!Are you sane mate!!!!";
	END IF;
END !


DROP PROCEDURE IF EXISTS EmployeeTransactionInsert;
DELIMITER !
CREATE PROCEDURE EmployeeTransactionInsert(EmpId INT, LeaveTypeIdParm TINYINT, DateOfLeavepar DATE, DOL INT)
BEGIN
	IF DOL <= ((SELECT NoOfDays FROM EmployeeLeavePolicy WHERE RoleId = (SELECT RoleId FROM Employee WHERE EId = EmpId) AND LeaveTypeId = LeaveTypeIdParm)
		- (SELECT COUNT(*) FROM EmployeeLeaveTransaction WHERE EmpId = EmployeeId AND LeaveTypeId = LeaveTypeIdParm))
	THEN
		INSERT INTO EmployeeLeaveTransaction (EmployeeId, LeaveTypeId, DateOfLeave, State) VALUES (EmpId, LeaveTypeIdParm, DateOfLeavepar, 'Requested');
	END IF;
	
END !
CALL EmployeeTransactionInsert(5,1,'2017/10/26',3);
SELECT * FROM EmployeeLeaveTransaction;


DROP PROCEDURE IF EXISTS ApproveLeave;
DELIMITER !
CREATE PROCEDURE ApproveLeave(EmpId INT, StartDate DATE, EndDate DATE, StateParm VARCHAR(10))
BEGIN
	SET @TempDate=StartDate;
SET @DOL = 0;
IF StartDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
OR
EndDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
AND
@TempDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE State = "Approved")
THEN
	IF CURDATE() <= StartDate AND StartDate<=EndDate
	THEN
		IF EmpId IN (SELECT EId FROM Employee)
		THEN
			WHILE @TempDate <= EndDate
			DO
				IF DAYNAME(@TempDate) NOT IN (SELECT Weekend FROM Configuration) 
				AND 
				@TempDate NOT IN (SELECT Holidate FROM RevatureHolidays)
				AND
				@TempDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
				THEN
					SET @DOL = @DOL + 1;
				END IF;
				SET @TempDate = DATE_ADD(@TempDate, INTERVAL 1 DAY);
			END WHILE;
			SET @TempDate = StartDate;
			IF @DOL > 0
			THEN
				WHILE @TempDate <= EndDate
				DO
					IF DAYNAME(@TempDate) NOT IN (SELECT Weekend FROM Configuration)
					AND
					@TempDate NOT IN (SELECT Holidate FROM RevatureHolidays)
					AND
					@TempDate NOT IN (SELECT DateOfLeave FROM employeeleavetransaction WHERE EmployeeId=EmpId)
					THEN
						START TRANSACTION;
						SET autocommit=0;
						CALL EmployeeTransactionInsert(EmpId, LeaveTypeIdParm, @TempDate, @DOL); # Working Fine
						COMMIT;
					END IF;
					SET @TempDate = DATE_ADD(@TempDate, INTERVAL 1 DAY);
				END WHILE;
				SELECT cmmt(EmpId, LeaveTypeIdParm, @DOL); # Perfect//Fine NOW
			ELSE
				SELECT CONCAT("Leave requested Between ", StartDate, " and ", EndDate,
				" was already a HOLIDAY or You Have been Granted for it previously");
			END IF;
		ELSE
			SELECT "You are Not from our company BruH!!!!";
		END IF;
	ELSE
		SELECT "!!!!Are you sane mate!!!!";
	END IF;
ELSE
	SELECT "Those Days were already been approved mate if your checking the status!!!!";
END !
DELIMITER ;


-- Trials

SELECT '2016/01/01'+'0/0/1';

SELECT DAYNAME(DATE_ADD('2017/01/07', INTERVAL 1 DAY));

SELECT DAYNAME('2017/01/07') NOT IN (SELECT Weekend FROM Configuration);

SELECT '2017/01/09'<='2017/01/08';

SELECT DATE_ADD('2017/01/08', INTERVAL 1 DAY);