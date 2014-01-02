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
/* Star 14665944 CMDB SCHEMA ADDITIONS							*/
/*                                                                                      */
/****************************************************************************************/

if not exists (select * from dbo.sysusers where name = N'cmdb_admin' and uid > 16399)
	EXEC sp_addrole N'cmdb_admin'
GO

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
Select top 1 1 from mdb_service_pack with (tablockx)
GO
 
Select top 1 1 from mdb with (tablockx)
GO
 
Select top 1 1 from mdb_checkpoint with (tablockx)
GO
 
/* End of lines added to convert to online lock */

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_app_ext]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_app_ext]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_app_inhouse]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_app_inhouse]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_contract]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_contract]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_database]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_database]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_document]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_document]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_eligible_child]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_eligible_child]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_eligible_parent]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_eligible_parent]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_fac_ac]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_fac_ac]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_fac_fire_control]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_fac_fire_control]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_fac_furnishings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_fac_furnishings]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_fac_other]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_fac_other]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_fac_ups]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_fac_ups]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_lpar]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_lpar]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_mainframe]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_mainframe]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_monitor]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_monitor]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_other]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_other]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_printer]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_printer]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_server]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_server]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_storage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_storage]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_virtual]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_virtual]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_hardware_workstation]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_hardware_workstation]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_bridge]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_bridge]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_cluster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_cluster]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_controller]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_controller]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_frontend]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_frontend]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_gateway]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_gateway]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_hub]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_hub]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_nic]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_nic]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_other]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_other]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_peripheral]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_peripheral]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_port]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_port]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_resource]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_resource]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_resource_group]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_resource_group]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_router]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_router]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_network_server]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_network_server]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_operating_system]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_operating_system]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_rel_type]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_rel_type]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_security]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_security]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_service]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_service]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_sla]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_sla]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_telcom_ciruit]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_telcom_ciruit]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_telcom_other]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_telcom_other]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_telcom_radio]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_telcom_radio]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_telcom_voice]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_telcom_voice]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ci_telcom_wireless]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ci_telcom_wireless]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[busmgt]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[busmgt]
GO

CREATE TABLE [dbo].[busmgt] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[hier_parent] [binary] (16) NULL ,
	[hier_child] [binary] (16) NOT NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[cost] [int] NULL ,
	[sym] [nvarchar] (60) COLLATE !!insensitive NOT NULL ,
	[nx_desc] [nvarchar] (40) COLLATE !!insensitive NULL ,
	[bm_rep] [int] NULL ,
	[ci_rel_type] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[busmgt] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

 CREATE  INDEX [busmgt_X0] ON [dbo].[busmgt]([sym]) ON [PRIMARY]
GO

 CREATE  INDEX [busmgt_X1] ON [dbo].[busmgt]([hier_parent]) ON [PRIMARY]
GO

 CREATE  INDEX [busmgt_X2] ON [dbo].[busmgt]([hier_child]) ON [PRIMARY]
GO

 CREATE  INDEX [busmgt_X3] ON [dbo].[busmgt]([ci_rel_type]) ON [PRIMARY]
GO




CREATE TABLE [dbo].[ci_app_ext] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[app_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[portfolio] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[environment] [nvarchar] (200) COLLATE !!insensitive NULL ,
	[inhouse_or_vendor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[category] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[install_dir] [nvarchar] (100) COLLATE !!insensitive NULL ,
	[main_process] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[storage_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[uptime] [int] NULL ,
	[response_time] [int] NULL ,
	[highly_avail] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[highavail_appl_resources] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[date_installed] [int] NULL ,
	[support_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[support_start_date] [int] NULL ,
	[support_end_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ci_app_ext] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_app_inhouse] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[app_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[portfolio] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[environment] [nvarchar] (200) COLLATE !!insensitive NULL ,
	[inhouse_or_vendor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[category] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[install_dir] [nvarchar] (100) COLLATE !!insensitive NULL ,
	[main_process] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[storage_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[uptime] [int] NULL ,
	[response_time] [int] NULL ,
	[highly_avail] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[highavail_appl_resources] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[date_installed] [int] NULL ,
	[support_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[support_start_date] [int] NULL ,
	[support_end_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_app_inhouse] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_contract] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[proj_code] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[con_num] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[con_ref] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[con_status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[con_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[con_start_date] [int] NULL ,
	[con_end_date] [int] NULL ,
	[con_renewal_date] [int] NULL ,
	[con_comments] [nvarchar] (200) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_contract] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_database] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[db_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[portfolio] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[environment] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[version] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[support_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[support_start_date] [int] NULL ,
	[support_end_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [int] NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_database] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_document] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[doc_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[doc_category] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[doc_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[doc_status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[doc_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[doc_start_date] [int] NULL ,
	[doc_end_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_document] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_eligible_child] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[del] [int] NOT NULL ,
	[rel_id] [int] NOT NULL ,
	[fam_id] [int] NULL ,
	[class_id] [int] NULL ,
	[sym] [nvarchar] (50) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_eligible_child] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_eligible_parent] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[del] [int] NOT NULL ,
	[rel_id] [int] NOT NULL ,
	[fam_id] [int] NULL ,
	[class_id] [int] NULL ,
	[sym] [nvarchar] (50) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_eligible_parent] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_fac_ac] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_fac_ac] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_fac_fire_control] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_fac_fire_control] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_fac_furnishings] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[warehouse_loc] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_fac_furnishings] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_fac_other] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[warehouse_loc] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_fac_other] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_fac_ups] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[warehouse_loc] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_start_date] [int] NULL ,
	[lease_end_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_fac_ups] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_lpar] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[phys_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mem_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[hard_drive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_spd] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[profile] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[max_processors] [int] NULL ,
	[min_processors] [int] NULL ,
	[desired_processors] [int] NULL ,
	[max_memory] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[min_memory] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[desired_memory] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[panel_display] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[current_memory] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[current_processors] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_lpar] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_mainframe] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[phys_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mem_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[hard_drive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_spd] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[num_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [int] NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_mainframe] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_monitor] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_monitor] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_other] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[phys_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mem_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[hard_drive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_spd] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[media_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[media_drive_num] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[total_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[used_space] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[array_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[array_serial_num] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[cd_rom_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[graphics_card] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[scsi_card] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[modem_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[modem_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[printer] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_slot_proc] [int] NULL ,
	[number_proc_inst] [int] NULL ,
	[mem_cache_proc] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_total_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_mem_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[supervision_mode] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[processor_count] [int] NULL ,
	[swap_size] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[security_patch_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_other] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_printer] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_printer] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_server] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[phys_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mem_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[hard_drive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_speed] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[cd_rom_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[printer] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_slot_proc] [int] NULL ,
	[number_proc_inst] [int] NULL ,
	[mem_cache_proc] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_total_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_mem_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[supervision_mode] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[processor_count] [int] NULL ,
	[swap_size] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[security_patch_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_server] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_storage] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[media_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[media_drive_num] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[total_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[used_space] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[array_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[array_serial_num] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_storage] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_hardware_virtual] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[phys_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mem_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[hard_drive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_speed] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[media_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[security_patch_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[virtual_processors] [int] NULL ,
	[processor_affinity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[cpu_shares] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[memory_shares] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_virtual] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO


CREATE TABLE [dbo].[ci_hardware_workstation] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[phys_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mem_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[hard_drive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proc_speed] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[disk_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[cd_rom_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[graphics_card] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[scsi_card] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[modem_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[modem_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[printer] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_slot_proc] [int] NULL ,
	[number_proc_inst] [int] NULL ,
	[slot_total_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_mem_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[processor_count] [int] NULL ,
	[security_patch_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_hardware_workstation] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_bridge] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_bridge] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_cluster] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[channel_address] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[virtual_ip] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[quorum] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[security_patch_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_cluster] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_controller] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_smips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_controller] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_frontend] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_mips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_smips] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_frontend] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_gateway] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_gateway] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_hub] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_hub] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_nic] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[line_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[line_speed] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[protocol] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_nic] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_other] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [int] NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_other] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_peripheral] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_peripheral] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_port] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[domain] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[line_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[line_speed] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[protocol] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[channel_address] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_port] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_resource] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[resource_group_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[resource_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[resource_file] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[resource_mount_point] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[resource_disk] [nvarchar] (15) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_resource] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO


CREATE TABLE [dbo].[ci_network_resource_group] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[resource_group_type] [nvarchar] (15) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_resource_group] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_router] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[rout_prot] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[flow] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[modem_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[modem_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[number_proc_inst] [int] NULL ,
	[mem_cache_proc] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_total_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_mem_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[processor_count] [int] NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[protocol] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_router] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_network_server] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[rout_prot] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[addr_class] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[flow] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[graphics_card] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[scsi_card] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[modem_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[modem_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[printer] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[technology] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[number_ports] [int] NULL ,
	[number_ports_used] [int] NULL ,
	[number_proc_inst] [int] NULL ,
	[mem_cache_proc] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_total_mem] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[slot_mem_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[type_net_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_port_conn] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[number_net_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[role] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[supervision_mode] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[processor_count] [int] NULL ,
	[swap_size] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[ip_mgmt_addr] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[usb_active_connections] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[protocol] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[channel_address] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[os_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[security_patch_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_network_server] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_operating_system] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[os_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[environment] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[date_installed] [int] NULL ,
	[support_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[support_start_date] [int] NULL ,
	[support_end_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_operating_system] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_rel_type] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[del] [int] NOT NULL ,
	[parenttochild] [nvarchar] (50) COLLATE !!insensitive NOT NULL ,
	[childtoparent] [nvarchar] (50) COLLATE !!insensitive NOT NULL ,
	[is_peer] [int] NULL ,
	[nx_desc] [nvarchar] (40) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_rel_type] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO


CREATE TABLE [dbo].[ci_security] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[security_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[integrity_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[avail] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[confidentiality_level] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[appl] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_security] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_service] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[service_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[portfolio] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[category] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[site] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[start_date] [int] NULL ,
	[end_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_service] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_sla] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[sla_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[sla_category] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[sla_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[sla_status] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[sla_version] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[sla_date_active] [int] NULL ,
	[sla_start_date] [int] NULL ,
	[sla_end_date] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_sla] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_telcom_ciruit] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[carrier] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[circuit_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[circuit_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[bandwidth] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_telcom_ciruit] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_telcom_other] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[phone_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[carrier] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[circuit_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[domain] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[line_id] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[server_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[cpu_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[memory_available] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[memory_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[nic_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bandwidth] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[frequency] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[license_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[license_expiration_date] [int] NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_telcom_other] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_telcom_radio] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[domain] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[cpu_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[memory_available] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[memory_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[nic_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bandwidth] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[frequency] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[license_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[license_expiration_date] [int] NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_telcom_radio] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_telcom_voice] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[nci_network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[phone_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[main_extension] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[carrier] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[cpu_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[memory_available] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[memory_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[nic_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_telcom_voice] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

CREATE TABLE [dbo].[ci_telcom_wireless] (
	[id] [int] NOT NULL ,
	[persid] [nvarchar] (30) COLLATE !!insensitive NULL ,
	[last_mod_dt] [int] NULL ,
	[last_mod_by] [binary] (16) NULL ,
	[ext_asset] [binary] (16) NOT NULL ,
	[network_name] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[network_address] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[phone_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[carrier] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[gateway_id] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[subnet_mask] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[domain] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[bios_ver] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[cpu_type] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[memory_available] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[memory_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_capacity] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[harddrive_used] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[monitor] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[nic_card] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[bandwidth] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[frequency] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[license_number] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[license_expiration_date] [int] NULL ,
	[last_mtce_date] [int] NULL ,
	[mtce_level] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[active_date] [int] NULL ,
	[retire_date] [int] NULL ,
	[priority] [int] NULL ,
	[SLA] [nvarchar] (50) COLLATE !!insensitive NULL ,
	[leased_or_owned_status] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[proj_code] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[lease_effective_date] [int] NULL ,
	[lease_termination_date] [int] NULL ,
	[lease_renewal_date] [int] NULL ,
	[lease_cost_per_month] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[purchase_amount] [int] NULL ,
	[mtce_type] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_period] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[mtce_contract_number] [nvarchar] (15) COLLATE !!insensitive NULL ,
	[maintenance_fee] [int] NULL 
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[ci_telcom_wireless] ADD 
	 PRIMARY KEY  NONCLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_app_ext_X0] ON [dbo].[ci_app_ext]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_app_inhouse_X0] ON [dbo].[ci_app_inhouse]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_contract_X0] ON [dbo].[ci_contract]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_database_X0] ON [dbo].[ci_database]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_document_X0] ON [dbo].[ci_document]([ext_asset]) ON [PRIMARY]
GO

 CREATE  CLUSTERED  INDEX [ci_eligible_child_X0] ON [dbo].[ci_eligible_child]([rel_id]) ON [PRIMARY]
GO

 CREATE  CLUSTERED  INDEX [ci_eligible_parent_X0] ON [dbo].[ci_eligible_parent]([rel_id]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_fac_ac_X0] ON [dbo].[ci_fac_ac]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_fac_fire_control_X0] ON [dbo].[ci_fac_fire_control]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_fac_furnishings_X0] ON [dbo].[ci_fac_furnishings]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_fac_other_X0] ON [dbo].[ci_fac_other]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_fac_ups_X0] ON [dbo].[ci_fac_ups]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_lpar_X0] ON [dbo].[ci_hardware_lpar]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_mainframe_X0] ON [dbo].[ci_hardware_mainframe]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_monitor_X0] ON [dbo].[ci_hardware_monitor]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_other_X0] ON [dbo].[ci_hardware_other]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_printer_X0] ON [dbo].[ci_hardware_printer]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_server_X0] ON [dbo].[ci_hardware_server]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_storage_X0] ON [dbo].[ci_hardware_storage]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_virtual_X0] ON [dbo].[ci_hardware_virtual]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_hardware_workstation_X0] ON [dbo].[ci_hardware_workstation]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_bridge_X0] ON [dbo].[ci_network_bridge]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_cluster_X0] ON [dbo].[ci_network_cluster]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_controller_X0] ON [dbo].[ci_network_controller]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_frontend_X0] ON [dbo].[ci_network_frontend]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_gateway_X0] ON [dbo].[ci_network_gateway]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_hub_X0] ON [dbo].[ci_network_hub]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_nic_X0] ON [dbo].[ci_network_nic]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_other_X0] ON [dbo].[ci_network_other]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_peripheral_X0] ON [dbo].[ci_network_peripheral]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_port_X0] ON [dbo].[ci_network_port]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_resource_X0] ON [dbo].[ci_network_resource]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_resource_group_X0] ON [dbo].[ci_network_resource_group]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_router_X0] ON [dbo].[ci_network_router]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_network_server_X0] ON [dbo].[ci_network_server]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_operating_system_X0] ON [dbo].[ci_operating_system]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_security_X0] ON [dbo].[ci_security]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_service_X0] ON [dbo].[ci_service]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_sla_X0] ON [dbo].[ci_sla]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_telcom_ciruit_X0] ON [dbo].[ci_telcom_ciruit]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_telcom_other_X0] ON [dbo].[ci_telcom_other]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_telcom_radio_X0] ON [dbo].[ci_telcom_radio]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_telcom_voice_X0] ON [dbo].[ci_telcom_voice]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  CLUSTERED  INDEX [ci_telcom_wireless_X0] ON [dbo].[ci_telcom_wireless]([ext_asset]) ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [ci_rel_type_X0] ON [dbo].[ci_rel_type]([parenttochild]) ON [PRIMARY]
GO

 CREATE  UNIQUE  INDEX [ci_rel_type_X1] ON [dbo].[ci_rel_type]([childtoparent]) ON [PRIMARY]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_app_ext]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_app_inhouse]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_contract]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_database]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_document]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_eligible_child]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_eligible_parent]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_fac_ac]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_fac_fire_control]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_fac_furnishings]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_fac_other]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_fac_ups]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_lpar]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_mainframe]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_monitor]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_other]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_printer]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_server]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_storage]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_virtual]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_hardware_workstation]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_bridge]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_cluster]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_controller]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_frontend]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_gateway]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_hub]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_nic]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_other]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_peripheral]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_port]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_resource]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_resource_group]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_router]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_network_server]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_operating_system]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_rel_type]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_security]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_service]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_sla]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_telcom_ciruit]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_telcom_other]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_telcom_radio]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_telcom_voice]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[ci_telcom_wireless]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[busmgt]  TO [public], [cmdb_admin], [service_desk_admin_group]
GO

GRANT  SELECT ON [dbo].[ci_app_ext]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_app_inhouse]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_contract]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_database]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_document]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_eligible_child]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_eligible_parent]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_fac_ac]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_fac_fire_control]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_fac_furnishings]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_fac_other]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_fac_ups]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_lpar]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_mainframe]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_monitor]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_other]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_printer]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_server]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_storage]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_virtual]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_hardware_workstation]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_bridge]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_cluster]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_controller]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_frontend]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_gateway]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_hub]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_nic]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_other]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_peripheral]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_port]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_resource]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_resource_group]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_router]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_network_server]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_operating_system]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_rel_type]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_security]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_service]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_sla]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_telcom_ciruit]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_telcom_other]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_telcom_radio]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_telcom_voice]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[ci_telcom_wireless]  TO [service_desk_ro_group]
GO

GRANT  SELECT ON [dbo].[busmgt]  TO [service_desk_ro_group]
GO
/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14665944, getdate(), 1, 4, 'Star 14665944 (MODIFIED 16208491 v2) CMDB SCHEMA ADDITIONS' )
GO

COMMIT TRANSACTION 
GO

