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
/* Star 14835448 DSM: URC Needs to store host info with info about active sessions      */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from urc_active_session with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */


/* ******************** 9951 begin ************************* */

alter table urc_active_session
	add  host_uuid char(36)  /* same collation as ca_discovered_hardware.host_uuid */
						collate !!sensitive NULL
GO

/* ******************** 9951 end ************************* */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14835448, getdate(), 1, 4, 'Star 14835448 DSM: URC Needs to store host info with info about active sessions' )
GO

COMMIT TRANSACTION 
GO

