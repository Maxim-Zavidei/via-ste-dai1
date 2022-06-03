
-- Getting the last load date
DECLARE @LastLoadDate datetime
SET @LastLoadDate = (
	SELECT [Date]
	FROM [northwindDW].[edw].[DimDate]
	WHERE D_ID in (
		SELECT MAX([LastLoadDate])
		FROM [etl].[LogUpdate]
		WHERE [Table] = 'FactSale'
	)
)


-- Setting a last load date
DECLARE @LastLoadDate datetime
SET @LastLoadDate = (
	SELECT [Date]
	FROM [northwindDW].[edw].[DimDate]
	WHERE D_ID = 19980505
)


-- Insert any newer records into the staging area
TRUNCATE TABLE [stage].[FactSale]
INSERT INTO [stage].[FactSale]
	([ProductId]
	,[CustomerId]
	,[EmployeeId]
	,[ShipperId]
	,[OrderDate]
	,[OrderId]
	,[ShippedDate]
	,[LineTotal]
	,[Quantity]
	,[Discount]
	)
SELECT
	[ProductId]
	,[CustomerId]
	,[EmployeeId]
	,[ShipVia]
	,[OrderDate]
	,o.[OrderId]
	,[ShippedDate]
	,[UnitPrice] * [Quantity] * (1 - [Discount]) AS [LineTotal]
	,[Quantity]
	,[Discount]
FROM [northwindDB].[dbo].[Orders] o
inner join [northwindDB].[dbo].[Order Details] od
ON o.OrderID = od.OrderID
WHERE o.[OrderDate] > (@LastLoadDate)


-- Data cleansing
UPDATE [stage].[FactSale]
SET ShippedDate='2100-01-01 00:00:00.000'
WHERE ShippedDate is null


-- Insert the data into the edw
INSERT INTO [edw].[FactSale]
	([P_ID]
	,[C_ID]
	,[E_ID]
	,[S_ID]
	,[OD_ID]
	,[SD_ID]
	,[LineTotal]
	,[Quantity]
	,[Discount]
	)
SELECT
	p.[P_ID]
	,c.[C_ID]
	,e.[E_ID]
	,s.[S_ID]
	,od.[D_ID]
	,sd.[D_ID]
	,f.[LineTotal]
	,f.[Quantity]
	,f.[Discount]
FROM [northwindDW].[stage].[FactSale] f
left join [edw].[DimProduct] as p
on p.ProductId = f.ProductId
left join [edw].[DimCustomer] as c
on c.CustomerId = f.CustomerId
left join [edw].[DimEmployee] as e
on e.EmployeeId = f.EmployeeId
left join [edw].DimShipper as s
on s.ShipperId = f.ShipperId
left join [edw].[DimDate] as od
on od.Date = f.OrderDate
left join [edw].[DimDate] as sd
on sd.Date = f.ShippedDate
WHERE p.ValidTo = 99990101
and c.ValidTo = 99990101
and e.ValidTo = 99990101
and s.ValidTo = 99990101
