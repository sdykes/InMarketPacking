SELECT 
	pa.PalletID,
	SeasonDesc AS Season,
	pd2.ProductDesc,
	pd2.PackTypeDesc,
	ptt.PalletTypeDesc,
	pd2.NoOfUnits,
	pd2.GraderBatchID,
	pd2.[Packing site]
FROM ma_PalletT AS pa
INNER JOIN
	(
	SELECT 
		PalletID,
		MAX(ProductDesc) AS ProductDesc,
		MAX(PackTypeDesc) AS PackTypeDesc,
		SUM(NoOfUnits) AS NoOfUnits,
		MAX(GraderBatchID) AS GraderBatchID,
		MAX(CompanyName) AS [Packing site]
	FROM ma_Pallet_DetailT AS pd
	INNER JOIN
		sw_ProductT AS prt
	ON prt.ProductID = pd.ProductID
	INNER JOIN
		sw_Pack_TypeT AS ptt
	ON ptt.PackTypeID = prt.PackTypeID
	INNER JOIN
		sw_CompanyT AS ct
	ON ct.CompanyID = pd.PackerCompanyID
	WHERE prt.PackTypeID IN (22,2028)
	GROUP BY PalletID
	) AS pd2
ON pd2.palletID = pa.PalletID
INNER JOIN
	sw_SeasonT AS st
ON st.SeasonID = pa.SeasonID
INNER JOIN
	sw_Pallet_TypeT AS ptt
ON ptt.PalletTypeID = pa.PalletTypeID
WHERE SeasonDesc = 2025
AND DespatchID IS NOT NULL

