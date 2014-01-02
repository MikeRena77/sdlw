/*
 * CopyData.sql
 *
 * Migrate data from old tables to new, 
 * insert objects with ID 0.
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
--
-- This script does not convert items, repositories, views, or versions
-- It also does not convert access.
--
INSERT INTO harAllUsers
            (UsrObjId,
             UserName,
             LoginDate,
             LastLogin,
             LoggedIn,
             RealName,
             PhoneNumber,
             Extension,
             FaxNumber,
             Encryptpsswd,
             CreationTime,
             CreatorId,
             ModifiedTime,
             ModifierId,
             email,
             Note
            )
   SELECT UsrObjId,
          UserName,
          LoginDate,
          LastLogin,
          LoggedIn,
          RealName,
          PhoneNumber,
          Extension,
          FaxNumber,
          Encryptpsswd,
          CreationTime,
          CreatorId,
          ModifiedTime,
          ModifierId,
          email,
          Note
     FROM OLDharAllUsers;
     

INSERT INTO harUser
            (UsrObjId,
             UserName,
             LoginDate,
             LastLogin,
             LoggedIn,
             RealName,
             PhoneNumber,
             Extension,
             FaxNumber,
             EncryptPsswd,
             PasswdAttrs,
             CreationTime,
             CreatorId,
             ModifiedTime,
             ModifierId,
             Email,
             Note
            )
   SELECT UsrObjId,
          UserName,
          LoginDate,
          LastLogin,
          LoggedIn,
          RealName,
          PhoneNumber,
          Extension,
          FaxNumber,
          EncryptPsswd,
          0,
          CreationTime,
          CreatorId,
          ModifiedTime,
          ModifierId,
          Email,
          Note
     FROM OLDharUser;
     
INSERT INTO harCheckinProc
            (PROCESSOBJID,
             PROCESSNAME,
             STATEOBJID,
             ITEMOPTION,
             PATHOPTION,
             ITEMNEWER,
             MODEOPTION,
             CREATIONTIME,
             CREATORID,
             MODIFIEDTIME,
             MODIFIERID,
             VIEWPATH,
             CLIENTDIR,
             DESCRIPTION,
             NOTE,
             NEWOREXISTINGITEM,
             NEWITEMONLY,
             EXISTINGITEMONLY,
             DELETEAFTERCI,
             OWNERONLY
            )
   SELECT PROCESSOBJID,
          PROCESSNAME,
          STATEOBJID,
          ITEMOPTION,
          PATHOPTION,
          ITEMNEWER,
          DECODE(MODEOPTION, 'Update and Release', 0, 
                             'Update and Keep', 1, 
                             'Release Only', 2, 0),
          CREATIONTIME,
          CREATORID,
          MODIFIEDTIME,
          MODIFIERID,
          VIEWPATH,
          CLIENTDIR,
          DESCRIPTION,
          NOTE,
          NEWOREXISTINGITEM,
          NEWITEMONLY,
          EXISTINGITEMONLY,
          DELETEAFTERCI,
          OWNERONLY
     FROM OLDharCheckinProc;


INSERT INTO harEnvironment(
	envobjid,
	environmentname,
	envisactive,
	baselineviewid,
	creationtime,
	creatorid,
	modifiedtime,
	modifierid,
	isarchive,
	archiveby,
	note
)
   SELECT EnvObjId,
          EnvironmentName,
          EnvIsActive,
          0,
          CreationTime,
          CreatorId,
          ModifiedTime,
          ModifierId,
          'N', 1,
          Note
     FROM OLDharEnvironment;

INSERT INTO harForm
            (FORMOBJID,
             FORMNAME,
             FORMTYPEOBJID,
             CREATIONTIME,
             CREATORID,
             MODIFIEDTIME,
             MODIFIERID
            )
   SELECT FORMOBJID, FORMNAME, FORMTYPEOBJID, SYSDATE, 1, SYSDATE, 1
     FROM OLDharForm;
     
UPDATE harForm f
   SET (CREATORID, CREATIONTIME) = ( SELECT h.USROBJID, h.EXECDTIME
                                       FROM harFormHistory h
                                      WHERE h.FORMOBJID = f.FORMOBJID
                                        AND h.ACTION = 'Created')
 WHERE EXISTS (SELECT USROBJID, EXECDTIME
                 FROM harFormHistory h
                WHERE h.FORMOBJID = f.FORMOBJID
                  AND h.ACTION = 'Created');

UPDATE harForm f
   SET (f.MODIFIEDTIME) = ( SELECT DISTINCT h.EXECDTIME
                              FROM harFormHistory h
                             WHERE h.FORMOBJID = f.FORMOBJID
                               AND h.EXECDTIME =
                                      (SELECT MAX (mh.EXECDTIME)
                                         FROM harFormHistory mh
                                        WHERE h.FORMOBJID = mh.FORMOBJID
                                          AND h.FORMOBJID = f.FORMOBJID));
UPDATE harForm f
   SET (f.MODIFIERID) = ( SELECT MAX (h.USROBJID)
                            FROM harFormHistory h
                           WHERE h.FORMOBJID = f.FORMOBJID
                             AND h.EXECDTIME = f.MODIFIEDTIME);
                             
INSERT INTO harItemAccess
            (itemobjid, usrgrpobjid, viewaccess)
     VALUES (0, 2, 'N');

INSERT INTO harPackageGroup(
    pkggrpobjid,
	pkggrpname,
	envobjid,
	bind,
	creationtime,
	creatorid,
	modifiedtime,
	modifierid,
	note )
   SELECT PkgGrpObjId,
          PkgGrpName,
          EnvObjId,
          'N',
          CreationTime,
          CreatorId,
          ModifiedTime,
          ModifierId,
          Note
     FROM OLDharPackageGroup;

INSERT INTO harPathFullName
            (itemobjid, pathfullname)
     VALUES (0, '\');

INSERT INTO harRepository (
               REPOSITOBJID,
               REPOSITNAME,
               ROOTPATHID,
               CREATIONTIME,
               CREATORID,
               MODIFIEDTIME,
               MODIFIERID,
               INITIALVIEWID,
               HOSTINSTANCE, 
               EXTENSIONOPTION,
               COMPFILE
            )
     VALUES (0, 'GLOBAL Repository', 0, SYSDATE, 1, SYSDATE, 1, 0, 0,
             1, 'N' );

INSERT INTO harStateProcess
(
	stateobjid,
	processobjid,
	processname,
	processtype,
	processorder
)
SELECT Stateobjid, ProcessObjId, ProcessName, ProcessType, ProcessOrder
 FROM OLDharStateProcess;

UPDATE harStateProcess S
   SET S.POSTCOUNT = (SELECT COUNT (*)
                        FROM harLinkedProcess L
                       WHERE L.PARENTPROCOBJID = S.PROCESSOBJID
                         AND L.PROCESSPRELINK = 'N');

UPDATE harStateProcess S
   SET S.PRECOUNT = (SELECT COUNT (*)
                       FROM harLinkedProcess L
                      WHERE L.PARENTPROCOBJID = S.PROCESSOBJID
                        AND L.PROCESSPRELINK = 'Y');

INSERT INTO harVersions
            (
               versionobjid,
               itemobjid,
               packageobjid,
               parentversionid,
               mergedversionid,
               inbranch,
               creationtime,
               creatorid,
               modifiedtime,
               modifierid,
               versiondataobjid,
               description
            )
     VALUES (0, 0, 0, 0, 0, 0, SYSDATE, 1, SYSDATE, 1, 0, 'Dummy version');
 
 


 

     


