SELECT 
	PalletDetailID, 
	pa.PalletID, 
	ctp.CompanyName AS [Packing site],
	pr.ProductDesc AS [Product],
	pkt.PackTypeDesc AS [Pack type],
	NoOfUnits
FROM ma_Pallet_DetailT AS pd
INNER JOIN
	ma_PalletT AS pa
ON pa.PalletID = pd.PalletID
INNER JOIN
	sw_ProductT AS pr
ON pr.ProductID = pd.ProductID
INNER JOIN
	sw_Pack_TypeT AS pkt
ON pkt.PackTypeID = pr.PackTypeID
INNER JOIN
	sw_CompanyT AS ctp
ON ctp.CompanyID = pd.PackerCompanyID
WHERE pkt.PackTypeID IN (13,22,2028,2035,2042)
AND pa.SeasonID = 2012


