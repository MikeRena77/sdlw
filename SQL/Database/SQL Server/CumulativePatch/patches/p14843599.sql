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
/* Star 14843599 DSM: Change rules/procedure/trigger in usd_proc_u_tbl_ver to avoid deadlocks	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ********************** 10022 begin ************************** */
/* performance relevant changes */

ALTER  procedure usd_proc_u_tbl_ver @tbl_no integer, @grp_type integer, @mem_type integer, @comp_id integer
as
begin
    if(@tbl_no = 0)
    begin
        if((@mem_type = 1 or @mem_type = 4) and (@comp_id = 40 or @comp_id = 46))
	begin
            /* Increase the USD table version for target */
            update usd_class_version set modify_version = modify_version + 1 where name = 'target'
	end
    end
    else if (@tbl_no = 1)
    begin
        if(@grp_type = 1) 
	begin
            /* Increase the USD table version for asset_grp */
            update usd_class_version set modify_version = modify_version + 1 where name = 'asset_grp'
	end
        if(@grp_type = 4) 
	begin
            /* Increase the USD table version for lsg */
            update usd_class_version set modify_version = modify_version + 1 where name = 'lsg'
	end
        if(@grp_type = 7) 
	begin
            /* Increase the USD table version for server_grp */
            update usd_class_version set modify_version = modify_version + 1 where name = 'server_grp'
	end
    end
    else if (@tbl_no = 2) 
    begin
        /* Increase the USD table version for csite, ls, ownsite */
        update usd_class_version set modify_version = modify_version + 1 where name = 'csite'
        update usd_class_version set modify_version = modify_version + 1 where name = 'ls'
        update usd_class_version set modify_version = modify_version + 1 where name = 'ownsite'
    end
    else if (@tbl_no = 3) 
    begin
        if(@mem_type = 0) 
	begin
            /* Increase the USD table version for asset_grp, lsg, server_grp */
            update usd_class_version set modify_version = modify_version + 1 where name = 'asset_grp'
            update usd_class_version set modify_version = modify_version + 1 where name = 'lsg'
            update usd_class_version set modify_version = modify_version + 1 where name = 'server_grp'
	end
        if(@mem_type = 1 or @mem_type = 4 or @mem_type = 7) 
	begin
            /* Increase the USD table version for ls */
            update usd_class_version set modify_version = modify_version + 1 where name = 'target'
	end
        if(@mem_type = 5) 
	begin
            /* Increase the USD table version for ls */
            update usd_class_version set modify_version = modify_version + 1 where name = 'ls'
	end
    end
end
go

ALTER  trigger usd_trg_d_ca_agent_tbl_ver 
on ca_agent
for delete as
declare
	@agent_type int
begin
	set @agent_type = (select top 1 agent_type from inserted)
	exec usd_proc_u_tbl_ver 0, -1, @agent_type, 40
end
go

ALTER  trigger usd_trg_u_ca_agent_tbl_ver 
on ca_agent
for update as
declare
	@agent_type int
begin
    if update(creation_user) or update(agent_name) or update(ip_address) or update(creation_date) or update(last_run_date) or update(registration_type) or update(agent_type) or update(proc_os_id) or update(description) or update(prev_manager) or update(agent_ref_count)
    begin
	set @agent_type = (select top 1 agent_type from inserted)
        exec usd_proc_u_tbl_ver 0, -1, @agent_type, 40
    end
end
go
/* ********************** 10022 end ************************** */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14843599, getdate(), 1, 4, 'Star 14843599 DSM: Change rules/procedure/trigger in usd_proc_u_tbl_ver to avoid deadlocks' )
GO

COMMIT TRANSACTION 
GO

