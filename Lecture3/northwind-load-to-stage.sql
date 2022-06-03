use [northwindDW]

truncate table [stage].[DimCustomer]
insert into [stage].[DimCustomer]
	([CustomerId]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country])
SELECT [CustomerID]
	,[CompanyName]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
FROM [northwindDB].[dbo].[Customers]


truncate table [stage].[DimEmployee]
insert into [stage].[DimEmployee]
	([EmployeeId]
	,[LastName]
	,[FirstName]
	,[Title]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country])
SELECT [EmployeeId]
	,[LastName]
	,[FirstName]
	,[Title]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
FROM [northwindDB].[dbo].[Employees]


truncate table [stage].[DimProduct]
insert into [stage].[DimProduct]
	([ProductId]
	,[ProductName]
	,[SupplierId]
	,[SupplierName]
	,[CategoryId]
	,[CategoryName]
	,[Discontinued])
SELECT [ProductId]
	,[ProductName]
	,p.[SupplierId]
	,s.[CompanyName] as [SupplierName]
	,p.[CategoryId]
	,c.[CategoryName]
	,[Discontinued]
FROM [northwindDB].[dbo].[Products] p
inner join [northwindDB].[dbo].Suppliers s
on p.SupplierID = s.SupplierID
inner join [northwindDB].[dbo].Categories c
on p.CategoryID = c.CategoryID


truncate table [stage].[DimShipper]
insert into [stage].[DimShipper]
	([ShipperId]
	,[ShipperName])
SELECT [ShipperId]
	,[CompanyName]
FROM [northwindDB].[dbo].[Shippers]


truncate table [stage].[FactSale]
insert into [stage].[FactSale]
	([ProductId]
	,[CustomerId]
	,[EmployeeId]
	,[ShipperId]
	,[OrderId]
	,[OrderDate]
	,[ShippedDate]
	,[LineTotal]
	,[Quantity]
	,[Discount])
SELECT [ProductId]
	,[CustomerId]
	,[EmployeeId]
	,[ShipVia]
	,o.[OrderId]
	,[OrderDate]
	,[ShippedDate]
	,[UnitPrice]*[Quantity]*(1-[Discount]) as LineTotal
	,[Quantity]
	,[Discount]
FROM [northwindDB].[dbo].[Orders] o
inner join [northwindDB].[dbo].[Order Details] od
on o.OrderID = od.OrderID