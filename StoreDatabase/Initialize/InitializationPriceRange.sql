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