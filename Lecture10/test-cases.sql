
-- Number of order lines
SELECT count(*) as CountOnSource
	FROM [TestSourceDB].[dbo].[Order Details]

SELECT count(*) as CountOnFact
	FROM [TestDW].[edw].[FactSale]

-- Number of customers
SELECT count(*) as CountCustomerOnSource
	FROM [TestSourceDB].[dbo].[Customers]

SELECT count(*) as CountCustomerOnEdw
	FROM [TestDW].[edw].[DimCustomer]

-- Total Sum of Sales (will have an error because of the datatypes in when creating the tables)
SELECT sum([UnitPrice] * [Quantity] * (1 - [Discount])) as SumOnSource
	FROM [TestSourceDB].[dbo].[Order Details]

SELECT sum(LineTotal) as SumOnFact
FROM [TestDW].[edw].[FactSale]