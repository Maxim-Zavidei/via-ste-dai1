
-- Product Dimension
-- Test DWH incremental update of a newly added product

-- Because it's a hell adding a product in our source database
-- Will just add stuff in staging area, hehe

-- 1. Extract and load to staging area the product dimension
truncate table [AdventureWorks2019DW].[stage].[Dim_Product]
insert into [AdventureWorks2019DW].[stage].[Dim_Product] (
	[ProductId]
    ,[ProductName]
    ,[ProductNumber]
    ,[CategoryName]
	,[Subcategory]
    ,[DiscontinuedDate]
)
SELECT
	p.[ProductID]
    ,p.[Name]
    ,[ProductNumber]
	,s.[Name]
    ,c.[Name]
    ,[DiscontinuedDate]
FROM [AdventureWorks2019].[Production].[Product] p
inner join [AdventureWorks2019].[Production].[ProductSubcategory] s
on p.ProductSubcategoryID = s.ProductSubcategoryID
inner join [AdventureWorks2019].[Production].[ProductCategory] c
on s.ProductCategoryID = c.ProductCategoryID

-- 2. Data cleansing of product dimension, taken from our handin
USE [AdventureWorks2019DW]
update stage.[Dim_Product]
set DiscontinuedDate = '2100-01-01 00:00:00.000'
WHERE DiscontinuedDate is null

update stage.[Dim_Product]
set ManufacturerName = 'Importadores Neptuno'
WHERE ManufacturerName is null


-- 3. Add a product record in the staging area
insert into [AdventureWorks2019DW].[stage].[Dim_Product] (
	[ProductID]
    ,[ProductName]
    ,[ProductNumber]
    ,[ManufacturerName]
    ,[CategoryName]
    ,[Subcategory]
    ,[DiscontinuedDate]
) VALUES (
	679,
	'New added product',
	'DAI-THE-BEST',
	'Rainbow Enterprise INC',
	'Road Frames',
	'Components',
	'2100-01-01 00:00:00.000'
)

-- 4. Run the incremental update code for adding new products
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