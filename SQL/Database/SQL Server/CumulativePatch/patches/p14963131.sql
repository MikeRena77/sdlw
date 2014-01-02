SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET XACT_ABORT ON
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
BEGIN TRANSACTION 
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 14963131 UPM: Triggers r_ssf_versionupdate_def, r_ssf_versionupdate_link for ca_software_def table */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ************** 10970 begin ************************************* */

create trigger r_ssf_versionupdate_def
on ca_software_def
after update,insert
as
begin
execute p_sp_ssf_versionupdate
end
GO

create trigger r_ssf_versionupdate_link
on ca_link_sw_def
after update,insert
as
begin
execute p_sp_ssf_versionupdate
end
GO

/* ************** 10970 end ************************************* */


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14963131, getdate(), 1, 4, 'Star 14963131 UPM: Triggers r_ssf_versionupdate_def, r_ssf_versionupdate_link for ca_software_def table' )
GO

COMMIT TRANSACTION 
GO

