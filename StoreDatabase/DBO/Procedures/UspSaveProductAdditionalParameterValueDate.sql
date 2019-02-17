CREATE PROCEDURE [dbo].[UspSaveProductAdditionalParameterValueDate]
	@ProductCode AS VARCHAR(64),
	@AdditionalProductParameterCode AS VARCHAR(64),
	@Value DATE
AS
BEGIN
	DECLARE @ProductId BIGINT;
	DECLARE @AdditionalProductParameterId BIGINT;
	DECLARE @Error VARCHAR(256) = '';

	SELECT TOP(1) @ProductId = pro.Id 
	FROM Product pro WITH (NOLOCK) 
	WHERE pro.Code = @ProductCode AND pro.IsActive = 1;

	SELECT TOP(1) @AdditionalProductParameterId = app.Id 
	FROM AdditionalProductParameter app WITH (NOLOCK) 
	INNER JOIN DataType dt WITH (NOLOCK) ON dt.Id = app.DataTypeId
	WHERE app.Code = @AdditionalProductParameterCode AND app.IsActive = 1 AND dt.Code = '3';

	IF @ProductId IS NULL
		SET @Error = 'Товар не существует. ';
	IF @AdditionalProductParameterId IS NULL 
		SET @Error = CONCAT(@Error, 'Дополнительный параметр продукта не существует или имеет неверный формат');

	IF @Error <> ''
		THROW 51001, @Error, 1;

	MERGE ProductAdditionalProductParameterMapping AS TargetTable
	USING
	(
		SELECT @ProductId AS ProductId, 
			@AdditionalProductParameterId AS AdditionalProductParameterId,
			CONVERT(VARCHAR(10), @Value, 104) AS Value
	) AS SourceTable
	ON SourceTable.ProductId = TargetTable.ProductId AND
		SourceTable.AdditionalProductParameterId = TargetTable.AdditionalProductParameterId
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (
			ProductId, 
			AdditionalProductParameterId,
			Value
		)
		VALUES (
			SourceTable.ProductId, 
			SourceTable.AdditionalProductParameterId,
			SourceTable.Value
		)
	WHEN MATCHED THEN
		UPDATE 
			SET IsActive = 1,
				Value = SourceTable.Value;

END

