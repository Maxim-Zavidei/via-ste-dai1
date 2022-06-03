create schema etl


CREATE TABLE etl.[LogUpdate] (
	[Table] [nvarchar](50) NULL,
	[LastLoadDate] int NULL
) ON [PRIMARY]
GO


INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('DimCustomer', 19980506)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('DimProduct', 19980506)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('DimShipper', 19980506)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('DimEmployee', 19980506)
INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('FactSale', 19980506)


alter table [edw].[DimCustomer]
add ValidFrom int, ValidTo int

alter table [edw].[DimEmployee]
add ValidFrom int, ValidTo int

alter table [edw].[DimProduct]
add ValidFrom int, ValidTo int

alter table [edw].[DimShipper]
add ValidFrom int, ValidTo int


update [edw].[DimCustomer]
set ValidFrom = 19960704, ValidTo = 99990101

update [edw].[DimEmployee]
set ValidFrom = 19960704, ValidTo = 99990101

update [edw].[DimProduct]
set ValidFrom = 19960704, ValidTo = 99990101

update [edw].[DimShipper]
set ValidFrom = 19960704, ValidTo = 99990101