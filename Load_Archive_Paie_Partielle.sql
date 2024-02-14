WITH RankedData AS (
  SELECT
    Matricule,
    Date_Classification,
    Classification,
    ROW_NUMBER() OVER (PARTITION BY Matricule ORDER BY Date_Classification DESC) AS RowNum
  FROM
    Tab_Promotion_Agent
),
ClassificationData AS (
  SELECT
    Matricule,
    Date_Modification,
    Code_qualification,
    ROW_NUMBER() OVER (PARTITION BY Matricule ORDER BY Date_Modification DESC) AS RowNum
  FROM
    Tab_Agent_Qualification
)
SELECT
  TAP.ID_Archive_Paie,
  TAP.Code_Information_Bulletin_Agent,
  TAP.Matricule,
  TAP.Code_Rubrique,
  TAP.Mmaa,
  TAP.Base,
  TAP.Taux,
  TAP.Mmaad,
  TAP.Mmaaf,
  TAP.Montant,
  TAP.Observation,
  TAP.Mode_Saisie,
  TAP.User_ID,
  TAP.Date_Modification,
  IBA.Code_Structure,
  CASE 
    WHEN LEFT(R.Classification, 1) IN ('C', 'S', 'H') THEN 3
    WHEN LEFT(R.Classification, 1) = 'M' THEN 2
    WHEN LEFT(R.Classification, 1) = 'E' THEN 1
    ELSE 0
  END AS CODE_groupe,
  CD.Code_qualification
FROM
  RankedData R
JOIN
  Tab_Archive_Paie TAP ON R.Matricule = TAP.Matricule
INNER JOIN
  Tab_Information_Bulletin_Agent IBA ON TAP.Code_Information_Bulletin_Agent = IBA.Code_Information_Bulletin_Agent
 JOIN
  ClassificationData CD ON  TAP.Matricule = CD.Matricule 
WHERE
  R.RowNum = 1 and  CD.RowNum = 1
 AND TAP.Mmaa =  ?