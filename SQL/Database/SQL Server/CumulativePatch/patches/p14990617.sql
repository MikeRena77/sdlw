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
/* Star 14990617 DAS: Remove un-needed entries in das_policyparms and das_policy tables	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from das_policyparms with (tablockx)
GO
 
Select top 1 1 from das_policy with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_DEF_BUF_CACHE_SELECT'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_DEF_BUF_CACHE_SEVERITY'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_DEF_BUF_CACHE_MIN'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_DEF_BUF_CACHE_TAR'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_DEF_BUF_CACHE_MAX'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_SHARED_POOL_SELECT'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_SHARED_POOL_SEVERITY'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_SHARED_POOL_MIN'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_SHARED_POOL_MAX'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_SHARED_POOL_TAR'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_LARGE_SGA_POOL_SELECT'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_LARGE_SGA_POOL_SEVERITY'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_LARGE_SGA_POOL_MIN'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_LARGE_SGA_POOL_TAR'
go
delete from das_policyparms where policyid=100 and policykey  = 'DBRM_RESOURCEOPT_LARGE_SGA_POOL_MAX'
go

delete from das_policy where policyid=100 and policyname = 'DBRM_RESOURCEOPT_POLICY1'
go

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                                     	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14990617, getdate(), 1, 4, 'DAS: Remove un-needed entries in das_policyparms and das_policy tables' )
GO

COMMIT TRANSACTION 
GO

