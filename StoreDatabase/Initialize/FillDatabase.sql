/*
	Скрипт заполняет базу данных тестовыми данными, если данных нет.
*/
MERGE Store AS TargetTable
USING 
(
	SELECT 'Store0001' AS Code, 'Первый магазин' AS Name UNION
	SELECT 'Store0002' AS Code, 'Второй магазин' AS Name UNION
	SELECT 'Store0003' AS Code, 'Третий магазин' AS Name
) AS SourceTable
ON TargetTable.Code = SourceTable.Code
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code,
		Name
	)
	VALUES (
		SourceTable.Code,
		SourceTable.Name
	);

MERGE Product AS TargetTable
USING 
(
	SELECT 'Product0001' AS Code, 'Зубная паста' AS Name, 69.99 AS Price UNION
	SELECT 'Product0002' AS Code, 'Зубная щетка' AS Name, 49.99 AS Price UNION
	SELECT 'Product0003' AS Code, 'Зубная щетка Lux' AS Name, 1299.99 AS Price UNION
	SELECT 'Product0004' AS Code, 'Мыло хозяйственное' AS Name, 17.00 AS Price UNION
	SELECT 'Product0005' AS Code, 'Мыло Dove' AS Name, 106.99 AS Price
) AS SourceTable
ON TargetTable.Code = SourceTable.Code
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code,
		Name,
		Price
	)
	VALUES (
		SourceTable.Code,
		SourceTable.Name,
		SourceTable.Price
	);

MERGE AdditionalProductParameter AS TargetTable
USING 
(
	SELECT src.Code, src.Name, dt.Id AS DataTypeId
	FROM 
	(
		SELECT 'ProductVolume' AS Code, 'Объем продукта' AS Name, '1' AS DataTypeCode UNION
		SELECT 'ProductCategory' AS Code, 'Категория продукта' AS Name, '3' AS DataTypeCode
	) src
	INNER JOIN DataType dt WITH (NOLOCK) ON dt.Code = src.DataTypeCode
) AS SourceTable
ON TargetTable.Code = SourceTable.Code
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code,
		Name,
		DataTypeId
	)
	VALUES (
		SourceTable.Code,
		SourceTable.Name,
		SourceTable.DataTypeId
	);

MERGE AdditionalProductParameter AS TargetTable
USING 
(
	SELECT src.Code, src.Name, dt.Id AS DataTypeId
	FROM 
	(
		SELECT 'ProductVolume' AS Code, 'Объем продукта' AS Name, '1' AS DataTypeCode UNION
		SELECT 'ProductCategory' AS Code, 'Категория продукта' AS Name, '3' AS DataTypeCode
	) src
	INNER JOIN DataType dt WITH (NOLOCK) ON dt.Code = src.DataTypeCode
) AS SourceTable
ON TargetTable.Code = SourceTable.Code
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code,
		Name,
		DataTypeId
	)
	VALUES (
		SourceTable.Code,
		SourceTable.Name,
		SourceTable.DataTypeId
	);

EXEC UspSaveProductAdditionalParameterValueFloat @ProductCode = 'Product0001',
	@AdditionalProductParameterCode = 'ProductVolume',
	@Value = 95.0;

EXEC UspSaveProductAdditionalParameterValueFloat @ProductCode = 'Product0002',
	@AdditionalProductParameterCode = 'ProductVolume',
	@Value = 70.0;

EXEC UspSaveProductAdditionalParameterValueFloat @ProductCode = 'Product0003',
	@AdditionalProductParameterCode = 'ProductVolume',
	@Value = 190.0;

EXEC UspSaveProductAdditionalParameterValueFloat @ProductCode = 'Product0004',
	@AdditionalProductParameterCode = 'ProductVolume',
	@Value = 200.0;

EXEC UspSaveProductAdditionalParameterValueFloat @ProductCode = 'Product0005',
	@AdditionalProductParameterCode = 'ProductVolume',
	@Value = 170.0;

CREATE TABLE #SaleId
(
	Id BIGINT NOT NULL
);

INSERT INTO Sale(StoreId, OperationDate)
OUTPUT inserted.Id INTO #SaleId(Id)
VALUES((SELECT TOP(1) Id FROM Store WHERE Code = 'Store0001'), GETDATE());

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0001'), 5);

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0002'), 7);

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0003'), 1);

TRUNCATE TABLE #SaleId;

INSERT INTO Sale(StoreId, OperationDate)
OUTPUT inserted.Id INTO #SaleId(Id)
VALUES((SELECT TOP(1) Id FROM Store WHERE Code = 'Store0001'), DATEADD(DAY, -2, GETDATE()));

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0002'), 1);

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0004'), 3);

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0003'), 2);

TRUNCATE TABLE #SaleId;

INSERT INTO Sale(StoreId, OperationDate)
OUTPUT inserted.Id INTO #SaleId(Id)
VALUES((SELECT TOP(1) Id FROM Store WHERE Code = 'Store0002'), DATEADD(MONTH, -2, GETDATE()));

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0003'), 2);

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0005'), 14);

INSERT INTO SaleDetail(SaleId, ProductId, Quantity)
VALUES((SELECT TOP(1) Id FROM #SaleId), (SELECT TOP(1) Id FROM Product WHERE Code = 'Product0002'), 3);

DROP TABLE #SaleId;