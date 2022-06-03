
DECLARE @LastLoadDate int
SET @LastLoadDate = (SELECT MAX([LastLoadDate]) From [etl].[LogUpdate] where [TABLE] = 'DimCustomer')
DECLARE @NewLoadDate int
SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate int
SET @FutureDate = 99990101


INSERT INTO [edw].[DimCustomer] (
	[CustomerId]
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
FROM [stage].[DimCustomer]

WHERE customerid in (
	SELECT [CustomerId]
	FROM [stage].[DimCustomer] EXCEPT SELECT [CustomerId]
	FROM [edw].[DimCustomer]
	WHERE validto = 99990101
)
