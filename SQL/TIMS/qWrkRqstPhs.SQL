--QUERY FOR WORK REQUEST PHASE
select *
from ae_p_phs_e
where status_code <> "60-CLOSED"
AND (( proposal LIKE "9907403")  OR
	( proposal LIKE "9907425") OR	
	( proposal LIKE "9907430") OR
	( proposal LIKE "9907432") OR
	( proposal LIKE "9907434") OR
	( proposal LIKE "9907441") OR
	( proposal LIKE "9907450") OR
	( proposal LIKE "9907455") OR
	( proposal LIKE "9907508") OR
	( proposal LIKE "9907509") OR
	( proposal LIKE "9907510") OR
	( proposal LIKE "9907550") OR
	( proposal LIKE "9907555") OR
	( proposal LIKE "9907557") OR
	( proposal LIKE "9907582") OR
	( proposal LIKE "9907587") OR
	( proposal LIKE "9907588") OR
	( proposal LIKE "9907671") OR
	(proposal LIKE "9907269")  OR
	(proposal LIKE "9907273")  OR
	(proposal LIKE "9907276")  OR
	(proposal LIKE "9907516")  OR
	(proposal LIKE "9907613")  OR
	(proposal LIKE "9907905")  OR
	(proposal LIKE "9908010")  OR
	(proposal LIKE "0008407"))
ORDER BY proposal
--JUST INFO ON 01060002 WR THAT LANETTE HASN'T CLOSED