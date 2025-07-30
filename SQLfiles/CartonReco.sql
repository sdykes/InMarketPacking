SELECT 
	 pd.PalletDetailID
	,pa.PalletID
	,se.SeasonDesc AS Season
	,pr.ProductDesc
	,COALESCE(cart.CartonNo,ebd.CartonNo) AS CartonNo
	,pa.PalletLabelNo
	,pt.PalletTypeDesc AS [Pallet type]
	,pkt.PackTypeDesc AS [Pack type]
	,pd.NoOfUnits
	,co.CompanyName AS [Packing site]
	,pd.GraderBatchID
	,ct.ContainerNo AS [Container Number]
	,ct.DespatchDate
FROM ma_PalletT AS pa
INNER JOIN
	ma_Pallet_DetailT AS pd
ON pd.PalletID = pa.PalletID
INNER JOIN
	ma_DespatchT AS dt
ON dt.DespatchID = pa.DespatchID
INNER JOIN
	ma_ContainerT AS ct
ON ct.ContainerID = dt.ContainerID
INNER JOIN
	sw_Pallet_TypeT AS pt
ON pt.PalletTypeID = pa.PalletTypeID
INNER JOIN
	sw_ProductT AS pr
ON pr.ProductID = pd.ProductID
INNER JOIN
	sw_Pack_TypeT AS pkt
ON pkt.PackTypeID = pr.PackTypeID
INNER JOIN
	sw_CompanyT AS co
ON co.CompanyID = pd.PackerCompanyID
INNER JOIN
	sw_SeasonT AS se
ON se.SeasonID = pa.SeasonID
LEFT JOIN
	ma_CartonT AS cart
ON cart.PalletDetailID = pd.PalletDetailID
LEFT JOIN
	ma_Export_Bin_DetailT AS ebd
ON ebd.PalletDetailID = pd.PalletDetailID
ORDER BY PalletLabelNo




