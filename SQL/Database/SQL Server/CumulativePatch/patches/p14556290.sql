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
/* Star 14556290 DSM:MSSQL General Table Index and User changes                   */
/*                                                                                      */
/****************************************************************************************/
if not exists (select * from dbo.sysusers where name = N'ca_itrm_group_ams' and uid > 16399)
	EXEC sp_addrole N'ca_itrm_group_ams'
GO
BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from usd_applic with (tablockx)
GO
 
Select top 1 1 from ca_discovered_software with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */


/* ************************************** 9295 begin ****************** */
/* For AMS integration we need a new group */



GRANT  EXECUTE  ON [dbo].[uuid_from_char]  TO [ca_itrm_group_ams]
GO
GRANT  EXECUTE  ON [dbo].[uuid_to_char]  TO [ca_itrm_group]
GO

GRANT  SELECT  ON [dbo].[csm_v_computer]  TO [ca_itrm_group_ams]
Go
GRANT  SELECT  ON [dbo].[csm_v_parameter]  TO [ca_itrm_group_ams]
Go
GRANT  SELECT  ON [dbo].[csm_v_property]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_compos]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_iprocos]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_nr_of_active_applics]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_nr_of_ok_applics]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_nr_of_renew_active_applics]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_nr_of_renew_ok_applics]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_nr_of_renew_wait_applics]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_nr_of_waiting_applics]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_osim_targets_all]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_query_del_time]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_query_inst_time]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_osim_targets]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_am_agent_view]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_am_asset_derived_status]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_nodom]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_nodom_v1]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_nodomsrv]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_nodomsrv_v1]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_nosrv]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_nosrv_v1]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_coapi_agent_view_v1]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[dts_dtasset_view]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_agents]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_asset_grp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_common_grp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_container_installations]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_container_installations_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_container_jobs]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_container_jobs_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_csite]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_group_installed_products]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_group_installed_products_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_group_jobs]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_group_jobs_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_installed_products]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_installed_products_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_ls]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_lsg]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_osim_targets_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_ownsite]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_product_jobs]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_product_jobs_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_product_procedures]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_product_procedures_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_server_grp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_sserver_clients]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_sserver_clients_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[usd_v_target]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_target_jobs]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_target_jobs_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_targets_os]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_targets_os_s]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_v_user_dhw_sec]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[addmemo]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[addtext]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[am_approved_licenses]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[am_external_device]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[am_external_device_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[am_link_external_device]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[am_link_object_folder]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[am_object_folder]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[amaccmap]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[amepdef]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[amepjobs]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[amlegacy_objects]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[appuknow]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_action]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_actiondf]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_actionlk]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_assetver]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_costdet]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_drpdnlst]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_itemver]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_legaldef]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_legaldoc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_legasset]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_linkdef]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_paydet]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[arg_strlst]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[audithis]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_active_user_policy]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_agent_config]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_alert]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_archive]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_backed_up_file]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_backed_up_file_revision]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_backed_up_folder]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_data_growth]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_job]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_link_backup_policy_server]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_link_backup_set_policy]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_link_backup_set_user]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_login_history]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_msg_log]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_msg_log_config]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_network_throttle]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_performed_backup]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_performed_restore]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_policy]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_restored_file]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_schedule]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_server]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_server_config]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_set]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_set_include_exclude]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_set_inventory_selection_p]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_statistic]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_user]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_user_drive]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[backup_user_shell_folder]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[bckbin]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[bckdef]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[bckfile]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[bit_support]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_acme_checkpoint]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_agent_component]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_application_registration]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_asset_source_location]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_asset_subschema]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_asset_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_capacity_unit]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_cateGOry_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_class_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_company_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_config_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_country]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_directory_details]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_directory_schema_map]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_discovered_hardware_network]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_document]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_geo_coord_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_group_ace]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_hierarchy]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_job_title]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_language]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_license_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_license_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_object_owner]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_manager]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_model_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_named_configuration]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_object_ace]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_pool_resource]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_proc_os]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_query_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_query_def_contents]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_query_pre_result]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_reg_control]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_replication_conf]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_replication_history]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_resource_class]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_resource_cost_center]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_resource_family]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_resource_gl_code]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_resource_operating_system]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_resource_pool]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_resource_status]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_sdi_ticket]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_security_class_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_security_profile]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_settings]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_site]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_software_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_source_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_state_province]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_taskwiz_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[chip_set]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[confmemo]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[csm_class]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[csm_link]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[csm_object]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[csm_property]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_dbversion]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_dtfilter]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_dtsubscribers]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_dttransfer]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_dttransfergroup]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_dtversion]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[dts_torproperties]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[eventlog]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[filemgr]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[infohis]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[infolng]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[infoqlt]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_default_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_default_tree]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_externaldevice_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_externaldevice_tree]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_generalinventory_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_generalinventory_tree]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_item_name_id]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_object_tree_id]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_performance_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_performance_tree]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_root_map]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_table_map]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[inv_tree_name_id]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[invgene]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[invsetup]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[joborder]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[linkbck]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[linkjob]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[linkmod]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[lockunit]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[logicalrelations]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[miftypes]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncipc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncjobbin]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncjobcfg]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[nclog]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncmodbin]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncmodcfg]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncovervw]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncprofil]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ncrc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[nctngref]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[nctpldef]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[openunit]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[policonf]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[polidef]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[polijob]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[polilog]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpauto]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpdatcat]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpdatfld]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpdatqry]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpdatsrc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpdattyp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpfield]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpfilter]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpglobal]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpipc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rppub]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpresult]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpstats]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rptables]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rptpl]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rptree]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[rpview]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[signature_os_group]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[snapmain]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[snapmemo]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[statjob]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[statjobm]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[statmod]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[statmodm]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[strlst]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[tng_adminstatus]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[tng_interface_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[tng_managedobject]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[tng_status]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[unitsec]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[unittype]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[upm_event]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[upm_name_value_pair]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_ab_computer]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_ab_group_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_ab_group_member]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_ab_permission]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_active_session]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_local_server]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_schema_version]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_activity]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_actproc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_apdep]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_applic]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_carrier]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_cc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_class_version]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_cmp_grp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_cont]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_contfold]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_distap]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_distsw]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_disttempl]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_fio]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_fitem]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_jcappgr]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_jcview]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_job_cont]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_act_cmp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_act_grp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_act_inst]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_cfold_cont]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_cmpgrp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_contfold]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_grp_cmp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_grp_proc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_jc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_jc_act]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_jc_srv]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_swg_sw]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_link_swgrp]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_order]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_rsw]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_swfold]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_target]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_task]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[usd_volume]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[amephis]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_asset]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_class_ace]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_class_hierarchy]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_config_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_config_item_doc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_dir_details_map]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_named_config_doc]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_named_config_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_manager_component]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_query_version]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_replication_status]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_requirement_spec]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_software_license]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[tplmemo]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_logical_asset]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_query_result]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_requirement_spec_group]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_asset_class]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_asset_source]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_logical_asset_property]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_requirement_spec_item]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_agent]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_cateGOry_member]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_company]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_contact]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_contact_type]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_discovered_hardware]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT  ON [dbo].[ca_discovered_hardware_ext_sys]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_discovered_software]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_discovered_software_prop]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_discovered_user]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_engine]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_group_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_group_member]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_install_package]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_install_step]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_configured_service]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_contact_user]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_dis_hw]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_dis_hw_user]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_dis_user_sec_profile]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_lic_def_domain]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_license_sw_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_link_sw_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_location]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_n_tier]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_organization]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_owned_resource]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_server]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_server_component]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_server_push_status]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_server_queue]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_software_def]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_software_def_class_def_matrix]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_software_def_types]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[ca_software_signature]  TO [ca_itrm_group_ams]
GO
GRANT  SELECT   ON [dbo].[urc_computer]  TO [ca_itrm_group_ams]
GO
/* ************************************** 9295 end ****************** */

/* ********************** 8995 begin ******************** */

/* optimization of usd_applic access */

CREATE NONCLUSTERED INDEX [usd_applic0] ON [dbo].[usd_applic] ([target] ASC )
go
CREATE NONCLUSTERED INDEX [usd_applic1] ON [dbo].[usd_applic] ([activity] ASC )
go
CREATE NONCLUSTERED INDEX [usd_applic2] ON [dbo].[usd_applic] ([installation] ASC )
go
CREATE NONCLUSTERED INDEX [usd_applic3] ON [dbo].[usd_applic] ([applicationgroup] ASC)
go
/* ********************** 8995 end ******************** */

/* *********************** 9299 begin ************************************ */


 CREATE  INDEX [ca_disc_software_idx_05] ON [dbo].[ca_discovered_software]([auto_rep_version],[sw_def_uuid]) ON [PRIMARY]
go

/* *********************** 9299 end ************************************ */



/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14556290, getdate(), 1, 4, 'Star 14556290 DSM:MSSQL General Table Index and User changes' )
GO

COMMIT TRANSACTION 
GO


