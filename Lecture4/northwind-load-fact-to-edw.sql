INSERT INTO [edw].[FactSale]
	([P_ID]
	,[C_ID]
	,[E_ID]
	,[S_ID]
	,[OD_ID]
	,[SD_ID]
	,[LineTotal]
	,[Quantity]
	,[Discount])
SELECT p.[P_ID]
	,c.[C_ID]
	,e.[E_ID]
	,s.[S_ID]
	,od.[D_ID]
	,sd.[D_ID]
	,f.[LineTotal]
	,f.[Quantity]
	,f.[Discount]

FROM [stage].[FactSale] f
inner join [edw].[DimProduct] AS p
ON p.ProductId = f.ProductId
inner join [edw].[DimCustomer] AS c
ON c.CustomerId = f.CustomerId
inner join [edw].[DimEmployee] AS e
ON e.EmployeeId = f.EmployeeId
inner join [edw].[DimShipper] AS s
ON s.ShipperId = f.ShipperId
inner join [edw].[DimDate] AS od
ON od.Date = f.OrderDate
inner join [edw].[DimDate] AS sd
ON sd.Date = f.ShippedDate