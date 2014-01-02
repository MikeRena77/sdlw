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
/* Star 14875635 DSM: New trigger/rule/ usd_proc_d_agent_comp_usd_rel procedure       	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ********************** 10622 begin  ******************* */
create trigger usd_trg_d_agent_comp_usd_rel
on ca_agent_component
for delete as
declare
    @counted int
begin
    -- Does the agent exist?
    set @counted = (select count (*)
    from ca_agent where object_uuid in (select object_uuid from deleted))
    if(@counted = 0)
    begin
	-- It doesn't then just allow this as we are about to remove the whole computer
        return
    end

    set @counted = (select count(*)
    from deleted d, usd_applic app, usd_activity act
    where app.target = d.object_uuid 
    and app.activity = act.objectid
    and (d.agent_comp_id = 40 or d.agent_comp_id = 46))
    if(@counted > 0)
    begin
        rollback transaction
        raiserror('Error 9018: Cannot remove the USD agent component because of Software Delivery jobs', 16, 1 )
	return
    end

    -- else update class version
    update usd_class_version set modify_version = modify_version + 1 where name = 'target'
end
go

/* ********************** 10622 end  ******************* */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14875635, getdate(), 1, 4, 'Star 14875635 DSM: New trigger/rule/ usd_proc_d_agent_comp_usd_rel procedure' )
GO

COMMIT TRANSACTION 
GO

