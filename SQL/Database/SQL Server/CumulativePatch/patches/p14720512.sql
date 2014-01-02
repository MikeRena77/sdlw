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
/* Patch Star 14720512 DAS: Remove un-needed insert statements                          */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from das_anlyarglist with (tablockx)
GO
 
Select top 1 1 from das_anlydef with (tablockx)
GO
 
Select top 1 1 from das_anlyplugin with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* modify objects...  */

delete from das_anlyarglist where pluginid = 1 and argnumber = 1 and anlydefid = 100 and argstringvalue = '%C(REPOSITORY_HANDLE)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 2 and anlydefid = 100 and argstringvalue = '%C(INSTANCE_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 3 and anlydefid = 100 and argstringvalue = '%C(ANALYSIS_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 4 and anlydefid = 100 and argstringvalue = '%C(PLUGIN_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 5 and anlydefid = 100 and argstringvalue = '%C(JOB_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 6 and anlydefid = 100 and argstringvalue = '%C(RUN_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 7 and anlydefid = 100 and argstringvalue = '%C(CATEGORY)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 8 and anlydefid = 100 and argstringvalue = '%E(ORACLE_HOME)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 1 and anlydefid = 101 and argstringvalue = '%C(REPOSITORY_HANDLE)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 2 and anlydefid = 101 and argstringvalue = '%C(INSTANCE_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 3 and anlydefid = 101 and argstringvalue = '%C(ANALYSIS_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 4 and anlydefid = 101 and argstringvalue = '%C(PLUGIN_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 5 and anlydefid = 101 and argstringvalue = '%C(JOB_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 6 and anlydefid = 101 and argstringvalue = '%C(RUN_ID)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 7 and anlydefid = 101 and argstringvalue = '%C(CATEGORY)';
go
delete from das_anlyarglist where pluginid = 1 and argnumber = 8 and anlydefid = 101 and argstringvalue = '%E(ORACLE_HOME)';
go
 
delete from das_anlydef where anlydefid = 100 and productcode = 'DBRM' and category = 'DBRM_RESOURCEOPT';
go
delete from das_anlydef where anlydefid = 101 and productcode = 'DBRM' and category = 'DBRM_RESOURCEOPT';
go
 
delete from das_anlyplugin where pluginname = 'DBRM_RESOPT_ANLY' and libname = 'libdbrmanal' and entrypoint='dbrm_anal_RESOPT';
go
delete from das_anlyplugin where pluginname = 'DBRM_INSTCONS_ANLY' and libname = 'libdbrmanal' and entrypoint='dbrm_anal_instconsolidation';								
go

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14720512, getdate(), 1, 4, 'Star 14720512 DAS: Remove un-needed insert statements ' )
GO

COMMIT TRANSACTION 
GO


