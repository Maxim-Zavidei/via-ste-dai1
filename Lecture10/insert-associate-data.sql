SET IDENTITY_INSERT [dbo].[Orders] OFF

INSERT INTO [dbo].[Order Details] (
	[OrderID]
	,[ProductID]
	,[UnitPrice]
	,[Quantity]
	,[Discount]
	)
SELECT
	[OrderID]
	,[ProductID]
	,[UnitPrice]
	,[Quantity]
	,[Discount]
FROM [northwindDB].[dbo].[Order Details]
WHERE OrderID in (
	SELECT DISTINCT orderid
	FROM [dbo].[Orders]
)
GO

SET IDENTITY_INSERT [dbo].[Products] ON
GO

INSERT INTO [dbo].[Products]
(
	[ProductName]
	,[ProductID]
	,[SupplierID]
	,[CategoryID]
	,[QuantityPerUnit]
	,[UnitPrice]
	,[UnitsInStock]
	,[ReorderLevel]
	,[Discontinued]
) SELECT
	[ProductName]
	,[ProductID]
	,[SupplierID]
	,[CategoryID]
	,[QuantityPerUnit]
	,[UnitPrice]
	,[UnitsInStock]
	,[ReorderLevel]
	,[Discontinued]
FROM [northwindDB].[dbo].[Products]
WHERE ProductID in (
	SELECT DISTINCT ProductID
	FROM [dbo].[Order Details]
	)
GO

SET IDENTITY_INSERT [dbo].[Products] OFF

SET IDENTITY_INSERT [dbo].[Categories] ON
GO

INSERT INTO [dbo].[Categories] (
	[CategoryID]
	,[CategoryName]
	,[Description]
	,[Picture])
SELECT
	[CategoryID]
	,[CategoryName]
	,[Description]
	,[Picture]
FROM [northwindDB].[dbo].[Categories]
WHERE [CategoryID] IN (
	SELECT DISTINCT [CategoryID]
	FROM [dbo].[Products]
	)
GO

SET IDENTITY_INSERT [dbo].[Categories] OFF

SET IDENTITY_INSERT [dbo].[Suppliers] ON

INSERT INTO [dbo].[Suppliers] (
	[SupplierID]
	,[CompanyName]
	,[ContactName]
	,[ContactTitle]
	,[Address]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	,[Phone]
	,[Fax]
	,[HomePage])
SELECT
	[SupplierID]
	,[CompanyName]
	,[ContactName]
	,[ContactTitle]
	,[Address]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	,[Phone]
	,[Fax]
	,[HomePage]
FROM [northwindDB].[dbo].[Suppliers]
WHERE [SupplierID] IN (
	SELECT DISTINCT [SupplierID]
	FROM [dbo].[Products]
	)
GO
SET IDENTITY_INSERT [dbo].[Suppliers] OFF



SET IDENTITY_INSERT [dbo].[Shippers] ON
GO

INSERT INTO [dbo].[Shippers] (
	[ShipperID]
	,[CompanyName]
	,[Phone])
SELECT
	[ShipperID]
	,[CompanyName]
	,[Phone]
FROM [northwindDB].[dbo].[Shippers]
WHERE [ShipperID] IN (
	SELECT DISTINCT [ShipperID]
	FROM [dbo].[Products]
	)
GO

SET IDENTITY_INSERT [dbo].[Shippers] OFF


SET IDENTITY_INSERT [dbo].[Employees] ON
GO

INSERT INTO [dbo].[Employees]
	([EmployeeID]
	,[LastName]
	,[FirstName]
	,[Title]
	,[TitleOfCourtesy]
	,[BirthDate]
	,[HireDate]
	,[Address]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	,[HomePhone]
	,[Extension]
	,[Photo]
	,[Notes]
	,[ReportsTo]
	,[PhotoPath])
SELECT
	[EmployeeID]
	,[LastName]
	,[FirstName]
	,[Title]
	,[TitleOfCourtesy]
	,[BirthDate]
	,[HireDate]
	,[Address]
	,[City]
	,[Region]
	,[PostalCode]
	,[Country]
	,[HomePhone]
	,[Extension]
	,[Photo]
	,[Notes]
	,[ReportsTo]
	,[PhotoPath]
FROM [northwindDB].[dbo].[Employees]
WHERE [EmployeeID] IN (
	SELECT DISTINCT [EmployeeID]
	FROM [dbo].[Orders]
	)
GO

SET IDENTITY_INSERT [dbo].[Employees] OFF


INSERT INTO [dbo].[Customers]
	([CustomerID]
      ,[CompanyName]
      ,[ContactName]
      ,[ContactTitle]
      ,[Address]
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]
      ,[Phone]
      ,[Fax])
SELECT [CustomerID]
      ,[CompanyName]
      ,[ContactName]
      ,[ContactTitle]
      ,[Address]
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]
      ,[Phone]
      ,[Fax]
  FROM [northwindDB].[dbo].[Customers]
  WHERE [CustomerID] IN (
	SELECT DISTINCT [CustomerID]
	FROM [dbo].[Orders]
	)
GO
