CREATE PROCEDURE [dbo].[UspSaveStoreAdditionalParameterValueDate]
	@StoreCode AS VARCHAR(64),
	@AdditionalStoreParameterCode AS VARCHAR(64),
	@Value DATE
AS
BEGIN
	DECLARE @StoreId BIGINT;
	DECLARE @AdditionalStoreParameterId BIGINT;
	DECLARE @Error VARCHAR(256) = '';

	SELECT TOP(1) @StoreId = pro.Id 
	FROM Store pro WITH (NOLOCK) 
	WHERE pro.Code = @StoreCode AND pro.IsActive = 1;

	SELECT TOP(1) @AdditionalStoreParameterId = asp.Id 
	FROM AdditionalStoreParameter asp WITH (NOLOCK) 
	INNER JOIN DataType dt WITH (NOLOCK) ON dt.Id = asp.DataTypeId
	WHERE asp.Code = @AdditionalStoreParameterCode AND asp.IsActive = 1 AND dt.Code = '3';

	IF @StoreId IS NULL
		SET @Error = 'Товар не существует. ';
	IF @AdditionalStoreParameterId IS NULL 
		SET @Error = CONCAT(@Error, 'Дополнительный параметр продукта не существует или имеет неверный формат');

	IF @Error <> ''
		THROW 51002, @Error, 1;

	MERGE StoreAdditionalStoreParameterMapping AS TargetTable
	USING
	(
		SELECT @StoreId AS StoreId, 
			@AdditionalStoreParameterId AS AdditionalStoreParameterId,
			CONVERT(VARCHAR(10), @Value, 104) AS Value
	) AS SourceTable
	ON SourceTable.StoreId = TargetTable.StoreId AND
		SourceTable.AdditionalStoreParameterId = TargetTable.AdditionalStoreParameterId
	WHEN NOT MATCHED BY TARGET THEN
		INSERT (
			StoreId, 
			AdditionalStoreParameterId,
			Value
		)
		VALUES (
			SourceTable.StoreId, 
			SourceTable.AdditionalStoreParameterId,
			SourceTable.Value
		)
	WHEN MATCHED THEN
		UPDATE 
			SET IsActive = 1,
				Value = SourceTable.Value;

END

