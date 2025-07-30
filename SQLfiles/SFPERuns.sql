SELECT 
	GraderBatchID,
	GraderBatchNo,
	HarvestDate,
	PackDate,
	PresizeInputFlag,
	ExternalRun,
	ctp.CompanyName AS [Packing site]
FROM ma_Grader_BatchT AS gb
INNER JOIN
	sw_CompanyT AS ctp
ON ctp.CompanyID = gb.PackingCompanyID
WHERE SeasonID = 2012
AND PresizeInputFlag = 1
AND ExternalRun IS NOT NULL

