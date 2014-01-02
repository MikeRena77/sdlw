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
/* Star 14835457 DSM: Better info about installed patches & installed status of VW  		*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_directory_details with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */


/* ********************** 10113 begin ******************* */

grant select on mdb_patch to ca_itrm_group
go
grant select on mdb_checkpoint to ca_itrm_group
go
grant select on mdb_service_pack to ca_itrm_group
go

/* ********************** 10113 end   ******************* */

/* ******************** 10458 begin ************************* */
/*
dir_authorities 				List of mapped authorities 
		example: democorp,tant-a01 
 
dir_macros 						customised macros definitions 
 		example: $HOSTNAME=^.+://(.[^/]*)/.+,$SCHEMA$=^(.+)://.*
 
dir_user_search_filter 			customised user search filter 
		example: (&(objectClass=$USER_MAP$)(!(objectClass=$COMPUTER_MAP$))(userCN=$ACCOUNTNAME$))
 
dir_hardware_search_filter 		Custom computer search filter
		example: (&(objectClass=$COMPUTER_MAP$)(sAMAccountName=$ACCOUNTNAME$$))
*/
 

alter table ca_directory_details
	add  [dir_authorities] [nvarchar] (1024) null,
		[dir_user_search_filter] [nvarchar] (1024) null,
		[dir_hardware_search_filter] [nvarchar] (1024) null,
		[dir_macros] [nvarchar] (1024) null
 
GO

/* ******************** 10458 end ************************* */

/* ********************** 10541 begin ******************* */

grant select on tng_class_ext to ca_itrm_group
GO

/* ********************** 10541 end   ******************* */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14835457, getdate(), 1, 4, 'Star 14835457 DSM: Better info about installed patches & installed status of VW' )
GO

COMMIT TRANSACTION 
GO

