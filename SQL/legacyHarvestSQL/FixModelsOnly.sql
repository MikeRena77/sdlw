--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
SPOOL &1
/*
 * The following statements were used to make the Models dump
 * match its documentation.
 * They're not guaranteed to work in user's database.
 * Don't bother with these changes during database 
 * conversion. 
 */ 
INSERT INTO harLinkedProcess( stateobjid, parentprocobjid, processobjid,
                              processorder, processname, processtype, 
                              processprelink)
VALUES ( 182, 1085, harProcessSeq.NextVal, 1, 'Notify of Create Change Request', 
         'NotifyProcess', 'N');
 
INSERT INTO harNotify( processobjid, processname, parentprocobjid, stateobjid,
                       outputtarget, onerroraction, creationtime, creatorid, 
                       modifiedtime, modifierid,
                       mailfacility, message)
VALUES ( harProcessSeq.CurrVal, 'Notify of Create Change Request', 1085, 
NULL, 'Display', 'Display', SYSDATE, 1, SYSDATE, 1,
         'hmail -usr harvest -pw mail', 'Date: [date]');

INSERT INTO harNotifyList(PROCESSOBJID, PARENTPROCOBJID, ISGROUP, USRGRPOBJID)
VALUES(harProcessSeq.CurrVal, 1085, 'Y', 5);
 
INSERT INTO harLinkedProcess( stateobjid, parentprocobjid, processobjid,
                              processorder, processname, processtype, 
                              processprelink)
VALUES ( 183, 1091, harProcessSeq.NextVal, 1, 'Notify Promote to Test',
         'NotifyProcess', 'N');
 
INSERT INTO harNotify( processobjid, processname, parentprocobjid, stateobjid,
                       outputtarget, onerroraction, creationtime, creatorid, 
                       modifiedtime, modifierid,
                       mailfacility, message)
VALUES ( harProcessSeq.CurrVal, 'Notify Promote to Test', 1091, NULL,
         'Display', 'Display', SYSDATE, 1, SYSDATE, 1,
         'hmail -usr harvest -pw mail', 'Date: [date]');
 

INSERT INTO harNotifyList(PROCESSOBJID, PARENTPROCOBJID, ISGROUP, USRGRPOBJID)
VALUES(harProcessSeq.CurrVal, 1091, 'Y', 11);

UPDATE harNotify
SET processname = 'Notify Promote to Invalid'
WHERE processobjid = 1007;
 
UPDATE harLinkedProcess
SET processname = 'Notify Promote to Invalid'
WHERE processobjid = 1007;
 
UPDATE harNotify
SET processname = 'Notify Demote to Development'
WHERE processobjid = 97;
 
UPDATE harLinkedProcess
SET processname = 'Notify Demote to Development'
WHERE processobjid = 97;
 
UPDATE harNotify
SET processname = 'Notify Promote to Release'
WHERE processobjid = 96;
 
UPDATE harLinkedProcess
SET processname = 'Notify Promote to Release'
WHERE processobjid = 96;
 
UPDATE harCheckinProc
SET processname = 'Check In Items'
WHERE processobjid = 344;
 
UPDATE harStateProcess
SET processname = 'Check In Items'
WHERE processobjid = 344;

UPDATE harUDP
SET inputparm = 'SELECT' || inputparm
WHERE processobjid = 248 and inputparm LIKE '  environmentname%';
--
-- Multi Site option is no longer supported
-- Delete MS form types
--
DELETE FROM harFormType
	WHERE formtablename = 'harMSMapping' 
        OR formtablename = 'harMSSiteDef';

DROP TABLE harMSMapping;
DROP TABLE harMSSiteDef;

commit;

SPOOL off
EXIT
