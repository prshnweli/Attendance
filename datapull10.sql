SELECT
STU.ID,
STU.LN + ', ' + STU.FN AS 'Name',
STU.GR AS 'Grade',
Teacher = (SELECT TE FROM TCH WHERE STU.CU = TCH.TN AND STU.SC = TCH.SC AND TCH.DEL = 0),
STU.U2 AS 'SPED',
STU.U4 AS 'Migrant',
STU.ETH AS 'Ethnicity',
SocioEcoStatus =  CASE WHEN STU.ID IN (SELECT FRE.ID FROM FRE WHERE FRE.ID = STU.ID AND FRE.CD IN ('F', 'R') AND  (FRE.ESD > '7/1/2019' AND FRE.EED = '6/30/2020') AND FRE.DEL = 0 AND (STU.PED = 14 OR FRE.CD IS NOT NULL)) THEN 'Y' ELSE 'N' END,
[Race] = (CASE
	WHEN STU.ETH = 'Y' AND STU.RC1 > 100 THEN 'Hispanic'
	WHEN STU.RC1 = 100 THEN 'American Indian or Alaskan Native'
	WHEN STU.RC1 > 200 AND STU.RC1 < 300 THEN 'Asian'
	WHEN STU.RC1 > 300 AND STU.RC1 < 401 THEN 'Pacific Islander'
	WHEN STU.RC1 = 600 THEN 'Black or African American'
	WHEN STU.RC1 = 700 THEN 'White'
	ELSE 'Unknown'
END),
[LangFluency] = CASE STU.LF
  WHEN 'E' THEN 'English Only'
  WHEN 'L' THEN 'English Learner'
  WHEN 'R' THEN 'Redesignated'
  WHEN 'C' THEN 'Cum'
  WHEN 'I' THEN 'Initially Fluent'
  WHEN 'T' THEN 'TBD'
  WHEN 'N' THEN 'Needs Testing'
END,
[ParentEdLvl] = CASE STU.PED
	WHEN 10 THEN 'Grad School/post grad trng'
	WHEN 11 THEN 'College Graduate'
	WHEN 12 THEN 'Some College'
	WHEN 13 THEN 'High School Graduate'
	WHEN 14 THEN 'Not HS Graduate'
	WHEN 15 THEN 'Declined to State/Unkown'
END,
SUM(CASE WHEN DATEPART(weekday, ATT.DT) = 2 THEN 1 ELSE 0 END) AS 'Monday',
SUM(CASE WHEN DATEPART(weekday, ATT.DT) = 3 THEN 1 ELSE 0 END) AS 'Tuesday',
SUM(CASE WHEN DATEPART(weekday, ATT.DT) = 4 THEN 1 ELSE 0 END) AS 'Wednesday',
SUM(CASE WHEN DATEPART(weekday, ATT.DT) = 5 THEN 1 ELSE 0 END) AS 'Thursday',
SUM(CASE WHEN DATEPART(weekday, ATT.DT) = 6 THEN 1 ELSE 0 END) AS 'Friday',
COUNT(ATT.AL) AS 'Total Absences',
SUM(CASE WHEN ATT.AL = '3' THEN 1 ELSE 0 END) AS 'DO UNEXA',
SUM(CASE WHEN ATT.AL = '4' THEN 1 ELSE 0 END) AS 'Emergency',
SUM(CASE WHEN ATT.AL = '5' THEN 1 ELSE 0 END) AS 'DO EXA',
SUM(CASE WHEN ATT.AL = '6' THEN 1 ELSE 0 END) AS 'Absnt UnxV',
SUM(CASE WHEN ATT.AL = '8' THEN 1 ELSE 0 END) AS 'NPS Absent',
SUM(CASE WHEN ATT.AL = 'A' THEN 1 ELSE 0 END) AS 'Absent Unv',
SUM(CASE WHEN ATT.AL = 'D' THEN 1 ELSE 0 END) AS 'Dental',
SUM(CASE WHEN ATT.AL = 'E' THEN 1 ELSE 0 END) AS 'Med Xclusn',
SUM(CASE WHEN ATT.AL = 'F' THEN 1 ELSE 0 END) AS 'Funeral',
SUM(CASE WHEN ATT.AL = 'H' THEN 1 ELSE 0 END) AS 'Do HHAbsnt',
SUM(CASE WHEN ATT.AL = 'I' THEN 1 ELSE 0 END) AS 'Illness',
SUM(CASE WHEN ATT.AL = 'K' THEN 1 ELSE 0 END) AS 'In Office',
SUM(CASE WHEN ATT.AL = 'M' THEN 1 ELSE 0 END) AS 'Medical',
SUM(CASE WHEN ATT.AL = 'N' THEN 1 ELSE 0 END) AS 'Nurse Ofc',
SUM(CASE WHEN ATT.AL = 'O' THEN 1 ELSE 0 END) AS 'Other',
SUM(CASE WHEN ATT.AL = 'Q' THEN 1 ELSE 0 END) AS 'Susp In Hs',
SUM(CASE WHEN ATT.AL = 'S' THEN 1 ELSE 0 END) AS 'Suspension',
SUM(CASE WHEN ATT.AL = 'U' THEN 1 ELSE 0 END) AS 'Absent Unx',
SUM(CASE WHEN ATT.AL = 'V' THEN 1 ELSE 0 END) AS 'Activity',
SUM(CASE WHEN ATT.AL = 'X' THEN 1 ELSE 0 END) AS 'Absent Exc',
SUM(CASE WHEN ATT.AL = 'Z' THEN 1 ELSE 0 END) AS 'Med Cnfdl'
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
AND ATT.DT < '2020-01-01'
AND STU.SC = 10
AND STU.SN NOT IN (24764,24767,24757,24759,24760,24766,24761,24754,24762,24763)
GROUP BY STU.ID, STU.FN, STU.LN, STU.GR, STU.U2, STU.U4, STU.ETH, STU.PED, STU.RC1, STU.LF
ORDER BY STU.GR, STU.LN, STU.FN


SELECT
CAST(ATT.DT AS DATE),
[Day] = CASE DATEPART(weekday, ATT.DT)
WHEN 2 THEN 'Monday'
WHEN 3 THEN 'Tuesday'
WHEN 4 THEN 'Wednesday'
WHEN 5 THEN 'Thursday'
WHEN 6 THEN 'Friday'
END,
SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 30 THEN 1 ELSE 0 END) AS Central
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
AND ATT.DT < '2019-12-21'
GROUP BY DT
ORDER BY DT
