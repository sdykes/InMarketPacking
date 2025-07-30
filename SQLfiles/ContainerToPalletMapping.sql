SELECT 
	PalletLabelNo,
	pol.POLineID,
	pol.POID,
	PONo,
	SeasonDesc AS Season,
	pol.ProductID,
	ProductDesc AS [Product description],
	pd.NoOfUnits,
	PalletTypeDesc AS [Pallet type],
	PalletQty,
	ctp.CompanyName AS [Packing site],
	PortName AS [Port name],
	ContainerNo,
	GraderBatchID
FROM sw_Purchase_Order_LineT AS pol
INNER JOIN
	(
	SELECT
		ProductID
	FROM sw_ProductT
	WHERE PackTypeID IN (13,22)
	) AS prt
ON prt.ProductID = pol.ProductID
INNER JOIN
	sw_Purchase_OrderT AS po
ON po.POID = pol.POID
INNER JOIN
	sw_SeasonT AS st
ON st.SeasonID = po.SeasonID
INNER JOIN
	sw_Pallet_TypeT AS ptt
ON ptt.PalletTypeID = pol.PalletTypeID
INNER JOIN
	sw_PortT AS port
ON port.PortID = po.FinalDestinationPortID
INNER JOIN
	ma_DespatchT AS dt
ON dt.POID = pol.POID
LEFT JOIN
	ma_PalletT AS pt
ON pt.DespatchID = dt.DespatchID
LEFT JOIN
	ma_Pallet_detailT AS pd
ON pd.PalletID = pt.PalletID
INNER JOIN
	ma_ContainerT AS ct
ON ct.ContainerID = dt.ContainerID
INNER JOIN
	sw_CompanyT AS ctp
ON ctp.CompanyID = pd.PackerCompanyID

	


