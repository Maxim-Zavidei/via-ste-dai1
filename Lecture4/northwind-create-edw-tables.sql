use northwindDW

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[DimDate]') AND type in (N'U'))
CREATE TABLE [edw].[DimDate](
	[D_ID] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Day] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [nvarchar](9) NOT NULL,
	[Week] [int] NOT NULL,
	[Quarter] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[DayOfWeek] [int] NOT NULL,
	[WeekdayName] [nvarchar](9) NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [edw].DimDate ADD CONSTRAINT PK_DimDate PRIMARY KEY (D_ID);
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[DimCustomer]') AND type in (N'U'))
CREATE TABLE edw.DimCustomer (
 C_ID INT IDENTITY NOT NULL,
 CustomerId NVARCHAR(5),
 CompanyName NVARCHAR(40),
 City NVARCHAR(15),
 Region NVARCHAR(15),
 PostalCode NVARCHAR(10),
 Country NVARCHAR(15)
);
GO

ALTER TABLE [edw].DimCustomer ADD CONSTRAINT PK_DimCustomer PRIMARY KEY (C_ID);
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[DimEmployee]') AND type in (N'U'))
CREATE TABLE edw.DimEmployee (
 E_ID INT IDENTITY NOT NULL,
 EmployeeId INT,
 LastName NVARCHAR(20),
 FirstName NVARCHAR(10),
 Title NVARCHAR(30),
 City NVARCHAR(15),
 Region NVARCHAR(15),
 PostalCode NVARCHAR(10),
 Country NVARCHAR(10)
);
GO

ALTER TABLE [edw].DimEmployee ADD CONSTRAINT PK_DimEmployee PRIMARY KEY (E_ID);
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[DimProduct]') AND type in (N'U'))
CREATE TABLE edw.DimProduct (
 P_ID INT IDENTITY NOT NULL,
 ProductId INT,
 ProductName NVARCHAR(40),
 SupplierId INT,
 SupplierName NVARCHAR(40),
 CategoryId INT,
 CategoryName NVARCHAR(15),
 Discontinued INT
);
GO

ALTER TABLE [edw].DimProduct ADD CONSTRAINT PK_DimProduct PRIMARY KEY (P_ID);
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[DimShipper]') AND type in (N'U'))
CREATE TABLE edw.DimShipper (
 S_ID INT IDENTITY NOT NULL,
 ShipperId INT,
 ShipperName NVARCHAR(40)
);
GO

ALTER TABLE [edw].DimShipper ADD CONSTRAINT PK_DimShipper PRIMARY KEY (S_ID);
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[edw].[FactSale]') AND type in (N'U'))
CREATE TABLE edw.FactSale (
 P_ID INT NOT NULL,
 C_ID INT NOT NULL,
 E_ID INT NOT NULL,
 S_ID INT NOT NULL,
 OD_ID INT NOT NULL,
 SD_ID INT NOT NULL,
 LineTotal DECIMAL(10),
 Quantity DECIMAL(10),
 Discount DECIMAL(10),
);
GO

ALTER TABLE edw.FactSale ADD CONSTRAINT PK_FactSale PRIMARY KEY (P_ID,C_ID,E_ID,OD_ID,S_ID,SD_ID);
GO


ALTER TABLE edw.FactSale ADD CONSTRAINT FK_FactSale_0 FOREIGN KEY (P_ID) REFERENCES edw.DimProduct (P_ID);
ALTER TABLE edw.FactSale ADD CONSTRAINT FK_FactSale_1 FOREIGN KEY (C_ID) REFERENCES edw.DimCustomer (C_ID);
ALTER TABLE edw.FactSale ADD CONSTRAINT FK_FactSale_2 FOREIGN KEY (E_ID) REFERENCES edw.DimEmployee (E_ID);
ALTER TABLE edw.FactSale ADD CONSTRAINT FK_FactSale_3 FOREIGN KEY (OD_ID) REFERENCES edw.DimDate (D_ID);
ALTER TABLE edw.FactSale ADD CONSTRAINT FK_FactSale_4 FOREIGN KEY (S_ID) REFERENCES edw.DimShipper (S_ID);
ALTER TABLE edw.FactSale ADD CONSTRAINT FK_FactSale_5 FOREIGN KEY (SD_ID) REFERENCES edw.DimDate (D_ID);