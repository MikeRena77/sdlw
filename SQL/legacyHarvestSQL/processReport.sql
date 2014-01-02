SELECT 
harenvironment.environmentname, 
harstate.statename,
harstateprocess.processname
from harenvironment, harstate, harstateprocess
WHERE 
harenvironment.envobjid=harstate.envobjid AND
harstate.stateobjid=harstateprocess.stateobjid and
harstateprocess.processobjid='19942'
GROUP BY 
environmentname, 
statename,
processname