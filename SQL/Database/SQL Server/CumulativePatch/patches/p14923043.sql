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
/* Star 14923043 Brightstor: BABLD Changes: Manager administration, User authentication, Server enhancements, DARs and CES */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from backup_schedule with (tablockx)
GO
 
Select top 1 1 from backup_msg_log with (tablockx)
GO
 
Select top 1 1 from backup_msg_log_config with (tablockx)
GO
 
Select top 1 1 from backup_policy with (tablockx)
GO
 
Select top 1 1 from backup_user with (tablockx)
GO
 
Select top 1 1 from backup_login_history with (tablockx)
GO
 
Select top 1 1 from backup_statistic with (tablockx)
GO
 
Select top 1 1 from backup_backed_up_file_revision with (tablockx)
GO
 
Select top 1 1 from backup_backed_up_file with (tablockx)
GO
 
Select top 1 1 from backup_job with (tablockx)
GO
 
Select top 1 1 from backup_server with (tablockx)
GO
 
Select top 1 1 from backup_server_config with (tablockx)
GO
 
Select top 1 1 from backup_agent_config with (tablockx)
GO
 
Select top 1 1 from backup_set_include_exclude with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ================================================================ */
/* Change existing table backup_schedule			    */
/* ================================================================ */

alter table backup_schedule add retry_times integer null;

alter table backup_schedule add retry_interval integer null;

go

/* ================================================================ */
/* Change existing table backup_msg_log				    */
/* ================================================================ */

alter table backup_msg_log add creation_date_m_seconds integer null;


drop index backup_msg_log.xif1backup_msg_log;
alter table backup_msg_log drop constraint XPKbackup_msg_log;

alter table backup_msg_log alter column server_id binary(16) null;
alter table backup_msg_log add manager_id binary(16) null;

ALTER TABLE backup_msg_log ADD 
CONSTRAINT XPKbackup_msg_log PRIMARY KEY  CLUSTERED 
	(
		msg_log_id		ASC
	)  ON [PRIMARY];


create index xif1backup_msg_log on backup_msg_log
(
	server_id		ASC
);
CREATE INDEX xif3backup_msg_log ON backup_msg_log
(
       manager_id               ASC
);


go

/* ================================================================ */
/* Change existing table backup_msg_log_config			    */
/* ================================================================ */

alter table backup_msg_log_config add email_def_id binary(16) null;

CREATE INDEX XIF1backup_msg_log_config ON backup_msg_log_config
(
       email_def_id               ASC
);

alter table backup_msg_log_config add smtp_user_id nvarchar(255) collate !!sensitive null;
alter table backup_msg_log_config add smtp_password nvarchar(255) collate !!sensitive null; 
alter table backup_msg_log_config add smtp_need_authentic integer null;		

go

/* ================================================================ */
/* Change existing table backup_policy				    */
/* ================================================================ */

alter table backup_policy add quota integer null;

alter table backup_policy add postpone_backup integer null;

alter table backup_policy add merge_backup_set integer null;

go

/* ================================================================ */
/* Change existing table backup_user				    */
/* ================================================================ */

drop index backup_user.xif8backup_user;

alter table backup_user alter column archive_id varbinary(16) null;

create index xif8backup_user on backup_user
(
	archive_id			ASC
)
;
 
alter table backup_user alter column storage_area_id varbinary(4) null;
 	

alter table backup_user add label nvarchar(255) collate !!sensitive null;

alter table backup_user add use_eiam_account char(1) collate !!sensitive null;

alter table backup_user add quota integer null;

alter table backup_user add use_quota char(1) collate !!sensitive null;

alter table backup_user add has_migrated_files char(1) collate !!sensitive null;
go

/* ================================================================ */
/* Change existing table backup_login_history			    */
/* ================================================================ */

alter table backup_login_history add binarys_read_high integer null;

alter table backup_login_history add binarys_wrote_high integer null;

go

/* ================================================================ */
/* Change existing table backup_statistic			    */
/* ================================================================ */

alter table backup_statistic add package_size_high integer null;

alter table backup_statistic add total_files_size_high integer null;

go

/* ================================================================ */
/* Change existing table backup_backed_up_file_revision		    */
/* ================================================================ */

alter table backup_backed_up_file_revision add file_size_high integer null;

alter table backup_backed_up_file_revision add compressed_size_high integer null;

go

/* ================================================================ */
/* Change existing table backup_backed_up_file			    */
/* ================================================================ */

alter table backup_backed_up_file add original_cdb_file_name nvarchar(520) collate !!sensitive null;

alter table backup_backed_up_file add original_cdb_file_size integer null;

alter table backup_backed_up_file add original_cdb_file_size_high integer null;

alter table backup_backed_up_file add session_id integer null;

alter table backup_backed_up_file add tape_name nvarchar(32) collate !!sensitive null;

alter table backup_backed_up_file add tape_id integer null;

alter table backup_backed_up_file add sequence_id integer null;

alter table backup_backed_up_file add migration_date integer null;

alter table backup_backed_up_file add remigration_submission_date integer null;

alter table backup_backed_up_file add remigration_job_counter integer null;

go

/* ================================================================ */
/* Change existing table backup_job								    */
/* ================================================================ */

alter table backup_job add creation_date_m_seconds integer null;

go

/* ================================================================ */
/* Create new table backup_manager				    */
/* ================================================================ */


CREATE TABLE backup_manager (
       manager_id					binary(16) not null,
	domain_uuid					binary(16) null,
	   msg_log_config_id			binary varying(16) null,
	network_address				nvarchar(76) collate !!sensitive null,
       use_job_max_store_days		char(1) collate !!sensitive null,
       job_max_store_days			integer null,
       use_job_max_store_numbers	char(1) collate !!sensitive null,
       job_max_store_numbers		integer null,
       job_delete					char(1) collate !!sensitive null,
	   creation_user				nvarchar(255) collate !!sensitive null,
	   creation_date				integer null,
	   last_update_user				nvarchar(255) collate !!sensitive null,
	   last_update_date				integer null,
	   version_number				integer null,
	   job_last_seq_number			integer null,
	   job_max_seq_number			integer null
	   );

ALTER TABLE backup_manager ADD 
CONSTRAINT XPKbackup_manager PRIMARY KEY  CLUSTERED 
	(
		manager_id		ASC
	)  ON [PRIMARY];

 
CREATE INDEX xif1backup_manager ON backup_manager
(
       msg_log_config_id                 ASC
);
   	
go

/* ================================================================ */
/* Create new table backup_email_def				    */
/* ================================================================ */


CREATE TABLE backup_email_def (
       email_def_id         binary(16) not null,
       name				nvarchar(255) collate !!sensitive null,
       address_list			nvarchar(512) collate !!sensitive null,
       cc_list				nvarchar(512) collate !!sensitive null,
       subject				nvarchar(512) collate !!sensitive null,
       content				nvarchar(1024) collate !!sensitive null,
       signature			nvarchar(255) collate !!sensitive null,
       is_plain_text		integer null,
       creation_user		nvarchar(255) collate !!sensitive null,
	   creation_date		integer null,
	   last_update_user		nvarchar(255) collate !!sensitive null,
	   last_update_date		integer null,
	   version_number		integer null
	   );

ALTER TABLE backup_email_def ADD 
CONSTRAINT XPKbackup_email_def PRIMARY KEY  CLUSTERED 
	(
		email_def_id		ASC
	)  ON [PRIMARY];

   	
go

/* ================================================================ */
/* Create new table backup_query_based_policy			    */
/* ================================================================ */


CREATE TABLE backup_query_based_policy (
       query_based_policy_id    binary(16) not null,
       query_uuid				binary(16) null,
       name						nvarchar(255) collate !!sensitive null,
       email_def_id				binary(16) null,
       launch_application		nvarchar(1024) collate !!sensitive null,
       check_server				integer null,
       activate_user			integer null,
       protect_user				integer null,
       evaluate_type			integer null,
       last_evaluate_time			integer null,
       evaluate_interval			integer null,
       backup_now				integer null,
       creation_user			nvarchar(255) collate !!sensitive null,
	   creation_date			integer null,
	   last_update_user			nvarchar(255) collate !!sensitive null,
	   last_update_date			integer null,
	   version_number			integer null
	   );

ALTER TABLE backup_query_based_policy ADD 
CONSTRAINT XPKbackup_query_based_policy PRIMARY KEY  CLUSTERED 
	(
		query_based_policy_id		ASC
	)  ON [PRIMARY];


   	
CREATE INDEX xif1backup_query_based_policy ON backup_query_based_policy
(
       query_uuid                 ASC
);
 
CREATE INDEX xif2backup_query_based_policy ON backup_query_based_policy
(
       email_def_id                 ASC
);
 
go

/* ================================================================ */
/* Create new table backup_job_member				    */
/* ================================================================ */
CREATE TABLE backup_job_member (
       member_id			binary(16) not null,
       job_id				binary(16) not null,
       member_type			char(1) collate !!sensitive null,
       exit_code			integer null,
       status				integer null,
       status_description	nvarchar(1024) collate !!sensitive null,
       job_content			nvarchar(1024) collate !!sensitive null,
       creation_user		nvarchar(255) collate !!sensitive null,
	   creation_date		integer null,
	   last_update_user		nvarchar(255) collate !!sensitive null,
	   last_update_date		integer null,
	   version_number		integer null
	   );


ALTER TABLE backup_job_member ADD 
CONSTRAINT XPKbackup_job_member PRIMARY KEY  CLUSTERED 
	(
		member_id		ASC,
		job_id			ASC
	)  ON [PRIMARY];



   	
CREATE INDEX xif1backup_job_member ON backup_job_member
(
       job_id                 ASC
);

CREATE INDEX xif2backup_job_member ON backup_job_member
(
       member_id                 ASC
);

go 

/* ================================================================ */
/* Change existing table backup_server				    */
/* ================================================================ */


drop index backup_server.xif5backup_server;

alter table backup_server alter column server_config_id binary(16) null;

create index xif5backup_server on backup_server
(
	server_config_id			ASC
);
  	

alter table backup_server add parent_server_id binary(16) null;

create index xif3backup_server on backup_server
(
	parent_server_id			ASC
);
   	

alter table backup_server add is_remote integer null;

alter table backup_server add last_update_server_date integer null;


alter table backup_server add manager_id binary(16) null;

create index xif1backup_server on backup_server
(
	manager_id			ASC
);

go

/* ================================================================ */
/* Change existing table backup_server_config			    */
/* ================================================================ */

alter table backup_server_config add data_growth_id binary varying(16) null;

create index xif2backup_server_config on backup_server_config
(
	data_growth_id			ASC
);

/*   
alter table backup_server_config add msg_log_config_id binary varying(16) null;
*/
create index xif3backup_server_config on backup_server_config
(
	msg_log_config_id			ASC
);

go

/* ================================================================ */
/* Change existing table backup_agent_config			    */
/* ================================================================ */

alter table backup_agent_config add msg_log_config_id binary varying(16) null;

create index xif2backup_agent_config on backup_agent_config
(
	msg_log_config_id			ASC
);
   

alter table backup_agent_config add start_port integer null;

alter table backup_agent_config add end_port integer null;

go



/* =========================================================================== */
/* procedure to set last sequential number for jobs in backup_server table     */
/* =========================================================================== */

create procedure  backup_p_job_seq_number
	@_server_id binary(16) 
as 
begin
	declare @_last_seq_number integer;
	declare @_max_seq_number integer;
	declare @_manager_id binary(16);
	
	select @_last_seq_number = 
		(select bmgr.job_last_seq_number
			 from	backup_server bsrv,
				backup_manager bmgr 
			 where	((bsrv.server_id = @_server_id) and
				 (bsrv.manager_id = bmgr.manager_id)));

	select @_max_seq_number = 
		(select bmgr.job_max_seq_number
			 from	backup_server bsrv,
				backup_manager bmgr 
			 where	((bsrv.server_id = @_server_id) and
				 (bsrv.manager_id = bmgr.manager_id)));
 
	select @_manager_id = 
		(select manager_id
			 from	backup_server  
			 where	(server_id = @_server_id));

	if ((@_max_seq_number = 0) or 
		(@_last_seq_number < @_max_seq_number)) 
		begin 
			set @_last_seq_number = @_last_seq_number + 1;
		end;	
	else 
		begin
			set @_last_seq_number = 0;
		end;	
	  
	update backup_manager
  		set job_last_seq_number = @_last_seq_number
  		where manager_id = @_manager_id;
end;
go

grant execute on [dbo].[backup_p_job_seq_number] to [ca_itrm_group]
grant execute on [dbo].[backup_p_job_seq_number] to [backup_admin_group]
grant execute on [dbo].[backup_p_job_seq_number] to [dms_backup_group]
go

/*
 *********************************************
 trigger for inserting backup_job entry
*/

create trigger backup_r_insert_job
			on backup_job
            after insert
	as
    begin
		declare @_server_id binary(16);
		select	@_server_id = (select server_id from inserted);

		execute backup_p_job_seq_number @_server_id;
	end;
go

/*
*******************************************************************************
grant access to new backup tables
*/

grant select,insert,update,delete on backup_manager		to ca_itrm_group
grant select,insert,update,delete on backup_email_def		to ca_itrm_group
grant select,insert,update,delete on backup_query_based_policy	to ca_itrm_group
grant select,insert,update,delete on backup_job_member		to ca_itrm_group

grant select,insert,update,delete on backup_manager		to backup_admin_group, dms_backup_group
grant select,insert,update,delete on backup_email_def		to backup_admin_group, dms_backup_group
grant select,insert,update,delete on backup_query_based_policy	to backup_admin_group, dms_backup_group
grant select,insert,update,delete on backup_job_member		to backup_admin_group, dms_backup_group

go

/* ================================================================ */
/* New changes after change request	(part 2)					    */
/* ================================================================ */

/* ================================================================ */
/* Change existing table backup_server_config					    */
/* ================================================================ */

alter table backup_server_config add rmi_server_port integer null;

go

/* ================================================================ */
/* star issue fix 15043083							    */
/* ================================================================ */


alter table backup_server_config alter column name nvarchar(255) collate !!insensitive null;
alter table backup_agent_config alter column name nvarchar(255) collate !!insensitive null;
alter table backup_policy alter column name nvarchar(255) collate !!insensitive null;
alter table backup_set alter column name nvarchar(255) collate !!insensitive null;
alter table backup_query_based_policy alter column name nvarchar(255) collate !!insensitive null;

go


/* ================================================================ */
/* Change existing table backup_set_include_exclude				    */
/* ================================================================ */

alter table backup_set_include_exclude alter column folder nvarchar(255) collate !!insensitive null;
alter table backup_set_include_exclude alter column startin nvarchar(255) collate !!insensitive null;
alter table backup_set_include_exclude alter column file_name nvarchar(255) collate !!insensitive null;
alter table backup_set_include_exclude alter column extension nvarchar(30) collate !!insensitive null;

go


/* ================================================================ */
/* Change existing table backup_msg_log							    */
/* ================================================================ */

alter table backup_msg_log alter column source nvarchar(56) collate !!insensitive null;
alter table backup_msg_log alter column extended_description nvarchar(1024) collate !!insensitive null;

go


/* ================================================================ */
/* Create new table backup_link_job_file_object					    */
/* ================================================================ */

CREATE TABLE backup_link_job_file_object (
       job_id				binary(16) not null,
       file_object_id		binary(16) not null,
       object_type			integer not null,
       backup_run_date		integer null,
       creation_user		nvarchar(255) collate !!sensitive null,
       creation_date		integer null
	   );

ALTER TABLE backup_link_job_file_object ADD 
CONSTRAINT XPKbackup_link_job_file_object PRIMARY KEY CLUSTERED
(
       job_id                       ASC,
       file_object_id				ASC,
       object_type					ASC
) ON [PRIMARY];

CREATE INDEX xif1backup_link_job_file_object ON backup_link_job_file_object
(
       job_id                 ASC
);
 
CREATE INDEX xif2backup_link_job_file_object ON backup_link_job_file_object
(
       file_object_id         ASC,
       object_type			  ASC
);

grant select,insert,update,delete on backup_link_job_file_object	to ca_itrm_group;
grant select,insert,update,delete on backup_link_job_file_object	to backup_admin_group, dms_backup_group;

go

/* ================================================================ */
/* New changes after change request	(part 3)					    */
/* ================================================================ */

/* ================================================================ */
/* Change existing table backup_query_based_policy				    */
/* ================================================================ */

alter table backup_query_based_policy add schedule_id varbinary(16) null;

CREATE INDEX xif3backup_query_based_policy ON backup_query_based_policy
(
       schedule_id                 ASC
);
go


/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14923043, getdate(), 1, 4, 'Brightstor: BABLD Changes: Manager administration, User authentication, Server enhancements, DARs and CES' )
GO

COMMIT TRANSACTION 
GO

