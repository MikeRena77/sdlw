--QUERY WORK REQUEST HEADER WHERE NOT CLOSED
select *
from ae_p_pro_e
where  status_code <> "60-CLOSED"
AND ((	ref LIKE "01060002")  OR
	(ref LIKE "01060004")  OR
	(ref LIKE "01060008")  OR
	(ref LIKE "01060009")  OR
	(ref LIKE "01060018")  OR
	(ref LIKE "01060022")  OR
	(ref LIKE "01060025")  OR
	(ref LIKE "01060032")  OR
	(ref LIKE "01060037"))
ORDER BY ref