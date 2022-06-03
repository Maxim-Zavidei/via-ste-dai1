
DECLARE @LastLoadDate int
SET @LastLoadDate = (SELECT MAX([LastLoadDate]) From [etl].[LogUpdate] where [TABLE] = 'DimCustomer')
DECLARE @NewLoadDate int
SET @NewLoadDate = CONVERT(CHAR(8), GETDATE(), 112)
DECLARE @FutureDate int
SET @FutureDate = 99990101

UPDATE [edw].[DimCustomer]
SET ValidTo=@NewLoadDate-1
WHERE CustomerId in (
	SELECT [CustomerId]
	FROM [edw].[DimCustomer]
	WHERE [CustomerId] in (
		SELECT [CustomerId] FROM [edw].[DimCustomer]
		EXCEPT SELECT [CustomerId]
		FROM [stage].[DimCustomer]
	)
) and ValidTo = 99990101

INSERT INTO [etl].[LogUpdate] ([Table],[LastLoadDate]) VALUES ('DimCustomer', @NewLoadDate)