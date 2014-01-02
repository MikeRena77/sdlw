Spool ./catest.log
set linesize 2000
set pagesize 100
 
SELECT PC.ParentPathId, PC.PathObjId, PC.PathName, PF.PathFullName,
substr(pf.pathfullname, 0, instr (PF.PathFullName, '/', -1, 2))  ParentPathFullName,
ltrim (rtrim (substr(substr(pf.pathfullname, 0, instr (PF.PathFullName, '/', -1, 2)), instr (substr(pf.pathfullname, 0, instr (PF.PathFullName, '/', -1, 2)), '/', -1, 2) ), '/'), '/')  ParentPathName 
FROM HarItemPath PC, HarItemPath PP, HarPathFullName PF
WHERE 
PC.ParentPathId = PP.PathObjId (+)
AND
PP.PathObjId IS NULL
AND
PC.PathObjId = PF.PathObjId (+)
ORDER BY PC.ParentPathId, PC.PathObjId;
spool off;
 
spool ./catest2.log
SELECT PF1.PathObjId, PF1.PathFullName
FROM HarPathFullName PF1
WHERE RTRIM(PF1.PathFullName) IN
(
SELECT DISTINCT substr(pf.pathfullname, 1, instr (PF.PathFullName, '/', -1, 3)) FullName
FROM HarItemPath PC, HarItemPath PP, HarPathFullName PF
WHERE 
PC.ParentPathId = PP.PathObjId (+)
AND
PP.PathObjId IS NULL
AND
PC.PathObjId = PF.PathObjId (+)
)


spool off;
exit;