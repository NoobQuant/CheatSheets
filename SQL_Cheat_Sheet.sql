
/***********************************************************************

			SQL CHEAT SHEET

***********************************************************************/





/**********************************************************************
		Modifications to data base table
***********************************************************************/


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






/**********************************************************************
		Table operations
***********************************************************************/


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
/*****************OPEN*********************/


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


/****************CLOSE*********************/






-- Avoid nested loops due to calculated columns using OUTER APPLY
/*****************OPEN*********************/


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
GO
-- 1st calculated column is put to OUTER APPLY
-- 2nd calculated column can be done in SELECT
SELECT 
	 [name]
	,[year]
	,[value]
	,B.new_col
	,B.new_col + 2 AS new_col2
FROM #temp_test AS A
OUTER APPLY (SELECT [year] - [value] as new_col ) AS B
GO

-- Second outer apply can use first outer apply!
SELECT 
	 [name]
	,[year]
	,[value]
	,B.new_col
	,C.new_col2
FROM #temp_test AS A
OUTER APPLY (SELECT [year] - [value] as new_col ) AS B
OUTER APPLY (SELECT B.new_col + 5 as new_col2 ) AS C

/****************CLOSE*********************/





-- Info on CROSS APPLY vs OUTER APPLY
/*****************OPEN********************

CROSS APPLY is SQL Servre specific

CROSS Apply is like an inner join and will only return the results from the parent 
table where it is getting a result from the function.

OUTER Apply can be compared to a left outer join and shows all the records from the 
parent table, plus will show a null if no result from the function

****************CLOSE*********************/


