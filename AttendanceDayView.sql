SELECT
CAST(ATT.DT AS DATE),
SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 10 AND STU.GR < 6 THEN 1 ELSE 0 END) AS School10 -- Sum of total absences
-- SUM(CASE WHEN ATT.AL IS NOT NULL AND ATT.SC = 30 THEN 1 ELSE 0 END) AS School30
FROM ATT
JOIN STU ON STU.SN = ATT.SN AND STU.SC = ATT.SC
WHERE STU.DEL = 0
AND STU.TG = ''
AND ATT.AL IN ('3','4','5','6','8','A','D','E','F','H','I','K','M','N','O','Q','S','U','V','X','Z')
-- AND ATT.AL IN ('3','6','8','A','B','E','O','Q','S','U') -- Unexcused
-- AND ATT.AL IN ('4','5','D','F','H','I','K','M','N','V','X','Z') -- Excused
AND ATT.DT < '2019-12-21'
AND ATT.DT > '2019-06-10'
AND STU.DEL = 0
AND STU.TG = ''
GROUP BY DT
ORDER BY DT
