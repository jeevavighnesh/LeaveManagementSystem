DROP TABLE IF EXISTS test;
CREATE TABLE test
(
	_range INT CHECK (_range BETWEEN 5 AND 5),
	cmmt VARCHAR(100)
);
INSERT INTO test.test VALUES (0); 

SELECT * FROM test;