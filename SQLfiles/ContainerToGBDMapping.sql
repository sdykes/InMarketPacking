SELECT 
	pd.PalletDetailID
	,pd.PalletID
	,pa.PalletLabelNo
	,ebd.CartonNo
	,seas.SeasonDesc AS Season
	,ptt.PalletTypeDesc AS [Pallet type]
	,prt.ProductDesc
	,pkt.PackTypeDesc AS [Pack type]
	,pd.NoOfUnits
	,COALESCE(ebd.KGWeight,pd.NoOfUnits*prt.NetFruitWeight) AS KGWeight
	,pd.GraderBatchID
	,ctp.CompanyName AS [Packing site]
	,con.ContainerNo
	,con.DespatchDate
	,COALESCE(bt.ActualArrivalDate,bt.EstimatedArrivalDate) AS ArrivalDate
FROM ma_Pallet_DetailT AS pd
INNER JOIN
	ma_PalletT AS pa
ON pa.PalletID = pd.PalletID
LEFT JOIN
	ma_Export_Bin_DetailT AS ebd
ON ebd.PalletDetailID = pd.PalletDetailID
LEFT JOIN
	ma_DespatchT AS de
ON de.DespatchID = pa.DespatchID
LEFT JOIN
	ma_ContainerT AS con
ON con.ContainerID = de.ContainerID
LEFT JOIN
	(
	SELECT 
		gb.GraderBatchID,
		InputKgs,
		WasteOtherKgs+COALESCE(jkg.JuiceKgs,0)+COALESCE(skg.SampleKgs,0) AS RejectKgs,
		1-(WasteOtherKgs+COALESCE(jkg.JuiceKgs,0)+COALESCE(skg.SampleKgs,0))/InputKgs AS Packout
	FROM ma_Grader_BatchT AS gb
/* Juice Kgs */
	LEFT JOIN
		(
		SELECT 
			PresizeOutputFromGraderBatchID AS GraderBatchID,
			SUM(TotalWeight) As JuiceKgs
		FROM ma_Bin_DeliveryT
		WHERE PresizeProductID = 278
		GROUP BY PresizeOutputFromGraderBatchID
		) AS jkg
	ON jkg.GraderBatchID = gb.GraderBatchID
/* Sample Kgs*/
	LEFT JOIN
		(
		SELECT 
			pd.GraderBatchID,
			SUM(NoOfUnits*NetFruitWeight) AS SampleKgs
		FROM ma_Pallet_detailT AS pd
		INNER JOIN
			sw_ProductT AS prt
		ON prt.ProductID = pd.ProductID
		WHERE SampleFlag = 1
		AND pd.GraderBatchID IS NOT NULL
		GROUP BY pd.GraderBatchID
		) AS skg
	ON skg.GraderBatchID = gb.GraderBatchID
	WHERE ClosedDateTime IS NOT NULL
	) AS gbd
ON gbd.GraderBatchID = pd.GraderBatchID
INNER JOIN
	sw_ProductT AS prt
ON prt.ProductID = pd.ProductID
INNER JOIN	
	sw_Pack_TypeT AS pkt
ON pkt.PackTypeID = prt.PackTypeID
INNER JOIN
	sw_CompanyT AS ctp
ON ctp.CompanyID = pd.PackerCompanyID
INNER JOIN
	sw_Pallet_TypeT AS ptt
ON ptt.PalletTypeID = pa.PalletTypeID
INNER JOIN
	sw_SeasonT AS seas
ON seas.SeasonID = pa.SeasonID
INNER JOIN
	sw_Purchase_Order_LineT AS pol
ON pol.POLineID = pd.POLineID
INNER JOIN
	sw_Purchase_OrderT AS po
ON po.POID = pol.POID
INNER JOIN
	ma_BookingT AS bt
ON bt.BookingID = po.BookingID
WHERE ContainerNo IS NOT NULL


