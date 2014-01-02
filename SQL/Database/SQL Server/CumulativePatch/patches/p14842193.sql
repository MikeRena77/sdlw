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
/* Star 14842193 Autosys: Remove tables and procedures no longer used                   */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select * from sysobjects where name = 'ujo_charcodes' and type = 'U')
begin
	drop table ujo_charcodes
end
go

if exists (select * from sysobjects where name = 'ujo_machine_group' and type = 'U')
begin
	drop table ujo_machine_group
end
go

if exists (select * from sysobjects where name = 'ujo_tmp_status' and type = 'U')
begin
	drop table ujo_tmp_status
end
go

if exists (select * from sysobjects where name = 'ujo_box_status' and type = 'P')
begin
	drop procedure ujo_box_status
end
go

if exists (select * from sysobjects where name = 'ujo_external_dependency' and type = 'P')
begin
	drop procedure ujo_external_dependency
end
go

if exists (select * from sysobjects where name = 'ujo_get_event' and type = 'P')
begin
	drop procedure ujo_get_event
end
go

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14842193, getdate(), 1, 4, 'Star 14842193 Autosys: Remove tables and procedures no longer used' )
GO

COMMIT TRANSACTION 
GO

