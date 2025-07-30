SELECT 
	pa.PalletID
	,SeasonDesc AS Season
	,PalletLabelNo
	,PalletTypeDesc AS [Pallet type]
	,ProductDesc
	,[Pack type]
	,NoOfUnits
	,PalletWeight
	,[Packing site]
	,GraderBatchID
	,ContainerNo AS [Container Number]
	,ct.DespatchDate
	,COALESCE(bt.ActualArrivalDate,bt.EstimatedArrivalDate) AS ArrivalDate
FROM ma_PalletT AS pa
LEFT JOIN
	(
	SELECT 
		PalletID,
		MAX(ProductDesc) AS ProductDesc,
		MAX(PackType) AS [Pack type],
		SUM(NoOfUnits) AS NoOfUnits,
		COALESCE(SUM(PalletWeight),SUM(NoOfUnits*NetFruitWeight)) AS PalletWeight,
		MAX([Packing site]) AS [Packing site],
		MAX(GraderBatchID) AS GraderBatchID
	FROM
		(
		SELECT 
			pd.PalletDetailID,
			PalletID,
			ProductDesc,
			PackTypeDesc AS PackType,
			NoOfUnits,
			NetFruitWeight,
			PalletWeight,
			GraderBatchID,
			CompanyName AS [Packing site]
		FROM ma_Pallet_detailT AS pd
		LEFT JOIN
			(
			SELECT 
				PalletDetailID,
				SUM(KGWeight) AS PalletWeight
			FROM ma_Export_Bin_detailT
			GROUP BY PalletDetailID
			) AS ebd
		ON ebd.PalletDetailID = pd.PalletDetailID
		INNER JOIN
			sw_ProductT AS prt
		ON prt.ProductID = pd.ProductID
		INNER JOIN
			sw_Pack_TypeT AS pkt
		ON pkt.PackTypeID = prt.PackTypeID
		INNER JOIN
			sw_CompanyT AS ctp
		ON ctp.CompanyID = pd.PackerCompanyID 
		) AS pd2
	GROUP BY PalletID
	) AS pd3
ON pd3.PalletID = pa.PalletID
LEFT JOIN
	ma_DespatchT AS dt
ON dt.DespatchID = pa.DespatchID
LEFT JOIN
	ma_ContainerT AS ct
ON ct.ContainerID = dt.ContainerID
INNER JOIN 
	sw_Purchase_OrderT AS po
ON po.POID = dt.POID
INNER JOIN
	ma_BookingT AS bt
ON bt.BookingID = po.BookingID
INNER JOIN
	sw_Pallet_TypeT AS ptt
ON ptt.PalletTypeID = pa.PalletTypeID
INNER JOIN
	sw_SeasonT AS st
ON st.SeasonID = pa.SeasonID
WHERE PalletLabelNo IS NOT NULL 

