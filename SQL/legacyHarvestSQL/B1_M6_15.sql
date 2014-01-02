/* Formatted by PL/Formatter v2.1.5.2 on 2000/06/28 19:59 */
WHENEVER SQLERROR CONTINUE;
spool &1;

ALTER TABLE HARPACKAGE 
ADD(CLIENTNAME VARCHAR2(128) NULL);

ALTER TABLE HARPACKAGE 
ADD(SERVERNAME VARCHAR2(128) NULL);

ALTER table hartableinfo   add (
Databaseid     INTEGER DEFAULT 0 NOT NULL);

ALTER TABLE HARENVIRONMENT ADD (
isArchive      char(1),
archiveBy      INTEGER,
archivemachine char(256),
archivefile    char(256),
archivetime    date);

ALTER TABLE HARAPPROVEHIST 
 ADD CONSTRAINT HARAPPROVEHIST_PK 
 PRIMARY KEY (ENVOBJID, STATEOBJID, PACKAGEOBJID, USROBJID, EXECDTIME, ACTION)
    USING INDEX
    TABLESPACE HARVESTINDEX;

CREATE OR REPLACE VIEW HARAPPROVEHISTACTIONVIEW (
   ENVOBJID,
   STATEOBJID,
   PACKAGEOBJID,
   USROBJID,
   ACTIONTIME,
   ACTION,
   NOTE
)
AS
   SELECT h.envobjid,
          h.stateobjid,
          h.packageobjid,
          h.usrobjid,
          h.execdtime,
          h.action,
          h.note
     FROM harApproveHist h, harApproveHistView v, harpackage p
    WHERE v.packageobjid = p.packageobjid
      AND v.stateobjid = p.stateobjid
      AND h.envobjid = v.envobjid
      AND h.stateobjid = v.stateobjid
      AND h.packageobjid = v.packageobjid
      AND h.usrobjid = v.usrobjid
      AND h.execdtime = v.actiontime;

CREATE OR REPLACE VIEW HARAPPROVEACTIONVIEW (
   ENVOBJID,
   STATEOBJID,
   PACKAGEOBJID,
   USROBJID,
   ACTIONTIME,
   ACTION,
   USRGRPOBJID,
   PROCESSOBJID
)
AS
   SELECT v.envobjid,
          v.stateobjid,
          v.packageobjid,
          v.usrobjid,
          v.actiontime,
          v.action,
          l.usrgrpobjid,
          l.processobjid
     FROM harApproveHistActionView v, harApproveList l
    WHERE v.stateobjid = l.stateobjid
      AND (  (   l.isgroup = 'N'
             AND l.usrobjid = v.usrobjid)
          OR (   l.isgroup = 'Y'
             AND l.usrgrpobjid IN (SELECT usrgrpobjid
                                     FROM harusersingroup g
                                    WHERE v.usrobjid = g.usrobjid)));

CREATE TABLE harExternAssoc
(
 PACKAGEOBJID    NUMBER NOT NULL,
 USROBJID        NUMBER NOT NULL,
 EXTERNALID      NUMBER NOT NULL,
 RESTRICT        NUMBER NOT NULL,
 CONSTRAINT harExternAssoc_Pkg_FK FOREIGN KEY (PACKAGEOBJID) 
   REFERENCES harPackage (PACKAGEOBJID) ON DELETE CASCADE,
 CONSTRAINT harExternAssoc_Usr_FK FOREIGN KEY (USROBJID) 
   REFERENCES harAllUsers (USROBJID),
 PRIMARY KEY (EXTERNALID, USROBJID, PACKAGEOBJID)
    USING INDEX 
    TABLESPACE HARVESTINDEX
) 
TABLESPACE HARVESTMETA;

UPDATE HARENVIRONMENT
 SET ISARCHIVE = 'N', ARCHIVEBY = 1
 WHERE ISARCHIVE IS NULL AND ARCHIVEBY IS NULL;
 
ALTER TABLE HARENVIRONMENT
MODIFY( ISARCHIVE DEFAULT 'N' NOT NULL, 
        ARCHIVEBY DEFAULT 1 NOT NULL);
         
COMMIT;
spool off
EXIT


