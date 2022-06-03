SELECT SUM(f.LineTotal) AS TotalSalesFromPromotions FROM edw.FactSale f
left join edw.DimPromotionsBridge pb
ON f.PROMO_PROD_ID = pb.PROMO_PROD_ID
left join edw.DimPromotions p
ON p.PROMO_ID = pb.PROMO_ID
WHERE p.PROMO_ID != -1


SELECT SUM(f.LineTotal), CompanyName AS TotalSalesFromPromotions FROM edw.FactSale f
left join edw.DimPromotionsBridge pb
ON f.PROMO_PROD_ID = pb.PROMO_PROD_ID
left join edw.DimPromotions p
ON p.PROMO_ID = pb.PROMO_ID
left join edw.DimCustomer c
ON f.C_ID = c.C_ID
WHERE p.PROMO_ID != -1
GROUP BY CompanyName