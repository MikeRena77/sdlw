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
/* Star 15505796 GRANTS FOR HARUDP					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
/* End of lines added to convert to online lock */

grant select,update,insert,delete on harusdcomputernames to harvest_group
GO

grant select,update,insert,delete on harusddeployinfo to harvest_group
GO

grant select,update,insert,delete on harusdgroupnames to harvest_group
GO

grant select,update,insert,delete on harusdhistory to harvest_group
GO

grant select,update,insert,delete on harusdpackageinfo to harvest_group
GO

grant select,update,insert,delete on harusdpackagenames to harvest_group
GO

grant select,update,insert,delete on harusdplatforminfo to harvest_group
GO

grant select,update,insert,delete on haruserdata to harvest_group
GO

grant select,update,insert,delete on harusergroup to harvest_group
GO

grant select,update,insert,delete on harudp to harvest_group
GO


grant select on harusdcomputernames to harvest_rep
GO

grant select on harusddeployinfo to harvest_rep
GO

grant select on harusdgroupnames to harvest_rep
GO

grant select on harusdhistory to harvest_rep
GO

grant select on harusdpackageinfo to harvest_rep
GO

grant select on harusdpackagenames to harvest_rep
GO

grant select on harusdplatforminfo to harvest_rep
GO

grant select on haruserdata to harvest_rep
GO

grant select on harusergroup to harvest_rep
GO

grant select on harudp to harvest_rep
GO

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15505796, getdate(), 1, 4, 'Star 15505796 GRANTS FOR HARUDP' )
GO

COMMIT TRANSACTION 
GO
