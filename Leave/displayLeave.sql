DROP PROCEDURE IF EXISTS DisplayLeaves;
DELIMITER !
CREATE PROCEDURE DisplayLeaves(EmpId INT, StartDate DATE, EndDate DATE)
BEGIN
	SELECT CONCAT("You have a total of ", SELECT COUNT(*) FROM employeeleavetransaction WHERE EmployeeId = EmpId, "");
END !
DELIMITER;