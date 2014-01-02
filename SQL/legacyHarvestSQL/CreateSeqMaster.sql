/*
 * CreateSeqMaster.sql
 *
 * Build and run a script to create a sequence
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
DEFINE seqname = &1
DEFINE tablename = &2
DEFINE idname = &3
DEFINE storedtblname = &4

DEFINE scriptname = CreateSeqSlave.sql
DEFINE logfile = CreateSeqSlave.log

START off
spool &scriptname
SELECT 'CREATE SEQUENCE &seqname INCREMENT BY 1 START WITH ',
       MAX( nextid) + 1,
      ' NOMAXVALUE NOCYCLE CACHE 5;' 
FROM (
SELECT MAX(&idname) nextid FROM &tablename
UNION
SELECT 0 nextid FROM DUAL);

spool off
SET feedback ON
spool &logfile
START &scriptname

INSERT INTO harObjectSequenceId
VALUES ('&storedtblname', '&seqname');

spool off








