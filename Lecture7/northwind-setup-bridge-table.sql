-- Creating the brdige table
CREATE TABLE [stage].[DimPromotionsBridge](
	[PROMO_ID] INT,
	[ProductsInPromotion] INT
) ON [PRIMARY]
GO


-- Insert into the stage bridge table, making one row per sale id that was sold in each promotion
INSERT INTO [stage].[DimPromotionsBridge]
SELECT
	ep.PROMO_ID, value ProductsInPromotion
FROM
	[stage].[DimPromotions] sp
	CROSS APPLY STRING_SPLIT(ProductsInPromotion, ',')
	left join [edw].[DimPromotions] ep
	on ep.PromotionName = sp.PromotionName

SELECT * FROM [stage].[DimPromotions]
SELECT * FROM [edw].[DimPromotions]

-- Create the promotion bridge in the edw
CREATE TABLE [edw].[DimPromotionsBridge](
	[PROMO_ID] INT,
	[PROMO_PROD_ID] INT,
	[ProductsInPromotion] INT
) ON [PRIMARY]
GO

-- Insert into bridge table in the edw
INSERT INTO [edw].[DimPromotionsBridge]
SELECT [PROMO_ID]
,CONCAT([PROMO_ID], p.P_ID)
,p.P_ID
FROM [northwindDW].[stage].[DimPromotionsBridge] pb
left join [northwindDW].[edw].[DimProduct] p
on pb.ProductsInPromotion = p.ProductId

INSERT [edw].[DimPromotionsBridge]([PROMO_ID], [PROMO_PROD_ID], [ProductsInPromotion])
VALUES (-1, -1, NULL)