IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[DimCustomer]') AND type in (N'U'))
CREATE TABLE stage.DimCustomer (
 CustomerId NCHAR VARYING(5) NOT NULL,
 CompanyName NCHAR VARYING(40),
 City NCHAR VARYING(15),
 Region NCHAR VARYING(15),
 PostalCode NCHAR VARYING(10),
 Country NCHAR VARYING(15)
);

ALTER TABLE stage.DimCustomer ADD CONSTRAINT PK_DimCustomer PRIMARY KEY (CustomerId);


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[DimEmployee]') AND type in (N'U'))
CREATE TABLE stage.DimEmployee (
 EmployeeId INT NOT NULL,
 LastName NCHAR VARYING(20),
 FirstName NCHAR VARYING(10),
 Title NCHAR VARYING(30),
 City NCHAR VARYING(15),
 Region NCHAR VARYING(15),
 PostalCode NCHAR VARYING(10),
 Country NCHAR VARYING(15)
);

ALTER TABLE stage.DimEmployee ADD CONSTRAINT PK_DimEmployee PRIMARY KEY (EmployeeId);


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[DimProduct]') AND type in (N'U'))
CREATE TABLE stage.DimProduct (
 ProductId INT NOT NULL,
 ProductName NCHAR VARYING(40),
 SupplierName NCHAR VARYING(40),
 SupplierId INT,
 CategoryName NCHAR VARYING(15),
 CategoryId INT,
 Discontinued BIT
);

ALTER TABLE stage.DimProduct ADD CONSTRAINT PK_DimProduct PRIMARY KEY (ProductId);


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[DimShipper]') AND type in (N'U'))
CREATE TABLE stage.DimShipper (
 ShipperId INT NOT NULL,
 ShipperName NCHAR VARYING(40)
);

ALTER TABLE stage.DimShipper ADD CONSTRAINT PK_DimShipper PRIMARY KEY (ShipperId);


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[stage].[FactSale]') AND type in (N'U'))
CREATE TABLE stage.FactSale (
 EmployeeId INT NOT NULL,
 CustomerId NCHAR VARYING(5) NOT NULL,
 ShipperId INT NOT NULL,
 ProductId INT NOT NULL,
 OrderId INT NOT NULL,
 LineTotal DECIMAL(10),
 Quantity DECIMAL(10),
 Discount DECIMAL(10),
 OrderDate DATETIME,
 ShippedDate DATETIME
);

ALTER TABLE stage.FactSale ADD CONSTRAINT PK_FactSale PRIMARY KEY (EmployeeId,CustomerId,ShipperId,ProductId,OrderId);