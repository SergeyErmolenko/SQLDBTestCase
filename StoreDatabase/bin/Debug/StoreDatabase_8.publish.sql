﻿/*
Deployment script for StoreDatabase

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "StoreDatabase"
:setvar DefaultFilePrefix "StoreDatabase"
:setvar DefaultDataPath "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\"
:setvar DefaultLogPath "C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
/*
Post-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.		
 Use SQLCMD syntax to include a file in the post-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the post-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
*/

/*
	Скрипт заполняет данными таблицу DataType.
*/
MERGE DataType AS TargetTable
USING 
(
	SELECT '1' AS Code, 'Число' AS Name UNION
	SELECT '2' AS Code, 'Текст' AS Name UNION
	SELECT '3' AS Code, 'Дата' AS Name
) AS SourceTable
ON SourceTable.Code = TargetTable.Code
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code,
		Name
	)
	VALUES (
		SourceTable.Code,
		SourceTable.Name
	);
/*
	Скрипт заполняет данными таблицу PriceRange.
*/
MERGE PriceRange AS TargetTable
USING 
(
	SELECT 'Range1' AS Code, 'до 50 рублей' AS Name, 0 AS PriceLow, 50 AS PriceHigh UNION
	SELECT 'Range2' AS Code, '50 - 100 рублей' AS Name, 50 AS PriceLow, 100 AS PriceHigh UNION
	SELECT 'Range3' AS Code, '100 - 500 рублей' AS Name, 100 AS PriceLow, 500 AS PriceHigh UNION
	SELECT 'Range4' AS Code, 'остальные товары' AS Name, 500 AS PriceLow, NULL AS PriceHigh
) AS SourceTable
ON SourceTable.Code = TargetTable.Code
WHEN NOT MATCHED BY TARGET THEN
	INSERT (
		Code,
		Name,
		PriceLow,
		PriceHigh
	)
	VALUES (
		SourceTable.Code,
		SourceTable.Name,
		SourceTable.PriceLow,
		SourceTable.PriceHigh
	);

DECLARE @StoreCount INT;
SELECT @StoreCount = COUNT(*) FROM Store WITH (NOLOCK);
IF @StoreCount = 0
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
GO

GO
PRINT N'Update complete.';


GO
