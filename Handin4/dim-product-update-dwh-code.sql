
-- Update the DWH with:
-- any new added products since last update

DECLARE @LastLoadDate int
SET @LastLoadDate = (SELECT MAX([LastLoadDate]) From [et1].[LogUpdate] where [TABLE] = 'Dim_Product')
DECLARE @NewLoadDate int
SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate int
SET @FutureDate = 99990101

INSERT INTO [edw].[Dim_Product] (
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
	,[ValidFrom]
	,[ValidTo])
SELECT
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
	,@NewLoadDate
	,@FutureDate
FROM [stage].[Dim_Product]

WHERE ProductId in (
	SELECT [ProductId]
	FROM [stage].[Dim_Product] EXCEPT SELECT [ProductId]
	FROM [edw].[Dim_Product]
	WHERE validto = 99990101
)



-- Update the DWH with:
-- any deleted products since last update

DECLARE @LastLoadDate int
SET @LastLoadDate = (SELECT MAX([LastLoadDate]) From [et1].[LogUpdate] where [TABLE] = 'Dim_Product')
DECLARE @NewLoadDate int
SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate int
SET @FutureDate = 99990101

UPDATE [edw].[Dim_Product]
SET ValidTo = @NewLoadDate - 1
WHERE ProductId in (
	SELECT [ProductId]
	FROM [edw].[Dim_Product]
	WHERE [ProductId] in (
		SELECT [ProductId] FROM [edw].[Dim_Product]
		EXCEPT SELECT [ProductId]
		FROM [stage].[Dim_Product]
	)
) and ValidTo = 99990101

INSERT INTO [et1].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('Dim_Product', @NewLoadDate)



-- Update the DWH with:
-- any changed products since last update

DECLARE @LastLoadDate int
SET @LastLoadDate = (SELECT MAX([LastLoadDate]) From [et1].[LogUpdate] where [TABLE] = 'Dim_Product')
DECLARE @NewLoadDate int
SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate int
SET @FutureDate = 99990101

-- Get only the records that were changed
SELECT
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
	INTO #tmp
FROM [stage].[Dim_Product] EXCEPT SELECT
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
FROM [edw].[Dim_Product]
WHERE validto=99990101
EXCEPT SELECT
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
FROM [stage].[Dim_Product]
WHERE ProductId in (
	SELECT [ProductId]
	FROM [stage].[Dim_Product] EXCEPT SELECT [ProductId]
	FROM [edw].[Dim_Product]
	WHERE validto=99990101
)

INSERT INTO [edw].[Dim_Product] (
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
	,[ValidFrom]
	,[ValidTo])
SELECT
	[ProductId]
	,[ProductName]
	,[ProductNumber]
	,[ManufacturerName]
	,[CategoryName]
	,[Subcategory]
	,[DiscontinuedDate]
	,@NewLoadDate
	,@FutureDate
FROM #tmp

UPDATE [edw].[Dim_Product]
SET ValidTo = @NewLoadDate-1
WHERE ProductId in (
	SELECT [ProductId]
	FROM #tmp
) and [edw].[Dim_Product].ValidFrom < @NewLoadDate

DROP TABLE IF exists #tmp