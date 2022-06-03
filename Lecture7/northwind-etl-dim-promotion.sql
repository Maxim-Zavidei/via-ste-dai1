CREATE TABLE [edw].[DimPromotions](
	[PROMO_ID] INT IDENTITY,
	[PromotionName] [nvarchar](40) NULL,
	[StartDate] INT,
	[EndDate] INT
) ON [PRIMARY]
GO


INSERT INTO [edw].[DimPromotions] (PromotionName,StartDate,EndDate)
SELECT
	PromotionName,sd.D_ID,ed.D_ID
FROM
	[stage].[DimPromotions] p
	left join edw.DimDate sd
	on p.StartDate = sd.Date
	left join edw.DimDate ed
	on p.EndDate = ed.Date


-- Allows us to write to the identity column
SET IDENTITY_INSERT [edw].[DimPromotions] ON

-- Insert a value for no promotion
INSERT [edw].[DimPromotions]([PROMO_ID], [PromotionName])
VALUES (-1, 'No promotion')

SET IDENTITY_INSERT [edw].[DimPromotions] OFF