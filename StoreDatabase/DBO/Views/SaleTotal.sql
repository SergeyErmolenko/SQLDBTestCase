CREATE VIEW [dbo].[SaleTotal]
	AS
SELECT 
	sto.Id AS StoreId,
	MAX(sto.Name) AS StoreName,
	pro.Id AS ProductId,
	MAX(pro.Name) AS ProductName,
	DATEPART(YEAR, sal.OperationDate) AS [Year], 
	DATEPART(MONTH, sal.OperationDate) AS [Month],
	ISNULL(SUM(sd.Quantity), 0) AS TotalQuantity,
	ISNULL(SUM(sd.Quantity * pro.Price), 0) AS TotalSum
FROM Store sto WITH (NOLOCK)
INNER JOIN Sale sal WITH (NOLOCK) ON sto.Id = sal.StoreId
INNER JOIN SaleDetail sd WITH (NOLOCK) ON sd.SaleId = sal.Id
INNER JOIN Product pro WITH (NOLOCK) ON pro.Id = sd.ProductId
WHERE sal.IsActive = 1 AND sto.IsActive = 1 AND sd.IsActive = 1 AND pro.IsActive = 1
GROUP BY sto.Id, pro.Id, DATEPART(YEAR, sal.OperationDate), DATEPART(MONTH, sal.OperationDate)
