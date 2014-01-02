SELECT 
harenvironment.environmentname, 
harstate.statename,
harstateprocess.processname,
harudp.processname
from harenvironment, harstate, harstateprocess, harudp
WHERE 
harenvironment.envobjid=harstate.envobjid AND
harstate.stateobjid=harstateprocess.stateobjid AND
harstate.stateobjid=harudp.stateobjid AND
harstateprocess.processobjid=harudp.processobjid
GROUP BY 
environmentname, 
statename,
harstateprocess.processname,
harudp.processname