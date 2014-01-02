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
/* Star 15373649 : BABLD: MGUI: backup status for CLI CRE				*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */

select top 1 1 from backup_policy with (tablockx)
GO

select top 1 1 from backup_backed_up_file_revision with (tablockx)
GO

Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

/* ================================================================ */
/* Issue: 15013350    Title: MGUI:BACKUP STATUS FOR CLI CRE			    */
/* ================================================================ */
/*
 *********************************************
 trigger for insert backup_user is part of MDB and has to be dropped
*/
drop trigger rule_set_agent_backup_status 
GO

/*
 *********************************************
 trigger for update backup_user has to be re-created
*/
create trigger rule_set_agent_backup_status
	on backup_user
	after update
	
	as
	begin


	
		if update(last_login_date)
		begin

			declare @_last_login_date_old integer,
					@_last_login_date_new integer;
			select @_last_login_date_old = (select last_login_date from deleted);
			select @_last_login_date_new = (select last_login_date from inserted);

			if	(@_last_login_date_old = 0) and	(@_last_login_date_new > 0)	
			begin
				declare @_user_uuid binary(16),
						@_dis_hw_uuid binary(16),
						@_link_dis_hw_user_uuid binary(16);
		   
				select @_user_uuid = (select user_uuid from inserted);
				select @_dis_hw_uuid = (select dis_hw_uuid from inserted);
				select @_link_dis_hw_user_uuid = (select link_dis_hw_user_uuid from inserted);

				execute backup_p_set_agent_backup_status @_user_uuid, @_dis_hw_uuid, @_link_dis_hw_user_uuid;
			end;	
		end;	
	end;
GO


/* ================================================ */
/* Enhancement for time based retention policy		*/
/* ================================================ */

ALTER table backup_policy add file_retention_time integer not null default 0;

ALTER table backup_policy add file_rev_retention_time integer not null default 0;
GO


/* ================================================================ */
/* Performance improvement for reading backup folder names 		    */
/* ================================================================ */

/*
 Change existing table backup_backed_up_file_revision
*/
DROP INDEX backup_backed_up_file_revision.xif1backup_backed_up_file_revisi;
GO
alter table backup_backed_up_file_revision add backed_up_folder_id varbinary(16) null;
GO
CREATE INDEX xif1backup_backed_up_file_revisi ON backup_backed_up_file_revision
(
       user_id 		         ASC,
       backup_run_date		 ASC,
       backed_up_file_id	 ASC,
       backed_up_folder_id	 ASC	
);
GO

/* 
 Change existing table backup_backed_up_file
*/
DROP INDEX backup_backed_up_file.xif1backup_backed_up_file;
GO
CREATE INDEX xif1backup_backed_up_file ON backup_backed_up_file
(
       backed_up_folder_id	 ASC,
       backed_up_file_id	 ASC
);
GO

/* 
 Change existing table backup_backed_up_folder
*/
CREATE INDEX xif1backup_backed_up_folder ON backup_backed_up_folder
(
       name			 ASC,
       backed_up_folder_id	 ASC
);
GO


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15373649, getdate(), 1, 4, 'Star 15373649 : BABLD: MGUI: backup status for CLI CRE' )
GO

COMMIT TRANSACTION 
GO

