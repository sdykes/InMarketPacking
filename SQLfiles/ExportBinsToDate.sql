SELECT 
	PackTypeDesc,
	ProductDesc,
	COUNT(eb.ExportBinID) AS NoExportBins
FROM ma_Export_BinT AS eb
INNER JOIN
	sw_SeasonT AS st
ON st.SeasonID = eb.SeasonID
INNER JOIN
	sw_ProductT AS prt
ON prt.ProductID = eb.ProductID
INNER JOIN
	sw_Pack_TypeT AS ptt
ON ptt.PackTypeID = prt.PackTypeID
WHERE SeasonDesc = 2025
GROUP BY PackTypeDesc, ProductDesc


