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
/* Patch Star 14668173 Insight: Missing grants, schema changes in dbh_agent_status,     */
/*                              dbh_sql_ora, dbh_sql_udb tables                         */
/*                                                                                      */
/****************************************************************************************/
BEGIN TRANSACTION 
GO

/*=========================================*/
/*Submitted By:  Steve Moore               */
/*Product:       Unicenter Insight         */
/*Release:       r11.2                     */
/*MDBs:	       Ingres, Oracle, SQL Server  */
/*Date:	       Feb 24, 2006                */
/*=========================================*/
/*Summary of Changes for SQL Server MDB */
/*	1. Missing grants on tables */
/*	2. Change in DBH_AGENT_STATUS table DDL (rename column, add columns) */
/*	3. Change DBH_AGENT_STATUS_IDX index DDL (added more columns) */
/*	4. Change in DBH_SQL_ORA table column "DESC" => "DESCRIPTION" (renamed column */
/*	   because column name "DESC" is reserved Oracle keyword.  The column */
/*	   order is significant in this table) */
/*	5. Change in DBH_SQL_UDB table column "DESC" => "DESCRIPTION" (renamed column */
/*	   because column name "DESC" is reserved Oracle keyword.  The column */
/*	   order is significant in this table) */
/*	6. Converted Ingres SEQUENCES intop SQL Server IDENTITIY */
/*============================================================================*/

GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[dbh_hist]  TO [udmadmin_group]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_key]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
      DROP TABLE [dbo].[dbh_key]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_key]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[dbh_key] (
	[seq_no] [decimal](31, 0) IDENTITY (1, 1) NOT NULL ,
	[dbh_instance] [varchar] (80) COLLATE !!sensitive NOT NULL ,
	[name] [varchar] (50) COLLATE !!sensitive NOT NULL ,
	[sub_name] [varchar] (80) COLLATE !!sensitive NOT NULL ,
	[timestamp_first] [datetime] NULL ,
	[timestamp_last] [datetime] NULL 
) ON [PRIMARY]
END
GO

CREATE  INDEX [dbh_key_idx] ON [dbo].[dbh_key]([dbh_instance], [name], [sub_name]) ON [PRIMARY]
GO

GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[dbh_key]  TO [udmadmin_group]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_agent_status]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
      DROP TABLE [dbo].[dbh_agent_status]
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_agent_status]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[dbh_agent_status] (
	[agent_name] [varchar] (80) COLLATE !!sensitive NOT NULL ,
	[alarm_name] [varchar] (80) COLLATE !!sensitive NOT NULL ,
	[alarm_object] [varchar] (132) COLLATE !!sensitive NULL ,
	[alarm_threshold] [varchar] (32) COLLATE !!sensitive NULL ,
	[alarm_level] [int] NULL ,
	[alarm_type] [int] NULL ,
	[alarm_text] [varchar] (256) COLLATE !!sensitive NOT NULL ,
	[alarm_time] [datetime] NULL 
) ON [PRIMARY]
END

GO

CREATE  INDEX [dbh_agent_status_idx] ON [dbo].[dbh_agent_status]([agent_name], [alarm_name], [alarm_object]) ON [PRIMARY]
GO

GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[dbh_agent_status] TO [udmadmin_group] /* gecpi01 */
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_sql_ora]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
ALTER TABLE [dbo].[dbh_sql_bind_variables_ora]
	DROP CONSTRAINT [dbh_sql_bind_var_ora_sql_fk];
ALTER TABLE [dbo].[dbh_sql_tables_ora] /* ADD -- gecpi01 */
	DROP CONSTRAINT [dbh_sql_tables_ora_sql_fk]; 
      DROP TABLE [dbo].[dbh_sql_ora];
END
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_sql_ora]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[dbh_sql_ora] (
	[sql_id] [decimal](8, 0) IDENTITY (1, 1) NOT NULL ,
	[capture_id] [decimal](8, 0) NULL ,
	[snapshot_timestamp] [datetime] NOT NULL ,
	[sql_owner] [varchar] (30) COLLATE !!sensitive NULL ,
	[sql_parser] [varchar] (30) COLLATE !!sensitive NOT NULL ,
	[appl_name] [varchar] (256) COLLATE !!sensitive NULL ,
	[os_user] [varchar] (256) COLLATE !!sensitive NULL ,
	[option_defer_parse] [char] (1) COLLATE !!sensitive NULL ,
	[option_describes_y_n] [char] (1) COLLATE !!sensitive NULL ,
	[option_combine_fetch] [char] (1) COLLATE !!sensitive NULL ,
	[option_min_sorting] [char] (1) COLLATE !!sensitive NULL ,
	[option_array_size] [decimal](12, 0) NULL ,
	[option_n_fetches] [decimal](12, 0) NULL ,
	[option_long_piece_size] [decimal](12, 0) NULL ,
	[option_n_long_peices] [decimal](12, 0) NULL ,
	[option_roll_segment] [varchar] (30) COLLATE !!sensitive NULL ,
	[bind_carnality] [decimal](12, 0) NULL ,
	[prod_plan] [varchar] (1) COLLATE !!sensitive NULL ,
	[do_elapsed_time_last] [decimal](12, 0) NULL ,
	[do_total_cpu_last] [decimal](16, 6) NULL ,
	[do_db_calls] [decimal](12, 0) NULL ,
	[row_num_limit] [decimal](12, 0) NULL ,
	[sql_type] [varchar] (1) COLLATE !!sensitive NOT NULL ,
	[c_sharable_mem] [decimal](12, 0) NULL ,
	[c_sorts] [decimal](12, 0) NULL ,
	[c_loaded_versions] [decimal](12, 0) NULL ,
	[c_executions] [decimal](12, 0) NULL ,
	[c_parse_calls] [decimal](12, 0) NULL ,
	[c_disk_reads] [decimal](12, 0) NULL ,
	[c_buffer_gets] [decimal](12, 0) NULL ,
	[c_users_opening] [decimal](12, 0) NULL ,
	[c_first_load_time] [datetime] NULL ,
	[c_last_load_time] [datetime] NULL ,
	[c_rows_processed] [decimal](12, 0) NULL ,
	[c_cpu_time] [decimal](16, 6) NULL ,
	[c_elapsed_time] [decimal](12, 0) NULL ,
	[c_log_write] [decimal](12, 0) NULL ,
	[c_log_io] [decimal](12, 0) NULL ,
	[c_optimizer_mode] [varchar] (30) COLLATE !!sensitive NULL ,
	[aud_sid] [decimal](12, 0) NULL ,
	[sid] [decimal](12, 0) NULL ,
	[serial_num] [decimal](12, 0) NULL ,
	[sql_address] [varchar] (50) COLLATE !!sensitive NULL ,
	[sql_hash_value] [decimal](12, 0) NULL ,
	[child_number] [decimal](12, 0) NULL ,
	[diff_log_read] [decimal](12, 0) NULL ,
	[diff_log_write] [decimal](12, 0) NULL ,
	[diff_phy_read] [decimal](12, 0) NULL ,
	[diff_io] [decimal](12, 0) NULL ,
	[diff_cpu] [decimal](16, 6) NULL ,
	[stmt_text] [text] COLLATE !!sensitive NOT NULL ,
	[tag] [varchar] (50) COLLATE !!sensitive NULL ,
	[folder] [varchar] (50) COLLATE !!sensitive NULL ,
	[description] [varchar] (2000) COLLATE !!sensitive NULL ,
	[plan_owner] [varchar] (30) COLLATE !!sensitive NULL ,
	[db_connect_string] [varchar] (400) COLLATE !!sensitive NULL ,
	[db_name] [varchar] (50) COLLATE !!sensitive NULL ,
	[db_version] [varchar] (30) COLLATE !!sensitive NULL ,
	[create_date] [datetime] NULL ,
	[verify_date] [datetime] NULL ,
	[start_capture_time] [datetime] NULL ,
	[end_capture_time] [datetime] NULL ,
	[capture_interval] [decimal](12, 2) NULL ,
	[var1] [varchar] (400) COLLATE !!sensitive NULL ,
	[var2] [varchar] (400) COLLATE !!sensitive NULL ,
	[var3] [varchar] (400) COLLATE !!sensitive NULL ,
	[var4] [varchar] (400) COLLATE !!sensitive NULL ,
	[var5] [varchar] (400) COLLATE !!sensitive NULL ,
	[text1] [varchar] (1) COLLATE !!sensitive NULL ,
	[dec1] [decimal](12, 2) NULL ,
	[dec2] [decimal](12, 2) NULL ,
	[dec3] [decimal](12, 2) NULL ,
	[dec4] [decimal](16, 6) NULL ,
	[dec5] [decimal](16, 6) NULL ,
	[float1] [float] NULL ,
	[float2] [float] NULL ,
	[float3] [float] NULL ,
	[date1] [datetime] NULL ,
	[date2] [datetime] NULL ,
	[date3] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO

ALTER TABLE [dbo].[dbh_sql_ora] WITH NOCHECK ADD 
	CONSTRAINT [dbh_sql_ora_pk] PRIMARY KEY  CLUSTERED 
	(
		[sql_id]
	)  ON [PRIMARY] 
GO

CREATE  INDEX [dbh_sql_ora_snapshot_ts_idx] ON [dbo].[dbh_sql_ora]([capture_id], [snapshot_timestamp]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[dbh_sql_bind_variables_ora] ADD 
	CONSTRAINT [dbh_sql_bind_var_ora_sql_fk] FOREIGN KEY 
	(
		[sql_id]
	) REFERENCES [dbo].[dbh_sql_ora] (
		[sql_id]
	) ON DELETE CASCADE 
GO

ALTER TABLE [dbo].[dbh_sql_tables_ora] ADD 
	CONSTRAINT [dbh_sql_tables_ora_sql_fk] FOREIGN KEY 
	(
		[sql_id]
	) REFERENCES [dbo].[dbh_sql_ora] (
		[sql_id]
	) ON DELETE CASCADE 
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dbh_sql_ora]  TO [udmadmin_group]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_sql_udb]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
ALTER TABLE [dbo].[dbh_sql_udb]
	DROP CONSTRAINT [dbh_sql_udb_capture_fk];
      DROP TABLE [dbo].[dbh_sql_udb];
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_sql_udb]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[dbh_sql_udb] (
	[sql_id] [decimal](8, 0) IDENTITY (1, 1) NOT NULL ,
	[capture_id] [decimal](8, 0) NULL ,
	[snapshot_timestamp] [datetime] NOT NULL ,
	[sql_owner] [varchar] (256) COLLATE !!sensitive NULL ,
	[sql_parser] [varchar] (256) COLLATE !!sensitive NULL ,
	[agent_id] [decimal](12, 0) NOT NULL ,
	[appl_id] [varchar] (32) COLLATE !!sensitive NOT NULL ,
	[appl_name] [varchar] (256) COLLATE !!sensitive NULL ,
	[os_user] [varchar] (256) COLLATE !!sensitive NULL ,
	[agent_rows_read] [decimal](12, 0) NULL ,
	[agent_rows_written] [decimal](12, 0) NULL ,
	[agent_usr_cpu] [decimal](16, 6) NULL ,
	[agent_sys_cpu] [decimal](16, 6) NULL ,
	[stmt_rows_read] [decimal](12, 0) NULL ,
	[stmt_rows_written] [decimal](12, 0) NULL ,
	[stmt_rows_accessed] [decimal](12, 0) NULL ,
	[num_agents] [decimal](12, 0) NULL ,
	[agents_top] [decimal](12, 0) NULL ,
	[stmt_type] [decimal](4, 0) NULL ,
	[stmt_operation] [decimal](4, 0) NULL ,
	[section_number] [decimal](12, 0) NULL ,
	[query_cost_estimate] [decimal](12, 0) NULL ,
	[query_card_estimate] [decimal](12, 0) NULL ,
	[degree_parallelism] [decimal](12, 0) NULL ,
	[stmt_sorts] [decimal](12, 0) NULL ,
	[total_sort_time] [decimal](16, 6) NULL ,
	[sort_overflows] [decimal](12, 0) NULL ,
	[int_rows_deleted] [decimal](12, 0) NULL ,
	[int_rows_updated] [decimal](12, 0) NULL ,
	[int_rows_inserted] [decimal](12, 0) NULL ,
	[fetch_count] [decimal](12, 0) NULL ,
	[stmt_start] [datetime] NULL ,
	[stmt_stop] [datetime] NULL ,
	[stmt_usr_cpu] [decimal](16, 6) NULL ,
	[stmt_sys_cpu] [decimal](16, 6) NULL ,
	[stmt_elapsed_time] [decimal](16, 6) NULL ,
	[blocking_cursor] [decimal](12, 0) NULL ,
	[stmt_partition_number] [decimal](12, 0) NULL ,
	[cursor_name] [varchar] (256) COLLATE !!sensitive NULL ,
	[creator] [varchar] (256) COLLATE !!sensitive NULL ,
	[package_name] [varchar] (30) COLLATE !!sensitive NULL ,
	[diff_rows_read] [decimal](12, 0) NULL ,
	[diff_rows_written] [decimal](12, 0) NULL ,
	[diff_rows_accessed] [decimal](12, 0) NULL ,
	[diff_cpu] [decimal](16, 6) NULL ,
	[stmt_text] [text] COLLATE !!sensitive NULL ,
	[tag] [varchar] (50) COLLATE !!sensitive NULL ,
	[folder] [varchar] (50) COLLATE !!sensitive NULL ,
	[description] [varchar] (2000) COLLATE !!sensitive NULL ,
	[plan_owner] [varchar] (30) COLLATE !!sensitive NULL ,
	[db_connect_string] [varchar] (400) COLLATE !!sensitive NULL ,
	[db_name] [varchar] (50) COLLATE !!sensitive NULL ,
	[db_version] [varchar] (30) COLLATE !!sensitive NULL ,
	[create_date] [datetime] NULL ,
	[verify_date] [datetime] NULL ,
	[start_capture_time] [datetime] NULL ,
	[end_capture_time] [datetime] NULL ,
	[capture_interval] [decimal](12, 2) NULL ,
	[var1] [varchar] (400) COLLATE !!sensitive NULL ,
	[var2] [varchar] (400) COLLATE !!sensitive NULL ,
	[var3] [varchar] (400) COLLATE !!sensitive NULL ,
	[var4] [varchar] (400) COLLATE !!sensitive NULL ,
	[var5] [varchar] (400) COLLATE !!sensitive NULL ,
	[text1] [varchar] (1) COLLATE !!sensitive NULL ,
	[dec1] [decimal](12, 2) NULL ,
	[dec2] [decimal](12, 2) NULL ,
	[dec3] [decimal](12, 2) NULL ,
	[dec4] [decimal](16, 6) NULL ,
	[dec5] [decimal](16, 6) NULL ,
	[float1] [float] NULL ,
	[float2] [float] NULL ,
	[float3] [float] NULL ,
	[date1] [datetime] NULL ,
	[date2] [datetime] NULL ,
	[date3] [datetime] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[dbh_sql_udb] WITH NOCHECK ADD 
	CONSTRAINT [dbh_sql_udb_pk] PRIMARY KEY  CLUSTERED 
	(
		[sql_id]
	)  ON [PRIMARY] 
GO

CREATE  INDEX [dbh_sql_udb_snapshot_ts_idx] ON [dbo].[dbh_sql_udb]([capture_id], [snapshot_timestamp]) ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[dbh_sql_udb]  TO [udmadmin_group]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_captures]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
BEGIN
      DROP TABLE [dbo].[dbh_captures];
END

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[dbh_captures]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[dbh_captures] (
	[capture_id] [decimal](8, 0) IDENTITY (1, 1) NOT NULL ,
	[db] [varchar] (256) COLLATE !!sensitive NOT NULL ,
	[db_type] [char] (1) COLLATE !!sensitive NOT NULL ,
	[db_version] [varchar] (30) COLLATE !!sensitive NOT NULL ,
	[owner] [varchar] (256) COLLATE !!sensitive NOT NULL ,
	[collection_name] [varchar] (50) COLLATE !!sensitive NOT NULL ,
	[submit_date] [datetime] NULL ,
	[capture_desc] [varchar] (500) COLLATE !!sensitive NULL ,
	[collect_sys_y_n] [char] (1) COLLATE !!sensitive NULL ,
	[num_sql_collected] [decimal](8, 0) NULL ,
	[batch_or_interactive] [char] (1) COLLATE !!sensitive NULL ,
	[batch_job_id] [decimal](8, 0) NULL ,
	[batch_start_time] [datetime] NULL ,
	[batch_repeat] [varchar] (100) COLLATE !!sensitive NULL ,
	[batch_stop_time] [datetime] NULL ,
	[batch_executes_to_date] [decimal](12, 0) NULL ,
	[batch_errer_msg] [varchar] (500) COLLATE !!sensitive NULL ,
	[var1] [varchar] (100) COLLATE !!sensitive NULL ,
	[var2] [varchar] (100) COLLATE !!sensitive NULL ,
	[var3] [varchar] (100) COLLATE !!sensitive NULL ,
	[var4] [varchar] (100) COLLATE !!sensitive NULL ,
	[var5] [varchar] (4000) COLLATE !!sensitive NULL 
) ON [PRIMARY]
END
GO

ALTER TABLE [dbo].[dbh_captures] WITH NOCHECK ADD 
	CONSTRAINT [dbh_captures_pk] PRIMARY KEY  CLUSTERED 
	(
		[capture_id]
	)  ON [PRIMARY] 
GO

CREATE  INDEX [dbh_captures_db_batch_st_idx] ON [dbo].[dbh_captures]([db], [batch_start_time]) ON [PRIMARY]
GO

CREATE  INDEX [dbh_captures_db_collect_idx] ON [dbo].[dbh_captures]([db], [collection_name]) ON [PRIMARY]
GO

ALTER TABLE [dbo].[dbh_sql_ora] ADD 
	CONSTRAINT [dbh_sql_ora_capture_fk] FOREIGN KEY 
	(
		[capture_id]
	) REFERENCES [dbo].[dbh_captures] (
		[capture_id]
	) ON DELETE CASCADE 
GO

ALTER TABLE [dbo].[dbh_sql_udb] ADD 
	CONSTRAINT [dbh_sql_udb_capture_fk] FOREIGN KEY 
	(
		[capture_id]
	) REFERENCES [dbo].[dbh_captures] (
		[capture_id]
	) ON DELETE CASCADE 
GO

GRANT SELECT, UPDATE, INSERT, DELETE ON [dbo].[dbh_captures] TO [udmadmin_group] /* gecpi01 */
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14668173, getdate(), 1, 4, 'Star 14668173 Missing grants, schema changes in dbh_agent_status, dbh_sql_ora, dbh_sql_udb tables' )
GO

COMMIT TRANSACTION 
GO

