SELECT 
	gb.GraderBatchID,
	gb.GraderBatchNo,
	gb.ExternalRun,
	gb.HarvestDate,
	gb.PackDate,
	gb.InputKgs,
	gb.ClosedDateTime,
	WasteOtherKgs+COALESCE(jkg.JuiceKgs,0)+COALESCE(skg.SampleKgs,0) As RejectKgs,
	1-(WasteOtherKgs+COALESCE(jkg.JuiceKgs,0)+COALESCE(skg.SampleKgs,0))/InputKgs AS Packout,
	ctp.CompanyName AS [Packing site]
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
INNER JOIN
	sw_CompanyT AS ctp
ON ctp.CompanyID = gb.PackingCompanyID
/*WHERE ClosedDateTime IS NOT NULL*/
WHERE PresizeInputFlag = 0
AND SeasonID = 2012
AND PresizeInputFlag = 0


