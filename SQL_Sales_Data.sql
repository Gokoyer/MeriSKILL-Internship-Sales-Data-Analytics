--This is the first project from MeriSKILL Internship Program

/*Purpose: Analyze sales data to identify trends, top-selling products, and revenue metrics for business decision-making.
Description: In this project, you will dive into a large sales dataset to extract valuable insights. You will explore sales 
trends over time, identify the best-selling products, calculate revenue metrics such as total sales and profit margins, and
create visualizations to present your findings effectively. This project showcases your ability to manipulate and derive 
insights from large datasets, enabling you to make data-driven recommendations for optimizing sales strategies. */

--Overview of the Sales Dataset

SELECT 
   *
FROM
   [dbo].[MeriSKILL Sales Data_1]

----------------------------Cleaning of the dataset-------------------------------------------------------------------
--Check for NULL values

SELECT 
   *
FROM
   [dbo].[MeriSKILL Sales Data_1]
WHERE
   [Order ID] IS NULL OR [Product] IS NULL OR [Quantity Ordered] IS NULL OR [Price Each] IS NULL OR [Order Date] IS NULL
   OR [Purchase Address] IS NULL OR [Month] IS NULL OR [Sales] IS NULL OR [City] IS NULL OR [Hour] IS NULL
   
--Check for duplicates
 SELECT
    [Order ID], [Product], [Quantity Ordered], [Price Each], [Order Date], [Purchase Address], [Month], [Sales], [City], [Hour], COUNT(*)
FROM
   [dbo].[MeriSKILL Sales Data_1]
GROUP BY
   [Order ID], [Product], [Quantity Ordered], [Price Each], [Order Date], [Purchase Address], [Month], [Sales], [City], [Hour]
HAVING
   COUNT(*) > 1
ORDER BY
   [Order ID]

--To delete Duplicates by keeping original data
WITH CTE AS
   (
SELECT *,
   ROW_NUMBER() OVER (PARTITION BY 
      [Order ID], 
	  [Product], 
	  [Quantity Ordered],
	  [Price Each], 
	  [Order Date], 
	  [Purchase Address], 
	  [Month], 
	  [Sales], 
	  [City],
	  [Hour] 
   ORDER BY   
      [Order ID],
	  [Product],
	  [Quantity Ordered],
	  [Price Each], 
	  [Order Date], 
	  [Purchase Address],
	  [Month], [Sales],
	  [City], [Hour]) AS RN
FROM [dbo].[MeriSKILL Sales Data_1]
)
DELETE FROM CTE WHERE RN<>1

--To delete Duplicates without keeping original
WITH CTE AS
   (
SELECT *,
   R = RANK() OVER (ORDER BY 
      [Order ID], 
	  [Product], 
	  [Quantity Ordered],
	  [Price Each], 
	  [Order Date], 
	  [Purchase Address], 
	  [Month], 
	  [Sales], 
	  [City],
	  [Hour])
FROM
   [dbo].[MeriSKILL Sales Data_1])
DELETE 
   CTE
WHERE 
   R IN (SELECT R FROM CTE GROUP BY R HAVING COUNT(*)>1)

--CREATE COLUMN FOR DISTINCT ORDER ID TO ASCERTAIN NUMBER FOR PURCHASE

SELECT DISTINCT [Order ID]
FROM [dbo].[MeriSKILL Sales Data_1]

SELECT DISTINCT [Quantity Ordered]
FROM [dbo].[MeriSKILL Sales Data_1]

SELECT DISTINCT [Product]
FROM [dbo].[MeriSKILL Sales Data_1]
ORDER BY [Product]

--CREATE COLUMN FOR ORDER DATE ONLY
ALTER TABLE [dbo].[MeriSKILL Sales Data_1]
ADD Dates DATE


UPDATE [dbo].[MeriSKILL Sales Data_1]
SET Dates = CAST([Order Date] AS Date)

--CREATE NEW COLUMN FOR THE SEASONS NAMES ONLY

ALTER TABLE [dbo].[MeriSKILL Sales Data_1]
ADD SEASON VARCHAR(25)

--To Convert month(int) to string for categorization
ALTER TABLE [dbo].[MeriSKILL Sales Data_1]
ADD MONTH_String VARCHAR(25)

UPDATE [dbo].[MeriSKILL Sales Data_1]
SET [Month_Varchar] = CAST([Month] AS VARCHAR(25))

--Rename the column SEASON to Season
sp_rename '[MeriSKILL Sales Data_1].[SEASON]', 'Season', 'COLUMN'

--Categorized Months by Season
SELECT [Month_Varchar], CASE
   WHEN [Month_Varchar] BETWEEN 1 AND 2 THEN 'Winter'
   WHEN [Month_Varchar] BETWEEN 3 AND 5 THEN 'Spring'
   WHEN [Month_Varchar] BETWEEN 6 AND 8 THEN 'Summer'
   WHEN [Month_Varchar] BETWEEN 9 AND 11 THEN 'Autumn' 
   WHEN [Month_Varchar] = 12 THEN 'Winter'
ELSE [Month_Varchar]
END AS Season
FROM [dbo].[MeriSKILL Sales Data_1]

UPDATE [dbo].[MeriSKILL Sales Data_1]
SET [Season] = (CASE
   WHEN [Month_Varchar] BETWEEN 1 AND 2 THEN 'Winter'
   WHEN [Month_Varchar] BETWEEN 3 AND 5 THEN 'Spring'
   WHEN [Month_Varchar] BETWEEN 6 AND 8 THEN 'Summer'
   WHEN [Month_Varchar] BETWEEN 9 AND 11 THEN 'Autumn' 
   WHEN [Month_Varchar] = 12 THEN 'Winter'
ELSE NULL
END)

--To Convert Hour(int) to string for Categorization
ALTER TABLE [dbo].[MeriSKILL Sales Data_1]
ADD Hour_String VARCHAR(25)

UPDATE [dbo].[MeriSKILL Sales Data_1]
SET Hour_String = CAST([Hour] AS VARCHAR(25))

--Create new column for period of purchase

ALTER TABLE [dbo].[MeriSKILL Sales Data_1]
ADD [Period] VARCHAR(25)

SELECT [Hour_String], CASE
   WHEN [Hour_String] >= 0 AND [Hour_String] <= 5 THEN 'Night'
   WHEN [Hour_String] >= 6 AND [Hour_String] <= 11 THEN 'Morning'
   WHEN [Hour_String] >= 12 AND [Hour_String] <= 17 THEN 'Afternoon'
    WHEN [Hour_String] >= 18 AND [Hour_String] <= 23 THEN 'Evening'
ELSE [Hour_String]
END AS [Period]
FROM [dbo].[MeriSKILL Sales Data_1]

---Categorised period of purchase

UPDATE [dbo].[MeriSKILL Sales Data_1]
SET [Period] = (CASE
   WHEN [Hour_String] BETWEEN 0 AND 5 THEN 'Night'
   WHEN [Hour_String] BETWEEN 6 AND 11 THEN 'Morning'
   WHEN [Hour_String] BETWEEN 12 AND 17 THEN 'Afternoon'
   WHEN [Hour_String] BETWEEN 18 AND 23 THEN 'Evening'
ELSE NULL
END)

--SELECT DATENAME(WEEKDAY,GETDATE()) AS WeekDay

--Create new column for Weekdays

ALTER TABLE [dbo].[MeriSKILL Sales Data_1]
ADD WeekDays VARCHAR(25)
 
UPDATE [dbo].[MeriSKILL Sales Data_1]
SET Weekdays = DATENAME(WEEKDAY,[Order Date])

