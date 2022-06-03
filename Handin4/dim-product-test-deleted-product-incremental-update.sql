
-- Product Dimension
-- Test DWH incremental update of a deleted product

-- Because it's a hell deleting a product in our source database
-- Will just delete stuff in staging area, hehe

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


-- 3. Delete a product record in the staging area
delete from [AdventureWorks2019DW].[stage].[Dim_Product]
where ProductID = 753


-- 4. Run the incremental update code for deleted products
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