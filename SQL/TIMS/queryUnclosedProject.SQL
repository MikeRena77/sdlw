--PROJECTS NOT CLOSED
select *
from ae_j_sta_e
where status_code <> "60-CLOSED"
AND ((	project LIKE "01060002")  OR
	(project LIKE "01060004")  OR
	(project LIKE "01060008")  OR
	(project LIKE "01060009")  OR
	(project LIKE "01060018")  OR
	(project LIKE "01060022")  OR
	(project LIKE "01060025")  OR
	(project LIKE "01060032")  OR
	(project LIKE "01060037"))
ORDER BY project