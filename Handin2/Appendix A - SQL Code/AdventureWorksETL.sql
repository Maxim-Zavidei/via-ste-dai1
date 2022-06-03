USE [master]
GO

/*  Drop database to re-run: */
  /* DROP DATABASE AdventureWorks2019DW */

  /* Creating AdventureWorks2019DW database */

CREATE DATABASE [AdventureWorks2019DW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'AdventureWorksDW', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW7.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'AdventureWorks2019DW_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AdventureWorksDW7_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO  

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [AdventureWorks2019DW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO 

USE [AdventureWorks2019DW]
GO
CREATE SCHEMA [stage]
GO

/* Creation of edw schema */
USE [AdventureWorks2019DW]
GO
CREATE SCHEMA [edw]
GO

/* Creating dimension customer */

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[Dim_Customer]') AND type in (N'U'))

CREATE TABLE stage.Dim_Customer (
 CustomerID INT ,
 CustomerName NVARCHAR(150),
 CustomerType nchar(2) ,
 PersonId INT,
 StoreId INT,
 Country NVARCHAR(50) 
);

/* Creating dimension employee*/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[Dim_Employee]') AND type in (N'U'))

CREATE TABLE stage.Dim_Employee (
 EmployeeID INT,
 EmployeeType NCHAR(2),
 FirstName NVARCHAR(150) ,
  MiddleName NVARCHAR(150) ,
  LastName NVARCHAR(150) ,
  EmployeeName NVARCHAR(150),
 JobTitle NVARCHAR(50) ,
 City NVARCHAR(30),
 Region NVARCHAR(50),
 PostalCode NVARCHAR(15) ,
 Country NVARCHAR(50) 
);

/* Creating dimension location */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[Dim_Location]') AND type in (N'U'))

CREATE TABLE stage.Dim_Location (

 TerritoryId INT ,
 Name NVARCHAR(50),
 Country NVARCHAR(50) 
);

/* Creating dimension order */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[Dim_Order]') AND type in (N'U'))


CREATE TABLE stage.Dim_Order (

 OrderID INT,
 TerritoryId INT,
 OnlineOrderFlag BIT ,
);

/* Creating dimension product */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[Dim_Product]') AND type in (N'U'))


CREATE TABLE stage.Dim_Product (

 ProductID INT,
 ProductName NVARCHAR(50) ,
 ProductNumber NVARCHAR(25),
 ManufacturerName NVARCHAR(50),
 CategoryName NVARCHAR(50),
 Subcategory NVARCHAR(50),
 DiscontinuedDate DateTime
);

/* Creating fact sale table */
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[Fact_Sale]') AND type in (N'U'))
CREATE TABLE stage.Fact_Sale (
ProductID INT,
 CustomerID INT  ,
 EmployeeID INT  ,
 OrderID INT   ,

 TerritoryId INT  ,
 TotalAmount NUMERIC(38,6) NOT NULL,
 Quantity SMALLINT NOT NULL,
 TaxRate DECIMAL(10),
 OrderDate DATETIME
);



/****** Load to stage order  ******/

insert into [AdventureWorks2019DW].[stage].[Dim_Order]
([OrderId],
[TerritoryId]
      ,[OnlineOrderFlag]
     )
SELECT  [SalesOrderID]
      ,[TerritoryID]
      ,[OnlineOrderFlag]
      
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader]
 

   /** Load to stage product  **/

insert into [AdventureWorks2019DW].[stage].[Dim_Product]
([ProductId]
      ,[ProductName]
      ,[ProductNumber]
      ,[CategoryName]
	  ,[Subcategory]
      ,[DiscontinuedDate])
SELECT   p.[ProductID]
      ,p.[Name]
      ,[ProductNumber]
	, s.[Name]
      ,c.[Name]
      ,[DiscontinuedDate]
  FROM [AdventureWorks2019].[Production].[Product] p
  inner join [AdventureWorks2019].[Production].[ProductSubcategory] s
  on p.ProductSubcategoryID=s.ProductSubcategoryID
  inner join [AdventureWorks2019].[Production].[ProductCategory] c
  on s.ProductCategoryID = c.ProductCategoryID

  /** Load to stage facts  **/
insert into  [AdventureWorks2019DW].[stage].[Fact_Sale]
( [ProductID],
[CustomerID]
	  ,[EmployeeID]
      ,[OrderId]
	  ,[TerritoryId]
      ,[TotalAmount]
      ,[Quantity]
      ,[TaxRate],
	 [OrderDate])
SELECT [ProductID],
		[CustomerID]
      ,[SalesPersonID]
      ,oh.[SalesOrderID]
	  ,[TerritoryID]
      ,[LineTotal]
      ,[OrderQty]
      ,[TaxAmt]
	  , o.[OrderDate]
  FROM [AdventureWorks2019].[Sales].[SalesOrderHeader] o
  inner join[AdventureWorks2019].[Sales].[SalesOrderDetail] oh
  on o.SalesOrderID = oh.SalesOrderID 
   

  /** Load to stage employee  **/
insert into  [AdventureWorks2019DW].[stage].[Dim_Employee]
([EmployeeID],
[EmployeeType]
,[FirstName]
,[MiddleName]
,[LastName]
      ,[JobTitle]
      ,[Region]
	  ,[City]
      ,[PostalCode]
      ,[Country])
SELECT  p.[BusinessEntityID],
p.[PersonType]
      ,p.[FirstName]
	  ,p.[MiddleName],
	  p.[LastName]
      , e.JobTitle
	  ,sp.[Name]
      ,ad.[City]
      
      ,ad.[PostalCode]
	  , c.[Name]
    
  FROM [AdventureWorks2019].[Person].[Person] p
  inner join [AdventureWorks2019].[HumanResources].[Employee] e
  on p.BusinessEntityID = e.BusinessEntityID
  inner join [AdventureWorks2019].[Person].[BusinessEntityAddress] a
  on p.BusinessEntityID = a.AddressID
   inner join [AdventureWorks2019].[Person].[Address] ad
   on a.AddressID = ad.AddressID
    inner join [AdventureWorks2019].[Person].[StateProvince] as sp
 on  sp.[StateProvinceID]  =ad.[StateProvinceID]
  inner join [AdventureWorks2019].[Person].[CountryRegion] as c
 on sp.[CountryRegionCode] = c.[CountryRegionCode]

 
  /** Load to stage customer  **/
 INSERT INTO [AdventureWorks2019DW].[stage].[Dim_Customer]
	(	CustomerID,
		CustomerType,
		PersonId,
		StoreId,
		Country )
SELECT 
cust.[CustomerID],
p.[PersonType],
cust.[PersonID],
cust.[StoreID],
c.[Name]

 /*FROM [AdventureWorks2019].[Person].[Person] p
  inner join [AdventureWorks2019].[Sales].[Customer] cust
  on p.BusinessEntityID = cust.CustomerID
  inner join [AdventureWorks2019].[Person].[BusinessEntityAddress] a
  on p.BusinessEntityID = a.AddressID
   inner join [AdventureWorks2019].[Person].[Address] ad
   on a.AddressID = ad.AddressID
    inner join [AdventureWorks2019].[Person].[StateProvince] as sp
 on  sp.[StateProvinceID]  =ad.[StateProvinceID]
  inner join [AdventureWorks2019].[Person].[CountryRegion] as c
 on sp.[CountryRegionCode] = c.[CountryRegionCode]
 */


 FROM [AdventureWorks2019].[Sales].[Customer] as cust
 inner join [AdventureWorks2019].[Sales].[SalesTerritory] as t
 on cust.[TerritoryID] = t.[TerritoryID]
 inner join [AdventureWorks2019].[Person].[CountryRegion] as c
 on t.[CountryRegionCode] = c.[CountryRegionCode]
 full join [AdventureWorks2019].[Person].[Person] as p
 on p.BusinessEntityID = cust.PersonID   

update [AdventureWorks2019DW].[stage].[Dim_Customer]
 set CustomerType='SC'
 where PersonId = -1 or PersonId is null

 update [AdventureWorks2019DW].[stage].[Dim_Customer]
 set CustomerType='SC'
 where PersonId is not null and StoreId is not null

delete from [AdventureWorks2019DW].[stage].[Dim_Customer] where [AdventureWorks2019DW].[stage].[Dim_Customer].[CustomerType] = 'EM' or [AdventureWorks2019DW].[stage].[Dim_Customer].CustomerType = 'SP'
delete from [AdventureWorks2019DW].[stage].[Dim_Customer] where [AdventureWorks2019DW].[stage].[Dim_Customer].[CustomerID] is null
 update [AdventureWorks2019DW].[stage].[Dim_Customer]
 set CustomerName = (SELECT s.Name
         FROM [AdventureWorks2019].[Sales].[Store] as s
         WHERE [AdventureWorks2019DW].[stage].[Dim_Customer].StoreId = s.BusinessEntityID)
 where CustomerType='SC'

 update [AdventureWorks2019DW].[stage].[Dim_Customer]
 set CustomerName = (SELECT p.FirstName + ' '+ p.LastName
         FROM [AdventureWorks2019].[Person].[Person] as p
         WHERE [AdventureWorks2019DW].[stage].[Dim_Customer].PersonId = p.BusinessEntityID)
 where CustomerType ='IN'

update [AdventureWorks2019DW].[stage].[Dim_Customer]
set StoreId = -1 where StoreId is null
update [AdventureWorks2019DW].[stage].[Dim_Customer]
set PersonId = -1 where PersonId is null



  /** Load to stage location  **/
INSERT INTO [AdventureWorks2019DW].[stage].[Dim_Location]
	(	[TerritoryId]
      ,[Name]
      ,[Country])
SELECT 
t.[TerritoryID],
t.[Name],
c.[Name]

 FROM [AdventureWorks2019].[Sales].[SalesTerritory] as t
 inner join [AdventureWorks2019].[Person].[CountryRegion] as c
 on t.[CountryRegionCode] = c.[CountryRegionCode]

  /*UPDATE f SET f.TotalAmount = (SELECT SUM(f2.TotalAmount) FROM AdventureWorks2019DW.stage.Fact_Sale f2 WHERE f2.OrderID = f.OrderID)
FROM AdventureWorks2019DW.stage.Fact_Sale f;

UPDATE f SET f.Quantity = (SELECT Count(f2.OrderID) FROM AdventureWorks2019DW.stage.Fact_Sale f2 WHERE f2.OrderID = f.OrderID)
FROM AdventureWorks2019DW.stage.Fact_Sale f;

WITH cte AS (
    SELECT 
        [CustomerID]
      ,[EmployeeID]
      ,[OrderID]
      ,[TerritoryId]
      ,[TotalAmount]
      ,[Quantity]
      ,[TaxRate]
      ,[OrderDate], 
        ROW_NUMBER() OVER (
            PARTITION BY 
               [OrderID]
            ORDER BY 
                [OrderID]
        ) row_num
     FROM 
       AdventureWorks2019DW.stage.Fact_Sale
)
DELETE FROM cte
WHERE row_num > 1;*/

/** update employee  **/
use [AdventureWorks2019DW]
update stage.[Dim_Employee]
set EmployeeName = FirstName + ' ' + MiddleName + ' ' + LastName
Where EmployeeName is null

use [AdventureWorks2019DW]
update stage.[Dim_Employee]
set EmployeeName = 'UNKNOWN'
WHERE EmployeeName is null

/** update fact sale table  **/
use [AdventureWorks2019DW]
update stage.[Fact_Sale]
set EmployeeID = -1
WHERE EmployeeID is null

/** update product table  **/

USE [AdventureWorks2019DW]
update stage.[Dim_Product]
set DiscontinuedDate = '2100-01-01 00:00:00.000'
WHERE DiscontinuedDate is null

update stage.[Dim_Product]
set ManufacturerName = 'Importadores Neptuno'
WHERE ManufacturerName is null




USE [AdventureWorks2019DW]
GO
/* Creation of Date Dimension */

DECLARE @Date DATETIME;
SET @Date = getdate()
SELECT CONVERT (CHAR(8), @Date, 112)
select GETDATE()

CREATE TABLE [edw].[Dim_Date](
[D_ID] [int] NOT NULL,
[Date] [datetime]  not null,
[Day] [int] NOT NULL,
[Month] [int] not null,
[MonthName] [nvarchar] (9) not null,
[Week] [int] not null,
[Quarter] [int] not null,
[Year] [int] not null,
[DayOfWeek] [int] not null,
[WeekdayName] [nvarchar] (9) not null,
Constraint [PK_Dim_Date] PRIMARY KEY CLUSTERED
(
[D_ID] ASC
)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
)ON [PRIMARY]
/*Adding data from start of times */

DECLARE @StartDate DATETIME;
DECLARE @EndDate DATETIME;

SET @StartDate = 1996-01-01
SET @EndDate = DATEADD(YEAR, 100, getDate())
WHILE @StartDate <= @EndDate
BEGIN
INSERT INTO edw.[Dim_Date]
( [D_ID]
,
[Date]
, [Day]
, [Month]
, [MonthName]
, [Week]
, [Quarter]
, [Year]
,[DayOfWeek]
, [WeekdayName]
)
SELECT 
CONVERT (CHAR(8), @StartDate, 112) as D_ID
, @StartDate as [Date]
, DATEPART(day, @StartDate) as Day
, DATEPART(month, @StartDate) as Month
, DATENAME(month, @StartDate) as MonthName
, DATEPART(week, @StartDate) as Week
, DATEPART(QUARTER, @StartDate) as Quarter
, DATEPART(YEAR, @StartDate) as Year
, DATEPART(WEEKDAY, @StartDate) as DayOfWeek
, DATENAME(WEEKDAY, @StartDate) as WeekdayName 
SET @StartDate = DATEADD(dd, 1, @StartDate)
END

GO

/*ALTER TABLE [edw].DimDate ADD CONSTRAINT PK_DimDate PRIMARY KEY (D_ID);
GO*/

/* Creation of edw dimension employee */ 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[Dim_Employee]') AND type in (N'U'))
CREATE TABLE edw.Dim_Employee (
E_ID INT IDENTITY NOT NULL,
 EmployeeID INT NOT NULL,
 EmployeeType NCHAR(2) NOT NULL,
  EmployeeName NVARCHAR(150),
 JobTitle NVARCHAR(50) NOT NULL,
 City NVARCHAR(30) NOT NULL,
 Region NVARCHAR(50) NOT NULL,
 PostalCode NVARCHAR(15) NOT NULL,
 Country NVARCHAR(50) 
);

ALTER TABLE edw.Dim_Employee ADD CONSTRAINT PK_DimEmployee PRIMARY KEY (E_ID);

/* Creation of edw dimension product */ 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[Dim_Product]') AND type in (N'U'))
use AdventureWorks2019DW
CREATE TABLE edw.Dim_Product (
P_ID INT IDENTITY NOT NULL,
 ProductID INT NOT NULL,
 ProductName NVARCHAR(50) NOT NULL,
 ProductNumber NVARCHAR(25) NOT NULL,
 ManufacturerName NVARCHAR(50),
 CategoryName NVARCHAR(50) NOT NULL,
 Subcategory NVARCHAR(50) NOT NULL,
 DiscontinuedDate DateTime
);

ALTER TABLE edw.Dim_Product ADD CONSTRAINT PK_Dim_Product PRIMARY KEY (P_ID);

/* Creation of edw dimension order */ 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[Dim_Order]') AND type in (N'U'))
use AdventureWorks2019DW
CREATE TABLE edw.Dim_Order (
O_ID INT IDENTITY NOT NULL,
 OrderID INT NOT NULL,
 TerritoryId INT,
 OnlineOrderFlag BIT NOT NULL
);

ALTER TABLE edw.Dim_Order ADD CONSTRAINT PK_Dim_Order PRIMARY KEY (O_ID);

/* Creation of edw dimension customer */ 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[Dim_Customer]') AND type in (N'U'))
CREATE TABLE edw.Dim_Customer (
 C_ID INT Identity(1,1) NOT NULL,
 CustomerID INT NOT NULL,
 PersonID INT NOT NULL,
 StoreID INT NOT NULL,
 CustomerName NVARCHAR(150),
 CustomerType NCHAR(2) NOT NULL,
 Country NVARCHAR(50) NOT NULL
);

ALTER TABLE edw.Dim_Customer ADD CONSTRAINT PK_Dim_Customer PRIMARY KEY (C_ID);

/* Creation of edw dimension location  */ 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[Dim_Location]') AND type in (N'U'))

CREATE TABLE edw.Dim_Location (
 L_ID INT Identity(1,1) NOT NULL,
 TerritoryId INT NOT NULL,
 Name NVARCHAR(50) NOT NULL,
 Country NVARCHAR(50) NOT NULL
);

ALTER TABLE edw.Dim_Location ADD CONSTRAINT PK_Dim_Location PRIMARY KEY (L_ID);


/* Creation of edw fact table  */ 

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[Fact_Sale]') AND type in (N'U'))

CREATE TABLE edw.Fact_Sale (
P_ID INT NOT NULL,
 C_ID INT  NOT NULL ,
 E_ID INT NOT NULL ,
 O_ID INT NOT NULL  ,
 L_ID INT NOT NULL ,
 OD_ID INT NOT NULL,
 TotalAmount NUMERIC(38,6) NOT NULL,
 Quantity SMALLINT NOT NULL,
 TaxRate DECIMAL(10)
);

ALTER TABLE edw.Fact_Sale ADD CONSTRAINT PK_Fact_Sale PRIMARY KEY (P_ID, C_ID, E_ID, O_ID, L_ID,OD_ID);

ALTER TABLE  edw.Fact_Sale ADD CONSTRAINT FK_Fact_Sale FOREIGN KEY (P_ID) REFERENCES edw.Dim_Product (P_ID);
ALTER TABLE  edw.Fact_Sale ADD CONSTRAINT FK_Fact_Sale_1 FOREIGN KEY (C_ID) REFERENCES edw.Dim_Customer (C_ID);
ALTER TABLE  edw.Fact_Sale ADD CONSTRAINT FK_Fact_Sale_2 FOREIGN KEY (E_ID) REFERENCES edw.Dim_Employee (E_ID);
ALTER TABLE  edw.Fact_Sale ADD CONSTRAINT FK_Fact_Sale_3 FOREIGN KEY (O_ID) REFERENCES edw.Dim_Order (O_ID);

ALTER TABLE  edw.Fact_Sale ADD CONSTRAINT FK_Fact_Sale_5 FOREIGN KEY (L_ID) REFERENCES edw.Dim_Location (L_ID);
ALTER TABLE  edw.Fact_Sale ADD CONSTRAINT FK_Fact_Sale_6 FOREIGN KEY (OD_ID) REFERENCES edw.Dim_Date (D_ID);

  /** Load to edw employee  **/

insert into [AdventureWorks2019DW].[edw].[Dim_Employee]
([EmployeeID]
 ,[EmployeeType]
      ,[EmployeeName]
	
      ,[JobTitle]    
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]  )
SELECT  [EmployeeID]
,[EmployeeType]
      ,[EmployeeName]
      ,[JobTitle]    
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country]      
  FROM [AdventureWorks2019DW].[stage].[Dim_Employee]

  Insert into [AdventureWorks2019DW].[edw].[Dim_Employee]
  ([EmployeeID]
 ,[EmployeeType]
      ,[EmployeeName]
	
      ,[JobTitle]    
      ,[City]
      ,[Region]
      ,[PostalCode]
      ,[Country] ) values 
	  (-1,'NA', 'None','None','None','None','None','None')

   /** Load to edw order  **/

insert into [AdventureWorks2019DW].[edw].[Dim_Order]
([OrderId],
[TerritoryId]
      ,[OnlineOrderFlag]  )
SELECT  [OrderId],
[TerritoryId]
      ,[OnlineOrderFlag]      
  FROM [AdventureWorks2019DW].[stage].[Dim_Order]

    /** Load to edw product  **/

insert into [AdventureWorks2019DW].[edw].[Dim_Product]
([ProductID]
      ,[ProductName]
      ,[ProductNumber]
	  ,[ManufacturerName]      
	  ,[CategoryName]
	  ,[Subcategory]
      ,[DiscontinuedDate])
SELECT  [ProductID]
      ,[ProductName]
     ,[ProductNumber]
	  ,[ManufacturerName]      
	  ,[CategoryName]
	  ,[Subcategory]
      ,[DiscontinuedDate]
  FROM [AdventureWorks2019DW].[stage].[Dim_Product] 

      /** Load to edw customer  **/
   INSERT INTO [AdventureWorks2019DW].[edw].[Dim_Customer]
	(	CustomerID,
		CustomerName,
		CustomerType,
		PersonID,
		StoreID,
		Country )
SELECT 
CustomerID,
CustomerName,
		CustomerType,
		PersonId,
		StoreId,
		Country

 FROM [AdventureWorks2019DW].[stage].[Dim_Customer]
 
 USE [AdventureWorks2019DW]
   /** Load to edw location  **/
  INSERT INTO [AdventureWorks2019DW].[edw].[Dim_Location]
	(	[TerritoryId]
      ,[Name]
      ,[Country])
SELECT 
[TerritoryId]
      ,[Name]
      ,[Country]

 FROM [AdventureWorks2019DW].[stage].[Dim_Location]

    /** Load to edw fact table */

  INSERT INTO [edw].[Fact_Sale]
  ( [P_ID],
  [C_ID]
  ,[E_ID]
  ,[O_ID]
  ,[L_ID]
   , [OD_ID]
  ,[TotalAmount]
  ,[Quantity]
  ,[TaxRate]
 )
  SELECT  
  p.[P_ID],
  c.[C_ID]
  , e.[E_ID]
  , o.[O_ID]
  , l.[L_ID]
  , od.[D_ID]
  , f.[TotalAmount]
  , f.[Quantity]
  , f.[TaxRate]
    
  FROM [stage].Fact_Sale f
  inner join [edw].Dim_Product as p
  on p.ProductID = f.ProductID
   inner join [edw].[Dim_Customer] as c
  on c.CustomerID = f.CustomerID

   inner join [edw].[Dim_Employee] as e
  on e.EmployeeID = f.EmployeeID

   inner join [edw].[Dim_Order] as o
  on o.OrderID = f.OrderID

   inner join [edw].[Dim_Location] as l
  on l.TerritoryId = f.TerritoryId

   inner join [edw].[Dim_Date] as od
  on od.Date = f.OrderDate