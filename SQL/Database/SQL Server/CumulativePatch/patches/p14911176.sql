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
/* Patch Star 14911176 Autosys: ujo_get_machine stored procedure update                 */
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

if exists (select * from sysobjects where name = 'ujo_get_machine' and type = 'P')
begin
	drop procedure ujo_get_machine
end
go

create procedure ujo_get_machine
 @machine_name varchar(80)

as
	declare @machine_type char(1)

	if @machine_name = 'ALL'
		select distinct name, parent_name, que_name, type, factor, max_load, mstatus
		from ujo_machine 
	else
	begin
		if exists (select name from ujo_machine where name = @machine_name)
			select name, parent_name, que_name, type, factor, max_load, mstatus
			from ujo_machine where 
			name = @machine_name or 
			parent_name = @machine_name or 
			que_name = @machine_name
		--else
		--	print 'machine is not defined to AutoSys' 
	end
return -999 /*SUCCESS*/
go

grant execute on ujo_get_machine to ujoadmin
go
/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14911176, getdate(), 1, 4, 'Patch Star 14911176 Autosys: ujo_get_machine stored procedure update' )
GO

COMMIT TRANSACTION 
GO


