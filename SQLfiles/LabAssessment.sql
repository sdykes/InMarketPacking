SELECT 
	la.LabAssessmentID,
	SeasonDesc AS Season,
	AssessmentDate,
	FarmCode AS RPIN,
	FarmName AS Orchard,
	SubdivisionCode AS [Production site],
	SampleWeight,
	AverageBrixPercentage,
	(FirmnessA + FirmnessB)/2 AS MeanFirmness,
	SPI AS MeanSPI,
	SampleQuantity
FROM qa_Lab_AssessmentT AS la
LEFT JOIN
	(
	SELECT 
		LabAssessmentID,
		AVG(FirmnessA) AS FirmnessA,
		AVG(FirmnessB) AS FirmnessB,
		AVG(StarchPatternIndex) AS SPI
	FROM qa_Lab_Assessment_DetailT
	GROUP BY LabAssessmentID
	) AS lad
ON lad.LabAssessmentID = la.LabAssessmentID
INNER JOIN
	sw_SeasonT AS st
ON st.SeasonID = la.SeasonID
INNER JOIN
	sw_FarmT AS fa
ON fa.FarmID = la.FarmID
INNER JOIN
	sw_Farm_BlockT AS fbt
ON fbt.BlockID = la.BlockID
INNER JOIN
	sw_SubdivisionT AS sb
ON sb.SubdivisionID = fbt.SubdivisionID
WHERE SampleTypeID IN (4,10)


