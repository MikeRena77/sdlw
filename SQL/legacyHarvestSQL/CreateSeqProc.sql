/*
 * CreateSeqProc.sql
 *
 * Build and run a script to create process sequence
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
DEFINE seqname = harProcessSeq
DEFINE tablename = harProcess
DEFINE idname = processobjid
DEFINE scriptname = CreateSeqSlave.sql
DEFINE logfile = CreateSeqSlave.log

START off
spool &scriptname
SELECT 'CREATE SEQUENCE &seqname INCREMENT BY 1 START WITH ',
       MAX( nextid) + 1,
      ' NOMAXVALUE NOCYCLE CACHE 5;' 
FROM (
SELECT MAX(&idname) nextid FROM harStateProcess
UNION
SELECT MAX(&idname) nextid FROM harLinkedProcess
UNION
SELECT 0 nextid FROM DUAL);

spool off
SET feedback ON
spool &logfile
START &scriptname

INSERT INTO harObjectSequenceId
VALUES ('&tablename', '&seqname');

spool off








