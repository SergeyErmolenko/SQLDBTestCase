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