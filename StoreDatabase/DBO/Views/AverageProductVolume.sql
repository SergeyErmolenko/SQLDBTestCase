CREATE VIEW [dbo].[AverageProductVolume]
	AS 
SELECT 
	MAX(pr.Name) AS PriceRangeName,
	AVG(CAST(pap.Value AS DECIMAL(10, 2))) AS AverageVolume
FROM Product pro WITH (NOLOCK) 
INNER JOIN PriceRange pr WITH (NOLOCK) ON pro.Price > pr.PriceLow AND (pro.Price <= pr.PriceHigh OR pr.PriceHigh IS NULL)
INNER JOIN ProductAdditionalProductParameterMapping pap WITH (NOLOCK) ON pap.ProductId = pro.Id 
INNER JOIN AdditionalProductParameter app WITH (NOLOCK) ON app.Id = pap.AdditionalProductParameterId
WHERE app.Code = 'ProductVolume' AND pro.IsActive = 1
GROUP BY pr.Id