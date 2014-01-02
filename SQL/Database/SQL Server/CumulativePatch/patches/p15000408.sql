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
/* Star 15000408 UAPM: Implement new UAPM functionality for customer CSC              	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from arg_extension_rule_def with (tablockx)
GO
 
Select top 1 1 from arg_field_def with (tablockx)
GO
 
Select top 1 1 from arg_attribute_def with (tablockx)
GO
 
Select top 1 1 from arg_roledef with (tablockx)
GO
 
Select top 1 1 from arg_legaldoc with (tablockx)
GO
 
Select top 1 1 from ca_location with (tablockx)
GO
 
Select top 1 1 from ca_resource_cost_center with (tablockx)
GO
 
Select top 1 1 from ca_resource_department with (tablockx)
GO
 
Select top 1 1 from ca_job_title with (tablockx)
GO
 
Select top 1 1 from ca_job_function with (tablockx)
GO
 
Select top 1 1 from arg_drpdnlst with (tablockx)
GO
 
Select top 1 1 from ca_owned_resource with (tablockx)
GO
 
Select top 1 1 from arg_reconcile_task with (tablockx)
GO
 
Select top 1 1 from arg_reconcile_data with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* SQL for 11.CSC changes*/

/*****************************************************************************/
/* NOTE!!!!!!!!  Run this before running 11.CSC SQL Server mdb data update.sql */
/*****************************************************************************/

/* create the arg_hierarchy_def table */

CREATE TABLE arg_hierarchy_def (
        hierarchy_id int not null,
        hierarchy_name nvarchar(255) not null,
        hierarchy_type nvarchar(100) not null,
        ext_table_name nvarchar(32),
        last_update_user nvarchar(64),
        last_update_date int,
        version_number int null)
go

/* define the primary key */

ALTER TABLE arg_hierarchy_def
       ADD PRIMARY KEY CLUSTERED (hierarchy_id ASC)
go

/* create the arg_hierarchy_values table */

CREATE TABLE arg_hierarchy_values (
        hierarchy_id int not null,
        hierarchy_value_id int not null,
        hierarchy_value nvarchar(255) not null,
        parent_id nvarchar(32),
        inactive int not null,
        last_update_user nvarchar(64),
        last_update_date int,
        version_number int null)
go

/* define the primary key */

ALTER TABLE arg_hierarchy_values
       ADD PRIMARY KEY CLUSTERED (hierarchy_value_id ASC)
go

CREATE INDEX arg_hierarchy_values_idx_02 on arg_hierarchy_values (
       parent_id ASC)
go

/***********************************************************************************/

/* alter the arg_extension_rule_def table */

ALTER TABLE arg_extension_rule_def ADD hierarchy_id int null
go

/***********************************************************************************/

/* alter the arg_field_def table */

ALTER TABLE arg_field_def ADD ishierarchy smallint null
go

/***********************************************************************************/

/* alter the arg_attribute_def table */

ALTER TABLE arg_attribute_def ADD api_property_name nvarchar(100) null
go

ALTER TABLE arg_attribute_def ADD api_object_name nvarchar(100) null
go

ALTER TABLE arg_attribute_def ADD api_updatable int null
go

ALTER TABLE arg_attribute_def ADD api_searchable int null
go

ALTER TABLE arg_attribute_def ADD hierarchy smallint null
go

/***********************************************************************************/

/* alter the arg_roledef table */

ALTER TABLE arg_roledef ADD inactive smallint null
go

/***********************************************************************************/

/* add organization_uuid fields */

/* alter the arg_legaldoc table */

ALTER TABLE arg_legaldoc ADD organization_uuid binary (16) null
go

ALTER TABLE arg_legaldoc ADD owner_uuid binary (16) null
go

ALTER TABLE arg_legaldoc ADD manager_uuid binary (16) null
go

ALTER TABLE arg_legaldoc ADD cost_approver_uuid binary (16) null
go

/* alter the ca_location table */

ALTER TABLE ca_location ADD organization_uuid binary (16) null
go

/* alter the ca_resource_cost_center table */

ALTER TABLE ca_resource_cost_center ADD organization_uuid binary (16) null
go

CREATE INDEX ca_resource_cost_center_idx_02 ON ca_resource_cost_center (organization_uuid) 
go

/* alter the ca_resource_department table */

ALTER TABLE ca_resource_department ADD organization_uuid binary (16) null
go

CREATE INDEX ca_resource_department_idx_02 ON ca_resource_department (organization_uuid) 
go

/* alter the ca_job_title table */

ALTER TABLE ca_job_title ADD organization_uuid binary (16) null
go

CREATE INDEX ca_job_title_idx_02 ON ca_job_title (organization_uuid) 
go

/* alter the ca_job_function table */

ALTER TABLE ca_job_function ADD organization_uuid binary (16) null
go

CREATE INDEX ca_job_function_idx_02 ON ca_job_function (organization_uuid) 
go

/* alter the arg_drpdnlst table */

ALTER TABLE arg_drpdnlst ADD organization_uuid binary (16) null
go

CREATE INDEX arg_drpdnlst_idx_04 ON arg_drpdnlst (organization_uuid) 
go

/***********************************************************************************/

/* create the arg_link_notification_attachmt table */

CREATE TABLE arg_link_notification_attachmt (
        object_uuid binary (16) not null,
        amid int not null,
        nyerid int not null,
        nyid smallint not null,
        last_update_date int null,
        version_number int null)
go

/* define the primary key */

ALTER TABLE arg_link_notification_attachmt
       ADD PRIMARY KEY CLUSTERED (object_uuid ASC, 
                                  amid ASC, 
                                  nyerid ASC, 
                                  nyid ASC)
go          
                             
/* add new fields to the ca_owned_resource table */

ALTER TABLE ca_owned_resource ADD alternate_host_name nvarchar(255) null
go

ALTER TABLE ca_owned_resource ADD discovery_last_run_date int null
go

ALTER TABLE ca_owned_resource ADD previous_resource_tag nvarchar(64) null
go

ALTER TABLE ca_owned_resource ADD processor_count int null
go

ALTER TABLE ca_owned_resource ADD processor_speed float null
go

ALTER TABLE ca_owned_resource ADD processor_speed_unit int null
go

ALTER TABLE ca_owned_resource ADD processor_type nvarchar(50) null
go

ALTER TABLE ca_owned_resource ADD reconciliation_date int null
go

ALTER TABLE ca_owned_resource ADD total_disk_space float null
go

ALTER TABLE ca_owned_resource ADD total_disk_space_unit int null
go

ALTER TABLE ca_owned_resource ADD total_memory float null
go

ALTER TABLE ca_owned_resource ADD total_memory_unit int null
go

ALTER TABLE ca_owned_resource ADD billing_contact_uuid binary (16) null
go

ALTER TABLE ca_owned_resource ADD support_contact1_uuid binary (16) null
go

ALTER TABLE ca_owned_resource ADD support_contact2_uuid binary (16) null
go

ALTER TABLE ca_owned_resource ADD support_contact3_uuid binary (16) null
go

ALTER TABLE ca_owned_resource ADD disaster_recovery_contact_uuid binary (16) null
go

ALTER TABLE ca_owned_resource ADD backup_services_contact_uuid binary (16) null
go

ALTER TABLE ca_owned_resource ADD network_contact_uuid binary (16) null
go

/* add new fields to the arg_reconcile_task table */

ALTER TABLE arg_reconcile_task ADD watch_disk_space_switch smallint null
go

ALTER TABLE arg_reconcile_task ADD watch_memory_switch smallint null
go

ALTER TABLE arg_reconcile_task ADD watch_processor_count_switch smallint null
go

ALTER TABLE arg_reconcile_task ADD watch_processor_speed_switch smallint null
go

ALTER TABLE arg_reconcile_task ADD watch_processor_type_switch smallint null
go

ALTER TABLE arg_reconcile_task ADD watch_last_run_date_switch smallint null
go

/* add new fields to the arg_reconcile_data table */

ALTER TABLE arg_reconcile_data ADD discovery_last_run_date int null
go

ALTER TABLE arg_reconcile_data ADD discovery_processor_count int null
go

ALTER TABLE arg_reconcile_data ADD discovery_processor_speed float null
go

ALTER TABLE arg_reconcile_data ADD discovery_processor_speed_unit int null
go

ALTER TABLE arg_reconcile_data ADD discovery_processor_type nvarchar(50) null
go

ALTER TABLE arg_reconcile_data ADD discovery_total_disk_space float null
go

ALTER TABLE arg_reconcile_data ADD discovery_total_disk_space_unt int null
go

ALTER TABLE arg_reconcile_data ADD discovery_total_memory float null
go

ALTER TABLE arg_reconcile_data ADD discovery_total_memory_unit int null
go

/* Note: The GRANT statements are absent.  There is legacy code in UAPM Database Utility to handle this already */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15000408, getdate(), 1, 4, 'Star 15000408 UAPM: Implement new UAPM functionality for customer CSC' )
GO

COMMIT TRANSACTION 
GO

