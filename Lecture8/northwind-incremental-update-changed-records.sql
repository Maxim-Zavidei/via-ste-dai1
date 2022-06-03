
DECLARE @LastLoadDate int
SET @LastLoadDate = (SELECT MAX([LastLoadDate]) From [etl].[LogUpdate] where [TABLE] = 'DimCustomer')
DECLARE @NewLoadDate int
SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate int
SET @FutureDate = 99990101


-- Get only the records that were changed
SELECT [CustomerId]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	INTO #tmp
FROM [stage].[DimCustomer] EXCEPT SELECT [CustomerId]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
FROM [edw].[DimCustomer]
WHERE validto=99990101
EXCEPT SELECT
	[CustomerId]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
FROM [stage].[DimCustomer]
WHERE CustomerId in (
	SELECT [CustomerId]
	FROM [stage].[DimCustomer] EXCEPT SELECT [CustomerId]
	FROM [edw].[DimCustomer]
	WHERE validto=99990101
)


INSERT INTO [edw].[DimCustomer] ([CustomerId]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	,[ValidFrom]
	,[ValidTo])
SELECT
	[CustomerId]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	,@NewLoadDate
	,@FutureDate
FROM #tmp

UPDATE [edw].[DimCustomer]
SET ValidTo=@NewLoadDate-1
WHERE CustomerId in (
	SELECT [CustomerId]
	FROM #tmp
) and [edw].[DimCustomer].ValidFrom < @NewLoadDate

DROP TABLE IF exists #tmp