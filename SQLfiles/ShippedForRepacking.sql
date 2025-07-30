SELECT 
	POLineID,
	polt.POID,
	PONo,
	pot2.SeasonID,
	cont.ContainerNo,
	polt.ProductID,
	pr.ProductDesc [Product],
	pkt.PackTypeDesc AS [Pack type],
	polt.PalletQty AS [Pallet qty],
	NoOfUnits,
	CompanyName,
	[Destination port],
	cont.DespatchDate,
	bt.ActualArrivalDate
FROM sw_Purchase_Order_LineT AS polt
INNER JOIN
	(
	SELECT 
		POID,
		SeasonID,
		PONo,
		ctc.CompanyName,
		portt.PortName AS [Destination port],
		BookingID
	FROM sw_Purchase_OrderT AS pot
	INNER JOIN
		sw_CompanyT AS ctc
	ON ctc.CompanyID = pot.CustomerCompanyID
	INNER JOIN
		sw_PortT AS portt
	ON portt.PortID = pot.FinalDestinationPortID
	) AS pot2
ON pot2.POID = polt.POID
INNER JOIN
	ma_DespatchT AS dt
ON dt.POID = polt.POID
INNER JOIN
	ma_ContainerT AS cont
ON cont.ContainerID = dt.ContainerID
INNER JOIN
	sw_ProductT AS pr
ON pr.ProductID = polt.ProductID
INNER JOIN
	sw_Pack_TypeT AS pkt
ON pkt.PackTypeID = pr.PackTypeID
INNER JOIN
	ma_BookingT AS bt
ON bt.BookingID = pot2.BookingID
WHERE pot2.SeasonID = 2012
AND CompanyName IN ('JOY WING MAU FRUIT TECHNOLOGIES CORPORATION LIMITED','Rockit Trading (Shanghai) Company Limited','Pomina Enterprise Co., Ltd.')
AND pkt.PackTypeID IN (13,22,2028,2035,2042)





