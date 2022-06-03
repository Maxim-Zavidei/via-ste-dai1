ALTER TABLE [northwindDW].[edw].[FactSale]
ADD [PROMO_PROD_ID] INT

update edw.FactSale
SET [PROMO_PROD_ID] = ISNULL(subq.[PROMO_PROD_ID], -1)
FROM edw.FactSale f
left join (
	SELECT p.PROMO_ID, pb.[PROMO_PROD_ID], pb.ProductsInPromotion, p.StartDate, p.EndDate 
	FROM [northwindDW].[edw].[DimPromotionsBridge] pb
	left join [northwindDW].[edw].[DimPromotions] p
	on pb.PROMO_ID = P.PROMO_ID) AS subq

on f.P_ID = subq.ProductsInPromotion
and f.OD_ID > subq.StartDate
and f.OD_ID < subq.EndDate