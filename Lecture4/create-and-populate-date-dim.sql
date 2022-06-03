use northwindDW
GO


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate = 1996-01-01
SET @EndDate = DATEADD(YEAR, 100, GETDATE())

WHILE @StartDate <= @EndDate
BEGIN
	INSERT INTO [edw].[DimDate]
		([D_ID]
		,[Date]
		,[Day]
		,[Month]
		,[MonthName]
		,[Week]
		,[Quarter]
		,[Year]
		,[DayOfWeek]
		,[WeekdayName])
	SELECT
		CONVERT(CHAR(8), @StartDate, 112) AS D_ID
		,@StartDate AS [Date]
		,DATEPART(day, @StartDate) AS Day
		,DATEPART(month, @StartDate) AS Month
		,DATENAME(month, @StartDate) AS MonthName
		,DATEPART(week, @StartDate) AS Week
		,DATEPART(quarter, @StartDate) AS Quarter
		,DATEPART(year, @StartDate) AS Year
		,DATEPART(weekday, @StartDate) AS DayOfWeek
		,DATENAME(weekday, @StartDate) AS WeekdayName

	SET @StartDate = DATEADD(dd, 1, @StartDate)
END
GO