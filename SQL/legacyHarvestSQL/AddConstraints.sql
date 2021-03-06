--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
-- SPOOL &1
-- Put back foreign key constraints after all data has been migrated.
ALTER TABLE harAllChildrenPath ADD ( CONSTRAINT HARALLCHILDPATH_ITEMID_FK
  FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARAPPROVE ADD ( CONSTRAINT HARAPPOVE_SPID_FK
   FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARAPPROVEHIST ADD ( CONSTRAINT HARAPPROVEHIST_ENVID_FK 
  FOREIGN KEY (ENVOBJID) REFERENCES HARENVIRONMENT ON DELETE CASCADE ) ;

ALTER TABLE HARAPPROVELIST ADD ( CONSTRAINT HARAPPROVELIST_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARAPPROVELIST ADD ( CONSTRAINT HARAPPROVELIST_USRGRP_FK 
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARAPPROVELIST ADD ( CONSTRAINT HARAPPROVELIST_USRID_FK 
  FOREIGN KEY (USROBJID) REFERENCES HARUSER ON DELETE CASCADE ) ;
  
ALTER TABLE HARASSOCPKG ADD ( CONSTRAINT HARASSOCPKG_FID_FK FOREIGN KEY (FORMOBJID)
  REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARASSOCPKG ADD ( CONSTRAINT HARASSOCPKG_AID_FK FOREIGN KEY (ASSOCPKGID)
  REFERENCES HARPACKAGE ON DELETE CASCADE ) ;

ALTER TABLE HARBRANCH ADD ( CONSTRAINT HARBRANCH_ITEMID_FK FOREIGN KEY (ITEMOBJID)
  REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARCHECKINPROC ADD ( CONSTRAINT HARCHECKINPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;
/*
 *  HARCHECKOUT is obsolete
 * ALTER TABLE HARCHECKOUT ADD ( CONSTRAINT HARCHECKOUT_FORMID_FK FOREIGN 
 * KEY (FORPKGID) REFERENCES HARPACKAGE ON DELETE CASCADE ) ;
 */
ALTER TABLE HARCHECKOUTPROC ADD ( CONSTRAINT HARCHECKOUTPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;
/*
 * Foreign key constraints for form tables are created in subsequent 
 * script
 */
-- ALTER TABLE HARCOMMENT ADD ( CONSTRAINT HARCOMMENT_FORMID_FK FOREIGN 
-- KEY (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARCONMRGPROC ADD ( CONSTRAINT HARCONMRGPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARCRPKGPROC ADD ( CONSTRAINT HARCRPKGPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARCRSENVMRGPROC ADD ( CONSTRAINT HARCRSENVMRGPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

-- ALTER TABLE HARDEFECT ADD ( CONSTRAINT HARDEFECT_FORMID_FK FOREIGN KEY 
-- (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARDELVERSPROC ADD ( CONSTRAINT HARDELVERSPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARDEMOTEPROC ADD ( CONSTRAINT HARDEMOTEPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARENVIRONMENTACCESS ADD ( CONSTRAINT HARENVACCESS_ENVID_FK 
  FOREIGN KEY (ENVOBJID) REFERENCES HARENVIRONMENT ON DELETE CASCADE ) ;

ALTER TABLE HARENVIRONMENTACCESS ADD ( CONSTRAINT HARENVACCESS_USRGRPID_FK
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

-- ALTER TABLE HARESD ADD ( CONSTRAINT HARESD_FORMID_FK FOREIGN KEY 
-- (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HAREXTERNASSOC ADD CONSTRAINT HAREXTERNASSOC_PKG_FK
 FOREIGN KEY (PACKAGEOBJID)
  REFERENCES HARPACKAGE(PACKAGEOBJID)
  ON DELETE CASCADE;
  
ALTER TABLE HAREXTERNASSOC ADD CONSTRAINT HAREXTERNASSOC_USR_FK
 FOREIGN KEY (USROBJID)
  REFERENCES HARALLUSERS(USROBJID);
  
ALTER TABLE HARFILEEXTENSION ADD CONSTRAINT HARFILEEXTENSION_REPID_FK
 FOREIGN KEY (REPOSITOBJID)
  REFERENCES HARREPOSITORY(REPOSITOBJID)
  ON DELETE CASCADE;
  
ALTER TABLE HARFORM ADD ( CONSTRAINT HARFORM_FTID_FK FOREIGN KEY (FORMTYPEOBJID)
  REFERENCES HARFORMTYPE ON DELETE CASCADE ) ;

ALTER TABLE HARFORMHISTORY ADD ( CONSTRAINT HARFORMHIST_FORMID_FK FOREIGN KEY (FORMOBJID)
  REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARFORMTYPEACCESS ADD ( CONSTRAINT HARFORMTYPEACCESS_FTID_FK
  FOREIGN KEY (FORMTYPEOBJID) REFERENCES HARFORMTYPE ON DELETE CASCADE ) ;

ALTER TABLE HARFORMTYPEACCESS ADD ( CONSTRAINT HARFORMTYPEACCESS_USRGRPID_FK
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARFORMTYPEDEFS ADD ( CONSTRAINT HARFORMTYPEDEFS_FTID_FK 
  FOREIGN KEY (FORMTYPEOBJID) REFERENCES HARFORMTYPE ON DELETE CASCADE ) ;

ALTER TABLE HARHARVEST ADD ( CONSTRAINT HARHARVEST_USRGRPID_FK FOREIGN KEY (USRGRPOBJID)
  REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARINTMRGPROC ADD ( CONSTRAINT HARINTMRGPROC_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARITEMACCESS ADD ( CONSTRAINT HARITEMACCESS_ITEMID_FK
  FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARITEMACCESS ADD ( CONSTRAINT HARITEMACCESS_USRGRPID_FK
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARITEMS ADD ( CONSTRAINT HARITEMS_PID_FK FOREIGN KEY (PARENTOBJID)
  REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARITEMRELATIONSHIP ADD ( CONSTRAINT HARITEMREL_ITEMID_FK
  FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARITEMRELATIONSHIP ADD ( CONSTRAINT HARITEMREL_VERID_FK
  FOREIGN KEY (VERSIONOBJID) REFERENCES HARVERSIONS ON DELETE CASCADE ) ;

ALTER TABLE HARLINKEDPROCESS ADD ( CONSTRAINT HARLINKEDPROCESS_SPID_FK
  FOREIGN KEY (STATEOBJID, PARENTPROCOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARLINKEDPROCESS ADD ( CONSTRAINT HARLINKEDPROCESS_STATEID_FK
  FOREIGN KEY (STATEOBJID) REFERENCES HARSTATE ON DELETE CASCADE ) ;

ALTER TABLE HARLISTDIFFPROC ADD ( CONSTRAINT HARLISTDIFFPROC_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARLISTVERSPROC ADD ( CONSTRAINT HARLISTVERSPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARMOVEPKGPROC ADD ( CONSTRAINT HARMOVEPKGPROC_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

-- ALTER TABLE HARMR ADD ( CONSTRAINT HARMR_FORMID_FK FOREIGN KEY 
-- (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

/* MS form FK constraints were unnamed, so they were not dropped
ALTER TABLE HARMSMAPPING ADD 
( CONSTRAINT HARMSMAPPING_FORMID_FK 
  FOREIGN KEY (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARMSSITEDEF ADD ( CONSTRAINT HARMSSITEDEF_FORMID_FK 
  FOREIGN KEY (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;
*/
ALTER TABLE HARNOTIFY ADD ( CONSTRAINT HARNOTIFY_PPID_FK
  FOREIGN KEY (PARENTPROCOBJID, PROCESSOBJID) REFERENCES HARLINKEDPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARNOTIFY ADD ( CONSTRAINT HARNOTIFY_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARNOTIFYLIST ADD ( CONSTRAINT HARNOTIFYLIST_USRID_FK FOREIGN KEY (USROBJID)
  REFERENCES HARUSER ON DELETE CASCADE ) ;

ALTER TABLE HARNOTIFYLIST ADD ( CONSTRAINT HARNOTIFYLIST_PPID_FK 
  FOREIGN KEY (PARENTPROCOBJID, PROCESSOBJID) REFERENCES HARLINKEDPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARNOTIFYLIST ADD ( CONSTRAINT HARNOTIFYLIST_SPID_FK 
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARNOTIFYLIST ADD ( CONSTRAINT HARNOTIFYLIST_USRGRPID_FK 
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

-- ALTER TABLE HARPAC ADD ( CONSTRAINT HARPAC_FORMID_FK FOREIGN KEY 
-- (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARPACKAGE ADD ( CONSTRAINT HARPACKAGE_AID_FK FOREIGN KEY (ASSIGNEEID)
  REFERENCES HARALLUSERS ) ;

ALTER TABLE HARPACKAGE ADD ( CONSTRAINT HARPACKAGE_ENVID_FK FOREIGN KEY (ENVOBJID)
  REFERENCES HARENVIRONMENT ON DELETE CASCADE ) ;

ALTER TABLE HARPACKAGEGROUP ADD ( CONSTRAINT HARPACKAGEGROUP_ENVID_FK FOREIGN KEY (ENVOBJID)
  REFERENCES HARENVIRONMENT ON DELETE CASCADE ) ;

-- harPackageMovement has been dropped
-- ALTER TABLE HARPACKAGEMOVEMENT ADD ( CONSTRAINT HARPKGMOVEMENT_PKGID_FK
--  FOREIGN KEY (PACKAGEOBJID) REFERENCES HARPACKAGE ON DELETE CASCADE ) ;

-- ALTER TABLE HARPACKAGEMOVEMENT ADD ( CONSTRAINT 
-- HARPKGMOVEMENT_STATEID_FK 
--  FOREIGN KEY (STATEOBJID) REFERENCES HARSTATE ON DELETE CASCADE ) ;
 
ALTER TABLE HARPATHFULLNAME ADD ( CONSTRAINT HARPATHFULLNAME_ITEMID_FK
 FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARPKGHISTORY  ADD ( CONSTRAINT HARPKGHISTORY_PKGID_FK
  FOREIGN KEY (PACKAGEOBJID) REFERENCES HARPACKAGE ON DELETE CASCADE ) ;

ALTER TABLE HARPKGSINPKGGRP ADD ( CONSTRAINT HARPKGSINGRP_PKGID_FK
  FOREIGN KEY (PACKAGEOBJID) REFERENCES HARPACKAGE ON DELETE CASCADE ) ;

ALTER TABLE HARPKGSINPKGGRP ADD ( CONSTRAINT HARPKGSINGRP_PKGGRPID_FK
  FOREIGN KEY (PKGGRPOBJID) REFERENCES HARPACKAGEGROUP ON DELETE CASCADE ) ;

-- ALTER TABLE HARPROBLEMREPORT ADD ( CONSTRAINT HARPROBLEMREPORT_FORMID_FK
--  FOREIGN KEY (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARPROMOTEPROC ADD ( CONSTRAINT HARPROMOTEPROC_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

-- ALTER TABLE HARQANDA ADD ( CONSTRAINT HARQANDA_FORMID_FK FOREIGN KEY 
-- (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

--
-- We will leave SYNC tables as is. They are not used in RINCON
--
-- ALTER TABLE HARSYNCCONFIG ADD ( CONSTRAINT HARSYNCCONFIG_SITEID_FK
--   FOREIGN KEY (SITEOBJID) REFERENCES HARSITE ON DELETE CASCADE ) ;

-- ALTER TABLE HARSYNC ADD ( CONSTRAINT HARSYNC_CONFIGID_FK
--   FOREIGN KEY (CONFIGOBJID) REFERENCES HARSYNCCONFIG ) ;

-- ALTER TABLE HARRECEIVEUPDATES ADD ( CONSTRAINT HARRECEIVEUPDATES_CONFIGID_FK
--   FOREIGN KEY (CONFIGOBJID) REFERENCES HARSYNCCONFIG ) ;

-- ALTER TABLE HARRECEIVEUPDATES ADD ( CONSTRAINT HARRECEIVEUPDATE_SYNCID_FK
--   FOREIGN KEY (SYNCOBJID) REFERENCES HARSYNC ) ;

-- ALTER TABLE HARSENDUPDATES ADD ( CONSTRAINT HARSENDUPDATES_CONFIGID_FK
--   FOREIGN KEY (CONFIGOBJID) REFERENCES HARSYNCCONFIG ) ;

ALTER TABLE HARREMITEMPROC ADD ( CONSTRAINT HARREMITEMPROC_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARRENAMEITEMPROC ADD ( CONSTRAINT HARRENAMEITEMPROC_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARREPINVIEW ADD ( CONSTRAINT HARREPINVIEW_VIEWID_FK 
  FOREIGN KEY (VIEWOBJID) REFERENCES HARVIEW ON DELETE CASCADE ) ;

ALTER TABLE HARREPINVIEW ADD ( CONSTRAINT HARREPINVIEW_REPID_FK
  FOREIGN KEY (REPOSITOBJID) REFERENCES HARREPOSITORY ON DELETE CASCADE ) ;

ALTER TABLE HARREPOSITORYACCESS ADD ( CONSTRAINT HARREPACCESS_USRGRP_FK 
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARREPOSITORYACCESS ADD ( CONSTRAINT HARREPACCESS_REPID_FK
  FOREIGN KEY (REPOSITOBJID) REFERENCES HARREPOSITORY ON DELETE CASCADE ) ;

ALTER TABLE HARSNAPVIEWPROC ADD ( CONSTRAINT HARSNAPVIEWPROC_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARSTATE ADD ( CONSTRAINT HARSTATE_ENVID_FK FOREIGN KEY (ENVOBJID)
  REFERENCES HARENVIRONMENT ON DELETE CASCADE ) ;

--
-- ALTER TABLE HARSTATE ADD ( CONSTRAINT HARSTATE_PMINDX_FK
--  FOREIGN KEY (PMSTATUSINDEX) REFERENCES HARPMSTATUS ) ;

ALTER TABLE HARSTATE ADD ( CONSTRAINT HARSTATE_VIEWID_FK 
  FOREIGN KEY (VIEWOBJID) REFERENCES HARVIEW ) ;

ALTER TABLE HARSTATEPROCESS ADD ( CONSTRAINT HARSTATEPROC_STATEID_FK 
  FOREIGN KEY (STATEOBJID) REFERENCES HARSTATE ON DELETE CASCADE ) ;

ALTER TABLE HARSTATEACCESS ADD ( CONSTRAINT HARSTATEACCESS_STATEID_FK
  FOREIGN KEY (STATEOBJID) REFERENCES HARSTATE ON DELETE CASCADE ) ;

ALTER TABLE HARSTATEACCESS ADD ( CONSTRAINT HARSTATEACCESS_USRGRPID_FK
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARSTATEPROCESSACCESS ADD ( CONSTRAINT HARSTATEPROCACCESS_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARSTATEPROCESSACCESS ADD ( CONSTRAINT HARSTATEPROCACCESS_USRGRP_FK
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

-- ALTER TABLE HARTESTINGINFO ADD ( CONSTRAINT HARTESTINGINFOR_FORMID_FK
--  FOREIGN KEY (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARUDP ADD ( CONSTRAINT HARUDP_PPID_FK
  FOREIGN KEY (PARENTPROCOBJID, PROCESSOBJID) REFERENCES HARLINKEDPROCESS ON DELETE CASCADE ) ;

ALTER TABLE HARUDP ADD ( CONSTRAINT HARUDP_SPID_FK
  FOREIGN KEY (STATEOBJID, PROCESSOBJID) REFERENCES HARSTATEPROCESS ON DELETE CASCADE ) ;

-- ALTER TABLE HARUSERCONTACT ADD ( CONSTRAINT HARUSERCONTACT_FORMID_FK
--  FOREIGN KEY (FORMOBJID) REFERENCES HARFORM ON DELETE CASCADE ) ;

ALTER TABLE HARUSERSINGROUP ADD ( CONSTRAINT HARUSRINGRP_USRGRPID_FK
  FOREIGN KEY (USRGRPOBJID) REFERENCES HARUSERGROUP ON DELETE CASCADE ) ;

ALTER TABLE HARUSERSINGROUP ADD ( CONSTRAINT HARUSRINGRP_USRID_FK
  FOREIGN KEY (USROBJID) REFERENCES HARUSER ON DELETE CASCADE ) ;

ALTER TABLE HARVERSIONDATA ADD (CONSTRAINT HARVERSIONDATA_ITMID_FK  
FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS ON DELETE CASCADE);

ALTER TABLE HARVERSIONDELTA ADD (CONSTRAINT HARVERSIONDELTA_CHIDID_FK 
FOREIGN KEY (CHILDVERSIONDATAID) REFERENCES 
	HARVERSIONDATA(VERSIONDATAOBJID) ON DELETE CASCADE);

ALTER TABLE HARVERSIONDELTA ADD ( CONSTRAINT HARVERSIONDELTA_PARENTID_FK 
FOREIGN KEY (PARENTVERSIONDATAID) REFERENCES 
	HARVERSIONDATA(VERSIONDATAOBJID) ON DELETE CASCADE); 

ALTER TABLE HARVERSIONINVIEW ADD ( CONSTRAINT HARVERSIONINVIEW_VERID_FK
  FOREIGN KEY (VERSIONOBJID) REFERENCES HARVERSIONS ON DELETE CASCADE ) ;
--
-- HARVERSIONPACKAGEDEPENDENCY was going to be new table, not used
-- ALTER TABLE HARVERSIONPACKAGEDEPENDENCY ADD ( CONSTRAINT 
-- HARVERPKGDEP_PKGID_FK
--  FOREIGN KEY (PACKAGEOBJID) REFERENCES HARPACKAGE ON DELETE CASCADE ) ;
-- 
-- ALTER TABLE HARVERSIONPACKAGEDEPENDENCY ADD ( CONSTRAINT 
-- HARVERPKGDEP_VERID_FK
--  FOREIGN KEY (VERSIONOBJID) REFERENCES HARVERSIONS ON DELETE CASCADE ) ;
--

ALTER TABLE HARVERSIONS ADD ( CONSTRAINT HARVERSIONS_ITEMID_FK 
  FOREIGN KEY (ITEMOBJID) REFERENCES HARITEMS ON DELETE CASCADE ) ;

ALTER TABLE HARVERSIONS ADD ( CONSTRAINT HARVERSIONS_PKGID_FK 
  FOREIGN KEY (PACKAGEOBJID) REFERENCES HARPACKAGE ) ;

ALTER TABLE HARVIEW ADD ( CONSTRAINT HARVIEW_ENVID_FK FOREIGN KEY (ENVOBJID)
  REFERENCES HARENVIRONMENT ON DELETE CASCADE ) ;
  
-- SPOOL off
-- EXIT

