SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO


/****************************************************************************************/
/*                                                                                      */
/* Star 14558296 HARVEST: Additional Indexes                                       */
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO
/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from harallusers with (tablockx)
GO
 
Select top 1 1 from harapprovelist with (tablockx)
GO
 
Select top 1 1 from harassocpkg with (tablockx)
GO
 
Select top 1 1 from harbranch with (tablockx)
GO
 
Select top 1 1 from harformtypedefs with (tablockx)
GO
 
Select top 1 1 from haritemaccess with (tablockx)
GO
 
Select top 1 1 from haritems with (tablockx)
GO
 
Select top 1 1 from harlinkedprocess with (tablockx)
GO
 
Select top 1 1 from harnotifylist with (tablockx)
GO
 
Select top 1 1 from harpackage with (tablockx)
GO
 
Select top 1 1 from harpathfullname with (tablockx)
GO
 
Select top 1 1 from harpackagegroup with (tablockx)
GO
 
Select top 1 1 from harpkghistory with (tablockx)
GO
 
Select top 1 1 from harpkgsinpkggrp with (tablockx)
GO
 
Select top 1 1 from harrepinview with (tablockx)
GO
 
Select top 1 1 from harstate with (tablockx)
GO
 
Select top 1 1 from harversiondata with (tablockx)
GO
 
Select top 1 1 from harversioninview with (tablockx)
GO
 
Select top 1 1 from harversions with (tablockx)
GO
 
Select top 1 1 from harview with (tablockx)
GO
 
Select top 1 1 from haritemrelationship with (tablockx)
GO
 
Select top 1 1 from harnotify with (tablockx)
GO
 
Select top 1 1 from harudp with (tablockx)
GO
 
Select top 1 1 from haruserdata with (tablockx)
GO
 
Select top 1 1 from harformhistory with (tablockx)
GO
 
Select top 1 1 from harsync with (tablockx)
GO
 
Select top 1 1 from harsyncconfig with (tablockx)
GO
 
Select top 1 1 from harsite with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */
CREATE UNIQUE INDEX harallusers_objidname ON dbo.HARALLUSERS (
            usrobjid,            
            username
)
GO

CREATE UNIQUE INDEX HARAPPROVELIST_IND ON dbo.HARAPPROVELIST
(
    PROCESSOBJID
  , STATEOBJID
  , ISGROUP
  , USROBJID
  , USRGRPOBJID
)
GO

CREATE INDEX HARASSOCPKG_IND ON dbo.HARASSOCPKG
(
    ASSOCPKGID
)
GO
CREATE INDEX HARBRANCH_ITEMID_FK ON dbo.HARBRANCH 
( 
   ITEMOBJID 
)
GO

CREATE INDEX HARFORMTYPEDEFS_IND ON dbo.HARFORMTYPEDEFS
(
    FORMTYPEOBJID
)
GO


CREATE INDEX HARITEMACCESS_USRGRP ON dbo.HARITEMACCESS
(
    USRGRPOBJID
)
GO

CREATE INDEX HARITEMS_PARENTTYPE ON dbo.HARITEMS 
(
    PARENTOBJID,
    ITEMTYPE,
    ITEMOBJID,
    MODIFIERID,
    CREATORID,
    ITEMNAME,
    REPOSITOBJID,
    CREATIONTIME,
    MODIFIEDTIME
)
GO

drop index haritems.haritems_itemnameupper
GO

CREATE INDEX HARITEMS_ITEMNAMEUPPER ON dbo.HARITEMS 
(
    ITEMNAMEUPPER,
    PARENTOBJID,
    ITEMOBJID,
    ITEMNAME)
GO


CREATE INDEX HARITEMS_REPID ON dbo.HARITEMS
(
    REPOSITOBJID
)
GO

CREATE UNIQUE INDEX HARLINKEDPROCESS_IND ON dbo.HARLINKEDPROCESS
(
    PARENTPROCOBJID
  , PROCESSNAME
)
GO

CREATE INDEX HARLINKEDPROCESS_POBJID ON dbo.HARLINKEDPROCESS 
(
    PROCESSOBJID
)
GO

CREATE INDEX HARLINKEDPROCESS_PARENT ON dbo.HARLINKEDPROCESS 
(
    PARENTPROCOBJID, 
    PROCESSPRELINK, 
    PROCESSORDER
)
GO

CREATE UNIQUE INDEX HARNOTIFYLIST_IND ON dbo.HARNOTIFYLIST
(
    PROCESSOBJID
  , STATEOBJID
  , PARENTPROCOBJID
  , ISGROUP
  , USROBJID
  , USRGRPOBJID
)
GO

CREATE INDEX HARPACKAGE_IND_ENV ON dbo.HARPACKAGE
(
    ENVOBJID
  , STATEOBJID
)
GO

CREATE INDEX HARPATHFULLNAME_P ON dbo.HARPATHFULLNAME (PATHFULLNAME, ITEMOBJID)
GO

CREATE INDEX HARPATHFULLNAME_PU ON dbo.HARPATHFULLNAME (PATHFULLNAMEUPPER, ITEMOBJID)
GO

CREATE UNIQUE INDEX HARPKGGRP_IND ON dbo.HARPACKAGEGROUP
(
    ENVOBJID
  , PKGGRPNAME
)
GO


CREATE INDEX HARPKGHIST_IND ON dbo.HARPKGHISTORY
(
    PACKAGEOBJID
)
GO

CREATE INDEX HARPKGSINPKGGRP_IND ON dbo.HARPKGSINPKGGRP
(
    PKGGRPOBJID
)
GO

CREATE INDEX HARREPINVIEW_REPID_FK ON HARREPINVIEW
(
    REPOSITOBJID
)
GO

CREATE INDEX HARSTATE_ENVOBJID ON dbo.HARSTATE 
(
    ENVOBJID
)
GO

CREATE UNIQUE INDEX HARSTATE_LIST ON dbo.HARSTATE
(
    ENVOBJID,
    STATEOBJID,
    CREATORID,
    MODIFIERID,
    VIEWOBJID,
    STATENAME,   
    STATEORDER,
    SNAPSHOT,
    LOCATIONX,
    LOCATIONY,
    CREATIONTIME,
    MODIFIEDTIME
)
GO

CREATE INDEX HARVERSIONDATA_ITMID_FK ON dbo.HARVERSIONDATA 
( 
   ITEMOBJID
)
GO 

CREATE INDEX HARVIV_VERS_IND ON dbo.HARVERSIONINVIEW
(
    VERSIONOBJID
)
GO

CREATE INDEX HARVERSIONINVIEW_VIEW ON dbo.HARVERSIONINVIEW
(
	VIEWOBJID
)
GO

CREATE INDEX HARVERSIONS_ITEM_IND ON dbo.HARVERSIONS
(
    ITEMOBJID
   ,VERSIONOBJID
)
GO

CREATE INDEX HARVERSIONS_PKG_IND ON dbo.HARVERSIONS
(
    PACKAGEOBJID,
    MODIFIERID,
    CREATORID,
    VERSIONSTATUS
)
GO

CREATE INDEX HARVERSIONS_MERGED_IDX ON dbo.HARVERSIONS        
(
   MERGEDVERSIONID
  ,PARENTVERSIONID
)
GO

CREATE INDEX HARVERSIONS_STATUS ON dbo.HARVERSIONS 
(
   VERSIONSTATUS
  ,ITEMOBJID
  ,VERSIONOBJID
) 
GO

CREATE INDEX HARVERSIONS_VSTATUS ON dbo.HARVERSIONS
( 
   ITEMOBJID
  ,VERSIONSTATUS 
)
GO

CREATE INDEX HARVERSIONS_ITEMMAPPED ON dbo.HARVERSIONS
(
   ITEMOBJID,
   MAPPEDVERSION,
   VERSIONOBJID,
   PACKAGEOBJID
)
GO

CREATE INDEX HARVERSIONS_VERITEM ON HARVERSIONS 
(
   VERSIONOBJID,
   ITEMOBJID
)
GO

CREATE UNIQUE INDEX HARVIEW_OBJIDNAME ON dbo.HARVIEW
(
    VIEWOBJID,
    VIEWNAME
) 
GO

ALTER TABLE dbo.HARAPPROVELIST ADD CONSTRAINT HARAPPROVELIST_USRID_FK FOREIGN KEY
(
    USROBJID
)
REFERENCES HARUSER
(
    USROBJID
)
ON DELETE CASCADE
GO

ALTER TABLE dbo.HARBRANCH ADD CONSTRAINT HARBRANCH_ITEMID_FK FOREIGN KEY
(
    ITEMOBJID
)
REFERENCES HARITEMS
(
    ITEMOBJID
)
ON DELETE CASCADE
GO


ALTER TABLE dbo.HARITEMACCESS ADD CONSTRAINT HARITEMACCESS_ITEMID_FK FOREIGN KEY
(
    ITEMOBJID
)
REFERENCES HARITEMS
(
    ITEMOBJID
)
ON DELETE CASCADE
GO

ALTER TABLE dbo.HARITEMRELATIONSHIP ADD CONSTRAINT HARITEMREL_ITEMID_FK FOREIGN KEY
(
    ITEMOBJID
)
REFERENCES HARITEMS
(
    ITEMOBJID
)
ON DELETE CASCADE
GO

ALTER TABLE dbo.HARNOTIFY ADD CONSTRAINT HARNOTIFY_PPID_FK FOREIGN KEY
(
    PARENTPROCOBJID
  , PROCESSOBJID
)
REFERENCES HARLINKEDPROCESS
(
    PARENTPROCOBJID
  , PROCESSOBJID
)
ON DELETE CASCADE
GO

ALTER TABLE dbo.HARNOTIFYLIST ADD CONSTRAINT HARNOTIFYLIST_PPID_FK FOREIGN KEY
(
    PARENTPROCOBJID
  , PROCESSOBJID
)
REFERENCES HARLINKEDPROCESS
(
    PARENTPROCOBJID
  , PROCESSOBJID
)
ON DELETE CASCADE
GO

ALTER TABLE dbo.HARNOTIFYLIST ADD CONSTRAINT HARNOTIFYLIST_USRID_FK FOREIGN KEY
(
    USROBJID
)
REFERENCES HARUSER
(
    USROBJID
)
ON DELETE CASCADE
GO


ALTER TABLE dbo.HARSTATE ADD CONSTRAINT HARSTATE_STATUS_FK FOREIGN KEY
(
    PMSTATUSINDEX
)
REFERENCES HARPMSTATUS
(
    PMSTATUSINDEX
)
GO

ALTER TABLE dbo.HARUDP ADD CONSTRAINT HARUDP_PPID_FK FOREIGN KEY
(
    PARENTPROCOBJID
  , PROCESSOBJID
)
REFERENCES HARLINKEDPROCESS
(
    PARENTPROCOBJID
  , PROCESSOBJID
)
ON DELETE CASCADE
GO

ALTER TABLE dbo.HARUSERDATA ADD CONSTRAINT HARUSERDATA_FK FOREIGN KEY
(
    USROBJID
)
REFERENCES HARALLUSERS
(
    USROBJID
)
GO

CREATE INDEX HARFORMHIST_IND ON dbo.HARFORMHISTORY
(
    FORMOBJID
)
GO

CREATE INDEX HARITEMS_IND_TYPE ON dbo.HARITEMS
(
    ITEMTYPE
  , PARENTOBJID
)
GO

drop table harsync
GO

drop table harsyncconfig
GO

drop table harsite
GO



/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14558296, getdate(), 1, 4, 'Star 14558296 HARVEST: Additional Indexes ' )
GO

COMMIT TRANSACTION 
GO


