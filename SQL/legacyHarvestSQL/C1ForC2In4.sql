--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

-- Define Timezone according to Oracle Standard

define TIMEZONE = "'GMT'";

-- Harvest stores all data in GMT. So if you are in a Timezone different to GMT, you neeed
-- to adapt the offset. Use the number of your offset to GMT or other Oracle Timezones to 
-- have the correct value in the DB.
-- Define your Time offset according to your location (e.g. Germany is GMT +1 = "+1")
-- If your Timezone can be defined by a Oracle Timezone, e.g. you are in PDT, then offset is "0" !!!!

define OFFSET = "+1";

-- Update the object id counter

UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harForm';
UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harPackage';
UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harPackageGroup';
UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harEnvironment';
UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harRepository';
UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harUser';
UPDATE harOBJIDGEN SET idcounter=idcounter+10 WHERE harTableName='harState';

-- UPDATE harOBJIDGEN SET idcounter=(select count(*)+ harobjidgen.idcounter +10 from harEnvironment) WHERE harTableName='harUserGroup';


CREATE table ConvharStateProcess ( stateobjid integer, processobjid integer, action char(4) );

CREATE TRIGGER Conv_SP_trigger BEFORE INSERT OR UPDATE
  		ON harStateProcess FOR EACH ROW
  		BEGIN
    		IF INSERTING THEN
       		INSERT INTO ConvharStateProcess(stateobjid, processobjid, action )
          		VALUES ( :new.stateobjid, :new.processobjid, 'add');  
		ELSIF UPDATING THEN
			INSERT INTO ConvharStateProcess(stateobjid, processobjid, action )
          		VALUES ( :new.stateobjid, :new.processobjid, 'upd');     		
    		END IF;
  		END;
/


CREATE table ConvharEnvRepository ( envobjid integer, repviewobjid integer );

CREATE TRIGGER Conv_ER_trigger BEFORE INSERT OR UPDATE
  		ON harEnvRepository FOR EACH ROW
  		BEGIN
    		IF INSERTING THEN
       		INSERT INTO ConvharEnvRepository(envobjid, repviewobjid)
          		VALUES ( :new.envobjid, :new.repviewobjid);        		
    		END IF;
  		END;
/

UPDATE harobjidgen set idcounter = 
(select count(*) + harobjidgen.idcounter
from harrepository )
where harobjidgen.hartablename = 'harView';

Create Table ConvFormPackageAsso(
	Formobjid	integer,
	AssocPkgId	integer,
	Activity	char(4),
	ExecTime	date );


CREATE TRIGGER conv_PF_trigger BEFORE INSERT OR UPDATE
  ON harassocpkg FOR EACH ROW
  BEGIN
    IF INSERTING THEN
       INSERT INTO ConvFormPackageAsso ( formobjid, assocpkgid, activity, exectime )
          VALUES ( :new.formobjid, :new.assocpkgid, 'ADD', sysdate );    
    ELSIF UPDATING THEN
       INSERT INTO ConvFormPackageAsso ( formobjid, assocpkgid, activity, exectime )
          VALUES ( :new.formobjid, :new.assocpkgid, 'UPD', sysdate );
    END IF;
  END;
/

-- Triggers to restrict various Harvest 4.1.x functions, primarily deletes
-- records a "start time" when this script is executed
-- conditionally prevents functions based on object creation time

-- run this as the owner of the Harvest 4.1.x tables

-- create a table to strore the conversion start time of pass one
WHENEVER SQLERROR CONTINUE
DROP TABLE HARCONVERSION; 
WHENEVER SQLERROR EXIT FAILURE
CREATE TABLE HARCONVERSION (STARTTIME DATE NOT NULL);

-- record the current time in the table.
DECLARE
   tz char(3) := &TIMEZONE;
   os char(3) := &OFFSET;
   st date;
BEGIN
   st := new_time( sysdate - (os/24), tz, 'GMT' );
   INSERT INTO harconversion (starttime) VALUES (st);
END;
/

-- trigger to prevent the deletion of environments that were created before the start time
create or replace trigger prevent_del_env
before delete on harenvironment
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old environments may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of states that were created before the start time
create or replace trigger prevent_del_state
before delete on harstate
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old states may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of packages that were created before the start time
create or replace trigger prevent_del_pkg
before delete on harpackage
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old packages may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of package groups that were created before the start time
create or replace trigger prevent_del_pkggroup
before delete on HarPackageGroup
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old package groups may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of users that were created before the start time
create or replace trigger prevent_del_user
before delete on HarUser
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old users may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of user group that were created before the start time
create or replace trigger prevent_del_usergroup
before delete on HarUserGroup
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old user groups may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of view that were created before the start time
create or replace trigger prevent_del_view
before delete on HarView
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old views may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of repository that were created before the start time
create or replace trigger prevent_del_repository
before delete on HarRepository
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old repository may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of forms that were created before the start time
create or replace trigger prevent_del_form
before delete on harform
for each row
declare
   ct date;
   st date;
begin
    select starttime into st from harconversion;
    select execdtime into ct from harformhistory where formobjid=:old.formobjid;

    if (ct < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old forms may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the form typed to be touched
create or replace trigger prevent_del_formtype
before delete or update or insert on HarFormType
for each row
begin
    
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No form types may be updated during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));

end;
/

-- trigger to prevent the mods of pkg-form assocs of objects that were created before the start time
-- if the form is new or the package is new, associations may be added or deleted
-- if the form is old and the package is old, associations may NOT be added or deleted
create or replace trigger prevent_mod_assoc
before delete on harassocpkg
for each row
declare
   pct date;
   fct date;
   st date;
begin
    
    select creationtime into pct from harpackage     where packageobjid = :old.assocpkgid;
    select execdtime    into fct from harformhistory where formobjid = :old.formobjid and rtrim(action) = 'Created';    
    select starttime into st from harconversion;

    if (pct < st and fct < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No associations of old packages and forms may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/


-- trigger to prevent the deletion of approve processes that were created before the start time
create or replace trigger prevent_del_approve 
before delete on harApprove 
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old approve processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of checkin processes that were created before the start time
create or replace trigger prevent_del_checkin 
before delete on harCheckinProc 
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old checkin processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of checkout processes that were created before the start time
create or replace trigger prevent_del_checkout
before delete on harcheckoutproc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old checkout processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of concurrent merge processes that were created before the start time
create or replace trigger prevent_del_conmrg
before delete on HarConMrgProc 
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old concurrent merge processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of create package processes that were created before the start time
create or replace trigger prevent_del_crpkg
before delete on HarCrpkgProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old create package processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of cross env merge processes that were created before the start time
create or replace trigger prevent_del_crsenvmrg
before delete on HarCrsEnvMrgProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old cross environment merge processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of delete version processes that were created before the start time
create or replace trigger prevent_del_delvers
before delete on HarDelVersProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old delete version processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of demote processes that were created before the start time
create or replace trigger prevent_del_demote
before delete on HarDemoteProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old demote processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of interactive merge processes that were created before the start time
create or replace trigger prevent_del_intmrg
before delete on HarIntMrgProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old interactive merge processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/


-- trigger to prevent the deletion of list difference processes that were created before the start time
create or replace trigger prevent_del_listdiff
before delete on HarListDiffProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old list difference processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of list version processes that were created before the start time
create or replace trigger prevent_del_listvers
before delete on HarListVersProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old list version processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of move package processes that were created before the start time
create or replace trigger prevent_del_movepkg
before delete on HarMovePkgProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of notify processes that were created before the start time
create or replace trigger prevent_del_notify
before delete on HarNotify
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of promote processes that were created before the start time
create or replace trigger prevent_del_promote
before delete on HarPromoteProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of remove item processes that were created before the start time
create or replace trigger prevent_del_remitem
before delete on HarRemitemProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of snapshot view processes that were created before the start time
create or replace trigger prevent_del_snapview
before delete on HarSnapviewProc
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/


-- trigger to prevent the deletion of UDP processes that were created before the start time
create or replace trigger prevent_del_udp
before delete on harudp
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old UDP processes may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the modification of baselines of environments that were created before the start time
create or replace trigger prevent_mod_baseline
before insert or delete on harenvrepository
for each row
declare
   ct date;
   st date;
begin
    if inserting then
        select creationtime into ct from harenvironment where envobjid = :new.envobjid;
    else
        select creationtime into ct from harenvironment where envobjid = :old.envobjid;
    end if;
    select starttime    into st from harconversion;
    if (ct < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'Baselines of old environment may not be modified during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of item that were created before the start time
create or replace trigger prevent_del_item
before delete on HarItem
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old item may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of item path that were created before the start time
create or replace trigger prevent_del_itempath
before delete on HarItemPath
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old item path may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the deletion of version that were created before the start time
create or replace trigger prevent_del_version
before delete on HarVersion
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st and :old.versionstatus != 'R' ) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old version may be deleted during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the chane the user_list usage of environment that were created before the start time
CREATE TRIGGER prevent_update_userlistusage BEFORE UPDATE
  ON harenvironment FOR EACH ROW
  BEGIN
    IF (:old.envuserlist != :new.envuserlist ) THEN
       
	  RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'UserList usage can not be changed during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
       
    END IF;
  END;
/

-- trigger to prevent the rename of item that were created before the start time
create or replace trigger prevent_rename_item
before update on HarItem
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old item may be updated during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the rename of itempath that were created before the start time
create or replace trigger prevent_rename_itempath
before update on HarItempath
for each row
declare
   st date;
begin
    select starttime into st from harconversion;
    if (:old.creationtime < st) then
        RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No old item path may be updated during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
    end if;
end;
/

-- trigger to prevent the creation of user group 
create or replace trigger prevent_create_usergroup
before insert on HarUserGroup
for each row
begin
    RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No User Group can be created during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
end;
/

-- trigger to prevent the harFileExtension modification 
create or replace trigger prevent_mod_fileExtension
before insert or update or delete on HarFileExtension
for each row
begin
    RAISE_APPLICATION_ERROR (-20031,
            chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10)|| 
            'No File Extension table can be created during 4.x to 5.x conversion'
            ||chr(10)||chr(10)||
            '********************************************************************'
            ||chr(10)||chr(10));
end;
/

-- Add new index for 2nd pass
DROP INDEX HARVERSION_IND2;

CREATE INDEX HARVERSION_IND2
     ON HARVERSION
        (ITEMOBJID,
         PACKAGEOBJID,
         CREATIONTIME)
    LOGGING
    INITRANS 2
    MAXTRANS 255;


commit;

EXIT;


