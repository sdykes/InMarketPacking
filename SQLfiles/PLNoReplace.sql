SELECT
	ct.ContainerNo,
	pa.PalletLabelNo,
	pa.PalletID,
	SUM(NoOfUnits) AS Cartons
FROM ma_Pallet_DetailT AS pd
INNER JOIN
	ma_PalletT AS pa
ON pa.PalletID = pd.PalletID
LEFT JOIN
	ma_DespatchT AS dt
ON dt.DespatchID = pa.DespatchID
LEFT JOIN
	ma_ContainerT AS ct
ON ct.ContainerID = dt.ContainerID
WHERE ProductID = 2463
AND pa.SeasonID = 2012
AND ContainerNo IN ('SEGU9944356','PCIU6070176')
GROUP BY ct.ContainerNo, pa.PalletLabelNo, pa.PalletID
ORDER BY ct.ContainerNo


