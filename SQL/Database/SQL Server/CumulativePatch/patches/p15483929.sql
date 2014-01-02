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
/* Star 15483929 : BABLD: ENG_BACKUP status and N-WIN-USR				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO
 
Select top 1 1 from backup_user with (tablockx)
GO
 
Select top 1 1 from backup_backed_up_file with (tablockx)
GO
 
Select top 1 1 from backup_backed_up_folder with (tablockx)
GO
 
/* Start of locks for dependent tables */

Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO


/*
 ***********************************************************
 Issue: 15458839    Title: ENG_BACKUP STATUS IS WRONG
 ***********************************************************
*/
ALTER  trigger [dbo].[rule_set_agent_backup_status]
	on [dbo].[backup_user]
	after insert, update
	
	as
	begin

		declare @_user_uuid binary(16),
			@_dis_hw_uuid binary(16),
			@_link_dis_hw_user_uuid binary(16);
		   
		select @_user_uuid = (select user_uuid from inserted);
		select @_dis_hw_uuid = (select dis_hw_uuid from inserted);
		select @_link_dis_hw_user_uuid = (select link_dis_hw_user_uuid from inserted);

		declare @_last_login_date_new integer;
		select @_last_login_date_new = (select last_login_date from inserted);

		if	(@_last_login_date_new > 0)	
		begin
			execute backup_p_set_agent_backup_status @_user_uuid, @_dis_hw_uuid, @_link_dis_hw_user_uuid;
		end;
	end;

GO


ALTER procedure  [dbo].[backup_p_set_backup_status] 
	@_object_uuid binary(16)
	as
	begin

		declare @_agentCnt integer;
 		select @_agentCnt = (select count(*) from backup_user
	 					where (user_uuid = @_object_uuid or
							dis_hw_uuid = @_object_uuid or
							link_dis_hw_user_uuid = @_object_uuid) and
							(last_login_date > 0));
 		if (@_agentCnt > 0)
		begin 
			update ca_agent set derived_status_babld = 1
				where object_uuid = @_object_uuid;
		end;
	
	end;

GO




/*
 ***********************************************************
 Issue: 15467633    Title: N-WIN-USR:LONG NAME&PWD FAIL
 ***********************************************************
*/
ALTER table [dbo].[backup_user] alter column name nvarchar(255) null;
GO
ALTER table [dbo].[backup_user] alter column password nvarchar(255) collate !!sensitive null;
GO


/*
 ***********************************************************
 Issue: 15483727    Title: CAN NOT BKUP LONG JAP FILE
 ***********************************************************
*/
ALTER table [dbo].[backup_backed_up_file] alter column name nvarchar(1024) null;
GO
ALTER table [dbo].[backup_backed_up_folder] alter column name nvarchar(1024) null;
GO



SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO




/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15483929, getdate(), 1, 4, 'Star 15483929 : BABLD: ENG_BACKUP status and N-WIN-USR' )
GO

COMMIT TRANSACTION 
GO

