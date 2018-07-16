
/***********************************************************************

			SQL CHEAT SHEET

***********************************************************************/


/**********************************************************************
		Search tables, views  with name having
***********************************************************************/
SELECT * FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME LIKE '%SAP%'


/**********************************************************************
		Update column properties
***********************************************************************/

-- remove ceortain character
UPDATE my_table SET my_column = REPLACE(my_column,'"','');

-- set some string to NULL
update my_table
set my_column = NULL
WHERE my_column = 'NA';

-- change column type
ALTER TABLE my_table
ALTER COLUMN my_column int; 

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




-- Pivoting table
/*****************OPEN*********************/

IF OBJECT_ID('tempdb..#temp_test') IS NOT NULL DROP TABLE #temp_test 
SELECT 'A' AS [name], 2007 AS [year] , 4 AS [value] 
INTO #temp_test
UNION ALL 
SELECT 'A', 2008, 4
UNION ALL 
SELECT 'B', 2007, 2
UNION ALL 
SELECT 'B', 2008, 8
UNION ALL 
SELECT 'C', 2007, 3
UNION ALL 
SELECT 'C', 2008, 3

SELECT * FROM #temp_test

SELECT *
FROM 
(
  SELECT [name], [year], [value]
  FROM #temp_test
) src
PIVOT
(
  SUM([value])
  FOR [name] in ([A], [B], [C])
) piv

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



-- Custom ORDER BY
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
ORDER BY case
		when [name] = 'B' then 1
		when [name] = 'C' then 2
		when [name] = 'A' then 3
		end asc



-- Info on CROSS APPLY vs OUTER APPLY
/*****************OPEN********************

CROSS APPLY is SQL Servre specific

CROSS Apply is like an inner join and will only return the results from the parent 
table where it is getting a result from the function.

OUTER Apply can be compared to a left outer join and shows all the records from the 
parent table, plus will show a null if no result from the function

****************CLOSE*********************/



-- Lead/lag
/*****************OPEN*********************/

-- Wider format
IF OBJECT_ID('tempdb..#temp_test') IS NOT NULL DROP TABLE #temp_test 

SELECT 2007 AS [year], 3 AS val1, 1 AS val2 
INTO #temp_test 

UNION ALL 
SELECT 2008, 5, 9
UNION ALL 
SELECT 2009, 7, 3
GO

select 
	 a.*
	,Lag(val1, 1, NULL) over (order by [year] asc) as val1_lag
	,Lag(val2, 1, NULL) over (order by [year] asc) as val2_lag
from #temp_test AS a


-- Long format
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

select 
	 a.*
	,Lag([value], 1, NULL) over (partition by [name] order by [name], [year] asc) as Lag1
from #temp_test AS a

/****************CLOSE*********************/



-- Merge two tables and overlay columns
/*****************OPEN*********************/
IF OBJECT_ID('tempdb..#temp_test1') IS NOT NULL DROP TABLE #temp_test1
IF OBJECT_ID('tempdb..#temp_test2') IS NOT NULL DROP TABLE #temp_test2
IF OBJECT_ID('tempdb..#temp_test3') IS NOT NULL DROP TABLE #temp_test3


SELECT *
INTO #temp_test1
FROM
(
	SELECT 'A' AS col1, 'ee' AS col2, NULL AS val1 , NULL AS val2
	UNION ALL 
	SELECT 'B', 'ee', NULL, NULL
	UNION ALL 
	SELECT 'C', 'ee', 2007, 8
	UNION ALL 
	SELECT 'A', 'ff', 2008, 1
	UNION ALL 
	SELECT 'B', 'ff', NULL, NULL
	UNION ALL 
	SELECT 'C', 'ff', 2008, 5
) as a

SELECT *
INTO #temp_test2
FROM
(
	SELECT 'A' AS col1, 'ee' AS col2, NULL AS val1 , NULL AS val2 
	UNION ALL 
	SELECT 'B', 'ee', 2451, 9
	UNION ALL 
	SELECT 'C', 'ee', NULL, NULL
	UNION ALL 
	SELECT 'A', 'ff', NULL, NULL
	UNION ALL 
	SELECT 'B', 'ff', 2512, 41
	UNION ALL 
	SELECT 'C', 'ff', NULL, NULL
) as b

SELECT *
INTO #temp_test3
FROM
(
	SELECT 'A' AS col1, 'ee' AS col2, 2007 AS val1 , 10 AS val2 
	UNION ALL 
	SELECT 'B', 'ee', NULL, NULL
	UNION ALL 
	SELECT 'C', 'ee', NULL, NULL
	UNION ALL 
	SELECT 'A', 'ff', NULL, NULL
	UNION ALL 
	SELECT 'B', 'ff', NULL, NULL
	UNION ALL 
	SELECT 'C', 'ff', NULL, NULL
) as c


SELECT *
FROM #temp_test1

SELECT *
FROM #temp_test2

SELECT *
FROM #temp_test3

SELECT 
	 e.col1
	,e.col2
	,concat(e.val1, r.val1, t.val1) as concatval1
	,concat(e.val2, r.val2, t.val2) as concatval2
FROM #temp_test1 e
LEFT JOIN #temp_test2 r
ON e.col1 = r.col1 and e.col2 = r.col2
LEFT JOIN #temp_test3 t
ON e.col1 = T.col1 and e.col2 = t.col2


/****************CLOSE*********************/

-- Determine ynderlying types form varchars
/*****************OPEN*********************/

declare @test nvarchar(3) = '   '
declare @test2 nvarchar(3) = 'rge'
declare @test3 nvarchar(3) = '014'

select CAST(@test AS float), ISNUMERIC(@test2), ISNUMERIC(@test3) 

select SQL_VARIANT_PROPERTY('aa', 'BaseType'), SQL_VARIANT_PROPERTY('012', 'BaseType'), SQL_VARIANT_PROPERTY(cast('012' as float), 'BaseType'); 




-- FULL OUTER JOIN
/*****************OPEN*********************/


WITH tab1 AS
(
	SELECT 'A' AS [name], 2007 AS [year] , 4 AS [value] 
	UNION ALL 
	SELECT 'B', 2008, 6
	UNION ALL 
	SELECT 'C', 2009, 2
),
tab2 AS
(
	SELECT 'A' AS [name], 2007 AS [year] , 'tree' AS [stringfield] 
	UNION ALL 
	SELECT 'A' AS [name], 2008 AS [year] , 'tres' AS [stringfield] 
	UNION ALL 
	SELECT 'B', 2008, 'one'
)


-- all fields form both
SELECT 
	 tab1.[name]
	,tab1.[year]
	,tab1.[value]
	,tab2.[name]
	,tab2.[year]
	,tab2.[stringfield]
FROM tab1
FULL outer join tab2
ON		tab1.[name] = tab2.[name]
	and tab1.[year] = tab2.[year]



-- common fields lef tout
SELECT *
FROM tab1
FULL outer join tab2
ON tab1.[name] = tab2.[name]


/****************CLOSE*********************/

-- Counts from multiple tables
/*****************OPEN*********************/

SELECT  
(
    SELECT COUNT(*)
    FROM tab1
) AS count1,
(
    SELECT COUNT(*)
    FROM tab2
) AS count2,
(
    SELECT COUNT(*)
    FROM tab3
) AS count3


/****************CLOSE*********************/




-- Sum column values and show in another column
/*****************OPEN*********************/

WITH tab as
(
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
)

select *, SUM([value]) OVER() from tab

/****************CLOSE*********************/











/****************CLOSE*********************/



-- Multi-Statement Table-Valued Function
/*****************OPEN*********************/

CREATE FUNCTION schema.function_name(
	  -- input variables  
)

RETURNS @Output TABLE
(
	 -- output column types
)
AS
BEGIN
	
	-- one can e.g. declare table variables
	DECLARE @tab AS schema.TT_tab
	INSERT @tab
	SELECT *
	FROM some_table




	-- one can have IF ELSE clauses!
	IF EXISTS(
		select SopimusNumeroId
		from some_table
	)
	BEGIN
		-- do someting
	END
	ELSE
	BEGIN
		-- do something
	END

-- this is needed
RETURN

END

