USE [TestSourceDB]
GO

set identity_insert [dbo].[Orders] on
INSERT INTO [dbo].[Orders]
	([OrderID]
    ,[CustomerID]
    ,[EmployeeID]
    ,[OrderDate]
    ,[RequiredDate]
    ,[ShippedDate]
    ,[ShipVia]
    ,[Freight]
    ,[ShipName]
    ,[ShipAddress]
    ,[ShipCity]
    ,[ShipRegion]
    ,[ShipPostalCode]
    ,[ShipCountry])

SELECT [OrderID]
      ,[CustomerID]
      ,[EmployeeID]
      ,[OrderDate]
      ,[RequiredDate]
      ,[ShippedDate]
      ,[ShipVia]
      ,[Freight]
      ,[ShipName]
      ,[ShipAddress]
      ,[ShipCity]
      ,[ShipRegion]
      ,[ShipPostalCode]
      ,[ShipCountry]
  FROM [northwindDB].[dbo].[Orders]
  where [OrderID] % 10 = 7
  set identity_insert [dbo].[Orders] off