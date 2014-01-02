SELECT 
harenvironment.environmentname, 
harstate.statename,
harstateprocess.processname,
harlinkedprocess.processname
from harenvironment, harstate, harstateprocess, harlinkedprocess
WHERE 
harlinkedprocess.processname LIKE 'Notify%' AND
harenvironment.envobjid=harstate.envobjid AND
harstate.stateobjid=harstateprocess.stateobjid AND
harstate.stateobjid=harlinkedprocess.stateobjid AND
harstateprocess.processobjid=harlinkedprocess.parentprocobjid
GROUP BY 
environmentname, 
statename,
harstateprocess.processname,
harlinkedprocess.processname