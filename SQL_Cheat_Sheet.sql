
/***********************************************************************************************

										SQL CHEAT SHEET

***********************************************************************************************/





/***********************************************************************************************
		Modifications to data base table
***********************************************************************************************/


-- Drop table if exists
/**************************************/
IF OBJECT_ID('dbo.temp_table','U') IS NOT NULL DROP TABLE dbo.temp_table 


-- Drop temporary table if exists
/**************************************/
IF OBJECT_ID('tempdb..#temp_test') IS NOT NULL DROP TABLE #temp_test 


-- Create dummy table
/**************************************/

SELECT 'A' AS [name], 2007 AS [year] , 4 AS [value] 
UNION ALL 
SELECT 'B', 2007, 6
UNION ALL 
SELECT 'C', 2007, 2
UNION ALL 
SELECT 'A', 2008, 1
UNION ALL 
SELECT 'B', 2008, 3
UNION ALL 
SELECT 'C', 2008, 5

/**************************************/

-- Create a table by selecting into it
/**************************************/
IF OBJECT_ID('tempdb..#temp_test') IS NOT NULL DROP TABLE #temp_test 

SELECT 'A' AS [name], 2007 AS [year] , 4 AS [value] 
INTO #temp_test 

UNION ALL 
SELECT 'B', 2007, 6
UNION ALL 
SELECT 'C', 2007, 2
UNION ALL 
SELECT 'A', 2008, 1
UNION ALL 
SELECT 'B', 2008, 3
UNION ALL 
SELECT 'C', 2008, 5

/**************************************/






/***********************************************************************************************
		Table operations
***********************************************************************************************/


-- Aggragate over rows by GROUP BY
/**************************************/

IF OBJECT_ID('tempdb..#temp_test') IS NOT NULL DROP TABLE #temp_test 
SELECT 'A' AS [name], 2007 AS [year] , 4 AS [value] 
INTO #temp_test 
UNION ALL 
SELECT 'B', 2007, 6
UNION ALL 
SELECT 'C', 2007, 2
UNION ALL 
SELECT 'A', 2008, 1
UNION ALL 
SELECT 'B', 2008, 3
UNION ALL 
SELECT 'C', 2008, 5

SELECT * FROM #temp_test

SELECT 
	 name
	,SUM(value) as SumOverYears
FROM #temp_test
GROUP BY 
	name
/**************************************/


-- Fill missing values with UPDATE and INNER JOIN
/**************************************/


IF OBJECT_ID('tempdb..#temp_test') IS NOT NULL DROP TABLE #temp_test 
SELECT 'A' AS [name], 2007 AS [year] , 4 AS [value] 
INTO #temp_test
UNION ALL 
SELECT 'A', 2008, 4
UNION ALL 
SELECT 'B', 2007, 2
UNION ALL 
SELECT 'B', 2008, NULL
UNION ALL 
SELECT 'C', 2007, 3
UNION ALL 
SELECT 'C', 2008, 3

SELECT * FROM #temp_test

UPDATE dt1
SET dt1.[value] = dt2.[value]
FROM #temp_test AS dt1
INNER JOIN #temp_test AS dt2 ON
		dt1.[name] = dt2.[name]
WHERE dt1.[value] IS NULL AND dt2.[value] IS NOT NULL

SELECT * FROM #temp_test


/**************************************/