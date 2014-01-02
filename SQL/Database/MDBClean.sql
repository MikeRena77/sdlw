/* MDBClean.sql
 *
 * This script will remove all MDB objects which do not belong to the CA SCM product.
 * 
 * EXAMPLE: sqlcmd -S (local) -d mdb -e -E -i MDBClean.sql -o MDBClean.log 
 *
 * Copyright (c) 2007 Computer Associates inc. All rights reserved.
 *
 */
 

PRINT  'Removing all MDB objects which do not belong to the CA SCM Product...' 
GO

PRINT  'Disable Constraints' 
GO

exec sp_MSforeachtable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL' 
GO
exec sp_MSforeachtable 'ALTER TABLE ? DISABLE TRIGGER ALL' 
GO

create  procedure utility$removeAllRelationships
(
 @table_schema  sysname = 'dbo', 
 @parent_table_name sysname = '%', 
 @child_table_name sysname = '%', 
      --to another
 @constraint_name sysname = '%'  
) as
 begin
 set nocount on
 declare @statements cursor
 set @statements = cursor static for
 select  'alter table ' + quotename(ctu.table_schema) + '.' + quotename(ctu.table_name) +
         ' drop constraint ' + quotename(cc.constraint_name)
 from  INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS as cc
          join INFORMATION_SCHEMA.CONSTRAINT_TABLE_USAGE as ctu
           on cc.constraint_catalog = ctu.constraint_catalog
              and cc.constraint_schema = ctu.constraint_schema
              and cc.constraint_name = ctu.constraint_name
 where   ctu.table_schema = @table_schema
   and ctu.table_name like @child_table_name
   and cc.constraint_name like @constraint_name
   and lower(ctu.table_name) not like lower('har%')
 open @statements
 declare @statement nvarchar(1000)
 While  (1=1)
  begin
         fetch from @statements into @statement
                if @@fetch_status <> 0
                 break
                exec (@statement)
         end
 end
GO

exec utility$removeAllRelationships
GO
DROP PROCEDURE utility$removeAllRelationships
GO

PRINT  'Drop Functions' 
GO

DROP FUNCTION bit_and 
GO
DROP FUNCTION byte 
GO
DROP FUNCTION date 
GO
DROP FUNCTION date_part 
GO
DROP FUNCTION date_trunc 
GO
DROP FUNCTION decimal 
GO
DROP FUNCTION dow 
GO
DROP FUNCTION float8 
GO
DROP FUNCTION hex 
GO
DROP FUNCTION ifnull 
GO
DROP FUNCTION int4 
GO
DROP FUNCTION ip2hex 
GO
DROP FUNCTION isoyear 
GO
DROP FUNCTION mod 
GO
DROP FUNCTION ols_fn_getAreaAceByUser 
GO
DROP FUNCTION ols_fn_getAreaAceByUserUuid 
GO
DROP FUNCTION ols_fn_getAreaSecLevelByUser 
GO
DROP FUNCTION ols_fn_getGroupAreaPerm 
GO
DROP FUNCTION ServerAddrToStr 
GO
DROP FUNCTION StrToIP 
GO
DROP FUNCTION trim 
GO
DROP FUNCTION unhex 
GO
DROP FUNCTION uuid_from_char 
GO
DROP FUNCTION uuid_to_char 
GO
DROP FUNCTION varchar 
GO
DROP FUNCTION _time 
GO

PRINT  'Drop Procedures' 
GO

DROP PROCEDURE ADD_UND_ERROR 
GO
DROP PROCEDURE ADD_UND_JOB 
GO
DROP PROCEDURE ADD_UND_PROBE 
GO
DROP PROCEDURE ADD_UND_USER 
GO
DROP PROCEDURE am_proc_delete_unit 
GO
DROP PROCEDURE backup_p_del_agent 
GO
DROP PROCEDURE backup_p_del_job 
GO
DROP PROCEDURE backup_p_job_seq_number 
GO
DROP PROCEDURE backup_p_reset_agent_backup_stat 
GO
DROP PROCEDURE backup_p_set_agent_backup_status 
GO
DROP PROCEDURE backup_p_set_backup_status 
GO
DROP PROCEDURE bckdef_server_version 
GO
DROP PROCEDURE ca_agent_server_version_by_unit 
GO
DROP PROCEDURE ca_agent_server_version_by_uuid 
GO
DROP PROCEDURE ca_am_update_agent_derived 
GO
DROP PROCEDURE ca_insert_class 
GO
DROP PROCEDURE ca_merge_class_for_logical_asset 
GO
DROP PROCEDURE DELETE_UND_ERROR 
GO
DROP PROCEDURE DELETE_UND_JOB 
GO
DROP PROCEDURE DELETE_UND_PROBE 
GO
DROP PROCEDURE DELETE_UND_USER 
GO
DROP PROCEDURE dscv_add_class_rule 
GO
DROP PROCEDURE dscv_add_combo_class_rule 
GO
DROP PROCEDURE dscv_add_method 
GO
DROP PROCEDURE dscv_add_method_instance 
GO
DROP PROCEDURE dscv_add_method_param 
GO
DROP PROCEDURE dscv_add_relationship 
GO
DROP PROCEDURE e2e_wrm_summarize_wrm 
GO
DROP PROCEDURE e2e_wrm_sum_request_bytime 
GO
DROP PROCEDURE e2e_wrm_sum_tran_bytime 
GO
DROP PROCEDURE e2e_wrm_sum_tran_req_bytime 
GO
DROP PROCEDURE invalid_func 
GO
DROP PROCEDURE JMO_GBL_Del 
GO
DROP PROCEDURE JMO_GBL_Ins 
GO
DROP PROCEDURE JMO_GBL_Self 
GO
DROP PROCEDURE JMO_GBL_Selp 
GO
DROP PROCEDURE JMO_GBL_Upd 
GO
DROP PROCEDURE JMO_GEN_Del 
GO
DROP PROCEDURE JMO_GEN_Ins 
GO
DROP PROCEDURE JMO_GEN_Self 
GO
DROP PROCEDURE JMO_GEN_Selp 
GO
DROP PROCEDURE JMO_GEN_Upd 
GO
DROP PROCEDURE JMO_HSTU_Del 
GO
DROP PROCEDURE JMO_HSTU_Ins 
GO
DROP PROCEDURE JMO_HSTU_Self 
GO
DROP PROCEDURE JMO_HSTU_Selp 
GO
DROP PROCEDURE JMO_HSTU_Upd 
GO
DROP PROCEDURE JMO_JBR_Del 
GO
DROP PROCEDURE JMO_JBR_DelT 
GO
DROP PROCEDURE JMO_JBR_DelY 
GO
DROP PROCEDURE JMO_JBR_Ins 
GO
DROP PROCEDURE JMO_JBR_Self 
GO
DROP PROCEDURE JMO_JBR_Selp 
GO
DROP PROCEDURE JMO_JBR_Upd 
GO
DROP PROCEDURE JMO_JHR_Del 
GO
DROP PROCEDURE JMO_JHR_Ins 
GO
DROP PROCEDURE JMO_JHR_Self 
GO
DROP PROCEDURE JMO_JHR_Selp 
GO
DROP PROCEDURE JMO_JHR_Upd 
GO
DROP PROCEDURE JMO_JTR1_Del 
GO
DROP PROCEDURE JMO_JTR1_DelA 
GO
DROP PROCEDURE JMO_JTR1_Ins 
GO
DROP PROCEDURE JMO_JTR1_Self 
GO
DROP PROCEDURE JMO_JTR1_Selp 
GO
DROP PROCEDURE JMO_JTR1_Upd 
GO
DROP PROCEDURE JMO_JTR_Del 
GO
DROP PROCEDURE JMO_JTR_DelA 
GO
DROP PROCEDURE JMO_JTR_Ins 
GO
DROP PROCEDURE JMO_JTR_Self 
GO
DROP PROCEDURE JMO_JTR_Selp 
GO
DROP PROCEDURE JMO_JTR_Upd 
GO
DROP PROCEDURE JMO_JWB_Del 
GO
DROP PROCEDURE JMO_JWB_Ins 
GO
DROP PROCEDURE JMO_JWB_Self 
GO
DROP PROCEDURE JMO_JWB_Selp 
GO
DROP PROCEDURE JMO_JWB_Upd 
GO
DROP PROCEDURE JMO_MWC_Del 
GO
DROP PROCEDURE JMO_MWC_Ins 
GO
DROP PROCEDURE JMO_MWC_Self 
GO
DROP PROCEDURE JMO_MWC_Selp 
GO
DROP PROCEDURE JMO_MWC_Upd 
GO
DROP PROCEDURE JMO_NOD_Del 
GO
DROP PROCEDURE JMO_NOD_Ins 
GO
DROP PROCEDURE JMO_NOD_Self 
GO
DROP PROCEDURE JMO_NOD_Selp 
GO
DROP PROCEDURE JMO_NOD_Upd 
GO
DROP PROCEDURE JMO_PRB_Del 
GO
DROP PROCEDURE JMO_PRB_Ins 
GO
DROP PROCEDURE JMO_PRB_Self 
GO
DROP PROCEDURE JMO_PRB_Selp 
GO
DROP PROCEDURE JMO_PRB_Upd 
GO
DROP PROCEDURE JMO_PRT1_Del 
GO
DROP PROCEDURE JMO_PRT1_DelA 
GO
DROP PROCEDURE JMO_PRT1_Ins 
GO
DROP PROCEDURE JMO_PRT1_Self 
GO
DROP PROCEDURE JMO_PRT1_Selp 
GO
DROP PROCEDURE JMO_PRT1_Upd 
GO
DROP PROCEDURE JMO_PRT_Del 
GO
DROP PROCEDURE JMO_PRT_DelA 
GO
DROP PROCEDURE JMO_PRT_Ins 
GO
DROP PROCEDURE JMO_PRT_Self 
GO
DROP PROCEDURE JMO_PRT_Selp 
GO
DROP PROCEDURE JMO_PRT_Upd 
GO
DROP PROCEDURE JMO_PSR1_Del 
GO
DROP PROCEDURE JMO_PSR1_DelA 
GO
DROP PROCEDURE JMO_PSR1_Ins 
GO
DROP PROCEDURE JMO_PSR1_Self 
GO
DROP PROCEDURE JMO_PSR1_Selj 
GO
DROP PROCEDURE JMO_PSR1_Selp 
GO
DROP PROCEDURE JMO_PSR1_Sels 
GO
DROP PROCEDURE JMO_PSR1_Upd 
GO
DROP PROCEDURE JMO_PSRM_Del 
GO
DROP PROCEDURE JMO_PSRM_Ins 
GO
DROP PROCEDURE JMO_PSRM_Self 
GO
DROP PROCEDURE JMO_PSRM_Selj 
GO
DROP PROCEDURE JMO_PSRM_Selp 
GO
DROP PROCEDURE JMO_PSRM_Sels 
GO
DROP PROCEDURE JMO_PSRM_Upd 
GO
DROP PROCEDURE JMO_PSRT_Del 
GO
DROP PROCEDURE JMO_PSRT_DelA 
GO
DROP PROCEDURE JMO_PSRT_Ins 
GO
DROP PROCEDURE JMO_PSRT_Self 
GO
DROP PROCEDURE JMO_PSRT_Selj 
GO
DROP PROCEDURE JMO_PSRT_Selp 
GO
DROP PROCEDURE JMO_PSRT_Sels 
GO
DROP PROCEDURE JMO_PSRT_Upd 
GO
DROP PROCEDURE JMO_SBR_Del 
GO
DROP PROCEDURE JMO_SBR_DelT 
GO
DROP PROCEDURE JMO_SBR_DelY 
GO
DROP PROCEDURE JMO_SBR_Ins 
GO
DROP PROCEDURE JMO_SBR_Self 
GO
DROP PROCEDURE JMO_SBR_Selp 
GO
DROP PROCEDURE JMO_SBR_Upd 
GO
DROP PROCEDURE JMO_SHR_Del 
GO
DROP PROCEDURE JMO_SHR_Ins 
GO
DROP PROCEDURE JMO_SHR_Self 
GO
DROP PROCEDURE JMO_SHR_Selp 
GO
DROP PROCEDURE JMO_SHR_Upd 
GO
DROP PROCEDURE JMO_STR1_Del 
GO
DROP PROCEDURE JMO_STR1_DelA 
GO
DROP PROCEDURE JMO_STR1_Ins 
GO
DROP PROCEDURE JMO_STR1_Self 
GO
DROP PROCEDURE JMO_STR1_Selp 
GO
DROP PROCEDURE JMO_STR1_Upd 
GO
DROP PROCEDURE JMO_STR_Del 
GO
DROP PROCEDURE JMO_STR_DelA 
GO
DROP PROCEDURE JMO_STR_Ins 
GO
DROP PROCEDURE JMO_STR_Self 
GO
DROP PROCEDURE JMO_STR_Selp 
GO
DROP PROCEDURE JMO_STR_Upd 
GO
DROP PROCEDURE JMO_SWB_Del 
GO
DROP PROCEDURE JMO_SWB_Ins 
GO
DROP PROCEDURE JMO_SWB_Self 
GO
DROP PROCEDURE JMO_SWB_Selp 
GO
DROP PROCEDURE JMO_SWB_Upd 
GO
DROP PROCEDURE JMO_TRG_Del 
GO
DROP PROCEDURE JMO_TRG_Ins 
GO
DROP PROCEDURE JMO_TRG_Self 
GO
DROP PROCEDURE JMO_TRG_Selp 
GO
DROP PROCEDURE JMO_TRG_Upd 
GO
DROP PROCEDURE JMO_TRT1_Del 
GO
DROP PROCEDURE JMO_TRT1_DelA 
GO
DROP PROCEDURE JMO_TRT1_Ins 
GO
DROP PROCEDURE JMO_TRT1_Self 
GO
DROP PROCEDURE JMO_TRT1_Selp 
GO
DROP PROCEDURE JMO_TRT1_Upd 
GO
DROP PROCEDURE JMO_TRT_Del 
GO
DROP PROCEDURE JMO_TRT_DelA 
GO
DROP PROCEDURE JMO_TRT_Ins 
GO
DROP PROCEDURE JMO_TRT_Self 
GO
DROP PROCEDURE JMO_TRT_Selp 
GO
DROP PROCEDURE JMO_TRT_Upd 
GO
DROP PROCEDURE JMO_WBR_Self 
GO
DROP PROCEDURE JMO_WBR_Selp 
GO
DROP PROCEDURE ncjobcfg_server_version 
GO
DROP PROCEDURE ncmodcfg_server_version 
GO
DROP PROCEDURE nctpldef_server_version 
GO
DROP PROCEDURE ols_ac_reset 
GO
DROP PROCEDURE ols_ac_setup_area_ace 
GO
DROP PROCEDURE ols_ac_setup_sp 
GO
DROP PROCEDURE ols_sp_applyAreaMask 
GO
DROP PROCEDURE ols_sp_area_changed 
GO
DROP PROCEDURE ols_sp_getEffectiveAreaAce 
GO
DROP PROCEDURE ols_sp_setAreaCodeByUser 
GO
DROP PROCEDURE ols_sp_setObjectOwner 
GO
DROP PROCEDURE proc_d_so_removed_group_member 
GO
DROP PROCEDURE proc_d_so_removed_object 
GO
DROP PROCEDURE proc_d_so_removed_security_prof 
GO
DROP PROCEDURE proc_d_so_removed_user 
GO
DROP PROCEDURE proc_i_del_so_csm_object 
GO
DROP PROCEDURE proc_i_del_so_usd_group 
GO
DROP PROCEDURE proc_i_new_so_activity_object 
GO
DROP PROCEDURE proc_i_new_so_csm_object 
GO
DROP PROCEDURE proc_i_new_so_group 
GO
DROP PROCEDURE proc_i_new_so_group_member 
GO
DROP PROCEDURE proc_i_new_so_object 
GO
DROP PROCEDURE proc_i_new_so_procedure_object 
GO
DROP PROCEDURE proc_i_new_so_rptree 
GO
DROP PROCEDURE proc_i_new_so_security_profile 
GO
DROP PROCEDURE proc_i_new_so_usd_group 
GO
DROP PROCEDURE proc_i_new_so_usd_job_container 
GO
DROP PROCEDURE proc_i_new_so_user 
GO
DROP PROCEDURE proc_i_so_class_def 
GO
DROP PROCEDURE proc_i_so_inserted_group_ace 
GO
DROP PROCEDURE proc_i_so_new_job 
GO
DROP PROCEDURE proc_i_so_new_module 
GO
DROP PROCEDURE proc_upd_so_csm_object 
GO
DROP PROCEDURE proc_upd_so_usd_group_sec_grp 
GO
DROP PROCEDURE proc_u_so_area_revert 
GO
DROP PROCEDURE proc_u_so_class_ace 
GO
DROP PROCEDURE proc_u_so_updated_group 
GO
DROP PROCEDURE proc_u_so_updated_group_ace 
GO
DROP PROCEDURE proc_u_so_updated_object_ace 
GO
DROP PROCEDURE p_d_discovered_hardware 
GO
DROP PROCEDURE p_d_discovered_user 
GO
DROP PROCEDURE p_integrity_component_reg 
GO
DROP PROCEDURE p_integrity_d_agent 
GO
DROP PROCEDURE p_integrity_d_directory_details 
GO
DROP PROCEDURE p_integrity_d_dir_schema_map 
GO
DROP PROCEDURE p_integrity_d_engine 
GO
DROP PROCEDURE p_integrity_d_manager 
GO
DROP PROCEDURE p_integrity_d_proc_os 
GO
DROP PROCEDURE p_integrity_d_query_def 
GO
DROP PROCEDURE p_integrity_d_server 
GO
DROP PROCEDURE p_integrity_version_number 
GO
DROP PROCEDURE p_iu_computer_user 
GO
DROP PROCEDURE p_iu_dis_hw_host_uuid 
GO
DROP PROCEDURE p_iu_dis_user_uri_check 
GO
DROP PROCEDURE p_iu_group_member 
GO
DROP PROCEDURE p_i_dis_user_uri_check 
GO
DROP PROCEDURE p_sp_ssf_versionupdate 
GO
DROP PROCEDURE p_urc_ab_ca_agent_updated 
GO
DROP PROCEDURE p_urc_ab_ca_discvd_hw_updated 
GO
DROP PROCEDURE p_urc_ab_ca_group_def_deleted 
GO
DROP PROCEDURE p_urc_ab_ca_group_def_updated 
GO
DROP PROCEDURE p_urc_ab_ca_group_member_created 
GO
DROP PROCEDURE p_urc_ab_ca_group_member_deleted 
GO
DROP PROCEDURE p_urc_ab_ca_group_member_updated 
GO
DROP PROCEDURE p_urc_ab_ca_n_tier_updated 
GO
DROP PROCEDURE p_urc_ab_computer_created 
GO
DROP PROCEDURE p_urc_ab_group_member_create 
GO
DROP PROCEDURE p_urc_ab_update_parents 
GO
DROP PROCEDURE p_urc_computer_created 
GO
DROP PROCEDURE p_urc_computer_deleted 
GO
DROP PROCEDURE p_urc_computer_updated 
GO
DROP PROCEDURE SELECT_UND_ANIMATION_IP 
GO
DROP PROCEDURE SELECT_UND_ANIMATION_MAC 
GO
DROP PROCEDURE SELECT_UND_IP_MAC 
GO
DROP PROCEDURE SELECT_UND_IP_VND 
GO
DROP PROCEDURE SELECT_UND_PROTO_BY_FROM_IP 
GO
DROP PROCEDURE SELECT_UND_PROTO_BY_FROM_MAC 
GO
DROP PROCEDURE SELECT_UND_PROTO_BY_JOB 
GO
DROP PROCEDURE SELECT_UND_PROTO_BY_TO_IP 
GO
DROP PROCEDURE SELECT_UND_PROTO_BY_TO_MAC 
GO
DROP PROCEDURE send_event 
GO
DROP PROCEDURE setDateFirst 
GO
DROP PROCEDURE tng_add_2d_icon 
GO
DROP PROCEDURE tng_add_3d_icon 
GO
DROP PROCEDURE tng_add_alarmset 
GO
DROP PROCEDURE tng_add_auth 
GO
DROP PROCEDURE tng_add_class 
GO
DROP PROCEDURE tng_add_class_ext 
GO
DROP PROCEDURE tng_add_managedobject 
GO
DROP PROCEDURE tng_add_manuf 
GO
DROP PROCEDURE tng_add_method 
GO
DROP PROCEDURE tng_add_pollset 
GO
DROP PROCEDURE tng_add_propertydef 
GO
DROP PROCEDURE tng_add_sysobjid 
GO
DROP PROCEDURE tng_add_to_alarmset_entry 
GO
DROP PROCEDURE tng_ca_add_subnet1 
GO
DROP PROCEDURE tng_ca_add_subnet2 
GO
DROP PROCEDURE tng_ca_claim_discovery 
GO
DROP PROCEDURE tng_ca_devices_under_subnet 
GO
DROP PROCEDURE tng_ca_update_discovery_setup 
GO
DROP PROCEDURE tng_ca_update_discovery_status 
GO
DROP PROCEDURE tng_clean_change_history 
GO
DROP PROCEDURE tng_clean_prop_status_history 
GO
DROP PROCEDURE tng_clean_status_history 
GO
DROP PROCEDURE tng_DelUncls_IpDiffName_UptClsIp 
GO
DROP PROCEDURE tng_del_uncls_w_name_option_ip 
GO
DROP PROCEDURE tng_discovery_get_community 
GO
DROP PROCEDURE tng_discovery_get_drg_swtypes 
GO
DROP PROCEDURE tng_discovery_get_ip_subnet 
GO
DROP PROCEDURE tng_discovery_get_lookup 
GO
DROP PROCEDURE tng_discovery_get_setup_date 
GO
DROP PROCEDURE tng_get_class_ilp 
GO
DROP PROCEDURE tng_get_IF_uuid 
GO
DROP PROCEDURE tng_get_network_class 
GO
DROP PROCEDURE tng_get_segment_name 
GO
DROP PROCEDURE tng_get_subnet_IF_connect_to 
GO
DROP PROCEDURE tng_get_super_class_name 
GO
DROP PROCEDURE tng_get_uuid_classname_by_name 
GO
DROP PROCEDURE tng_iphex2str_nd 
GO
DROP PROCEDURE tng_ipstr2iphex 
GO
DROP PROCEDURE tng_IsDiffClsSameIpNameExist 
GO
DROP PROCEDURE tng_is_attr_same_as_superclass 
GO
DROP PROCEDURE tng_is_man_obj_exist_w_sameip 
GO
DROP PROCEDURE tng_is_obj_exist_class_name_ip 
GO
DROP PROCEDURE tng_is_obj_exist_w_name_diff_ip 
GO
DROP PROCEDURE tng_is_same_property 
GO
DROP PROCEDURE tng_manag_all_discovery_ipsubnet 
GO
DROP PROCEDURE tng_senderror 
GO
DROP PROCEDURE tng_setup_status 
GO
DROP PROCEDURE tng_start_service 
GO
DROP PROCEDURE tng_stop_service 
GO
DROP PROCEDURE tng_unmanage_discovery_ipsubnet 
GO
DROP PROCEDURE tng_upd_segment_uuid 
GO
DROP PROCEDURE ujo_audit_info_log 
GO
DROP PROCEDURE ujo_audit_msg_log 
GO
DROP PROCEDURE ujo_batch_get_event 
GO
DROP PROCEDURE ujo_bump_digit 
GO
DROP PROCEDURE ujo_chase_state 
GO
DROP PROCEDURE ujo_chk_cond 
GO
DROP PROCEDURE ujo_chk_running 
GO
DROP PROCEDURE ujo_cred_delete 
GO
DROP PROCEDURE ujo_cred_get 
GO
DROP PROCEDURE ujo_cred_set 
GO
DROP PROCEDURE ujo_det_rep 
GO
DROP PROCEDURE ujo_event_state 
GO
DROP PROCEDURE ujo_get_eoid 
GO
DROP PROCEDURE ujo_get_ext_event 
GO
DROP PROCEDURE ujo_get_id 
GO
DROP PROCEDURE ujo_get_jobrow 
GO
DROP PROCEDURE ujo_get_job_status 
GO
DROP PROCEDURE ujo_get_machine 
GO
DROP PROCEDURE ujo_get_mach_jobs 
GO
DROP PROCEDURE ujo_get_run_num 
GO
DROP PROCEDURE ujo_glob_set 
GO
DROP PROCEDURE ujo_init_jobset 
GO
DROP PROCEDURE ujo_job_lookup 
GO
DROP PROCEDURE ujo_lic_check 
GO
DROP PROCEDURE ujo_move_event 
GO
DROP PROCEDURE ujo_put_jobrow 
GO
DROP PROCEDURE ujo_put_monbro 
GO
DROP PROCEDURE ujo_put_sendbuf 
GO
DROP PROCEDURE ujo_return_int 
GO
DROP PROCEDURE ujo_sendevent 
GO
DROP PROCEDURE ujo_send_event 
GO
DROP PROCEDURE ujo_set2act 
GO
DROP PROCEDURE ujo_setNget_status 
GO
DROP PROCEDURE ujo_set_Eoid_counter 
GO
DROP PROCEDURE ujo_set_job_status 
GO
DROP PROCEDURE ujo_sum_rep 
GO
DROP PROCEDURE ujo_time_offset 
GO
DROP PROCEDURE UPDATE_UND_JOB_STATUS 
GO
DROP PROCEDURE UPDATE_UND_TASK_STATUS 
GO
DROP PROCEDURE usd_activity_acttime_allcltn 
GO
DROP PROCEDURE usd_act_appl_cmpname_cltn 
GO
DROP PROCEDURE usd_act_appl_cmpname_cltn_ro 
GO
DROP PROCEDURE usd_act_cmp_name_cltn 
GO
DROP PROCEDURE usd_act_cmp_name_cltn_ro 
GO
DROP PROCEDURE usd_act_grp_name_cltn 
GO
DROP PROCEDURE usd_act_grp_name_cltn_ro 
GO
DROP PROCEDURE usd_act_inst_instoid_cltn 
GO
DROP PROCEDURE usd_act_inst_instoid_cltn_ro 
GO
DROP PROCEDURE usd_act_jc_name_cltn 
GO
DROP PROCEDURE usd_act_jc_name_cltn_ro 
GO
DROP PROCEDURE usd_agrp_name_allcltn 
GO
DROP PROCEDURE usd_app_inst_acttime_cltn 
GO
DROP PROCEDURE usd_app_inst_acttime_cltn_ro 
GO
DROP PROCEDURE usd_ap_apdep_ordernr_cltn 
GO
DROP PROCEDURE usd_ap_apdep_ordernr_cltn_ro 
GO
DROP PROCEDURE usd_ap_applic_nosort_cltn 
GO
DROP PROCEDURE usd_ap_applic_nosort_cltn_ro 
GO
DROP PROCEDURE usd_ap_distap_nosort_cltn 
GO
DROP PROCEDURE usd_ap_distap_nosort_cltn_ro 
GO
DROP PROCEDURE usd_ap_swfold_name_cltn 
GO
DROP PROCEDURE usd_ap_swfold_name_cltn_ro 
GO
DROP PROCEDURE usd_assetgrp_cmp_name_cltn 
GO
DROP PROCEDURE usd_assetgrp_cmp_name_cltn_ro 
GO
DROP PROCEDURE usd_assetgrp_jc_name_cltn 
GO
DROP PROCEDURE usd_assetgrp_jc_name_cltn_ro 
GO
DROP PROCEDURE usd_assetgrp_subgrp_name_cltn 
GO
DROP PROCEDURE usd_assetgrp_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_assetgrp_supgrp_name_cltn 
GO
DROP PROCEDURE usd_assetgrp_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_assetgrp_swgr_nosort_cltn 
GO
DROP PROCEDURE usd_assetgrp_swgr_nosort_cltn_ro 
GO
DROP PROCEDURE usd_cfold_cont_disttime_cltn 
GO
DROP PROCEDURE usd_cfold_cont_disttime_cltn_ro 
GO
DROP PROCEDURE usd_cfold_subgrp_name_cltn 
GO
DROP PROCEDURE usd_cfold_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_cfold_supgrp_name_cltn 
GO
DROP PROCEDURE usd_cfold_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_cgrp_name_allcltn 
GO
DROP PROCEDURE usd_cmpgrp_cmp_name_cltn 
GO
DROP PROCEDURE usd_cmpgrp_cmp_name_cltn_ro 
GO
DROP PROCEDURE usd_cmpgrp_subgrp_name_cltn 
GO
DROP PROCEDURE usd_cmpgrp_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_cmpgrp_supgrp_name_cltn 
GO
DROP PROCEDURE usd_cmpgrp_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_cmp_applic_actprocid_cltn 
GO
DROP PROCEDURE usd_cmp_applic_actprocid_cltn_ro 
GO
DROP PROCEDURE usd_cmp_applic_itemname_cltn 
GO
DROP PROCEDURE usd_cmp_applic_itemname_cltn_ro 
GO
DROP PROCEDURE usd_cmp_appl_appltime_cltn 
GO
DROP PROCEDURE usd_cmp_appl_appltime_cltn_ro 
GO
DROP PROCEDURE usd_cmp_comp_ssname_cltn 
GO
DROP PROCEDURE usd_cmp_group_groupname_cltn 
GO
DROP PROCEDURE usd_cmp_group_groupname_cltn_ro 
GO
DROP PROCEDURE usd_cmp_name_allcltn 
GO
DROP PROCEDURE usd_cmp_ss_comp_name_cltn 
GO
DROP PROCEDURE usd_cmp_ss_comp_name_cltn_ro 
GO
DROP PROCEDURE usd_compos_id_allcltn 
GO
DROP PROCEDURE usd_contfold_name_allcltn 
GO
DROP PROCEDURE usd_cont_ccarr_nosort_cltn 
GO
DROP PROCEDURE usd_cont_ccarr_nosort_cltn_ro 
GO
DROP PROCEDURE usd_cont_cfold_name_cltn 
GO
DROP PROCEDURE usd_cont_cfold_name_cltn_ro 
GO
DROP PROCEDURE usd_cont_disttime_allcltn 
GO
DROP PROCEDURE usd_cont_name_allcltn 
GO
DROP PROCEDURE usd_cont_order_orderno_cltn 
GO
DROP PROCEDURE usd_cont_order_orderno_cltn_ro 
GO
DROP PROCEDURE usd_csite_siteid_allcltn 
GO
DROP PROCEDURE usd_dispap_nosort_allcltn 
GO
DROP PROCEDURE usd_distsw_distap_nosort_cltn 
GO
DROP PROCEDURE usd_distsw_distap_nosort_cltn_ro 
GO
DROP PROCEDURE usd_fio_fitems_nosort_cltn 
GO
DROP PROCEDURE usd_fio_fitems_nosort_cltn_ro 
GO
DROP PROCEDURE usd_fio_name_allcltn 
GO
DROP PROCEDURE usd_jcappgr_appl_nosort_cltn 
GO
DROP PROCEDURE usd_jcappgr_appl_nosort_cltn_ro 
GO
DROP PROCEDURE usd_jcview_jcapgr_nosort_cltn 
GO
DROP PROCEDURE usd_jcview_jcapgr_nosort_cltn_ro 
GO
DROP PROCEDURE usd_jc_act_order_cltn 
GO
DROP PROCEDURE usd_jc_act_order_cltn_ro 
GO
DROP PROCEDURE usd_jc_distemp_time_cltn 
GO
DROP PROCEDURE usd_jc_distemp_time_cltn_ro 
GO
DROP PROCEDURE usd_jc_jcview_nosort_cltn 
GO
DROP PROCEDURE usd_jc_jcview_nosort_cltn_ro 
GO
DROP PROCEDURE usd_jc_server_nosort_cltn 
GO
DROP PROCEDURE usd_jc_server_nosort_cltn_ro 
GO
DROP PROCEDURE usd_jc_subgrp_name_cltn 
GO
DROP PROCEDURE usd_jc_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_jc_supgrp_name_cltn 
GO
DROP PROCEDURE usd_jc_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_jobcont_name_allcltn 
GO
DROP PROCEDURE usd_lsgrp_ls_siteid_cltn 
GO
DROP PROCEDURE usd_lsgrp_ls_siteid_cltn_ro 
GO
DROP PROCEDURE usd_lsgrp_name_allcltn 
GO
DROP PROCEDURE usd_lsgrp_subgrp_name_cltn 
GO
DROP PROCEDURE usd_lsgrp_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_lsgrp_supgrp_name_cltn 
GO
DROP PROCEDURE usd_lsgrp_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_ls_distemp_time_cltn 
GO
DROP PROCEDURE usd_ls_distemp_time_cltn_ro 
GO
DROP PROCEDURE usd_ls_distsw_namever_cltn 
GO
DROP PROCEDURE usd_ls_distsw_namever_cltn_ro 
GO
DROP PROCEDURE usd_ls_fitems_nametime_cltn 
GO
DROP PROCEDURE usd_ls_fitems_nametime_cltn_ro 
GO
DROP PROCEDURE usd_ls_lsg_name_cltn 
GO
DROP PROCEDURE usd_ls_lsg_name_cltn_ro 
GO
DROP PROCEDURE usd_ls_siteid_allcltn 
GO
DROP PROCEDURE usd_order_nosort_allcltn 
GO
DROP PROCEDURE usd_ownsite_siteid_allcltn 
GO
DROP PROCEDURE usd_procos_id_allcltn 
GO
DROP PROCEDURE usd_proc_u_tbl_ver 
GO
DROP PROCEDURE usd_p_container_fd_jobs 
GO
DROP PROCEDURE usd_p_container_fd_jobs_s 
GO
DROP PROCEDURE usd_p_container_installations 
GO
DROP PROCEDURE usd_p_container_installations_s 
GO
DROP PROCEDURE usd_p_container_jobs 
GO
DROP PROCEDURE usd_p_container_jobs_s 
GO
DROP PROCEDURE usd_p_group_fd_jobs 
GO
DROP PROCEDURE usd_p_group_fd_jobs_s 
GO
DROP PROCEDURE usd_p_group_installed_products 
GO
DROP PROCEDURE usd_p_group_installed_products_s 
GO
DROP PROCEDURE usd_p_group_jobs 
GO
DROP PROCEDURE usd_p_group_jobs_s 
GO
DROP PROCEDURE usd_p_installed_products 
GO
DROP PROCEDURE usd_p_installed_products_s 
GO
DROP PROCEDURE usd_p_osim_targets 
GO
DROP PROCEDURE usd_p_osim_targets_s 
GO
DROP PROCEDURE usd_p_product_fd_jobs 
GO
DROP PROCEDURE usd_p_product_fd_jobs_s 
GO
DROP PROCEDURE usd_p_product_fd_procedures
GO
DROP PROCEDURE usd_p_product_fd_procedures_s 
GO
DROP PROCEDURE usd_p_product_jobs 
GO
DROP PROCEDURE usd_p_product_jobs_s 
GO
DROP PROCEDURE usd_p_product_procedures 
GO
DROP PROCEDURE usd_p_product_procedures_s 
GO
DROP PROCEDURE usd_p_sserver_clients 
GO
DROP PROCEDURE usd_p_sserver_clients_s 
GO
DROP PROCEDURE usd_p_targets_os 
GO
DROP PROCEDURE usd_p_targets_os_s 
GO
DROP PROCEDURE usd_p_target_fd_jobs 
GO
DROP PROCEDURE usd_p_target_fd_jobs_s 
GO
DROP PROCEDURE usd_p_target_jobs 
GO
DROP PROCEDURE usd_p_target_jobs_s 
GO
DROP PROCEDURE usd_rsw_ap_name_cltn 
GO
DROP PROCEDURE usd_rsw_ap_name_cltn_ro 
GO
DROP PROCEDURE usd_rsw_distsw_nosort_cltn 
GO
DROP PROCEDURE usd_rsw_distsw_nosort_cltn_ro 
GO
DROP PROCEDURE usd_rsw_fold_name_cltn 
GO
DROP PROCEDURE usd_rsw_fold_name_cltn_ro 
GO
DROP PROCEDURE usd_rsw_inclap_name_cltn 
GO
DROP PROCEDURE usd_rsw_inclap_name_cltn_ro 
GO
DROP PROCEDURE usd_rsw_name_allcltn 
GO
DROP PROCEDURE usd_rsw_nosort_allcltn 
GO
DROP PROCEDURE usd_rsw_vol_nosort_cltn 
GO
DROP PROCEDURE usd_rsw_vol_nosort_cltn_ro 
GO
DROP PROCEDURE usd_servgrp_srv_name_cltn 
GO
DROP PROCEDURE usd_servgrp_srv_name_cltn_ro 
GO
DROP PROCEDURE usd_servgrp_subgrp_name_cltn 
GO
DROP PROCEDURE usd_servgrp_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_servgrp_supgrp_name_cltn 
GO
DROP PROCEDURE usd_servgrp_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_sgrp_name_allcltn 
GO
DROP PROCEDURE usd_swfld_ap_nosort_cltn 
GO
DROP PROCEDURE usd_swfld_ap_nosort_cltn_ro 
GO
DROP PROCEDURE usd_swfld_rsw_nosort_cltn 
GO
DROP PROCEDURE usd_swfld_rsw_nosort_cltn_ro 
GO
DROP PROCEDURE usd_swfld_subgrp_name_cltn 
GO
DROP PROCEDURE usd_swfld_subgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_swfld_supgrp_name_cltn 
GO
DROP PROCEDURE usd_swfld_supgrp_name_cltn_ro 
GO
DROP PROCEDURE usd_swfold_name_allcltn 
GO
DROP PROCEDURE usd_task_nosort_allcltn 
GO
DROP PROCEDURE usd_vol_nosort_allcltn 
GO
DROP PROCEDURE usm_next_sequence_value 
GO

PRINT  'Drop Roles' 
GO

sp_dropRole aiadmin 
GO
sp_dropRole aionadmin_group 
GO
sp_dropRole aipublic 
GO
sp_dropRole amsgroup 
GO
sp_dropRole apmadmin 
GO
sp_dropRole apmuser 
GO
sp_dropRole apnm_admin 
GO
sp_dropRole apnm_user 
GO
sp_dropRole apwmv_admin 
GO
sp_dropRole apwmv_user 
GO
sp_dropRole asmoadmin 
GO
sp_dropRole asmouser 
GO
sp_dropRole backup_admin_group 
GO
sp_dropRole ca_itrm_group 
GO
sp_dropRole ca_itrm_group_ams 
GO
sp_dropRole cmdb_admin 
GO
sp_dropRole cmew_admin 
GO
sp_dropRole cmew_rdr 
GO
sp_dropRole dms_backup_group 
GO
sp_dropRole dsaadmin 
GO
sp_dropRole dscadmin 
GO
sp_dropRole dscuser 
GO
sp_dropRole emadmin 
GO
sp_dropRole emuser 
GO
sp_dropRole icanbill_group 
GO
sp_dropRole icancommon_group 
GO
sp_dropRole InfoPumpAdmin 
GO
sp_dropRole InfoPumpUsers 
GO
sp_dropRole jmoadmin 
GO
sp_dropRole jmouser 
GO
sp_dropRole pdadmin 
GO
sp_dropRole pduser 
GO
sp_dropRole portaldba_group 
GO
sp_dropRole regadmin 
GO
sp_dropRole sccadmingroup 
GO
sp_dropRole sccusergroup 
GO
sp_dropRole service_desk_admin_group 
GO
sp_dropRole service_desk_d_painter_group 
GO
sp_dropRole service_desk_ro_group 
GO
sp_dropRole siadmins 
GO
sp_dropRole uapmadmin_group 
GO
sp_dropRole uapmbatch_group 
GO
sp_dropRole uapmreporting_group 
GO
sp_dropRole ucmadmin 
GO
sp_dropRole ucmuser 
GO
sp_dropRole udmadmin_group 
GO
sp_dropRole ujoadmin 
GO
sp_dropRole umpadmin 
GO
sp_dropRole umpuser 
GO
sp_dropRole uniadmin 
GO
sp_dropRole uniuser 
GO
sp_dropRole upmadmin_group 
GO
sp_dropRole upmuser_group 
GO
sp_dropRole usmgroup 
GO
sp_dropRole workflow_admin_group 
GO
sp_dropRole workflow_ro_group 
GO
sp_dropRole wsm_admin_group 
GO
sp_dropRole wsm_ro_group 
GO
sp_dropRole wvadmin 
GO
sp_dropRole wvuser 
GO

PRINT  'Drop Rules' 
GO

DROP RULE r_macaddr 
GO

PRINT  'Drop Tables' 
GO

DROP TABLE acctyp 
GO
DROP TABLE acc_lvls 
GO
DROP TABLE actbool 
GO
DROP TABLE action 
GO
DROP TABLE actors 
GO
DROP TABLE actrbool 
GO
DROP TABLE act_log 
GO
DROP TABLE act_type 
GO
DROP TABLE addmemo 
GO
DROP TABLE addtext 
GO
DROP TABLE admin_tree 
GO
DROP TABLE aec_hist_report_v2 
GO
DROP TABLE aec_policy 
GO
DROP TABLE ai_fddef_prop 
GO
DROP TABLE ai_fsdef_prop 
GO
DROP TABLE ai_hfdef_hwdef_rel 
GO
DROP TABLE ai_hfdef_instcnt_kpi 
GO
DROP TABLE ai_hfdef_prop 
GO
DROP TABLE ai_hwdef_classdef_rel 
GO
DROP TABLE ai_hwdef_cpuperf_kpi 
GO
DROP TABLE ai_hwdef_createdate_kpi 
GO
DROP TABLE ai_hwdef_login_all_rel 
GO
DROP TABLE ai_hwdef_login_lscandate_rel 
GO
DROP TABLE ai_hwdef_login_maxscan_rel 
GO
DROP TABLE ai_hwdef_login_rel 
GO
DROP TABLE ai_hwdef_lscandate_kpi 
GO
DROP TABLE ai_hwdef_mac_kpi 
GO
DROP TABLE ai_hwdef_osinstdate_kpi 
GO
DROP TABLE ai_hwdef_prop 
GO
DROP TABLE ai_ipdef_prop 
GO
DROP TABLE ai_orgdef_rel 
GO
DROP TABLE ai_osdef_hwdef_rel 
GO
DROP TABLE ai_osdef_instcnt_kpi 
GO
DROP TABLE ai_osdef_prop 
GO
DROP TABLE ai_pubdef_hwdef_rel 
GO
DROP TABLE ai_pubdef_instcnt_kpi 
GO
DROP TABLE ai_pubdef_prop 
GO
DROP TABLE ai_swcat_hwdef_rel 
GO
DROP TABLE ai_swcat_instcnt_kpi 
GO
DROP TABLE ai_swcat_prop 
GO
DROP TABLE ai_swcat_swdef_rel 
GO
DROP TABLE ai_swdef_hwdef_rel 
GO
DROP TABLE ai_swdef_instcnt_kpi 
GO
DROP TABLE ai_swdef_prop 
GO
DROP TABLE ai_undef_hwdef_rel 
GO
DROP TABLE ai_usrdef_orgtree_prop 
GO
DROP TABLE ai_usrdef_prop 
GO
DROP TABLE alertdrillmap 
GO
DROP TABLE alias 
GO
DROP TABLE amaccmap 
GO
DROP TABLE amephis 
GO
DROP TABLE amepjobs 
GO
DROP TABLE amlegacy_objects 
GO
DROP TABLE ams_lv1_alerts 
GO
DROP TABLE ams_lv1_annotation 
GO
DROP TABLE ams_lv1_association 
GO
DROP TABLE ams_lv1_classes 
GO
DROP TABLE ams_lv1_display 
GO
DROP TABLE ams_lv1_escalation 
GO
DROP TABLE ams_lv1_global 
GO
DROP TABLE ams_lv1_history 
GO
DROP TABLE ams_lv1_menus 
GO
DROP TABLE ams_lv1_queues 
GO
DROP TABLE ams_lv1_uaction 
GO
DROP TABLE ams_lv1_uactionlinker 
GO
DROP TABLE ams_lv1_udata 
GO
DROP TABLE am_approved_licenses 
GO
DROP TABLE am_external_device 
GO
DROP TABLE am_external_device_def 
GO
DROP TABLE am_link_external_device 
GO
DROP TABLE am_link_object_folder 
GO
DROP TABLE am_map 
GO
DROP TABLE am_object_folder 
GO
DROP TABLE analysis 
GO
DROP TABLE analysisproperties 
GO
DROP TABLE anima 
GO
DROP TABLE anomaly 
GO
DROP TABLE anomalychange 
GO
DROP TABLE anomalylinkobject 
GO
DROP TABLE applicationgroups 
GO
DROP TABLE application_option 
GO
DROP TABLE applied_remediation 
GO
DROP TABLE applied_remediation_status 
GO
DROP TABLE approvalaction 
GO
DROP TABLE appuknow 
GO
DROP TABLE ap_nm_auth_call 
GO
DROP TABLE ap_nm_entity 
GO
DROP TABLE ap_nm_internal 
GO
DROP TABLE ap_nm_key 
GO
DROP TABLE ap_nm_log 
GO
DROP TABLE ap_nm_login 
GO
DROP TABLE ap_nm_method 
GO
DROP TABLE ap_nm_notify_item 
GO
DROP TABLE ap_nm_parameter 
GO
DROP TABLE ap_nm_record_lock 
GO
DROP TABLE ap_nm_schedule 
GO
DROP TABLE ap_wmv_messages 
GO
DROP TABLE ap_wmv_session_nm 
GO
DROP TABLE ap_wmv_usr_config 
GO
DROP TABLE arcpur_hist 
GO
DROP TABLE arcpur_rule 
GO
DROP TABLE arg_action 
GO
DROP TABLE arg_actiondf 
GO
DROP TABLE arg_actionlk 
GO
DROP TABLE arg_argdeflt 
GO
DROP TABLE arg_assetver 
GO
DROP TABLE arg_attachmt 
GO
DROP TABLE arg_attribute_def 
GO
DROP TABLE arg_class_def 
GO
DROP TABLE arg_controls 
GO
DROP TABLE arg_costdet 
GO
DROP TABLE arg_drpdnlst 
GO
DROP TABLE arg_evdefhdr 
GO
DROP TABLE arg_evdefny 
GO
DROP TABLE arg_evnotify 
GO
DROP TABLE arg_evrem 
GO
DROP TABLE arg_extension_rule_def 
GO
DROP TABLE arg_extsys 
GO
DROP TABLE arg_field_def 
GO
DROP TABLE arg_filtcrit 
GO
DROP TABLE arg_filtdata 
GO
DROP TABLE arg_filtdef 
GO
DROP TABLE arg_filtind 
GO
DROP TABLE arg_hierarchy_def 
GO
DROP TABLE arg_hierarchy_values 
GO
DROP TABLE arg_history 
GO
DROP TABLE arg_hsnotify 
GO
DROP TABLE arg_hsrem 
GO
DROP TABLE arg_index_def 
GO
DROP TABLE arg_index_member 
GO
DROP TABLE arg_intrface 
GO
DROP TABLE arg_intxref 
GO
DROP TABLE arg_itemver 
GO
DROP TABLE arg_job 
GO
DROP TABLE arg_job_task 
GO
DROP TABLE arg_join_def 
GO
DROP TABLE arg_join_member 
GO
DROP TABLE arg_keydef 
GO
DROP TABLE arg_keyword 
GO
DROP TABLE arg_legaldef 
GO
DROP TABLE arg_legaldet 
GO
DROP TABLE arg_legaldoc 
GO
DROP TABLE arg_legalpar 
GO
DROP TABLE arg_legasset 
GO
DROP TABLE arg_legasstc 
GO
DROP TABLE arg_linkdef 
GO
DROP TABLE arg_link_notification_attachmt 
GO
DROP TABLE arg_listdef 
GO
DROP TABLE arg_ltcdef 
GO
DROP TABLE arg_map 
GO
DROP TABLE arg_map_db 
GO
DROP TABLE arg_notes 
GO
DROP TABLE arg_note_text 
GO
DROP TABLE arg_paydet 
GO
DROP TABLE arg_query_assignment 
GO
DROP TABLE arg_query_def 
GO
DROP TABLE arg_reconcile_data 
GO
DROP TABLE arg_reconcile_modification 
GO
DROP TABLE arg_reconcile_msg_queue 
GO
DROP TABLE arg_reconcile_rule 
GO
DROP TABLE arg_reconcile_task 
GO
DROP TABLE arg_roledef 
GO
DROP TABLE arg_script 
GO
DROP TABLE arg_security 
GO
DROP TABLE arg_stathist 
GO
DROP TABLE arg_strlst 
GO
DROP TABLE arg_table_def 
GO
DROP TABLE arg_tclgdef 
GO
DROP TABLE arg_translation_list 
GO
DROP TABLE arg_xmlcache_in 
GO
DROP TABLE arg_xmlcache_ss 
GO
DROP TABLE asmo_event 
GO
DROP TABLE asmo_object 
GO
DROP TABLE asmo_platform 
GO
DROP TABLE asmo_roles 
GO
DROP TABLE asmo_rpt 
GO
DROP TABLE asmo_rules 
GO
DROP TABLE asmo_state 
GO
DROP TABLE asmo_tasks 
GO
DROP TABLE asmo_type 
GO
DROP TABLE asmo_users 
GO
DROP TABLE asmo_views 
GO
DROP TABLE assettyp_profile 
GO
DROP TABLE asset_detection_profile 
GO
DROP TABLE asset_detection_profile_status 
GO
DROP TABLE asset_group 
GO
DROP TABLE asset_group_process_schedule 
GO
DROP TABLE asset_group_software_product 
GO
DROP TABLE asset_vulnerability 
GO
DROP TABLE asset_work_archive 
GO
DROP TABLE assignments 
GO
DROP TABLE atn 
GO
DROP TABLE atomic_cond 
GO
DROP TABLE attached_sla 
GO
DROP TABLE attmnt 
GO
DROP TABLE attmnt_folder 
GO
DROP TABLE attmnt_lrel 
GO
DROP TABLE attr 
GO
DROP TABLE att_evt 
GO
DROP TABLE atyp_asc 
GO
DROP TABLE audithis 
GO
DROP TABLE audit_log 
GO
DROP TABLE auto_discover_scan_ip_range 
GO
DROP TABLE backup_active_user_policy 
GO
DROP TABLE backup_agent_config 
GO
DROP TABLE backup_alert 
GO
DROP TABLE backup_archive 
GO
DROP TABLE backup_backed_up_file 
GO
DROP TABLE backup_backed_up_file_revision 
GO
DROP TABLE backup_backed_up_folder 
GO
DROP TABLE backup_data_growth 
GO
DROP TABLE backup_email_def 
GO
DROP TABLE backup_job 
GO
DROP TABLE backup_job_member 
GO
DROP TABLE backup_link_backup_policy_server 
GO
DROP TABLE backup_link_backup_set_policy 
GO
DROP TABLE backup_link_backup_set_user 
GO
DROP TABLE backup_link_job_file_object 
GO
DROP TABLE backup_login_history 
GO
DROP TABLE backup_manager 
GO
DROP TABLE backup_msg_log 
GO
DROP TABLE backup_msg_log_config 
GO
DROP TABLE backup_network_throttle 
GO
DROP TABLE backup_performed_backup 
GO
DROP TABLE backup_performed_restore 
GO
DROP TABLE backup_policy 
GO
DROP TABLE backup_query_based_policy 
GO
DROP TABLE backup_restored_file 
GO
DROP TABLE backup_schedule 
GO
DROP TABLE backup_server 
GO
DROP TABLE backup_server_config 
GO
DROP TABLE backup_set 
GO
DROP TABLE backup_set_include_exclude 
GO
DROP TABLE backup_set_inventory_selection_p 
GO
DROP TABLE backup_statistic 
GO
DROP TABLE backup_user 
GO
DROP TABLE backup_user_drive 
GO
DROP TABLE backup_user_shell_folder 
GO
DROP TABLE baselinebgp4 
GO
DROP TABLE baselinecisco 
GO
DROP TABLE baselineciscotemp 
GO
DROP TABLE baselineciscovolt 
GO
DROP TABLE baselineconfig 
GO
DROP TABLE baselineetherstats 
GO
DROP TABLE baselinefr 
GO
DROP TABLE baselinefs 
GO
DROP TABLE baselinehopdelay 
GO
DROP TABLE baselineif 
GO
DROP TABLE baselineip 
GO
DROP TABLE baselinelp 
GO
DROP TABLE baselinelu 
GO
DROP TABLE baselinenbar 
GO
DROP TABLE baselinermon2proto 
GO
DROP TABLE baselinerttcapture 
GO
DROP TABLE baselinerttcoll 
GO
DROP TABLE baselinerttjitter 
GO
DROP TABLE baselinets 
GO
DROP TABLE bckbin 
GO
DROP TABLE bckdef 
GO
DROP TABLE bckfile 
GO
DROP TABLE bgp4peerentry 
GO
DROP TABLE bgp4peerentrymessage 
GO
DROP TABLE bhvtpl 
GO
DROP TABLE bit_support 
GO
DROP TABLE blob 
GO
DROP TABLE bool_tab 
GO
DROP TABLE bpwshft 
GO
DROP TABLE bp_standard_category 
GO
DROP TABLE building 
GO
DROP TABLE buscls 
GO
DROP TABLE buslrel 
GO
DROP TABLE busmgt 
GO
DROP TABLE busrep 
GO
DROP TABLE busstat 
GO
DROP TABLE bu_trans 
GO
DROP TABLE cai_version 
GO
DROP TABLE cal 
GO
DROP TABLE call_req 
GO
DROP TABLE category 
GO
DROP TABLE ca_acme_checkpoint 
GO
DROP TABLE ca_agent 
GO
DROP TABLE ca_agent_component 
GO
DROP TABLE ca_application_registration 
GO
DROP TABLE ca_asset 
GO
DROP TABLE ca_asset_class 
GO
DROP TABLE ca_asset_source 
GO
DROP TABLE ca_asset_source_location 
GO
DROP TABLE ca_asset_subschema 
GO
DROP TABLE ca_asset_type 
GO
DROP TABLE ca_capacity_unit 
GO
DROP TABLE ca_category_def 
GO
DROP TABLE ca_category_member 
GO
DROP TABLE ca_class_ace 
GO
DROP TABLE ca_class_def 
GO
DROP TABLE ca_class_hierarchy 
GO
DROP TABLE ca_company 
GO
DROP TABLE ca_company_type 
GO
DROP TABLE ca_configuration_policy 
GO
DROP TABLE ca_config_item 
GO
DROP TABLE ca_contact 
GO
DROP TABLE ca_contact_type 
GO
DROP TABLE ca_country 
GO
DROP TABLE ca_currency_type 
GO
DROP TABLE ca_directory_details 
GO
DROP TABLE ca_directory_schema_map 
GO
DROP TABLE ca_discovered_hardware_ext_sys 
GO
DROP TABLE ca_discovered_hardware_network 
GO
DROP TABLE ca_discovered_software 
GO
DROP TABLE ca_discovered_software_prop 
GO
DROP TABLE ca_discovered_user 
GO
DROP TABLE ca_disc_event 
GO
DROP TABLE ca_document 
GO
DROP TABLE ca_download_file 
GO
DROP TABLE ca_dscv_class_combo_rules 
GO
DROP TABLE ca_dscv_class_methods 
GO
DROP TABLE ca_dscv_class_method_params 
GO
DROP TABLE ca_dscv_class_relationships 
GO
DROP TABLE ca_dscv_class_rules 
GO
DROP TABLE ca_dscv_method_instances 
GO
DROP TABLE ca_engine 
GO
DROP TABLE ca_geo_coord_type 
GO
DROP TABLE ca_group_ace 
GO
DROP TABLE ca_group_def 
GO
DROP TABLE ca_group_member 
GO
DROP TABLE ca_hierarchy 
GO
DROP TABLE ca_image_type 
GO
DROP TABLE ca_install_package 
GO
DROP TABLE ca_install_step 
GO
DROP TABLE ca_job_function
GO
DROP TABLE ca_job_title 
GO
DROP TABLE ca_language 
GO
DROP TABLE ca_license_def 
GO
DROP TABLE ca_license_type 
GO
DROP TABLE ca_link_company_location 
GO
DROP TABLE ca_link_configured_service 
GO
DROP TABLE ca_link_config_item 
GO
DROP TABLE ca_link_config_item_doc 
GO
DROP TABLE ca_link_contact_user 
GO
DROP TABLE ca_link_dir_details_map 
GO
DROP TABLE ca_link_dis_hw 
GO
DROP TABLE ca_link_dis_hw_user 
GO
DROP TABLE ca_link_dis_user_sec_profile 
GO
DROP TABLE ca_link_license_sw_def 
GO
DROP TABLE ca_link_lic_def_domain 
GO
DROP TABLE ca_link_logical_asset_class_def 
GO
DROP TABLE ca_link_model_sw_def 
GO
DROP TABLE ca_link_named_config_doc 
GO
DROP TABLE ca_link_named_config_item 
GO
DROP TABLE ca_link_object_owner 
GO
DROP TABLE ca_link_sw_def 
GO
DROP TABLE ca_link_type 
GO
DROP TABLE ca_locale 
GO
DROP TABLE ca_location 
GO
DROP TABLE ca_location_type 
GO
DROP TABLE ca_logical_asset 
GO
DROP TABLE ca_logical_asset_property 
GO
DROP TABLE ca_manager 
GO
DROP TABLE ca_manager_component 
GO
DROP TABLE ca_model_def 
GO
DROP TABLE ca_named_configuration 
GO
DROP TABLE ca_n_tier 
GO
DROP TABLE ca_object_ace 
GO
DROP TABLE ca_organization 
GO
DROP TABLE ca_owned_resource 
GO
DROP TABLE ca_pool_resource 
GO
DROP TABLE ca_proc_os 
GO
DROP TABLE ca_query_def 
GO
DROP TABLE ca_query_def_contents 
GO
DROP TABLE ca_query_pre_result 
GO
DROP TABLE ca_query_result 
GO
DROP TABLE ca_query_version 
GO
DROP TABLE ca_reg_control 
GO
DROP TABLE ca_reg_intkeys 
GO
DROP TABLE ca_reg_lock 
GO
DROP TABLE ca_replication_conf 
GO
DROP TABLE ca_replication_history 
GO
DROP TABLE ca_replication_status 
GO
DROP TABLE ca_requirement_spec 
GO
DROP TABLE ca_requirement_spec_group 
GO
DROP TABLE ca_requirement_spec_item 
GO
DROP TABLE ca_resource_class 
GO
DROP TABLE ca_resource_cost_center 
GO
DROP TABLE ca_resource_department 
GO
DROP TABLE ca_resource_family 
GO
DROP TABLE ca_resource_gl_code 
GO
DROP TABLE ca_resource_operating_system 
GO
DROP TABLE ca_resource_pool 
GO
DROP TABLE ca_resource_status 
GO
DROP TABLE ca_sdi_ticket 
GO
DROP TABLE ca_security_class_def 
GO
DROP TABLE ca_security_profile 
GO
DROP TABLE ca_server 
GO
DROP TABLE ca_server_component 
GO
DROP TABLE ca_server_push_status 
GO
DROP TABLE ca_server_queue 
GO
DROP TABLE ca_settings 
GO
DROP TABLE ca_site 
GO
DROP TABLE ca_software_def 
GO
DROP TABLE ca_software_def_class_def_matrix 
GO
DROP TABLE ca_software_def_types 
GO
DROP TABLE ca_software_license 
GO
DROP TABLE ca_software_signature 
GO
DROP TABLE ca_software_type 
GO
DROP TABLE ca_source_type 
GO
DROP TABLE ca_state_province 
GO
DROP TABLE ca_taskwiz_def 
GO
DROP TABLE ca_time_zone 
GO
DROP TABLE ccat_grp 
GO
DROP TABLE ccat_loc 
GO
DROP TABLE ccat_wrkshft 
GO
DROP TABLE certificate 
GO
DROP TABLE certificaterequest 
GO
DROP TABLE chg 
GO
DROP TABLE chgalg 
GO
DROP TABLE chgcat 
GO
DROP TABLE chgstat 
GO
DROP TABLE chg_template 
GO
DROP TABLE chip_set 
GO
DROP TABLE ciscostats 
GO
DROP TABLE ciscotemperature_cfg 
GO
DROP TABLE ciscotemperature_stat 
GO
DROP TABLE ciscovoltage_cfg 
GO
DROP TABLE ciscovoltage_stat 
GO
DROP TABLE ci_actions 
GO
DROP TABLE ci_actions_alternate 
GO
DROP TABLE ci_app_ext 
GO
DROP TABLE ci_app_inhouse 
GO
DROP TABLE ci_bookmarks 
GO
DROP TABLE ci_contract 
GO
DROP TABLE ci_database 
GO
DROP TABLE ci_document 
GO
DROP TABLE ci_doc_links 
GO
DROP TABLE ci_doc_templates 
GO
DROP TABLE ci_doc_types 
GO
DROP TABLE ci_eligible_child 
GO
DROP TABLE ci_eligible_parent 
GO
DROP TABLE ci_fac_ac 
GO
DROP TABLE ci_fac_fire_control 
GO
DROP TABLE ci_fac_furnishings 
GO
DROP TABLE ci_fac_other 
GO
DROP TABLE ci_fac_ups 
GO
DROP TABLE ci_hardware_lpar 
GO
DROP TABLE ci_hardware_mainframe 
GO
DROP TABLE ci_hardware_monitor 
GO
DROP TABLE ci_hardware_other 
GO
DROP TABLE ci_hardware_printer 
GO
DROP TABLE ci_hardware_server 
GO
DROP TABLE ci_hardware_storage 
GO
DROP TABLE ci_hardware_virtual 
GO
DROP TABLE ci_hardware_workstation 
GO
DROP TABLE ci_mdr_idmap 
GO
DROP TABLE ci_mdr_provider 
GO
DROP TABLE ci_network_bridge 
GO
DROP TABLE ci_network_cluster 
GO
DROP TABLE ci_network_controller 
GO
DROP TABLE ci_network_frontend 
GO
DROP TABLE ci_network_gateway 
GO
DROP TABLE ci_network_hub 
GO
DROP TABLE ci_network_nic 
GO
DROP TABLE ci_network_other 
GO
DROP TABLE ci_network_peripheral 
GO
DROP TABLE ci_network_port 
GO
DROP TABLE ci_network_resource 
GO
DROP TABLE ci_network_resource_group 
GO
DROP TABLE ci_network_router 
GO
DROP TABLE ci_network_server 
GO
DROP TABLE ci_operating_system 
GO
DROP TABLE ci_priorities 
GO
DROP TABLE ci_rel_type 
GO
DROP TABLE ci_security 
GO
DROP TABLE ci_service 
GO
DROP TABLE ci_sla 
GO
DROP TABLE ci_statuses 
GO
DROP TABLE ci_telcom_ciruit 
GO
DROP TABLE ci_telcom_other 
GO
DROP TABLE ci_telcom_radio 
GO
DROP TABLE ci_telcom_voice 
GO
DROP TABLE ci_telcom_wireless 
GO
DROP TABLE ci_wf_templates 
GO
DROP TABLE clone 
GO
DROP TABLE CMSACL10003DATA 
GO
DROP TABLE CMSACL10010DATA 
GO
DROP TABLE CMSACL10074DATA 
GO
DROP TABLE CMSACL10085DATA 
GO
DROP TABLE CMSACL10093DATA 
GO
DROP TABLE CMSACL10108DATA 
GO
DROP TABLE CMSACL10115DATA 
GO
DROP TABLE CMSACL10122DATA 
GO
DROP TABLE CMSACL10130DATA 
GO
DROP TABLE CMSACL10153DATA 
GO
DROP TABLE CMSACL10160DATA 
GO
DROP TABLE CMSACL10167DATA 
GO
DROP TABLE CMSACL10175DATA 
GO
DROP TABLE CMSACL10182DATA 
GO
DROP TABLE CMSACL10190DATA 
GO
DROP TABLE CMSACL10197DATA 
GO
DROP TABLE CMSACL10205DATA 
GO
DROP TABLE CMSACL10219DATA 
GO
DROP TABLE CMSACL10226DATA 
GO
DROP TABLE CMSACL10233DATA 
GO
DROP TABLE CMSACLPORTALLINKDATA 
GO
DROP TABLE CMSADMINASSETRESOURCEDATA 
GO
DROP TABLE CMSADMINRESOURCEBACKBONEDATA 
GO
DROP TABLE CMSAIFFDATA 
GO
DROP TABLE CMSAIONRULEMANAGERDATA 
GO
DROP TABLE CMSAPPROVALCHAINDATA 
GO
DROP TABLE CMSASSETDATA 
GO
DROP TABLE CMSASSETFILEMAPDATA 
GO
DROP TABLE CMSAVIDATA 
GO
DROP TABLE CMSCOLLECTIONDATA 
GO
DROP TABLE cmscpcmconfig 
GO
DROP TABLE CMSDBLOG 
GO
DROP TABLE CMSERRORDATA 
GO
DROP TABLE cmsfastconfig 
GO
DROP TABLE CMSGROUPDATA 
GO
DROP TABLE CMSIMAGEDATA 
GO
DROP TABLE CMSMDIDCOLUMNSDATA 
GO
DROP TABLE CMSMDIDDATA 
GO
DROP TABLE CMSMP3DATA 
GO
DROP TABLE CMSMPEGDATA 
GO
DROP TABLE CMSMSOFFICEDATA 
GO
DROP TABLE CMSPDFDATA 
GO
DROP TABLE CMSPERSISTANTSTATEINFORMATIONDATA 
GO
DROP TABLE CMSPERSONALIZATIONDATA 
GO
DROP TABLE CMSPHOTOSHOPDATA 
GO
DROP TABLE CMSPORTALLINKDATA 
GO
DROP TABLE CMSPORTALPAGEDATA 
GO
DROP TABLE CMSPOSTSCRIPTDATA 
GO
DROP TABLE CMSQUICKTIMEDATA 
GO
DROP TABLE CMSREALAUDIODATA 
GO
DROP TABLE CMSREALMEDIADATA 
GO
DROP TABLE CMSROLLBK10010DATA 
GO
DROP TABLE CMSROLLBK10074DATA 
GO
DROP TABLE CMSROLLBK10085DATA 
GO
DROP TABLE CMSROLLBK10093DATA 
GO
DROP TABLE CMSROLLBK10108DATA 
GO
DROP TABLE CMSROLLBK10115DATA 
GO
DROP TABLE CMSROLLBK10122DATA 
GO
DROP TABLE CMSROLLBK10130DATA 
GO
DROP TABLE CMSROLLBK10153DATA 
GO
DROP TABLE CMSROLLBK10160DATA 
GO
DROP TABLE CMSROLLBK10167DATA 
GO
DROP TABLE CMSROLLBK10175DATA 
GO
DROP TABLE CMSROLLBK10182DATA 
GO
DROP TABLE CMSROLLBK10190DATA 
GO
DROP TABLE CMSROLLBK10197DATA 
GO
DROP TABLE CMSROLLBK10205DATA 
GO
DROP TABLE CMSROLLBK10219DATA 
GO
DROP TABLE CMSROLLBK10226DATA 
GO
DROP TABLE CMSROLLBK10233DATA 
GO
DROP TABLE CMSROLLBKPORTALLINKDATA 
GO
DROP TABLE CMSSHOCKWAVEDATA 
GO
DROP TABLE CMSSTDTRIGGERDATA 
GO
DROP TABLE CMSUSERDATA 
GO
DROP TABLE CMSVIEWFILESDATA 
GO
DROP TABLE CMSWAVDATA 
GO
DROP TABLE CMSWFACLDATA 
GO
DROP TABLE CMSWFACTIVITYDATA 
GO
DROP TABLE CMSWFACTIVITYDEFDATA 
GO
DROP TABLE CMSWFATTRIBUTEDATA 
GO
DROP TABLE CMSWFPROCESSDATA 
GO
DROP TABLE CMSWFPROCESSDEFDATA 
GO
DROP TABLE CMSWFWORKITEMDATA 
GO
DROP TABLE CMSWINDOWSMEDIADATA 
GO
DROP TABLE CMSWSSTORAGEDATA 
GO
DROP TABLE cn 
GO
DROP TABLE cnote 
GO
DROP TABLE CodeFragment 
GO
DROP TABLE collectionparmgroups 
GO
DROP TABLE collectionparms 
GO
DROP TABLE collectserver 
GO
DROP TABLE columndefinition 
GO
DROP TABLE componentofindex 
GO
DROP TABLE compression_type 
GO
DROP TABLE configuration_standard_set 
GO
DROP TABLE configuration_standard_vuln 
GO
DROP TABLE config_vuln_category_matrix 
GO
DROP TABLE confmemo 
GO
DROP TABLE counter 
GO
DROP TABLE crctmr 
GO
DROP TABLE crepository 
GO
DROP TABLE crltable
GO
DROP TABLE crsol 
GO
DROP TABLE crsq 
GO
DROP TABLE crt 
GO
DROP TABLE cr_prp 
GO
DROP TABLE cr_prptpl 
GO
DROP TABLE cr_stat 
GO
DROP TABLE cr_template 
GO
DROP TABLE csm_class 
GO
DROP TABLE csm_link 
GO
DROP TABLE csm_object 
GO
DROP TABLE csm_property 
GO
DROP TABLE ctab 
GO
DROP TABLE ct_mth 
GO
DROP TABLE das_anlyarglist 
GO
DROP TABLE das_anlydef 
GO
DROP TABLE das_anlyplugin 
GO
DROP TABLE das_anlyresults 
GO
DROP TABLE das_correctiveaction 
GO
DROP TABLE das_groupjob 
GO
DROP TABLE das_job 
GO
DROP TABLE das_monservers 
GO
DROP TABLE das_object_list 
GO
DROP TABLE das_policy 
GO
DROP TABLE das_policyaction 
GO
DROP TABLE das_policyparms 
GO
DROP TABLE das_recmnd 
GO
DROP TABLE das_recmndtext 
GO
DROP TABLE das_recmn_target 
GO
DROP TABLE das_runhistoryval 
GO
DROP TABLE datarolldate 
GO
DROP TABLE datarollup 
GO
DROP TABLE datasource 
GO
DROP TABLE dbh_agent_status 
GO
DROP TABLE dbh_captures 
GO
DROP TABLE dbh_hist 
GO
DROP TABLE dbh_key 
GO
DROP TABLE dbh_sql_bind_variables_ora 
GO
DROP TABLE dbh_sql_ora 
GO
DROP TABLE dbh_sql_tables_ora 
GO
DROP TABLE dbh_sql_udb 
GO
DROP TABLE dbm_guis 
GO
DROP TABLE dbm_prefs 
GO
DROP TABLE db_Application 
GO
DROP TABLE db_Column 
GO
DROP TABLE db_DataType 
GO
DROP TABLE db_Field 
GO
DROP TABLE db_Gator 
GO
DROP TABLE db_GatorStar 
GO
DROP TABLE db_Index 
GO
DROP TABLE db_IndexCol 
GO
DROP TABLE db_InfoBlob 
GO
DROP TABLE db_Layout 
GO
DROP TABLE db_Object 
GO
DROP TABLE db_Op 
GO
DROP TABLE db_OpSegment 
GO
DROP TABLE db_Parameter 
GO
DROP TABLE db_Program 
GO
DROP TABLE db_ProgramInstance 
GO
DROP TABLE db_ProgramType 
GO
DROP TABLE db_ProgramTypeMisc 
GO
DROP TABLE db_PSAFile 
GO
DROP TABLE db_SeqColumn 
GO
DROP TABLE db_SeqTable
GO
DROP TABLE db_ServerType 
GO
DROP TABLE db_Star 
GO
DROP TABLE db_StarTable
GO
DROP TABLE db_Table
GO
DROP TABLE db_WKF 
GO
DROP TABLE db_WKFConnection 
GO
DROP TABLE dcon 
GO
DROP TABLE dcon_typ 
GO
DROP TABLE DDColumn 
GO
DROP TABLE DDTable 
GO
DROP TABLE DDTableModify 
GO
DROP TABLE definitions 
GO
DROP TABLE deletedjobs 
GO
DROP TABLE detection_profile 
GO
DROP TABLE discovered_list 
GO
DROP TABLE discoveryvariable 
GO
DROP TABLE disp 
GO
DROP TABLE dispmoddn 
GO
DROP TABLE dit 
GO
DROP TABLE dlgtsrv 
GO
DROP TABLE dmn 
GO
DROP TABLE documentation 
GO
DROP TABLE doc_rep 
GO
DROP TABLE dts_dbversion 
GO
DROP TABLE dts_dtfilter 
GO
DROP TABLE dts_dtsubscribers 
GO
DROP TABLE dts_dttransfer 
GO
DROP TABLE dts_dttransfergroup 
GO
DROP TABLE dts_dtversion 
GO
DROP TABLE dts_torproperties 
GO
DROP TABLE dynamic_worklist 
GO
DROP TABLE d_painter 
GO
DROP TABLE e2e_adm_add_bpv_comp_mod 
GO
DROP TABLE e2e_adm_add_bpv_link_mod 
GO
DROP TABLE e2e_adm_add_component 
GO
DROP TABLE e2e_adm_add_history 
GO
DROP TABLE e2e_adm_add_h_component 
GO
DROP TABLE e2e_adm_add_h_link 
GO
DROP TABLE e2e_adm_add_link 
GO
DROP TABLE e2e_adm_add_transaction 
GO
DROP TABLE e2e_adm_appl_discovery_def 
GO
DROP TABLE e2e_adm_component_info 
GO
DROP TABLE e2e_adm_configuration 
GO
DROP TABLE e2e_adm_correlation_rule 
GO
DROP TABLE e2e_adm_daily_performance 
GO
DROP TABLE e2e_adm_disc_schedule 
GO
DROP TABLE e2e_adm_hourly_performance 
GO
DROP TABLE e2e_adm_observer_activity 
GO
DROP TABLE e2e_adm_observer_status 
GO
DROP TABLE e2e_adm_performance 
GO
DROP TABLE e2e_adm_perf_schedule 
GO
DROP TABLE e2e_adm_raw_component 
GO
DROP TABLE e2e_adm_raw_link 
GO
DROP TABLE e2e_adm_raw_transaction 
GO
DROP TABLE e2e_adm_scheduled_time 
GO
DROP TABLE e2e_adm_tailoring_rule 
GO
DROP TABLE e2e_adm_transaction_activity 
GO
DROP TABLE e2e_apm_alert 
GO
DROP TABLE e2e_apm_alertxref 
GO
DROP TABLE e2e_apm_application 
GO
DROP TABLE e2e_apm_appop_ref 
GO
DROP TABLE e2e_apm_client 
GO
DROP TABLE e2e_apm_group 
GO
DROP TABLE e2e_apm_group_update 
GO
DROP TABLE e2e_apm_host 
GO
DROP TABLE e2e_apm_net_subs 
GO
DROP TABLE e2e_apm_operation 
GO
DROP TABLE e2e_apm_report 
GO
DROP TABLE e2e_apm_reportcolumn 
GO
DROP TABLE e2e_apm_resp_data 
GO
DROP TABLE e2e_apm_resp_data_day 
GO
DROP TABLE e2e_apm_resp_data_hour 
GO
DROP TABLE e2e_apm_rpt_list 
GO
DROP TABLE e2e_apm_rpt_tags 
GO
DROP TABLE e2e_apm_schemaversion 
GO
DROP TABLE e2e_apm_server 
GO
DROP TABLE e2e_apm_settings 
GO
DROP TABLE e2e_apm_sla 
GO
DROP TABLE e2e_apm_subnet 
GO
DROP TABLE e2e_apm_temp_data 
GO
DROP TABLE e2e_apm_threshold 
GO
DROP TABLE e2e_apm_unit 
GO
DROP TABLE e2e_apm_user 
GO
DROP TABLE e2e_wrm_countersource 
GO
DROP TABLE e2e_wrm_report 
GO
DROP TABLE e2e_wrm_reportcolumn 
GO
DROP TABLE e2e_wrm_sourcelocale 
GO
DROP TABLE e2e_wrm_weblogurl 
GO
DROP TABLE e2e_wrm_wrm 
GO
DROP TABLE e2e_wrm_wrmactivedetail 
GO
DROP TABLE e2e_wrm_wrmcontentcheck 
GO
DROP TABLE e2e_wrm_wrmgroup 
GO
DROP TABLE e2e_wrm_wrmidentifier 
GO
DROP TABLE e2e_wrm_wrmreport 
GO
DROP TABLE e2e_wrm_wrmrequestname 
GO
DROP TABLE e2e_wrm_wrmstat 
GO
DROP TABLE e2e_wrm_wrmstatusmessage 
GO
DROP TABLE e2e_wrm_wrmtype 
GO
DROP TABLE ebr_acronyms 
GO
DROP TABLE ebr_dictionary 
GO
DROP TABLE ebr_dictionary_adm 
GO
DROP TABLE ebr_fulltext 
GO
DROP TABLE ebr_fulltext_adm 
GO
DROP TABLE ebr_log 
GO
DROP TABLE ebr_metrics 
GO
DROP TABLE ebr_noise_words 
GO
DROP TABLE ebr_patterns 
GO
DROP TABLE ebr_prefixes 
GO
DROP TABLE ebr_properties 
GO
DROP TABLE ebr_substits 
GO
DROP TABLE ebr_suffixes 
GO
DROP TABLE ebr_synonyms 
GO
DROP TABLE ebr_synonyms_adm 
GO
DROP TABLE ebr_synonym_groups 
GO
DROP TABLE ebr_synonym_groups_adm 
GO
DROP TABLE eccm_actionlog 
GO
DROP TABLE eccm_configuration 
GO
DROP TABLE eccm_log 
GO
DROP TABLE eccm_user 
GO
DROP TABLE emailaction 
GO
DROP TABLE emevt_mib 
GO
DROP TABLE emevt_trap 
GO
DROP TABLE engine_config 
GO
DROP TABLE enterprise_package 
GO
DROP TABLE enterprise_package_history 
GO
DROP TABLE enterprise_package_status 
GO
DROP TABLE enterprise_package_subpackage 
GO
DROP TABLE entry 
GO
DROP TABLE Error 
GO
DROP TABLE es_constants 
GO
DROP TABLE es_nodes 
GO
DROP TABLE es_responses 
GO
DROP TABLE es_sessions 
GO
DROP TABLE eventlog 
GO
DROP TABLE event_log 
GO
DROP TABLE event_type 
GO
DROP TABLE evm_appliance_configuration 
GO
DROP TABLE evm_company 
GO
DROP TABLE evm_discovered_software 
GO
DROP TABLE evm_message_center_message 
GO
DROP TABLE evt 
GO
DROP TABLE evtdlytp 
GO
DROP TABLE evt_dly 
GO
DROP TABLE Execution 
GO
DROP TABLE externalaction 
GO
DROP TABLE ext_appl 
GO
DROP TABLE faq_sym 
GO
DROP TABLE filemgr 
GO
DROP TABLE filter 
GO
DROP TABLE frcircuitid 
GO
DROP TABLE frcircuitstats 
GO
DROP TABLE frdlcmiid 
GO
DROP TABLE frmgrp 
GO
DROP TABLE frs_circuit_line 
GO
DROP TABLE frs_connection 
GO
DROP TABLE frs_frp 
GO
DROP TABLE frs_ip 
GO
DROP TABLE frs_node_id 
GO
DROP TABLE frs_packet_line 
GO
DROP TABLE frs_stat 
GO
DROP TABLE frs_stat_threshold 
GO
DROP TABLE frs_svp 
GO
DROP TABLE frs_trap 
GO
DROP TABLE fun_identifier 
GO
DROP TABLE fun_ixfcols 
GO
DROP TABLE fun_jas 
GO
DROP TABLE fun_lobpaths 
GO
DROP TABLE fun_nesttblpaths 
GO
DROP TABLE fun_nesttblsto 
GO
DROP TABLE fun_ora 
GO
DROP TABLE fun_outpaths 
GO
DROP TABLE fun_packedcols 
GO
DROP TABLE fun_partitions 
GO
DROP TABLE fun_sortpaths 
GO
DROP TABLE fun_sqlserver 
GO
DROP TABLE fun_template 
GO
DROP TABLE fun_udb 
GO
DROP TABLE fun_varraypaths 
GO
DROP TABLE gdcdiscovery 
GO
DROP TABLE gla_agents 
GO
DROP TABLE gla_errors 
GO
DROP TABLE gla_hours 
GO
DROP TABLE gla_objects 
GO
DROP TABLE gla_sdamaps 
GO
DROP TABLE GlobalVariable 
GO
DROP TABLE global_status_event 
GO
DROP TABLE groupaccesslist 
GO
DROP TABLE groupingtype 
GO
DROP TABLE grpmem 
GO
DROP TABLE grp_loc 
GO
DROP TABLE g_chg_ext 
GO
DROP TABLE g_chg_queue 
GO
DROP TABLE g_contact 
GO
DROP TABLE g_iss_ext 
GO
DROP TABLE g_iss_queue 
GO
DROP TABLE g_loc 
GO
DROP TABLE g_org 
GO
DROP TABLE g_product 
GO
DROP TABLE g_queue_names 
GO
DROP TABLE g_req_ext 
GO
DROP TABLE g_req_queue 
GO
DROP TABLE g_srvr 
GO
DROP TABLE g_tbl_map 
GO
DROP TABLE g_tbl_rule 
GO
DROP TABLE hardware_sd_server_matrix 
GO
DROP TABLE hardware_software_dvy_jb_file 
GO
DROP TABLE hex2decimal 
GO
DROP TABLE hier 
GO
DROP TABLE hist_report 
GO
DROP TABLE iam_attribute 
GO
DROP TABLE iam_event 
GO
DROP TABLE iam_object 
GO
DROP TABLE icat_grp 
GO
DROP TABLE icat_loc 
GO
DROP TABLE icat_wrkshft 
GO
DROP TABLE idmanager 
GO
DROP TABLE impact 
GO
DROP TABLE impact_analysis_queue 
GO
DROP TABLE increment_highval 
GO
DROP TABLE indexTable 
GO
DROP TABLE index_doc_links 
GO
DROP TABLE info 
GO
DROP TABLE infohis 
GO
DROP TABLE infolng 
GO
DROP TABLE infoqlt 
GO
DROP TABLE instances 
GO
DROP TABLE instance_history 
GO
DROP TABLE interface 
GO
DROP TABLE interfacechange 
GO
DROP TABLE inventory_profile 
GO
DROP TABLE investigation 
GO
DROP TABLE investigation_history 
GO
DROP TABLE investigation_person 
GO
DROP TABLE invgene 
GO
DROP TABLE invsetup 
GO
DROP TABLE inv_default_item 
GO
DROP TABLE inv_default_tree 
GO
DROP TABLE inv_externaldevice_item 
GO
DROP TABLE inv_externaldevice_tree 
GO
DROP TABLE inv_generalinventory_item 
GO
DROP TABLE inv_generalinventory_tree 
GO
DROP TABLE inv_item_name_id 
GO
DROP TABLE inv_object_tree_id 
GO
DROP TABLE inv_performance_item 
GO
DROP TABLE inv_performance_tree 
GO
DROP TABLE inv_reconcile_item 
GO
DROP TABLE inv_reconcile_tree 
GO
DROP TABLE inv_root_map 
GO
DROP TABLE inv_table_map 
GO
DROP TABLE inv_tree_name_id 
GO
DROP TABLE ipObject 
GO
DROP TABLE ipProvider 
GO
DROP TABLE ipRequest 
GO
DROP TABLE ipRequestCode 
GO
DROP TABLE IPUser 
GO
DROP TABLE issalg 
GO
DROP TABLE isscat 
GO
DROP TABLE issprp 
GO
DROP TABLE issstat 
GO
DROP TABLE issue 
GO
DROP TABLE isswf 
GO
DROP TABLE iss_template 
GO
DROP TABLE itfcconfig 
GO
DROP TABLE itfcconfighist 
GO
DROP TABLE jmo_gbl 
GO
DROP TABLE jmo_gbls 
GO
DROP TABLE jmo_gen 
GO
DROP TABLE jmo_gens 
GO
DROP TABLE jmo_group 
GO
DROP TABLE jmo_groupid 
GO
DROP TABLE jmo_hstu 
GO
DROP TABLE jmo_jbr 
GO
DROP TABLE jmo_jhr 
GO
DROP TABLE jmo_jtr 
GO
DROP TABLE jmo_jtr1 
GO
DROP TABLE jmo_jtrs 
GO
DROP TABLE jmo_jwb 
GO
DROP TABLE jmo_modeltemp 
GO
DROP TABLE jmo_mwc 
GO
DROP TABLE jmo_mwg 
GO
DROP TABLE jmo_nod 
GO
DROP TABLE jmo_prb 
GO
DROP TABLE jmo_prt 
GO
DROP TABLE jmo_prt1 
GO
DROP TABLE jmo_psr1 
GO
DROP TABLE jmo_psrm 
GO
DROP TABLE jmo_psrs 
GO
DROP TABLE jmo_psrt 
GO
DROP TABLE jmo_sbr 
GO
DROP TABLE jmo_shr 
GO
DROP TABLE jmo_simtsystemdeps 
GO
DROP TABLE jmo_srq 
GO
DROP TABLE jmo_station 
GO
DROP TABLE jmo_str 
GO
DROP TABLE jmo_str1 
GO
DROP TABLE jmo_strs 
GO
DROP TABLE jmo_swb 
GO
DROP TABLE jmo_systemdeps 
GO
DROP TABLE jmo_trg 
GO
DROP TABLE jmo_trt 
GO
DROP TABLE jmo_trt1 
GO
DROP TABLE jmo_tsystemdeps 
GO
DROP TABLE jmo_tsystemdeps1 
GO
DROP TABLE joborder 
GO
DROP TABLE jobvisionpassword 
GO
DROP TABLE jobvisionvalues 
GO
DROP TABLE job_history 
GO
DROP TABLE job_object 
GO
DROP TABLE job_template 
GO
DROP TABLE jv_box_job 
GO
DROP TABLE jv_command_job 
GO
DROP TABLE jv_fw_job 
GO
DROP TABLE jv_job 
GO
DROP TABLE jv_keymaster 
GO
DROP TABLE kc 
GO
DROP TABLE kdlinks 
GO
DROP TABLE kd_attmnt 
GO
DROP TABLE keys 
GO
DROP TABLE km_kword 
GO
DROP TABLE km_lrel 
GO
DROP TABLE kpi_control 
GO
DROP TABLE kpi_data 
GO
DROP TABLE kpi_exceptions 
GO
DROP TABLE kpi_exception_ack 
GO
DROP TABLE kpi_infer_summary_docs 
GO
DROP TABLE kpi_names 
GO
DROP TABLE kpi_personalization 
GO
DROP TABLE kpi_process_stats 
GO
DROP TABLE kpi_properties 
GO
DROP TABLE kpi_targets 
GO
DROP TABLE kpi_titles 
GO
DROP TABLE kpi_types 
GO
DROP TABLE kpi_values 
GO
DROP TABLE kt_report_card 
GO
DROP TABLE lac_filenames 
GO
DROP TABLE lac_filter_names 
GO
DROP TABLE lac_filter_objects 
GO
DROP TABLE lac_job_output 
GO
DROP TABLE lac_job_parms 
GO
DROP TABLE lac_strategy_parms 
GO
DROP TABLE lac_transactions 
GO
DROP TABLE language 
GO
DROP TABLE ldapactors_worklist 
GO
DROP TABLE ldapconfiguration 
GO
DROP TABLE ldaptemp 
GO
DROP TABLE linkbck 
GO
DROP TABLE linkjob 
GO
DROP TABLE linkmod 
GO
DROP TABLE list 
GO
DROP TABLE listnodes 
GO
DROP TABLE listproperties 
GO
DROP TABLE lockunit 
GO
DROP TABLE logicalrelations 
GO
DROP TABLE long_texts 
GO
DROP TABLE LookOutControl 
GO
DROP TABLE LookOutIdControl 
GO
DROP TABLE LookOutServer 
GO
DROP TABLE lrel 
GO
DROP TABLE lsyfileserverclients 
GO
DROP TABLE lsyfileserverid 
GO
DROP TABLE lsyfileserverstats 
GO
DROP TABLE lsyhopdelay 
GO
DROP TABLE lsyhopdelayid 
GO
DROP TABLE lsylanprotocols 
GO
DROP TABLE lsylanutilization 
GO
DROP TABLE lsynetnames 
GO
DROP TABLE lsyprobeid 
GO
DROP TABLE lsyprotocoltypes 
GO
DROP TABLE lsytermserverclients 
GO
DROP TABLE lsytermserverid 
GO
DROP TABLE lsytermserverstats 
GO
DROP TABLE lsytopncast 
GO
DROP TABLE lsytopnlinkerr 
GO
DROP TABLE lsytopnmatrix 
GO
DROP TABLE lsytopnnetrsp 
GO
DROP TABLE lsytopnroute 
GO
DROP TABLE lsytopnroutedelay 
GO
DROP TABLE m2if 
GO
DROP TABLE m2ifstats 
GO
DROP TABLE m2ipstats 
GO
DROP TABLE machinealias 
GO
DROP TABLE mactoip 
GO
DROP TABLE managed_survey 
GO
DROP TABLE management_asset_group 
GO
DROP TABLE management_groupid 
GO
DROP TABLE management_groups 
GO
DROP TABLE mdb 
GO
DROP TABLE mdb_checkpoint 
GO
DROP TABLE mdb_patch 
GO
DROP TABLE mdb_service_pack 
GO
DROP TABLE mgsalg 
GO
DROP TABLE mgsstat 
GO
DROP TABLE mibdefinition 
GO
DROP TABLE mibstructure 
GO
DROP TABLE mibvariabletype 
GO
DROP TABLE miftypes 
GO
DROP TABLE mitjas_calendar 
GO
DROP TABLE mitjas_calen_date 
GO
DROP TABLE mitjas_calen_node 
GO
DROP TABLE mitjas_group 
GO
DROP TABLE mitjas_job 
GO
DROP TABLE mitjas_jobhist 
GO
DROP TABLE mitjas_jobparms 
GO
DROP TABLE mitjas_setup 
GO
DROP TABLE mit_host 
GO
DROP TABLE mit_host_parm 
GO
DROP TABLE mit_identifier 
GO
DROP TABLE mit_product 
GO
DROP TABLE mit_repository 
GO
DROP TABLE mit_server 
GO
DROP TABLE mit_server_parm 
GO
DROP TABLE mit_server_type 
GO
DROP TABLE mit_server_user 
GO
DROP TABLE monitorappl 
GO
DROP TABLE name 
GO
DROP TABLE nbarprotocolstatus_cfg 
GO
DROP TABLE nbarprotocolstatus_stat 
GO
DROP TABLE nbarprotocol_cfg 
GO
DROP TABLE nbarprotocol_stat 
GO
DROP TABLE ncipc 
GO
DROP TABLE ncjobbin 
GO
DROP TABLE ncjobcfg 
GO
DROP TABLE nclog 
GO
DROP TABLE ncmodbin 
GO
DROP TABLE ncmodcfg 
GO
DROP TABLE ncovervw 
GO
DROP TABLE ncprofil 
GO
DROP TABLE ncrc 
GO
DROP TABLE nctngref 
GO
DROP TABLE nctpldef 
GO
DROP TABLE network_alert 
GO
DROP TABLE network_groupid 
GO
DROP TABLE network_groups 
GO
DROP TABLE network_mib 
GO
DROP TABLE network_probe 
GO
DROP TABLE neugentalerts 
GO
DROP TABLE neugentexceptions 
GO
DROP TABLE neugentreport 
GO
DROP TABLE nonavail 
GO
DROP TABLE nonhealth 
GO
DROP TABLE notification 
GO
DROP TABLE nottrn 
GO
DROP TABLE noturg 
GO
DROP TABLE not_log 
GO
DROP TABLE not_que 
GO
DROP TABLE nr_com 
GO
DROP TABLE ntfl 
GO
DROP TABLE objclasses 
GO
DROP TABLE objectudp 
GO
DROP TABLE objstore 
GO
DROP TABLE ols_area_ace 
GO
DROP TABLE ols_area_def 
GO
DROP TABLE ols_mapping 
GO
DROP TABLE openunit 
GO
DROP TABLE opra_act 
GO
DROP TABLE opra_ctl 
GO
DROP TABLE opra_msg 
GO
DROP TABLE opr_conview
GO
DROP TABLE opr_convusr 
GO
DROP TABLE options 
GO
DROP TABLE o_comments 
GO
DROP TABLE o_events 
GO
DROP TABLE o_indexes 
GO
DROP TABLE package_type 
GO
DROP TABLE pcat_grp 
GO
DROP TABLE pcat_loc 
GO
DROP TABLE pcat_wrkshft 
GO
DROP TABLE pd_bpv 
GO
DROP TABLE pd_bpv_def 
GO
DROP TABLE pd_cluster_def 
GO
DROP TABLE pd_cluster_ext 
GO
DROP TABLE pd_day 
GO
DROP TABLE pd_global 
GO
DROP TABLE pd_machine 
GO
DROP TABLE pd_machine_ext 
GO
DROP TABLE pd_max_bpv 
GO
DROP TABLE pd_max_day 
GO
DROP TABLE pd_max_machine 
GO
DROP TABLE pd_max_resource 
GO
DROP TABLE pd_resource 
GO
DROP TABLE pd_time 
GO
DROP TABLE pd_val_10min 
GO
DROP TABLE pd_val_12hr 
GO
DROP TABLE pd_val_15min 
GO
DROP TABLE pd_val_1day 
GO
DROP TABLE pd_val_1hr 
GO
DROP TABLE pd_val_1min 
GO
DROP TABLE pd_val_1month 
GO
DROP TABLE pd_val_1week 
GO
DROP TABLE pd_val_1year 
GO
DROP TABLE pd_val_20min 
GO
DROP TABLE pd_val_2hr 
GO
DROP TABLE pd_val_30min 
GO
DROP TABLE pd_val_3hr 
GO
DROP TABLE pd_val_4hr 
GO
DROP TABLE pd_val_5min 
GO
DROP TABLE pd_val_6hr 
GO
DROP TABLE pd_val_8hr 
GO
DROP TABLE Permissions 
GO
DROP TABLE permit_profile 
GO
DROP TABLE perscon 
GO
DROP TABLE personalias 
GO
DROP TABLE policonf 
GO
DROP TABLE policytable 
GO
DROP TABLE polidef 
GO
DROP TABLE polijob 
GO
DROP TABLE polilog 
GO
DROP TABLE pollrowdefinition 
GO
DROP TABLE por_audience 
GO
DROP TABLE por_dftpage 
GO
DROP TABLE por_discussion 
GO
DROP TABLE por_discussion_nfy 
GO
DROP TABLE por_distrib_item 
GO
DROP TABLE por_distrib_order 
GO
DROP TABLE por_distrib_order_state 
GO
DROP TABLE por_distrib_summary 
GO
DROP TABLE por_document 
GO
DROP TABLE por_documentgroups 
GO
DROP TABLE por_global 
GO
DROP TABLE por_group 
GO
DROP TABLE por_mime_type_mapping 
GO
DROP TABLE por_obcounter 
GO
DROP TABLE por_objectrepos 
GO
DROP TABLE por_pagecols 
GO
DROP TABLE por_pagecomps 
GO
DROP TABLE por_pagecounter 
GO
DROP TABLE por_pages 
GO
DROP TABLE por_portal_instance 
GO
DROP TABLE por_portlet_applic 
GO
DROP TABLE por_portlet_defn 
GO
DROP TABLE por_portlet_entity 
GO
DROP TABLE por_portlet_user_prefs 
GO
DROP TABLE por_preferences 
GO
DROP TABLE por_prefsconfig 
GO
DROP TABLE por_property 
GO
DROP TABLE por_pubcounter 
GO
DROP TABLE por_publisher 
GO
DROP TABLE por_registration 
GO
DROP TABLE por_relationships 
GO
DROP TABLE por_sequences 
GO
DROP TABLE por_server 
GO
DROP TABLE por_session 
GO
DROP TABLE por_sessobjpw 
GO
DROP TABLE por_svrcounter 
GO
DROP TABLE por_task 
GO
DROP TABLE por_taskcounter 
GO
DROP TABLE por_template 
GO
DROP TABLE por_templatelookup 
GO
DROP TABLE por_tplcounter 
GO
DROP TABLE por_translog 
GO
DROP TABLE por_user 
GO
DROP TABLE por_wp 
GO
DROP TABLE por_wp_fav 
GO
DROP TABLE por_wp_fav_dflt 
GO
DROP TABLE por_wp_layout_data 
GO
DROP TABLE por_wp_metadata 
GO
DROP TABLE por_wp_metadata_cat 
GO
DROP TABLE por_wp_portlet 
GO
DROP TABLE por_wp_to_wp_fav 
GO
DROP TABLE por_wsrp_portlet_handle 
GO
DROP TABLE por_wsrp_prod 
GO
DROP TABLE por_wsrp_reg 
GO
DROP TABLE por_wsrp_reg_context 
GO
DROP TABLE por_wsrp_reg_data 
GO
DROP TABLE pri 
GO
DROP TABLE probeaccesslist 
GO
DROP TABLE prob_ctg 
GO
DROP TABLE process_listeners 
GO
DROP TABLE process_schedule 
GO
DROP TABLE process_snapshots 
GO
DROP TABLE process_type 
GO
DROP TABLE product 
GO
DROP TABLE productids 
GO
DROP TABLE profile_expression_step 
GO
DROP TABLE profile_pki 
GO
DROP TABLE protection_level 
GO
DROP TABLE ProviderVersion 
GO
DROP TABLE provider_user 
GO
DROP TABLE prp 
GO
DROP TABLE prptpl 
GO
DROP TABLE p_groups 
GO
DROP TABLE quick_tpl_types 
GO
DROP TABLE racaction 
GO
DROP TABLE rbooltab 
GO
DROP TABLE RDBMS_Provider 
GO
DROP TABLE recoverrequest 
GO
DROP TABLE reference_group 
GO
DROP TABLE reference_source 
GO
DROP TABLE reference_source_vuln_matrix 
GO
DROP TABLE ref_ref_source_matrix 
GO
DROP TABLE region 
GO
DROP TABLE release 
GO
DROP TABLE remediation_profile 
GO
DROP TABLE remed_prof_detect_prof_matrix 
GO
DROP TABLE rem_ref 
GO
DROP TABLE renewalrequest 
GO
DROP TABLE repmeth 
GO
DROP TABLE reportdescr 
GO
DROP TABLE report_pki 
GO
DROP TABLE RequestProvider 
GO
DROP TABLE RequestQueue 
GO
DROP TABLE requesttype 
GO
DROP TABLE request_pki 
GO
DROP TABLE resnonhealth 
GO
DROP TABLE resource 
GO
DROP TABLE resourcemonitoring 
GO
DROP TABLE resourcename 
GO
DROP TABLE resourcetype 
GO
DROP TABLE response 
GO
DROP TABLE revocationrequest 
GO
DROP TABLE rmconfiguration 
GO
DROP TABLE rmoaddress 
GO
DROP TABLE rmobacklog 
GO
DROP TABLE rmon2addressmap 
GO
DROP TABLE rmon2alhost 
GO
DROP TABLE rmon2nlmatrix 
GO
DROP TABLE rmon2protocoldist 
GO
DROP TABLE rmon2protocoldistcontrol 
GO
DROP TABLE rmon2protocolid 
GO
DROP TABLE rmon2protocolproperties 
GO
DROP TABLE rmonetherstatsid 
GO
DROP TABLE rmonetherstatsstats 
GO
DROP TABLE rmonhostcontrol 
GO
DROP TABLE rmonhosttopnstat 
GO
DROP TABLE rmonrptquerydata 
GO
DROP TABLE rmonrptquerytempdata 
GO
DROP TABLE rolluptimestamp 
GO
DROP TABLE rolluptypes 
GO
DROP TABLE rootcause 
GO
DROP TABLE root_cause 
GO
DROP TABLE rpauto 
GO
DROP TABLE rpdatcat 
GO
DROP TABLE rpdatfld 
GO
DROP TABLE rpdatqry 
GO
DROP TABLE rpdatsrc 
GO
DROP TABLE rpdattyp 
GO
DROP TABLE rpfield 
GO
DROP TABLE rpfilter 
GO
DROP TABLE rpglobal 
GO
DROP TABLE rpipc 
GO
DROP TABLE rppub 
GO
DROP TABLE rpresult 
GO
DROP TABLE rpstats 
GO
DROP TABLE rptables 
GO
DROP TABLE rptmth 
GO
DROP TABLE rptpl 
GO
DROP TABLE rptree 
GO
DROP TABLE rpview
GO
DROP TABLE rttctrladmin_cfg 
GO
DROP TABLE rttechoadmin_cfg 
GO
DROP TABLE rttjitter_stat 
GO
DROP TABLE rttstatscapture_stat 
GO
DROP TABLE rttstatscoll_stat 
GO
DROP TABLE sapolicy 
GO
DROP TABLE saprobtyp 
GO
DROP TABLE scc_app_bp_kpi 
GO
DROP TABLE scc_app_hist 
GO
DROP TABLE scc_app_loc_kpi 
GO
DROP TABLE scc_app_org_kpi 
GO
DROP TABLE scc_app_prop 
GO
DROP TABLE scc_app_total_kpi 
GO
DROP TABLE scc_app_type_kpi 
GO
DROP TABLE scc_asset_bp_kpi 
GO
DROP TABLE scc_asset_hist 
GO
DROP TABLE scc_asset_loc_kpi 
GO
DROP TABLE scc_asset_org_kpi 
GO
DROP TABLE scc_asset_prop 
GO
DROP TABLE scc_asset_total_kpi 
GO
DROP TABLE scc_asset_type_kpi 
GO
DROP TABLE scc_asset_vendor_kpi 
GO
DROP TABLE scc_bp_prop 
GO
DROP TABLE scc_cfg_prop 
GO
DROP TABLE scc_exbox_hist 
GO
DROP TABLE scc_exbox_prop 
GO
DROP TABLE scc_exusr_hist 
GO
DROP TABLE scc_exusr_prop 
GO
DROP TABLE scc_hscfg_prop 
GO
DROP TABLE scc_hs_prop 
GO
DROP TABLE scc_lib_hist 
GO
DROP TABLE scc_lib_prop 
GO
DROP TABLE scc_loc_prop 
GO
DROP TABLE scc_managed_cfg_prop 
GO
DROP TABLE scc_mda_hist 
GO
DROP TABLE scc_mda_prop 
GO
DROP TABLE scc_msg_prop 
GO
DROP TABLE scc_org_prop 
GO
DROP TABLE scc_snp_hist 
GO
DROP TABLE scc_snp_prop 
GO
DROP TABLE scc_srv_bp_kpi 
GO
DROP TABLE scc_srv_hist 
GO
DROP TABLE scc_srv_loc_kpi 
GO
DROP TABLE scc_srv_org_kpi 
GO
DROP TABLE scc_srv_prop 
GO
DROP TABLE scc_srv_total_kpi 
GO
DROP TABLE scc_srv_type_kpi 
GO
DROP TABLE scc_swt_hist 
GO
DROP TABLE scc_swt_prop 
GO
DROP TABLE scc_sys_bp_kpi 
GO
DROP TABLE scc_sys_hist 
GO
DROP TABLE scc_sys_loc_kpi 
GO
DROP TABLE scc_sys_org_kpi 
GO
DROP TABLE scc_sys_os_kpi 
GO
DROP TABLE scc_sys_prop 
GO
DROP TABLE scc_sys_tier_kpi 
GO
DROP TABLE scc_sys_total_kpi 
GO
DROP TABLE scc_sys_type_kpi 
GO
DROP TABLE scc_vfs_bp_kpi 
GO
DROP TABLE scc_vfs_hist 
GO
DROP TABLE scc_vfs_loc_kpi 
GO
DROP TABLE scc_vfs_org_kpi 
GO
DROP TABLE scc_vfs_os_kpi 
GO
DROP TABLE scc_vfs_prop 
GO
DROP TABLE scc_vfs_tier_kpi 
GO
DROP TABLE scc_vfs_total_kpi 
GO
DROP TABLE scc_vfs_type_kpi 
GO
DROP TABLE scc_vol_app_kpi 
GO
DROP TABLE scc_vol_app_rel 
GO
DROP TABLE scc_vol_bp_kpi 
GO
DROP TABLE scc_vol_hist 
GO
DROP TABLE scc_vol_loc_kpi 
GO
DROP TABLE scc_vol_org_kpi 
GO
DROP TABLE scc_vol_os_kpi 
GO
DROP TABLE scc_vol_prop 
GO
DROP TABLE scc_vol_tier_kpi 
GO
DROP TABLE scc_vol_total_kpi 
GO
DROP TABLE scc_vol_type_kpi 
GO
DROP TABLE ScriptMessageLog 
GO
DROP TABLE sdsc_map 
GO
DROP TABLE sd_server_download_file 
GO
DROP TABLE search 
GO
DROP TABLE secure_event 
GO
DROP TABLE secure_job 
GO
DROP TABLE secure_machine 
GO
DROP TABLE secure_person 
GO
DROP TABLE securitypredicate 
GO
DROP TABLE seosdata 
GO
DROP TABLE seqctl 
GO
DROP TABLE service 
GO
DROP TABLE serviceproviders 
GO
DROP TABLE sessionlength 
GO
DROP TABLE session_log 
GO
DROP TABLE session_type 
GO
DROP TABLE setting 
GO
DROP TABLE settings 
GO
DROP TABLE sevrty 
GO
DROP TABLE show_obj 
GO
DROP TABLE signature_os_group 
GO
DROP TABLE simpleevent 
GO
DROP TABLE SimpleRequest 
GO
DROP TABLE si_ci_prop 
GO
DROP TABLE si_ci_rec_rel 
GO
DROP TABLE si_cnt_org_rel 
GO
DROP TABLE si_contact_prop 
GO
DROP TABLE si_financial_prop 
GO
DROP TABLE si_kpi_hist 
GO
DROP TABLE si_kpi_prop 
GO
DROP TABLE si_legdoc_ci_rel 
GO
DROP TABLE si_legdoc_prop 
GO
DROP TABLE si_log_prop 
GO
DROP TABLE si_org_prop 
GO
DROP TABLE si_pri_prop 
GO
DROP TABLE si_rec_prop 
GO
DROP TABLE si_survey_kpi 
GO
DROP TABLE si_wf_prop 
GO
DROP TABLE skeletons 
GO
DROP TABLE slatpl 
GO
DROP TABLE snapmain 
GO
DROP TABLE snapmemo 
GO
DROP TABLE software_delivery_file_params 
GO
DROP TABLE software_delivery_job 
GO
DROP TABLE software_delivery_job_file 
GO
DROP TABLE software_delivery_server 
GO
DROP TABLE software_vulnerability 
GO
DROP TABLE splmac 
GO
DROP TABLE splmactp 
GO
DROP TABLE sql_tab 
GO
DROP TABLE srvr_aliases 
GO
DROP TABLE srvr_zones 
GO
DROP TABLE srv_desc 
GO
DROP TABLE station 
GO
DROP TABLE statistic 
GO
DROP TABLE statisticaverages 
GO
DROP TABLE statisticgrouping 
GO
DROP TABLE statjob 
GO
DROP TABLE statjobm 
GO
DROP TABLE statmod 
GO
DROP TABLE statmodm 
GO
DROP TABLE stats 
GO
DROP TABLE stattype 
GO
DROP TABLE strlst 
GO
DROP TABLE subattr 
GO
DROP TABLE subsearch 
GO
DROP TABLE survey 
GO
DROP TABLE survey_answer 
GO
DROP TABLE survey_atpl 
GO
DROP TABLE survey_qtpl 
GO
DROP TABLE survey_question 
GO
DROP TABLE survey_statistics 
GO
DROP TABLE survey_tpl 
GO
DROP TABLE survey_tracking 
GO
DROP TABLE svc_contract 
GO
DROP TABLE SystemParameter 
GO
DROP TABLE systemvalues 
GO
DROP TABLE system_configuration 
GO
DROP TABLE tabledefinition 
GO
DROP TABLE tableindex 
GO
DROP TABLE tablejoins 
GO
DROP TABLE tablesdescription 
GO
DROP TABLE templatebob 
GO
DROP TABLE templatebob1 
GO
DROP TABLE templatebob2 
GO
DROP TABLE templateparameters 
GO
DROP TABLE templateudpvalues 
GO
DROP TABLE templateworkloadjob1 
GO
DROP TABLE templateworkloadjob2 
GO
DROP TABLE thresholdconst 
GO
DROP TABLE thresholddesc 
GO
DROP TABLE thresholdformula 
GO
DROP TABLE thresholds 
GO
DROP TABLE timedevent 
GO
DROP TABLE tn 
GO
DROP TABLE tng_address_type 
GO
DROP TABLE tng_adminstatus 
GO
DROP TABLE tng_agent_info 
GO
DROP TABLE tng_alarmset 
GO
DROP TABLE tng_alarmset_entry 
GO
DROP TABLE tng_auth 
GO
DROP TABLE tng_browser_menu 
GO
DROP TABLE tng_browser_method 
GO
DROP TABLE tng_ca_claim_discovery_tmp 
GO
DROP TABLE tng_change_history 
GO
DROP TABLE tng_city 
GO
DROP TABLE tng_class 
GO
DROP TABLE tng_class_addport 
GO
DROP TABLE tng_class_ext 
GO
DROP TABLE tng_class_reclass 
GO
DROP TABLE tng_class_special 
GO
DROP TABLE tng_conflict_object 
GO
DROP TABLE tng_country 
GO
DROP TABLE tng_dbpv 
GO
DROP TABLE tng_dbserver_connectinfo 
GO
DROP TABLE tng_dhcp_scope 
GO
DROP TABLE tng_discovery_ipsubnet 
GO
DROP TABLE tng_discovery_ipsubnet_tmp 
GO
DROP TABLE tng_discovery_setup 
GO
DROP TABLE tng_discovery_status 
GO
DROP TABLE tng_dsm_class_scope 
GO
DROP TABLE tng_dsm_comm_scope 
GO
DROP TABLE tng_dsm_ip_scope 
GO
DROP TABLE tng_dsm_mo_scope 
GO
DROP TABLE tng_dsm_poll_scope 
GO
DROP TABLE tng_field_definition 
GO
DROP TABLE tng_field_storage 
GO
DROP TABLE tng_geomap 
GO
DROP TABLE tng_icon_2d 
GO
DROP TABLE tng_icon_3d 
GO
DROP TABLE tng_inclusion 
GO
DROP TABLE tng_interface_type 
GO
DROP TABLE tng_ip_discovery_history 
GO
DROP TABLE tng_ip_interface 
GO
DROP TABLE tng_ip_subnet 
GO
DROP TABLE tng_jasmine_menu_action 
GO
DROP TABLE tng_jasmine_menu_object 
GO
DROP TABLE tng_jii_inclusion 
GO
DROP TABLE tng_key_change_hist 
GO
DROP TABLE tng_key_class_id 
GO
DROP TABLE tng_key_discovery_ipsubnet_id 
GO
DROP TABLE tng_key_id 
GO
DROP TABLE tng_key_prop_status_hist 
GO
DROP TABLE tng_key_status_hist 
GO
DROP TABLE tng_link 
GO
DROP TABLE tng_locale_info 
GO
DROP TABLE tng_mac_address 
GO
DROP TABLE tng_managedobject 
GO
DROP TABLE tng_map_authority 
GO
DROP TABLE tng_method 
GO
DROP TABLE tng_netpc_history 
GO
DROP TABLE tng_overlapinterface 
GO
DROP TABLE tng_ov_enum 
GO
DROP TABLE tng_ov_field_def 
GO
DROP TABLE tng_pollset 
GO
DROP TABLE tng_popup_menu 
GO
DROP TABLE tng_property_definition 
GO
DROP TABLE tng_prop_status_history 
GO
DROP TABLE tng_severity_propagation 
GO
DROP TABLE tng_status 
GO
DROP TABLE tng_status_history 
GO
DROP TABLE tng_sysobjid 
GO
DROP TABLE tng_tnd_geomap 
GO
DROP TABLE tng_unclassified_tcp 
GO
DROP TABLE tng_user_menu 
GO
DROP TABLE tng_vendor 
GO
DROP TABLE toc 
GO
DROP TABLE top_n_ids 
GO
DROP TABLE tplmemo 
GO
DROP TABLE tree 
GO
DROP TABLE triggers 
GO
DROP TABLE tskstat 
GO
DROP TABLE tskty 
GO
DROP TABLE tspan 
GO
DROP TABLE tsr_stats 
GO
DROP TABLE tz 
GO
DROP TABLE t_alert 
GO
DROP TABLE t_alldevs 
GO
DROP TABLE t_allifs 
GO
DROP TABLE t_always_dev 
GO
DROP TABLE t_always_devif 
GO
DROP TABLE t_always_if 
GO
DROP TABLE t_greatestcpu_dev 
GO
DROP TABLE t_greatestcpu_devif 
GO
DROP TABLE t_ifthruput 
GO
DROP TABLE t_ifutil 
GO
DROP TABLE t_mostalerts_dev 
GO
DROP TABLE t_mostalerts_devif 
GO
DROP TABLE t_mostalerts_if 
GO
DROP TABLE t_mostthruput_if 
GO
DROP TABLE ucm_calendars 
GO
DROP TABLE ucm_cron_triggers 
GO
DROP TABLE ucm_fired_triggers 
GO
DROP TABLE ucm_history 
GO
DROP TABLE ucm_job_details 
GO
DROP TABLE ucm_job_listeners 
GO
DROP TABLE ucm_link_calendar_trigger
GO
DROP TABLE ucm_link_config_report 
GO
DROP TABLE ucm_locks 
GO
DROP TABLE ucm_mib_data 
GO
DROP TABLE ucm_mib_miblabel 
GO
DROP TABLE ucm_mib_reportdata 
GO
DROP TABLE ucm_mib_tglabel 
GO
DROP TABLE ucm_mib_varlabel 
GO
DROP TABLE ucm_paused_trigger_grps 
GO
DROP TABLE ucm_scheduler_state 
GO
DROP TABLE ucm_simple_triggers 
GO
DROP TABLE ucm_triggers 
GO
DROP TABLE ucm_trigger_listeners 
GO
DROP TABLE udoinstance 
GO
DROP TABLE udp 
GO
DROP TABLE udpselectionvalues 
GO
DROP TABLE udpvalues 
GO
DROP TABLE ud_datasource_list 
GO
DROP TABLE ud_orgdef_list 
GO
DROP TABLE ud_swcat_rule 
GO
DROP TABLE UEACL10003DATA 
GO
DROP TABLE UEACL10011DATA 
GO
DROP TABLE UEACL10047DATA 
GO
DROP TABLE UEACL10075DATA 
GO
DROP TABLE UEACL10086DATA 
GO
DROP TABLE UEACL10094DATA 
GO
DROP TABLE UEACL10109DATA 
GO
DROP TABLE UEACL10116DATA 
GO
DROP TABLE UEACL10123DATA 
GO
DROP TABLE UEACL10131DATA 
GO
DROP TABLE UEACL10154DATA 
GO
DROP TABLE UEACL10161DATA 
GO
DROP TABLE UEACL10168DATA 
GO
DROP TABLE UEACL10176DATA 
GO
DROP TABLE UEACL10183DATA 
GO
DROP TABLE UEACL10191DATA 
GO
DROP TABLE UEACL10198DATA 
GO
DROP TABLE UEACL10206DATA 
GO
DROP TABLE UEACL10220DATA 
GO
DROP TABLE UEADMINASSETRESOURCEDATA 
GO
DROP TABLE UEADMINRESOURCEBACKBONEDATA 
GO
DROP TABLE UEAIFFDATA 
GO
DROP TABLE UEAIONRULEMANAGERDATA 
GO
DROP TABLE UEAPPROVALCHAINDATA 
GO
DROP TABLE UEASSETDATA 
GO
DROP TABLE UEASSETFILEMAPDATA 
GO
DROP TABLE UEAVIDATA 
GO
DROP TABLE UECOLLECTIONDATA 
GO
DROP TABLE UEERRORDATA 
GO
DROP TABLE UEGROUPDATA 
GO
DROP TABLE UEIMAGEDATA 
GO
DROP TABLE uejm_adapter 
GO
DROP TABLE uejm_alert 
GO
DROP TABLE uejm_alert_ping 
GO
DROP TABLE uejm_configuration 
GO
DROP TABLE uejm_jobscheduling 
GO
DROP TABLE uejm_monitoring 
GO
DROP TABLE UEMDIDCOLUMNSDATA 
GO
DROP TABLE UEMDIDDATA 
GO
DROP TABLE UEMGRSEQOPDATA 
GO
DROP TABLE UEMP3DATA 
GO
DROP TABLE UEMPEGDATA 
GO
DROP TABLE UEMSOFFICEDATA 
GO
DROP TABLE UEPDFDATA 
GO
DROP TABLE UEPERSISTANTSTATEINFORMATIONDATA 
GO
DROP TABLE UEPERSONALIZATIONDATA 
GO
DROP TABLE UEPHOTOSHOPDATA 
GO
DROP TABLE UEPOSTSCRIPTDATA 
GO
DROP TABLE UEQUICKTIMEDATA 
GO
DROP TABLE UEREALAUDIODATA 
GO
DROP TABLE UEREALMEDIADATA 
GO
DROP TABLE UEROLLBK10011DATA 
GO
DROP TABLE UEROLLBK10047DATA 
GO
DROP TABLE UEROLLBK10075DATA 
GO
DROP TABLE UEROLLBK10086DATA 
GO
DROP TABLE UEROLLBK10094DATA 
GO
DROP TABLE UEROLLBK10109DATA 
GO
DROP TABLE UEROLLBK10116DATA 
GO
DROP TABLE UEROLLBK10123DATA 
GO
DROP TABLE UEROLLBK10131DATA 
GO
DROP TABLE UEROLLBK10154DATA 
GO
DROP TABLE UEROLLBK10161DATA 
GO
DROP TABLE UEROLLBK10168DATA 
GO
DROP TABLE UEROLLBK10176DATA 
GO
DROP TABLE UEROLLBK10183DATA 
GO
DROP TABLE UEROLLBK10191DATA 
GO
DROP TABLE UEROLLBK10198DATA 
GO
DROP TABLE UEROLLBK10206DATA 
GO
DROP TABLE UEROLLBK10220DATA 
GO
DROP TABLE UESHOCKWAVEDATA 
GO
DROP TABLE UESTDTRIGGERDATA 
GO
DROP TABLE UEURLDATA 
GO
DROP TABLE UEUSERDATA 
GO
DROP TABLE UEWAVDATA 
GO
DROP TABLE UEWFACLDATA 
GO
DROP TABLE UEWFACTIVITYDATA 
GO
DROP TABLE UEWFACTIVITYDEFDATA 
GO
DROP TABLE UEWFATTRIBUTEDATA 
GO
DROP TABLE UEWFPROCESSDATA 
GO
DROP TABLE UEWFPROCESSDEFDATA 
GO
DROP TABLE UEWFWORKITEMDATA 
GO
DROP TABLE UEWINDOWSMEDIADATA 
GO
DROP TABLE UEWSSTORAGEDATA 
GO
DROP TABLE ujo_alamode 
GO
DROP TABLE ujo_alarm 
GO
DROP TABLE ujo_asbnode 
GO
DROP TABLE ujo_asext_config 
GO
DROP TABLE ujo_audit_alamode 
GO
DROP TABLE ujo_audit_info 
GO
DROP TABLE ujo_audit_msg 
GO
DROP TABLE ujo_avg_job_runs 
GO
DROP TABLE ujo_calendar 
GO
DROP TABLE ujo_chase 
GO
DROP TABLE ujo_chkpnt_rstart 
GO
DROP TABLE ujo_config 
GO
DROP TABLE ujo_cred 
GO
DROP TABLE ujo_cycle 
GO
DROP TABLE ujo_event 
GO
DROP TABLE ujo_event0 
GO
DROP TABLE ujo_event2 
GO
DROP TABLE ujo_ext_calendar 
GO
DROP TABLE ujo_ext_job 
GO
DROP TABLE ujo_glob 
GO
DROP TABLE ujo_globblob 
GO
DROP TABLE ujo_ha_designator 
GO
DROP TABLE ujo_ha_process 
GO
DROP TABLE ujo_ha_state 
GO
DROP TABLE ujo_ha_status 
GO
DROP TABLE ujo_intcodes 
GO
DROP TABLE ujo_job 
GO
DROP TABLE ujo_job2 
GO
DROP TABLE ujo_jobblob 
GO
DROP TABLE ujo_jobres 
GO
DROP TABLE ujo_jobtype 
GO
DROP TABLE ujo_job_cond 
GO
DROP TABLE ujo_job_delete 
GO
DROP TABLE ujo_job_runs 
GO
DROP TABLE ujo_job_status 
GO
DROP TABLE ujo_keymaster 
GO
DROP TABLE ujo_last_Eoid_counter 
GO
DROP TABLE ujo_lic_machine 
GO
DROP TABLE ujo_machine 
GO
DROP TABLE ujo_machres 
GO
DROP TABLE ujo_monbro 
GO
DROP TABLE ujo_msg_ack 
GO
DROP TABLE ujo_next_oid 
GO
DROP TABLE ujo_next_run_num 
GO
DROP TABLE ujo_overjob 
GO
DROP TABLE ujo_proc_event 
GO
DROP TABLE ujo_rep_daily 
GO
DROP TABLE ujo_rep_hourly 
GO
DROP TABLE ujo_rep_monthly 
GO
DROP TABLE ujo_rep_weekly 
GO
DROP TABLE ujo_req_job 
GO
DROP TABLE ujo_restart 
GO
DROP TABLE ujo_send_buffer 
GO
DROP TABLE ujo_sys_ha_state 
GO
DROP TABLE ujo_timezones 
GO
DROP TABLE ujo_uninotify 
GO
DROP TABLE ujo_wait_que 
GO
DROP TABLE ump_alertfilter 
GO
DROP TABLE ump_alertgroup 
GO
DROP TABLE ump_emfilter 
GO
DROP TABLE ump_emgroup 
GO
DROP TABLE ump_msgs 
GO
DROP TABLE ump_profiles 
GO
DROP TABLE und_error 
GO
DROP TABLE und_job 
GO
DROP TABLE und_probe 
GO
DROP TABLE und_task 
GO
DROP TABLE und_transaction 
GO
DROP TABLE und_user 
GO
DROP TABLE unitsec 
GO
DROP TABLE unittype 
GO
DROP TABLE upm_baseline_group 
GO
DROP TABLE upm_baseline_patch 
GO
DROP TABLE upm_baseline_sw 
GO
DROP TABLE upm_credential 
GO
DROP TABLE upm_deployment 
GO
DROP TABLE upm_download 
GO
DROP TABLE upm_event 
GO
DROP TABLE upm_name_value_pair 
GO
DROP TABLE upm_portlet 
GO
DROP TABLE upm_portlet_content 
GO
DROP TABLE upm_workflow 
GO
DROP TABLE urc_ab_computer 
GO
DROP TABLE urc_ab_group_def 
GO
DROP TABLE urc_ab_group_member 
GO
DROP TABLE urc_ab_permission 
GO
DROP TABLE urc_active_session 
GO
DROP TABLE urc_computer 
GO
DROP TABLE urc_local_server 
GO
DROP TABLE urc_schema_version 
GO
DROP TABLE urgncy 
GO
DROP TABLE usd_activity 
GO
DROP TABLE usd_actproc 
GO
DROP TABLE usd_apdep 
GO
DROP TABLE usd_applic 
GO
DROP TABLE usd_carrier 
GO
DROP TABLE usd_cc 
GO
DROP TABLE usd_class_version 
GO
DROP TABLE usd_cmp_grp 
GO
DROP TABLE usd_cont 
GO
DROP TABLE usd_contfold 
GO
DROP TABLE usd_distap 
GO
DROP TABLE usd_distsw 
GO
DROP TABLE usd_disttempl 
GO
DROP TABLE usd_fio 
GO
DROP TABLE usd_fitem 
GO
DROP TABLE usd_jcappgr 
GO
DROP TABLE usd_jcview
GO
DROP TABLE usd_job_cont 
GO
DROP TABLE usd_link_act_cmp 
GO
DROP TABLE usd_link_act_grp 
GO
DROP TABLE usd_link_act_inst 
GO
DROP TABLE usd_link_cfold_cont 
GO
DROP TABLE usd_link_cmpgrp 
GO
DROP TABLE usd_link_contfold 
GO
DROP TABLE usd_link_grp_cmp 
GO
DROP TABLE usd_link_grp_proc 
GO
DROP TABLE usd_link_jc 
GO
DROP TABLE usd_link_jc_act 
GO
DROP TABLE usd_link_jc_srv 
GO
DROP TABLE usd_link_swgrp 
GO
DROP TABLE usd_link_swg_sw 
GO
DROP TABLE usd_order 
GO
DROP TABLE usd_rsw 
GO
DROP TABLE usd_swfold 
GO
DROP TABLE usd_target 
GO
DROP TABLE usd_task 
GO
DROP TABLE usd_volume 
GO
DROP TABLE userlist_worklist 
GO
DROP TABLE userprofiles 
GO
DROP TABLE users 
GO
DROP TABLE usersec_profile 
GO
DROP TABLE user_acct_asset_group_matrix 
GO
DROP TABLE user_group 
GO
DROP TABLE user_preferences 
GO
DROP TABLE user_roles 
GO
DROP TABLE usm_account 
GO
DROP TABLE usm_account_app_user 
GO
DROP TABLE usm_account_domain 
GO
DROP TABLE usm_acl 
GO
DROP TABLE usm_adjustment 
GO
DROP TABLE usm_analysis 
GO
DROP TABLE usm_analysis_layout_set 
GO
DROP TABLE usm_analyzed_event_data 
GO
DROP TABLE usm_analyze_export_option 
GO
DROP TABLE usm_analyze_function 
GO
DROP TABLE usm_analyze_job 
GO
DROP TABLE usm_analyze_job_option 
GO
DROP TABLE usm_analyze_schedule 
GO
DROP TABLE usm_appuser 
GO
DROP TABLE usm_asset 
GO
DROP TABLE usm_attr_reference_plugin 
GO
DROP TABLE usm_attr_reference_plugin_attr 
GO
DROP TABLE usm_billing_account 
GO
DROP TABLE usm_billing_group 
GO
DROP TABLE usm_branding_template 
GO
DROP TABLE usm_branding_variable 
GO
DROP TABLE usm_bus_queue 
GO
DROP TABLE usm_cache 
GO
DROP TABLE usm_cache_listener 
GO
DROP TABLE usm_calendar 
GO
DROP TABLE usm_calendar_category 
GO
DROP TABLE usm_collection_profile 
GO
DROP TABLE usm_collection_profile_attrs 
GO
DROP TABLE usm_collection_profile_metric 
GO
DROP TABLE usm_collector 
GO
DROP TABLE usm_comp_instance 
GO
DROP TABLE usm_configuration 
GO
DROP TABLE usm_contact_domain 
GO
DROP TABLE usm_contact_domain_role 
GO
DROP TABLE usm_contact_extension 
GO
DROP TABLE usm_contract 
GO
DROP TABLE usm_contract_action 
GO
DROP TABLE usm_cor_data 
GO
DROP TABLE usm_cor_metric_capability 
GO
DROP TABLE usm_cost_pool 
GO
DROP TABLE usm_cp_inclusion 
GO
DROP TABLE usm_dash 
GO
DROP TABLE usm_data_collector 
GO
DROP TABLE usm_db 
GO
DROP TABLE usm_dca_app_status 
GO
DROP TABLE usm_dca_comp_status 
GO
DROP TABLE usm_default_service_hours 
GO
DROP TABLE usm_dependency 
GO
DROP TABLE usm_dm_event_data 
GO
DROP TABLE usm_doctmpl_layoutlist 
GO
DROP TABLE usm_document_template 
GO
DROP TABLE usm_dst 
GO
DROP TABLE usm_event_category 
GO
DROP TABLE usm_event_category_value 
GO
DROP TABLE usm_event_data 
GO
DROP TABLE usm_event_instance 
GO
DROP TABLE usm_event_instance_value 
GO
DROP TABLE usm_event_type 
GO
DROP TABLE usm_event_type_attributes 
GO
DROP TABLE usm_event_type_collector 
GO
DROP TABLE usm_exchange_rate 
GO
DROP TABLE usm_export 
GO
DROP TABLE usm_exporter 
GO
DROP TABLE usm_fiscal_period 
GO
DROP TABLE usm_guinode 
GO
DROP TABLE usm_guinode_content 
GO
DROP TABLE usm_host 
GO
DROP TABLE usm_host_element 
GO
DROP TABLE usm_host_type 
GO
DROP TABLE usm_icon 
GO
DROP TABLE usm_id_mapping 
GO
DROP TABLE usm_id_pd 
GO
DROP TABLE usm_id_plan 
GO
DROP TABLE usm_importer 
GO
DROP TABLE usm_importer_instance 
GO
DROP TABLE usm_importer_spec 
GO
DROP TABLE usm_importer_spec_value 
GO
DROP TABLE usm_import_attribute 
GO
DROP TABLE usm_import_rule 
GO
DROP TABLE usm_import_table_index 
GO
DROP TABLE usm_install 
GO
DROP TABLE usm_installed_component 
GO
DROP TABLE usm_installed_subcomponent 
GO
DROP TABLE usm_invoice_history 
GO
DROP TABLE usm_keyword 
GO
DROP TABLE usm_lastid 
GO
DROP TABLE usm_last_analysis 
GO
DROP TABLE usm_launchpad 
GO
DROP TABLE usm_launchpad_content 
GO
DROP TABLE usm_link_account_user 
GO
DROP TABLE usm_link_analysis_layout 
GO
DROP TABLE usm_link_analyze_func_metr_cat 
GO
DROP TABLE usm_link_analyze_job_group 
GO
DROP TABLE usm_link_analyze_job_ticket 
GO
DROP TABLE usm_link_billing_account_group 
GO
DROP TABLE usm_link_calendar_contract 
GO
DROP TABLE usm_link_contract_sla_inst 
GO
DROP TABLE usm_link_event_inst_metr_inst 
GO
DROP TABLE usm_link_event_metric_category 
GO
DROP TABLE usm_link_guinode_guinode 
GO
DROP TABLE usm_link_importer_inst_metric 
GO
DROP TABLE usm_link_install_comp_subcomp 
GO
DROP TABLE usm_link_launchpad_launchpad 
GO
DROP TABLE usm_link_method_method 
GO
DROP TABLE usm_link_metric_schema_comp 
GO
DROP TABLE usm_link_metric_scope 
GO
DROP TABLE usm_link_mr_import_event_inst 
GO
DROP TABLE usm_link_object_keyword 
GO
DROP TABLE usm_link_plugin_plugintype 
GO
DROP TABLE usm_link_profile_hosts 
GO
DROP TABLE usm_link_report_variable_data 
GO
DROP TABLE usm_link_resource_outage 
GO
DROP TABLE usm_link_rtapp_account 
GO
DROP TABLE usm_link_schema_component 
GO
DROP TABLE usm_link_schema_inst_metr_cat 
GO
DROP TABLE usm_link_schema_metr_category 
GO
DROP TABLE usm_link_schema_slo_template 
GO
DROP TABLE usm_link_scope_layout 
GO
DROP TABLE usm_link_server_systeminstall 
GO
DROP TABLE usm_link_service_event 
GO
DROP TABLE usm_link_service_event_metr_in 
GO
DROP TABLE usm_link_service_event_ticket 
GO
DROP TABLE usm_link_slo_instance_instance 
GO
DROP TABLE usm_link_slo_package_template 
GO
DROP TABLE usm_link_slo_template_template 
GO
DROP TABLE usm_link_subscription_asset 
GO
DROP TABLE usm_link_sysinstall_installcom 
GO
DROP TABLE usm_metering_package 
GO
DROP TABLE usm_meter_gui_cfg 
GO
DROP TABLE usm_method 
GO
DROP TABLE usm_method_input 
GO
DROP TABLE usm_method_optional_input 
GO
DROP TABLE usm_metric 
GO
DROP TABLE usm_metric_analyzer 
GO
DROP TABLE usm_metric_analyzer_attrs 
GO
DROP TABLE usm_metric_attr_spec 
GO
DROP TABLE usm_metric_attr_spec_value 
GO
DROP TABLE usm_metric_attr_value 
GO
DROP TABLE usm_metric_category 
GO
DROP TABLE usm_metric_folder 
GO
DROP TABLE usm_metric_instance 
GO
DROP TABLE usm_metric_instance_appuser 
GO
DROP TABLE usm_metric_resultxxxxx 
GO
DROP TABLE usm_mr_ierror 
GO
DROP TABLE usm_mr_ievent_load 
GO
DROP TABLE usm_mr_ievent_metric 
GO
DROP TABLE usm_mr_ifield 
GO
DROP TABLE usm_mr_ifile 
GO
DROP TABLE usm_mr_iftype 
GO
DROP TABLE usm_mr_imap 
GO
DROP TABLE usm_mr_import 
GO
DROP TABLE usm_mr_iref 
GO
DROP TABLE usm_mr_isystem 
GO
DROP TABLE usm_mr_itable 
GO
DROP TABLE usm_mr_itrend 
GO
DROP TABLE usm_mr_ivalue 
GO
DROP TABLE usm_news 
GO
DROP TABLE usm_note 
GO
DROP TABLE usm_numeric_policy 
GO
DROP TABLE usm_object_wf_instance_ref 
GO
DROP TABLE usm_offering 
GO
DROP TABLE usm_offering_ratedef_inclusion 
GO
DROP TABLE usm_offering_rplan_inclusion 
GO
DROP TABLE usm_onetime_event 
GO
DROP TABLE usm_pattern_type 
GO
DROP TABLE usm_payment_method 
GO
DROP TABLE usm_plan 
GO
DROP TABLE usm_planning_set 
GO
DROP TABLE usm_plan_data 
GO
DROP TABLE usm_plan_def 
GO
DROP TABLE usm_plan_set 
GO
DROP TABLE usm_plugin 
GO
DROP TABLE usm_plugin_type 
GO
DROP TABLE usm_portal_content 
GO
DROP TABLE usm_portal_template 
GO
DROP TABLE usm_pwd_policy 
GO
DROP TABLE usm_queue_item 
GO
DROP TABLE usm_queue_item_detail 
GO
DROP TABLE usm_rateplan_inclusion 
GO
DROP TABLE usm_rateplan_inheritance 
GO
DROP TABLE usm_rate_definition 
GO
DROP TABLE usm_rate_plan 
GO
DROP TABLE usm_recurring_event 
GO
DROP TABLE usm_report_data 
GO
DROP TABLE usm_report_dataview 
GO
DROP TABLE usm_report_dataview_field 
GO
DROP TABLE usm_report_group 
GO
DROP TABLE usm_report_group_goal 
GO
DROP TABLE usm_report_group_metr_instance 
GO
DROP TABLE usm_report_group_template 
GO
DROP TABLE usm_report_layout 
GO
DROP TABLE usm_report_layout_obj_list 
GO
DROP TABLE usm_report_profile 
GO
DROP TABLE usm_report_profile_attrs 
GO
DROP TABLE usm_report_profile_spec 
GO
DROP TABLE usm_report_profile_spec_values 
GO
DROP TABLE usm_report_variable 
GO
DROP TABLE usm_request 
GO
DROP TABLE usm_request_pending_action 
GO
DROP TABLE usm_request_value 
GO
DROP TABLE usm_role 
GO
DROP TABLE usm_role_user 
GO
DROP TABLE usm_rsc_map 
GO
DROP TABLE usm_rsc_method 
GO
DROP TABLE usm_rsc_nmrefer 
GO
DROP TABLE usm_rsc_node 
GO
DROP TABLE usm_rsc_parameter 
GO
DROP TABLE usm_rsc_property 
GO
DROP TABLE usm_rsc_system 
GO
DROP TABLE usm_rule 
GO
DROP TABLE usm_rule_action 
GO
DROP TABLE usm_rule_condition 
GO
DROP TABLE usm_rule_event_type 
GO
DROP TABLE usm_runtimecomp_parameter 
GO
DROP TABLE usm_runtime_application 
GO
DROP TABLE usm_runtime_component 
GO
DROP TABLE usm_schema 
GO
DROP TABLE usm_schema_comp 
GO
DROP TABLE usm_schema_instance 
GO
DROP TABLE usm_scope 
GO
DROP TABLE usm_search_node 
GO
DROP TABLE usm_security 
GO
DROP TABLE usm_server 
GO
DROP TABLE usm_serviceconfig 
GO
DROP TABLE usm_service_desk_priority 
GO
DROP TABLE usm_service_desk_ticket 
GO
DROP TABLE usm_service_event 
GO
DROP TABLE usm_service_goal 
GO
DROP TABLE usm_service_goal_values 
GO
DROP TABLE usm_service_hours 
GO
DROP TABLE usm_settlement 
GO
DROP TABLE usm_sla_config 
GO
DROP TABLE usm_sla_instance 
GO
DROP TABLE usm_sla_metric_instance 
GO
DROP TABLE usm_slm_server 
GO
DROP TABLE usm_slm_server_config 
GO
DROP TABLE usm_slm_server_status 
GO
DROP TABLE usm_slm_server_status_type 
GO
DROP TABLE usm_slm_server_type 
GO
DROP TABLE usm_slm_server_type_spec 
GO
DROP TABLE usm_slm_server_type_value 
GO
DROP TABLE usm_slo_data 
GO
DROP TABLE usm_slo_event 
GO
DROP TABLE usm_slo_instance 
GO
DROP TABLE usm_slo_package 
GO
DROP TABLE usm_slo_template 
GO
DROP TABLE usm_slo_template_sla_config 
GO
DROP TABLE usm_slo_threshold 
GO
DROP TABLE usm_sm_comp 
GO
DROP TABLE usm_sm_event 
GO
DROP TABLE usm_snmp_config 
GO
DROP TABLE usm_statement 
GO
DROP TABLE usm_stylesheet 
GO
DROP TABLE usm_subscription_detail 
GO
DROP TABLE usm_subscription_mgmt 
GO
DROP TABLE usm_system_alert 
GO
DROP TABLE usm_system_change 
GO
DROP TABLE usm_system_change_detail 
GO
DROP TABLE usm_system_change_detail_ext 
GO
DROP TABLE usm_system_install 
GO
DROP TABLE usm_task 
GO
DROP TABLE usm_tenant 
GO
DROP TABLE usm_tenant_ext_ldap_conf 
GO
DROP TABLE usm_transaction 
GO
DROP TABLE usm_unittype 
GO
DROP TABLE usm_user 
GO
DROP TABLE usm_user_query_history 
GO
DROP TABLE usm_webservice 
GO
DROP TABLE usm_webservice_method 
GO
DROP TABLE usm_wmi_classes 
GO
DROP TABLE usm_wmi_expression 
GO
DROP TABLE usp_contact 
GO
DROP TABLE usp_organization 
GO
DROP TABLE usp_owned_resource 
GO
DROP TABLE usp_preferences 
GO
DROP TABLE usp_projex 
GO
DROP TABLE usp_properties 
GO
DROP TABLE usq 
GO
DROP TABLE ut_datasource_log 
GO
DROP TABLE validation_method 
GO
DROP TABLE viewgroups 
GO
DROP TABLE viewlanquerydata 
GO
DROP TABLE viewquerydata 
GO
DROP TABLE viewsettings 
GO
DROP TABLE vulnerability 
GO
DROP TABLE vulnerability_vailidation_method 
GO
DROP TABLE vuln_management_backup_config 
GO
DROP TABLE vuln_management_configuration 
GO
DROP TABLE vunerability_asset_group 
GO
DROP TABLE watch 
GO
DROP TABLE weekday 
GO
DROP TABLE wf 
GO
DROP TABLE wfschema 
GO
DROP TABLE wftpl 
GO
DROP TABLE wftpl_grp 
GO
DROP TABLE wf_ids 
GO
DROP TABLE wf_locks 
GO
DROP TABLE wkresourceprofile 
GO
DROP TABLE wktriggerprofile 
GO
DROP TABLE workalert 
GO
DROP TABLE workbench_product 
GO
DROP TABLE workbench_provider 
GO
DROP TABLE workflow_configuration 
GO
DROP TABLE workflow_groups 
GO
DROP TABLE workitems 
GO
DROP TABLE worklist 
GO
DROP TABLE workloadcommon 
GO
DROP TABLE workloadextendedprops 
GO
DROP TABLE workloadjob 
GO
DROP TABLE workloadjobset 
GO
DROP TABLE wsm_accesszone 
GO
DROP TABLE wsm_accesszone_coordinates 
GO
DROP TABLE wsm_accesszone_gui_attrib 
GO
DROP TABLE wsm_advanced_psk 
GO
DROP TABLE wsm_advanced_psk_sched 
GO
DROP TABLE wsm_advanced_wep 
GO
DROP TABLE wsm_advanced_wep_sched 
GO
DROP TABLE wsm_agent 
GO
DROP TABLE wsm_attribute_type 
GO
DROP TABLE wsm_certificate_store 
GO
DROP TABLE wsm_configprofile_type 
GO
DROP TABLE wsm_configuration_history 
GO
DROP TABLE wsm_configuration_item 
GO
DROP TABLE wsm_configuration_object 
GO
DROP TABLE wsm_configuration_profile 
GO
DROP TABLE wsm_datamgmt_policy 
GO
DROP TABLE wsm_dc_day 
GO
DROP TABLE wsm_dc_resource 
GO
DROP TABLE wsm_dc_time 
GO
DROP TABLE wsm_dc_val_1day 
GO
DROP TABLE wsm_dc_val_1hr 
GO
DROP TABLE wsm_dc_val_1min 
GO
DROP TABLE wsm_dc_val_1mnth 
GO
DROP TABLE wsm_dc_val_1week 
GO
DROP TABLE wsm_dc_val_1year 
GO
DROP TABLE wsm_dc_val_30min 
GO
DROP TABLE wsm_dc_val_5min 
GO
DROP TABLE wsm_dc_val_8hr 
GO
DROP TABLE wsm_device 
GO
DROP TABLE wsm_device_attribute 
GO
DROP TABLE wsm_device_attrib_def 
GO
DROP TABLE wsm_device_gui_attributes 
GO
DROP TABLE wsm_device_relationship 
GO
DROP TABLE wsm_device_type 
GO
DROP TABLE wsm_engine 
GO
DROP TABLE wsm_events 
GO
DROP TABLE wsm_event_definitions 
GO
DROP TABLE wsm_firmware_definition 
GO
DROP TABLE wsm_global_gui_configuration 
GO
DROP TABLE wsm_icon_group 
GO
DROP TABLE wsm_image 
GO
DROP TABLE wsm_intrusion_rules 
GO
DROP TABLE wsm_level 
GO
DROP TABLE wsm_link_attribdef_to_model 
GO
DROP TABLE wsm_link_config_to_device 
GO
DROP TABLE wsm_link_firmware_def_to_model 
GO
DROP TABLE wsm_link_firmware_to_device 
GO
DROP TABLE wsm_link_icongrp_to_model 
GO
DROP TABLE wsm_link_model_method_tmplate 
GO
DROP TABLE wsm_link_model_to_template 
GO
DROP TABLE wsm_link_policy_to_policy 
GO
DROP TABLE wsm_link_rsrc_bundle_frmware 
GO
DROP TABLE wsm_link_rsrc_bundle_tmplt 
GO
DROP TABLE wsm_location 
GO
DROP TABLE wsm_model 
GO
DROP TABLE wsm_model_method_template 
GO
DROP TABLE wsm_model_relationship 
GO
DROP TABLE wsm_policy_detail 
GO
DROP TABLE wsm_profile_schedule 
GO
DROP TABLE wsm_propogation_model 
GO
DROP TABLE wsm_propogation_model_ext 
GO
DROP TABLE wsm_provisioning 
GO
DROP TABLE wsm_relationship_attrib 
GO
DROP TABLE wsm_resource_bundle 
GO
DROP TABLE wsm_rule 
GO
DROP TABLE wsm_status_definition 
GO
DROP TABLE wsm_subnets 
GO
DROP TABLE wsm_task_attribute 
GO
DROP TABLE wsm_task_list 
GO
DROP TABLE wsm_task_schedule 
GO
DROP TABLE wsm_template 
GO
DROP TABLE wsm_template_type 
GO
DROP TABLE wsm_user 
GO
DROP TABLE wsm_userprofile_assoc_detail 
GO
DROP TABLE wsm_userprofile_detail 
GO
DROP TABLE wsm_user_gui_configuration 
GO
DROP TABLE wsm_user_gui_config_item 
GO
DROP TABLE wspcol 
GO
DROP TABLE wsptbl 
GO
DROP TABLE wtaccesspointreference 
GO
DROP TABLE wtaccessstax 
GO
DROP TABLE wtaccess_point 
GO
DROP TABLE wtadhoc_access_point 
GO
DROP TABLE wtagent 
GO
DROP TABLE wtanoatmif 
GO
DROP TABLE wtanoatmlink 
GO
DROP TABLE wtanodevice 
GO
DROP TABLE wtanodscagent 
GO
DROP TABLE wtanofroif 
GO
DROP TABLE wtanointerface 
GO
DROP TABLE wtapc_ups 
GO
DROP TABLE wtas400 
GO
DROP TABLE wtasante 
GO
DROP TABLE wtatm 
GO
DROP TABLE wtatm_interface 
GO
DROP TABLE wtatm_link 
GO
DROP TABLE wtavayaaccesspoint 
GO
DROP TABLE wtbattery 
GO
DROP TABLE wtbaybridge 
GO
DROP TABLE wtbayhub 
GO
DROP TABLE wtbelkinaccesspoint 
GO
DROP TABLE wtbgp_link 
GO
DROP TABLE wtbillboard 
GO
DROP TABLE wtbreezecomaccesspoint 
GO
DROP TABLE wtbridge 
GO
DROP TABLE wtbuffalo_access_point 
GO
DROP TABLE wtbull 
GO
DROP TABLE wtbus 
GO
DROP TABLE wtcabletron 
GO
DROP TABLE wtcacmo_cpu 
GO
DROP TABLE wtcacmo_hacmp 
GO
DROP TABLE wtcacmo_hacmphost 
GO
DROP TABLE wtcacmo_hacmpinterface 
GO
DROP TABLE wtcacmo_hacmpresource 
GO
DROP TABLE wtcacmo_hacmpresourcegroup 
GO
DROP TABLE wtcacmo_hpserviceguard 
GO
DROP TABLE wtcacmo_hpsgfilesystem 
GO
DROP TABLE wtcacmo_hpsghost 
GO
DROP TABLE wtcacmo_hpsgpackage 
GO
DROP TABLE wtcacmo_hpsgservice 
GO
DROP TABLE wtcacmo_mem 
GO
DROP TABLE wtcacmo_msclusterservice 
GO
DROP TABLE wtcacmo_mscshost 
GO
DROP TABLE wtcacmo_mscsquorum 
GO
DROP TABLE wtcacmo_mscsresource 
GO
DROP TABLE wtcacmo_mscsresourcegroup 
GO
DROP TABLE wtcacmo_redhatcluhost 
GO
DROP TABLE wtcacmo_redhatclumanager 
GO
DROP TABLE wtcacmo_redhatcluser 
GO
DROP TABLE wtcacmo_schost 
GO
DROP TABLE wtcacmo_veritascluster 
GO
DROP TABLE wtcamera_3d 
GO
DROP TABLE wtchargeback 
GO
DROP TABLE wtchassis 
GO
DROP TABLE wtchipcom 
GO
DROP TABLE wtcisco 
GO
DROP TABLE wtcisco_aironet1100_access_point 
GO
DROP TABLE wtcisco_aironet1200_access_point 
GO
DROP TABLE wtcisco_aironet340_access_point 
GO
DROP TABLE wtcisco_aironet350_access_point 
GO
DROP TABLE wtcmutek 
GO
DROP TABLE wtcompaq_access_point 
GO
DROP TABLE wtcontextmenu 
GO
DROP TABLE wtdatacomagtinst 
GO
DROP TABLE wtdbpvqueryinfo 
GO
DROP TABLE wtdecbridge 
GO
DROP TABLE wtdechub 
GO
DROP TABLE wtdecrouter 
GO
DROP TABLE wtdecsystem 
GO
DROP TABLE wtdevice_disk_ide 
GO
DROP TABLE wtdevice_disk_scsi 
GO
DROP TABLE wtdevice_tapelibrary 
GO
DROP TABLE wtdg_ux 
GO
DROP TABLE wtdlink_access_point 
GO
DROP TABLE wtdomain 
GO
DROP TABLE wtdro_e10k_cb_folder 
GO
DROP TABLE wtdro_e10k_domains 
GO
DROP TABLE wtdro_e10k_domain_folder 
GO
DROP TABLE wtdro_e10k_fans 
GO
DROP TABLE wtdro_e10k_primary_cb 
GO
DROP TABLE wtdro_e10k_spare_cb 
GO
DROP TABLE wtdro_e10k_ssp 
GO
DROP TABLE wtdro_e10k_system_boards 
GO
DROP TABLE wtdro_e10k_system_board_folder 
GO
DROP TABLE wtdro_e10k_trays 
GO
DROP TABLE wtdro_e10k_tray_folder 
GO
DROP TABLE wtdro_ibmlpar 
GO
DROP TABLE wtdro_plfolder 
GO
DROP TABLE wtdro_plmem 
GO
DROP TABLE wtdro_plpar 
GO
DROP TABLE wtdro_plpartition 
GO
DROP TABLE wtdro_plprofile 
GO
DROP TABLE wtdro_plslot 
GO
DROP TABLE wtDRO_PLVEthernet 
GO
DROP TABLE wtDRO_PLVSCSI 
GO
DROP TABLE wtDRO_PLVSerial 
GO
DROP TABLE wtdro_starfire 
GO
DROP TABLE wtdro_sunfire 
GO
DROP TABLE wtdro_sunfire_cb_folder 
GO
DROP TABLE wtdro_sunfire_domain_folder 
GO
DROP TABLE wtdro_sunfire_highend 
GO
DROP TABLE wtdro_sunfire_highend_domain 
GO
DROP TABLE wtdro_sunfire_highend_fans 
GO
DROP TABLE wtdro_sunfire_highend_main_sc 
GO
DROP TABLE wtdro_sunfire_highend_sb_cpu 
GO
DROP TABLE wtdro_sunfire_highend_sb_io 
GO
DROP TABLE wtdro_sunfire_highend_spare_sc 
GO
DROP TABLE wtdro_sunfire_highend_trays 
GO
DROP TABLE wtdro_sunfire_midrange 
GO
DROP TABLE wtdro_sunfire_midrange_domain 
GO
DROP TABLE wtdro_sunfire_midrange_fans 
GO
DROP TABLE wtdro_sunfire_midrange_pri_cb 
GO
DROP TABLE wtdro_sunfire_midrange_sb_cpu 
GO
DROP TABLE wtdro_sunfire_midrange_sb_io 
GO
DROP TABLE wtdro_sunfire_midrange_sb_others 
GO
DROP TABLE wtdro_sunfire_midrange_spr_cb 
GO
DROP TABLE wtdro_sunfire_midrange_trays 
GO
DROP TABLE wtdro_sunfire_msp 
GO
DROP TABLE wtdro_sunfire_sb_folder 
GO
DROP TABLE wtdro_sunfire_tray_folder 
GO
DROP TABLE wteauditmessageannotate 
GO
DROP TABLE wteauditmessagegroup 
GO
DROP TABLE wteauditmessagegroupannotate 
GO
DROP TABLE wteauditmessagegroupmessage 
GO
DROP TABLE wtentrasys_access_point 
GO
DROP TABLE wtepcomsmpnodegroup 
GO
DROP TABLE wtepworldspace 
GO
DROP TABLE wtepworld_ecs_c6 
GO
DROP TABLE wtepworld_ecs_pc 
GO
DROP TABLE wtepworld_ecs_s1 
GO
DROP TABLE wtepworld_ecs_s2 
GO
DROP TABLE wtepworld_ecs_s3 
GO
DROP TABLE wtepworld_ecs_s4 
GO
DROP TABLE wtepworld_ecs_s5 
GO
DROP TABLE wtepworld_eportal_c5 
GO
DROP TABLE wtepworld_eportal_c8 
GO
DROP TABLE wtepworld_eportal_pc 
GO
DROP TABLE wtepworld_eportal_s10 
GO
DROP TABLE wtepworld_eportal_s11 
GO
DROP TABLE wtepworld_eportal_s12 
GO
DROP TABLE wtepworld_eportal_s14 
GO
DROP TABLE wtepworld_eportal_s15 
GO
DROP TABLE wtepworld_eportal_s2 
GO
DROP TABLE wtepworld_eportal_s3 
GO
DROP TABLE wtepworld_eportal_s6 
GO
DROP TABLE wtepworld_eportal_s7 
GO
DROP TABLE wtepworld_itech_c3 
GO
DROP TABLE wtepworld_itech_c4 
GO
DROP TABLE wtepworld_itech_pc 
GO
DROP TABLE wtepworld_itech_s5 
GO
DROP TABLE wtepworld_itech_s7 
GO
DROP TABLE wtepworld_mswin_c2 
GO
DROP TABLE wtepworld_mswin_c3 
GO
DROP TABLE wtepworld_mswin_pc 
GO
DROP TABLE wtepworld_mswin_s1 
GO
DROP TABLE wtepworld_tsenbl_pc 
GO
DROP TABLE wtepworld_tsenbl_s1 
GO
DROP TABLE wtericsson_access_point 
GO
DROP TABLE wtethairnetaccesspoint 
GO
DROP TABLE wtetsmim 
GO
DROP TABLE wtfoundry 
GO
DROP TABLE wtframerelaytrunk 
GO
DROP TABLE wtframerelay_pvc_endpoint 
GO
DROP TABLE wtframerelay_switch 
GO
DROP TABLE wtfrlink 
GO
DROP TABLE wtfujiuxp 
GO
DROP TABLE wtgatorstar 
GO
DROP TABLE wtgenericpc 
GO
DROP TABLE wthawking_access_point 
GO
DROP TABLE wthost 
GO
DROP TABLE wthpbridge 
GO
DROP TABLE wthphub 
GO
DROP TABLE wthpserver 
GO
DROP TABLE wthpunix 
GO
DROP TABLE wthp_printer 
GO
DROP TABLE wthub 
GO
DROP TABLE wtibm 
GO
DROP TABLE wtibm3090 
GO
DROP TABLE wtibm_access_point 
GO
DROP TABLE wtibm_mss 
GO
DROP TABLE wticlunix 
GO
DROP TABLE wticssnmp 
GO
DROP TABLE wtidmsinstance 
GO
DROP TABLE wtintel_access_point 
GO
DROP TABLE wtinteractive 
GO
DROP TABLE wtipx_generic_interface 
GO
DROP TABLE wtipx_host 
GO
DROP TABLE wtipx_printserver 
GO
DROP TABLE wtirm2snmp 
GO
DROP TABLE wtkarlnetaccesspoint 
GO
DROP TABLE wtlane 
GO
DROP TABLE wtlaserprinter 
GO
DROP TABLE wtlec 
GO
DROP TABLE wtlecs 
GO
DROP TABLE wtles 
GO
DROP TABLE wtlight_3d 
GO
DROP TABLE wtlinksysaccesspoint 
GO
DROP TABLE wtlinux 
GO
DROP TABLE wtlun 
GO
DROP TABLE wtmacintosh 
GO
DROP TABLE wtmanagedpc 
GO
DROP TABLE wtmicom 
GO
DROP TABLE wtmicrosoftadsdevice 
GO
DROP TABLE wtmkagent 
GO
DROP TABLE wtmobiledevice 
GO
DROP TABLE wtmqaliasq 
GO
DROP TABLE wtmqaliasqinst 
GO
DROP TABLE wtmqchaninit 
GO
DROP TABLE wtmqchaninitinst 
GO
DROP TABLE wtmqchannel 
GO
DROP TABLE wtmqchannelinst 
GO
DROP TABLE wtmqdlq 
GO
DROP TABLE wtmqdlqinst 
GO
DROP TABLE wtmqmgr 
GO
DROP TABLE wtmqmgrinst 
GO
DROP TABLE wtmqmodelq 
GO
DROP TABLE wtmqmodelqinst 
GO
DROP TABLE wtmqprocess 
GO
DROP TABLE wtmqprocessinst 
GO
DROP TABLE wtmqpsid 
GO
DROP TABLE wtmqpsidinst 
GO
DROP TABLE wtmqqueue 
GO
DROP TABLE wtmqqueueinst 
GO
DROP TABLE wtmqremoteq 
GO
DROP TABLE wtmqremoteqinst 
GO
DROP TABLE wtmqsinstance 
GO
DROP TABLE wtmultinet 
GO
DROP TABLE wtmulti_port 
GO
DROP TABLE wtncrunix 
GO
DROP TABLE wtnetgearaccesspoint 
GO
DROP TABLE wtnetgeneral 
GO
DROP TABLE wtnetjet_printerserver 
GO
DROP TABLE wtnetque_printerserver 
GO
DROP TABLE wtnetsnmp 
GO
DROP TABLE wtnetworth 
GO
DROP TABLE wtngsniffer 
GO
DROP TABLE wtnortel_access_point 
GO
DROP TABLE wtnovell 
GO
DROP TABLE wtnovellhub 
GO
DROP TABLE wtopenvms 
GO
DROP TABLE wtopenvms_system_monitor 
GO
DROP TABLE wtorinocoaccesspoint 
GO
DROP TABLE wtos2 
GO
DROP TABLE wtospf_area 
GO
DROP TABLE wtospf_link 
GO
DROP TABLE wtospf_router 
GO
DROP TABLE wtotherdevices 
GO
DROP TABLE wtpcniu 
GO
DROP TABLE wtperformance 
GO
DROP TABLE wtperformancetrend 
GO
DROP TABLE wtprinters 
GO
DROP TABLE wtprobe 
GO
DROP TABLE wtprofiledomainserver 
GO
DROP TABLE wtproxim_access_point 
GO
DROP TABLE wtpv705n 
GO
DROP TABLE wtqlogic_switch 
GO
DROP TABLE wtresponsemanagercollector 
GO
DROP TABLE wtrisc6000 
GO
DROP TABLE wtroamaboutaccesspoint 
GO
DROP TABLE wtrogue_access_point 
GO
DROP TABLE wtrouter 
GO
DROP TABLE wtrouter_interface 
GO
DROP TABLE wtsamsung 
GO
DROP TABLE wtsapagent 
GO
DROP TABLE wtsapinstance 
GO
DROP TABLE wtsapinstance4 
GO
DROP TABLE wtscounix 
GO
DROP TABLE wtsequent_server 
GO
DROP TABLE wtsiemenux 
GO
DROP TABLE wtsilicon 
GO
DROP TABLE wtsmcaccesspoint 
GO
DROP TABLE wtsolaris 
GO
DROP TABLE wtssmedia 
GO
DROP TABLE wtssmediasubnet 
GO
DROP TABLE wtssmodule 
GO
DROP TABLE wtssport 
GO
DROP TABLE wtssroute 
GO
DROP TABLE wtsssubnet 
GO
DROP TABLE wtssswitch 
GO
DROP TABLE wtssvlan 
GO
DROP TABLE wtssvtpdomain 
GO
DROP TABLE wtstoragesubsystem 
GO
DROP TABLE wtsunos 
GO
DROP TABLE wtsuspectaccesspoint 
GO
DROP TABLE wtswitch 
GO
DROP TABLE wtswitch_interface 
GO
DROP TABLE wtsymbol80211_11m_access_point 
GO
DROP TABLE wtsymbol80211_1_2m_access_point 
GO
DROP TABLE wtsymbol_1m_access_point 
GO
DROP TABLE wtsynoptics 
GO
DROP TABLE wtsynoptics_bridge 
GO
DROP TABLE wttandem 
GO
DROP TABLE wttapesubsystem 
GO
DROP TABLE wttelebit 
GO
DROP TABLE wttnd_icon 
GO
DROP TABLE wttng_ipx_discovery_status 
GO
DROP TABLE wttooltip 
GO
DROP TABLE wtubempower 
GO
DROP TABLE wtubniu 
GO
DROP TABLE wtunicenter_openvms 
GO
DROP TABLE wtunicenter_openvmsmanagedobject 
GO
DROP TABLE wtunisys 
GO
DROP TABLE wtunix 
GO
DROP TABLE wtunixware 
GO
DROP TABLE wtups 
GO
DROP TABLE wturm 
GO
DROP TABLE wtusr_access_point 
GO
DROP TABLE wtvcp_1000 
GO
DROP TABLE wtvip_interface 
GO
DROP TABLE wtvitalink 
GO
DROP TABLE wtvlan 
GO
DROP TABLE wtvlan_interface 
GO
DROP TABLE wtvlan_switch 
GO
DROP TABLE wtvmo_cpu 
GO
DROP TABLE wtvmo_disk_io 
GO
DROP TABLE wtvmo_guestos 
GO
DROP TABLE wtvmo_hb 
GO
DROP TABLE wtvmo_linux 
GO
DROP TABLE wtvmo_linux_hostos 
GO
DROP TABLE wtvmo_mem 
GO
DROP TABLE wtvmo_msdos 
GO
DROP TABLE wtvmo_netware4 
GO
DROP TABLE wtvmo_netware5 
GO
DROP TABLE wtvmo_netware6 
GO
DROP TABLE wtvmo_network_io 
GO
DROP TABLE wtvmo_other 
GO
DROP TABLE wtvmo_power 
GO
DROP TABLE wtvmo_win2k3es 
GO
DROP TABLE wtvmo_win2k3s 
GO
DROP TABLE wtvmo_win2k3ws 
GO
DROP TABLE wtvmo_win2kas 
GO
DROP TABLE wtvmo_win2kp 
GO
DROP TABLE wtvmo_win2ks 
GO
DROP TABLE wtvmo_win31 
GO
DROP TABLE wtvmo_win95 
GO
DROP TABLE wtvmo_win98 
GO
DROP TABLE wtvmo_windows_hostos 
GO
DROP TABLE wtvmo_winme 
GO
DROP TABLE wtvmo_winnt 
GO
DROP TABLE wtvmo_winxph 
GO
DROP TABLE wtvmo_winxpp 
GO
DROP TABLE wtwbem 
GO
DROP TABLE wtwellfleet 
GO
DROP TABLE wtwindows 
GO
DROP TABLE wtwindows2000 
GO
DROP TABLE wtwindows2000_server 
GO
DROP TABLE wtwindows9x 
GO
DROP TABLE wtwindowsnt 
GO
DROP TABLE wtwindowsnt_server 
GO
DROP TABLE wtwindowsxp 
GO
DROP TABLE wtwindows_netserver 
GO
DROP TABLE wtwireless_domain 
GO
DROP TABLE wtworkstation 
GO
DROP TABLE wtxterm 
GO
DROP TABLE wtzone 
GO
DROP TABLE wtzoneset 
GO
DROP TABLE wt_3com 
GO
DROP TABLE wt_3com_access_point 
GO
DROP TABLE xent_map 
GO
DROP TABLE actiongroup 
GO
DROP TABLE actiontype 
GO
DROP TABLE amepdef 
GO
DROP TABLE application_type 
GO
DROP TABLE asset_software_delivery_job 
GO
DROP TABLE ca_discovered_hardware 
GO

PRINT  'Drop Views' 
GO

DROP VIEW ActivitiesAvgOverdueView 
GO
DROP VIEW ActivitiesLateCompView 
GO
DROP VIEW ActivitiesLateIncompView 
GO
DROP VIEW ActivitiesTimeToDueDate 
GO
DROP VIEW activitydistravgsview 
GO
DROP VIEW activitydistrcompview 
GO
DROP VIEW ActorBottleneckView 
GO
DROP VIEW ActorThroughputView 
GO
DROP VIEW aiv_usrtoorglast 
GO
DROP VIEW alamode 
GO
DROP VIEW AlertView 
GO
DROP VIEW anomalycommentview 
GO
DROP VIEW apps 
GO
DROP VIEW appsbycategory 
GO
DROP VIEW appsetrust 
GO
DROP VIEW BaselineBGP4View 
GO
DROP VIEW BaselineCiscoView 
GO
DROP VIEW BaselineEtherStatsView 
GO
DROP VIEW BaselineFRView 
GO
DROP VIEW BaselineFSView 
GO
DROP VIEW BaselineIfView 
GO
DROP VIEW BaselineIpView 
GO
DROP VIEW BaselineLPView 
GO
DROP VIEW BaselineLUView 
GO
DROP VIEW BaselineNBarView 
GO
DROP VIEW BaselineRMON2ProtoView 
GO
DROP VIEW BaselineRTTCaptureView 
GO
DROP VIEW BaselineRTTCollView 
GO
DROP VIEW BaselineRTTJitterView 
GO
DROP VIEW BaselineTSView 
GO
DROP VIEW BGP4AlertView 
GO
DROP VIEW BGP4PeerEntryMessageDayView 
GO
DROP VIEW BGP4PeerEntryMessageHourView 
GO
DROP VIEW BGP4PeerEntryMessageLastDayView 
GO
DROP VIEW BGP4PeerEntryMessageLastWeekView 
GO
DROP VIEW BGP4PeerEntryMessageMinuteView 
GO
DROP VIEW BGP4PeerEntryMessageMonthView 
GO
DROP VIEW BGP4PeerEntryMessagePSDayView 
GO
DROP VIEW BGP4PeerEntryMessagePSHourView 
GO
DROP VIEW BGP4PeerEntryMessagePSMinuteView 
GO
DROP VIEW BGP4PeerEntryMessagePSMonthView 
GO
DROP VIEW BGP4PeerEntryMessageThView 
GO
DROP VIEW BGP4ScoreBoard 
GO
DROP VIEW buildingview 
GO
DROP VIEW ca_am_agent_view
GO
DROP VIEW ca_am_asset_derived_status 
GO
DROP VIEW ca_coapi_agent_view 
GO
DROP VIEW ca_coapi_agent_view_nodomsrv_v1 
GO
DROP VIEW ca_coapi_agent_view_nodom_v1 
GO
DROP VIEW ca_coapi_agent_view_nosrv_v1 
GO
DROP VIEW ca_coapi_agent_view_v1 
GO
DROP VIEW ca_v_query_def_user 
GO
DROP VIEW CiscoAlertView 
GO
DROP VIEW CiscoScoreBoard 
GO
DROP VIEW CiscoStatsDayView 
GO
DROP VIEW CiscoStatsHourView 
GO
DROP VIEW CiscoStatsLastDayView 
GO
DROP VIEW CiscoStatsLastWeekView 
GO
DROP VIEW CiscoStatsMinuteView 
GO
DROP VIEW CiscoStatsMonthView 
GO
DROP VIEW CiscoStatsPSDayView 
GO
DROP VIEW CiscoStatsPSHourView 
GO
DROP VIEW CiscoStatsPSMinuteView 
GO
DROP VIEW CiscoStatsPSMonthView 
GO
DROP VIEW CiscoStatsThView 
GO
DROP VIEW CiscoTemperature_statDayView 
GO
DROP VIEW CiscoTemperature_statHourView 
GO
DROP VIEW CiscoTemperature_statLastDayView 
GO
DROP VIEW CiscoTemperature_statLastWeek 
GO
DROP VIEW CiscoTemperature_statMinuteView 
GO
DROP VIEW CiscoTemperature_statMonthView 
GO
DROP VIEW CiscoTemperature_statPSDayView 
GO
DROP VIEW CiscoTemperature_statPSHourView 
GO
DROP VIEW CiscoTemperature_statPSMinute 
GO
DROP VIEW CiscoTemperature_statPSMonthView 
GO
DROP VIEW CiscoVoltage_statDayView 
GO
DROP VIEW CiscoVoltage_statHourView 
GO
DROP VIEW CiscoVoltage_statLastDayView 
GO
DROP VIEW CiscoVoltage_statLastWeekView 
GO
DROP VIEW CiscoVoltage_statMinuteView 
GO
DROP VIEW CiscoVoltage_statMonthView 
GO
DROP VIEW CiscoVoltage_statPSDayView 
GO
DROP VIEW CiscoVoltage_statPSHourView 
GO
DROP VIEW CiscoVoltage_statPSMinuteView 
GO
DROP VIEW CiscoVoltage_statPSMonthView 
GO
DROP VIEW CriticalInterfaceView 
GO
DROP VIEW csm_v_computer 
GO
DROP VIEW csm_v_parameter 
GO
DROP VIEW csm_v_property 
GO
DROP VIEW CurrentNonAvailView 
GO
DROP VIEW DeviceTypeView 
GO
DROP VIEW DeviceView 
GO
DROP VIEW dts_dtasset_view
GO
DROP VIEW e2e_apm_AnalysisAlertsV 
GO
DROP VIEW e2e_apm_AnalysisDetailV 
GO
DROP VIEW e2e_apm_AnalysisDetail_dayV 
GO
DROP VIEW e2e_apm_AnalysisDetail_hourV 
GO
DROP VIEW e2e_apm_AppOpSummaryV 
GO
DROP VIEW e2e_apm_AppOpSummary_dayV 
GO
DROP VIEW e2e_apm_AppOpSummary_hourV 
GO
DROP VIEW e2e_apm_CancellationDetailV 
GO
DROP VIEW e2e_apm_CancellationDetail_dayV 
GO
DROP VIEW e2e_apm_CancellationDetail_hourV 
GO
DROP VIEW e2e_apm_ClientSummaryV 
GO
DROP VIEW e2e_apm_ClientSummary_dayV 
GO
DROP VIEW e2e_apm_ClientSummary_hourV 
GO
DROP VIEW e2e_apm_ExceptionDetail2V 
GO
DROP VIEW e2e_apm_ExceptionDetail2_dayV 
GO
DROP VIEW e2e_apm_ExceptionDetail2_hourV 
GO
DROP VIEW e2e_apm_ExceptionDetail3V 
GO
DROP VIEW e2e_apm_ExceptionDetail3_dayV 
GO
DROP VIEW e2e_apm_ExceptionDetail3_hourV 
GO
DROP VIEW e2e_apm_ExceptionDetailV 
GO
DROP VIEW e2e_apm_ExceptionDetail_dayV 
GO
DROP VIEW e2e_apm_ExceptionDetail_hourV 
GO
DROP VIEW e2e_apm_GeneralDetailV 
GO
DROP VIEW e2e_apm_GeneralDetail_dayV 
GO
DROP VIEW e2e_apm_GeneralDetail_hourV 
GO
DROP VIEW e2e_apm_LocationDetailsV 
GO
DROP VIEW e2e_apm_LocationDetails_dayV 
GO
DROP VIEW e2e_apm_LocationDetails_hourV 
GO
DROP VIEW e2e_apm_NonExceptDetail3V 
GO
DROP VIEW e2e_apm_NonExceptDetail3_dayV 
GO
DROP VIEW e2e_apm_NonExceptDetail3_hourV 
GO
DROP VIEW e2e_apm_OperationSummaryV 
GO
DROP VIEW e2e_apm_OperationSummary_dayV 
GO
DROP VIEW e2e_apm_OperationSummary_hourV 
GO
DROP VIEW e2e_apm_RootCauseAnalysisV 
GO
DROP VIEW e2e_apm_ServerSummaryV 
GO
DROP VIEW e2e_apm_ServerSummary_dayV 
GO
DROP VIEW e2e_apm_ServerSummary_hourV 
GO
DROP VIEW e2e_apm_SubTransactionsDetailV 
GO
DROP VIEW e2e_apm_WebResponseDetailV 
GO
DROP VIEW e2e_apm_WebResponseDetail_dayV 
GO
DROP VIEW e2e_apm_WebResponseDetail_hourV 
GO
DROP VIEW e2e_wrm_columnnamev 
GO
DROP VIEW e2e_wrm_wrmdetailv 
GO
DROP VIEW e2e_wrm_wrmgroupsummaryv 
GO
DROP VIEW e2e_wrm_wrmgroupsv 
GO
DROP VIEW e2e_wrm_wrminstancesv 
GO
DROP VIEW e2e_wrm_wrmmessagev 
GO
DROP VIEW e2e_wrm_wrmnotsentdetailv 
GO
DROP VIEW e2e_wrm_wrmreportdetailv 
GO
DROP VIEW e2e_wrm_wrmreportdnotrollv 
GO
DROP VIEW e2e_wrm_wrmreporthnotrollv 
GO
DROP VIEW e2e_wrm_wrmreportinotrollv 
GO
DROP VIEW e2e_wrm_wrmreportmnotrollv 
GO
DROP VIEW e2e_wrm_wrmreporttrandnotrollv 
GO
DROP VIEW e2e_wrm_wrmreporttranhnotrollv 
GO
DROP VIEW e2e_wrm_wrmreporttraninotrollv 
GO
DROP VIEW e2e_wrm_wrmreporttranmnotrollv 
GO
DROP VIEW e2e_wrm_wrmreporttranreqdnotroll 
GO
DROP VIEW e2e_wrm_wrmreporttranreqhnotroll 
GO
DROP VIEW e2e_wrm_wrmreporttranreqinotroll 
GO
DROP VIEW e2e_wrm_wrmreporttranreqmnotroll 
GO
DROP VIEW e2e_wrm_wrmreporttranreqwnotroll 
GO
DROP VIEW e2e_wrm_wrmreporttranwnotrollv 
GO
DROP VIEW e2e_wrm_wrmreportwnotrollv 
GO
DROP VIEW e2e_wrm_wrmtranrequestv 
GO
DROP VIEW e2e_wrm_wrmtransactionv 
GO
DROP VIEW e2e_wrm_wrmurlv 
GO
DROP VIEW EchoPathScoreBoard 
GO
DROP VIEW eventview 
GO
DROP VIEW FRAlertView 
GO
DROP VIEW FRCircuitStatsDayView 
GO
DROP VIEW FRCircuitStatsHourView 
GO
DROP VIEW FRCircuitStatsLastDayView 
GO
DROP VIEW FRCircuitStatsLastWeekView 
GO
DROP VIEW FRCircuitStatsMinuteView 
GO
DROP VIEW FRCircuitStatsMonthView 
GO
DROP VIEW FRCircuitStatsPSDayView 
GO
DROP VIEW FRCircuitStatsPSHourView 
GO
DROP VIEW FRCircuitStatsPSMinuteView 
GO
DROP VIEW FRCircuitStatsPSMonthView 
GO
DROP VIEW FRCircuitStatsThView 
GO
DROP VIEW FRScoreBoard 
GO
DROP VIEW hotfixdetailforcomputer 
GO
DROP VIEW iam_attribute_view 
GO
DROP VIEW iam_global_membership_view 
GO
DROP VIEW iam_global_user_attr_view 
GO
DROP VIEW iam_global_user_group_attr_view 
GO
DROP VIEW iam_global_user_group_view 
GO
DROP VIEW iam_global_user_view
GO
DROP VIEW iam_object_view
GO
DROP VIEW InterfaceAlertView 
GO
DROP VIEW InterfaceScoreBoard 
GO
DROP VIEW InterfaceView 
GO
DROP VIEW investigationhistoryview 
GO
DROP VIEW investigationview 
GO
DROP VIEW IPAlertView 
GO
DROP VIEW IPScoreBoard 
GO
DROP VIEW JitterScoreBoard 
GO
DROP VIEW jmo_wbr 
GO
DROP VIEW jobhistoryview 
GO
DROP VIEW jobview 
GO
DROP VIEW LANScoreBoard 
GO
DROP VIEW LSYFileServerClientsDayView 
GO
DROP VIEW LSYFileServerClientsHourView 
GO
DROP VIEW LSYFileServerClientsLastDayView 
GO
DROP VIEW LSYFileServerClientsLastWeekView 
GO
DROP VIEW LSYFileServerClientsMinuteView 
GO
DROP VIEW LSYFileServerClientsMonthView 
GO
DROP VIEW LSYFileServerClientsPSDayView 
GO
DROP VIEW LSYFileServerClientsPSHourView 
GO
DROP VIEW LSYFileServerClientsPSMinuteView 
GO
DROP VIEW LSYFileServerClientsPSMonthView 
GO
DROP VIEW LSYFileServerStatsDayView 
GO
DROP VIEW LSYFileServerStatsHourView 
GO
DROP VIEW LSYFileServerStatsLastDayView 
GO
DROP VIEW LSYFileServerStatsLastWeekView 
GO
DROP VIEW LSYFileServerStatsMinuteView 
GO
DROP VIEW LSYFileServerStatsMonthView 
GO
DROP VIEW LSYFileServerStatsPSDayView 
GO
DROP VIEW LSYFileServerStatsPSHourView 
GO
DROP VIEW LSYFileServerStatsPSMinuteView 
GO
DROP VIEW LSYFileServerStatsPSMonthView 
GO
DROP VIEW LSYFileServerStatsThView 
GO
DROP VIEW LSYLanProtocolsDayView 
GO
DROP VIEW LSYLanProtocolsHourView 
GO
DROP VIEW LSYLanProtocolsLastDayView 
GO
DROP VIEW LSYLanProtocolsLastWeekView 
GO
DROP VIEW LSYLanProtocolsMinuteView 
GO
DROP VIEW LSYLanProtocolsMonthView 
GO
DROP VIEW LSYLanProtocolsPSDayView 
GO
DROP VIEW LSYLanProtocolsPSHourView 
GO
DROP VIEW LSYLanProtocolsPSMinuteView 
GO
DROP VIEW LSYLanProtocolsPSMonthView 
GO
DROP VIEW LSYLanProtocolsThView 
GO
DROP VIEW LSYLanUtilizationDayView 
GO
DROP VIEW LSYLanUtilizationHourView 
GO
DROP VIEW LSYLanUtilizationLastDayView 
GO
DROP VIEW LSYLanUtilizationLastWeekView 
GO
DROP VIEW LSYLanUtilizationMinuteView 
GO
DROP VIEW LSYLanUtilizationMonthView 
GO
DROP VIEW LSYLanUtilizationPSDayView 
GO
DROP VIEW LSYLanUtilizationPSHourView 
GO
DROP VIEW LSYLanUtilizationPSMinuteView 
GO
DROP VIEW LSYLanUtilizationPSMonthView 
GO
DROP VIEW LSYLanUtilizationThView 
GO
DROP VIEW LSYTermServerClientsDayView 
GO
DROP VIEW LSYTermServerClientsHourView 
GO
DROP VIEW LSYTermServerClientsLastDayView 
GO
DROP VIEW LSYTermServerClientsLastWeekView 
GO
DROP VIEW LSYTermServerClientsMinuteView 
GO
DROP VIEW LSYTermServerClientsMonthView 
GO
DROP VIEW LSYTermServerClientsPSDayView 
GO
DROP VIEW LSYTermServerClientsPSHourView 
GO
DROP VIEW LSYTermServerClientsPSMinuteView 
GO
DROP VIEW LSYTermServerClientsPSMonthView 
GO
DROP VIEW LSYTermServerStatsDayView 
GO
DROP VIEW LSYTermServerStatsHourView 
GO
DROP VIEW LSYTermServerStatsLastDayView 
GO
DROP VIEW LSYTermServerStatsLastWeekView 
GO
DROP VIEW LSYTermServerStatsMinuteView 
GO
DROP VIEW LSYTermServerStatsMonthView 
GO
DROP VIEW LSYTermServerStatsPSDayView 
GO
DROP VIEW LSYTermServerStatsPSHourView 
GO
DROP VIEW LSYTermServerStatsPSMinuteView 
GO
DROP VIEW LSYTermServerStatsPSMonthView 
GO
DROP VIEW LSYTermServerStatsThView 
GO
DROP VIEW LSYTopNCastDayView 
GO
DROP VIEW LSYTopNCastHourView 
GO
DROP VIEW LSYTopNCastLastDayView 
GO
DROP VIEW LSYTopNCastLastWeekView 
GO
DROP VIEW LSYTopNCastMinuteView 
GO
DROP VIEW LSYTopNCastMonthView 
GO
DROP VIEW LSYTopNCastPSDayView 
GO
DROP VIEW LSYTopNCastPSHourView 
GO
DROP VIEW LSYTopNCastPSMinuteView 
GO
DROP VIEW LSYTopNCastPSMonthView 
GO
DROP VIEW LSYTopNLinkErrDayView 
GO
DROP VIEW LSYTopNLinkErrHourView 
GO
DROP VIEW LSYTopNLinkErrLastDayView 
GO
DROP VIEW LSYTopNLinkErrLastWeekView 
GO
DROP VIEW LSYTopNLinkErrMinuteView 
GO
DROP VIEW LSYTopNLinkErrMonthView 
GO
DROP VIEW LSYTopNLinkErrPSDayView 
GO
DROP VIEW LSYTopNLinkErrPSHourView 
GO
DROP VIEW LSYTopNLinkErrPSMinuteView 
GO
DROP VIEW LSYTopNLinkErrPSMonthView 
GO
DROP VIEW LSYTopNMatrixDayView 
GO
DROP VIEW LSYTopNMatrixHourView 
GO
DROP VIEW LSYTopNMatrixLastDayView 
GO
DROP VIEW LSYTopNMatrixLastWeekView 
GO
DROP VIEW LSYTopNMatrixMinuteView 
GO
DROP VIEW LSYTopNMatrixMonthView 
GO
DROP VIEW LSYTopNMatrixPSDayView 
GO
DROP VIEW LSYTopNMatrixPSHourView 
GO
DROP VIEW LSYTopNMatrixPSMinuteView 
GO
DROP VIEW LSYTopNMatrixPSMonthView 
GO
DROP VIEW LSYTopNNetRspDayView 
GO
DROP VIEW LSYTopNNetRspHourView 
GO
DROP VIEW LSYTopNNetRspLastDayView 
GO
DROP VIEW LSYTopNNetRspLastWeekView 
GO
DROP VIEW LSYTopNNetRspMinuteView 
GO
DROP VIEW LSYTopNNetRspMonthView 
GO
DROP VIEW LSYTopNNetRspPSDayView 
GO
DROP VIEW LSYTopNNetRspPSHourView 
GO
DROP VIEW LSYTopNNetRspPSMinuteView 
GO
DROP VIEW LSYTopNNetRspPSMonthView 
GO
DROP VIEW LSYTopNRouteDayView 
GO
DROP VIEW LSYTopNRouteDelayDayView 
GO
DROP VIEW LSYTopNRouteDelayHourView 
GO
DROP VIEW LSYTopNRouteDelayLastDayView 
GO
DROP VIEW LSYTopNRouteDelayLastWeekView 
GO
DROP VIEW LSYTopNRouteDelayMinuteView 
GO
DROP VIEW LSYTopNRouteDelayMonthView 
GO
DROP VIEW LSYTopNRouteDelayPSDayView 
GO
DROP VIEW LSYTopNRouteDelayPSHourView 
GO
DROP VIEW LSYTopNRouteDelayPSMinuteView 
GO
DROP VIEW LSYTopNRouteDelayPSMonthView 
GO
DROP VIEW LSYTopNRouteHourView 
GO
DROP VIEW LSYTopNRouteLastDayView 
GO
DROP VIEW LSYTopNRouteLastWeekView 
GO
DROP VIEW LSYTopNRouteMinuteView 
GO
DROP VIEW LSYTopNRouteMonthView 
GO
DROP VIEW LSYTopNRoutePSDayView 
GO
DROP VIEW LSYTopNRoutePSHourView 
GO
DROP VIEW LSYTopNRoutePSMinuteView 
GO
DROP VIEW LSYTopNRoutePSMonthView 
GO
DROP VIEW M2ifStatsDayView 
GO
DROP VIEW M2ifStatsHourView 
GO
DROP VIEW M2ifStatsLastDayView 
GO
DROP VIEW M2ifStatsLastWeekView 
GO
DROP VIEW M2ifStatsMinuteView 
GO
DROP VIEW M2ifStatsMonthView 
GO
DROP VIEW M2ifStatsPSDayView 
GO
DROP VIEW M2ifStatsPSHourView 
GO
DROP VIEW M2ifStatsPSMinuteView 
GO
DROP VIEW M2ifStatsPSMonthView 
GO
DROP VIEW M2ifStatsThView 
GO
DROP VIEW M2ipStatsDayView 
GO
DROP VIEW M2ipStatsHourView 
GO
DROP VIEW M2ipStatsLastDayView 
GO
DROP VIEW M2ipStatsLastWeekView 
GO
DROP VIEW M2ipStatsMinuteView 
GO
DROP VIEW M2ipStatsMonthView 
GO
DROP VIEW M2ipStatsPSDayView 
GO
DROP VIEW M2ipStatsPSHourView 
GO
DROP VIEW M2ipStatsPSMinuteView 
GO
DROP VIEW M2ipStatsPSMonthView 
GO
DROP VIEW M2ipStatsThView 
GO
DROP VIEW machineview 
GO
DROP VIEW MANAGEMENT_WBR 
GO
DROP VIEW MibIndexView 
GO
DROP VIEW NBarAlertView 
GO
DROP VIEW NBARprotocol_statDayView 
GO
DROP VIEW NBARprotocol_statHourView 
GO
DROP VIEW NBARprotocol_statLastDayView 
GO
DROP VIEW NBARprotocol_statLastWeekView 
GO
DROP VIEW NBARprotocol_statMinuteView 
GO
DROP VIEW NBARprotocol_statMonthView 
GO
DROP VIEW NBARprotocol_statPSDayView 
GO
DROP VIEW NBARprotocol_statPSHourView 
GO
DROP VIEW NBARprotocol_statPSMinuteView 
GO
DROP VIEW NBARprotocol_statPSMonthView 
GO
DROP VIEW NBARprotocol_statThView 
GO
DROP VIEW NBarScoreBoard 
GO
DROP VIEW NonAvailView 
GO
DROP VIEW NonAvailViewDayView 
GO
DROP VIEW NonAvailViewHourView 
GO
DROP VIEW NonAvailViewLastDayView 
GO
DROP VIEW NonAvailViewLastWeekView 
GO
DROP VIEW NonAvailViewMinuteView 
GO
DROP VIEW NonAvailViewMonthView 
GO
DROP VIEW NonAvailViewPSDayView 
GO
DROP VIEW NonAvailViewPSHourView 
GO
DROP VIEW NonAvailViewPSMinuteView 
GO
DROP VIEW NonAvailViewPSMonthView 
GO
DROP VIEW NonHealthDayView 
GO
DROP VIEW NonHealthHourView 
GO
DROP VIEW NonHealthLastDayView 
GO
DROP VIEW NonHealthLastWeekView 
GO
DROP VIEW NonHealthMinuteView 
GO
DROP VIEW NonHealthMonthView 
GO
DROP VIEW NonHealthPSDayView 
GO
DROP VIEW NonHealthPSHourView 
GO
DROP VIEW NonHealthPSMinuteView 
GO
DROP VIEW NonHealthPSMonthView 
GO
DROP VIEW NPOProbeAlertView 
GO
DROP VIEW NPOProbeScoreBoard 
GO
DROP VIEW NPOTSAlertView 
GO
DROP VIEW NPOTSScoreBoard 
GO
DROP VIEW OidColumnMappingView 
GO
DROP VIEW ols_v_user 
GO
DROP VIEW ols_v_user_link_profile 
GO
DROP VIEW OutstandingAlertView 
GO
DROP VIEW personview 
GO
DROP VIEW pmftoorg 
GO
DROP VIEW processlistview 
GO
DROP VIEW ProcStatusCompView 
GO
DROP VIEW ProcStatusIncompView 
GO
DROP VIEW ProcStatusJoinedView 
GO
DROP VIEW ProcStatusListView 
GO
DROP VIEW productidview 
GO
DROP VIEW productkeyview 
GO
DROP VIEW pubsum 
GO
DROP VIEW pubsumcomputers 
GO
DROP VIEW ResNonhealthDayView 
GO
DROP VIEW ResNonhealthHourView 
GO
DROP VIEW ResNonhealthLastDayView 
GO
DROP VIEW ResNonhealthLastWeekView 
GO
DROP VIEW ResNonhealthMinuteView 
GO
DROP VIEW ResNonhealthMonthView 
GO
DROP VIEW ResNonhealthPSDayView 
GO
DROP VIEW ResNonhealthPSHourView 
GO
DROP VIEW ResNonhealthPSMinuteView 
GO
DROP VIEW ResNonhealthPSMonthView 
GO
DROP VIEW resourcenamebgp4asview 
GO
DROP VIEW ResourceNameBGP4View 
GO
DROP VIEW ResourceNameCiscoView 
GO
DROP VIEW ResourceNameEchoPathView 
GO
DROP VIEW ResourceNameFRView 
GO
DROP VIEW ResourceNameInterfaceView 
GO
DROP VIEW ResourceNameIPView 
GO
DROP VIEW ResourceNameJitterView 
GO
DROP VIEW ResourceNameLANView 
GO
DROP VIEW ResourceNameNBarProtocolView 
GO
DROP VIEW ResourceNameNBarView 
GO
DROP VIEW ResourceNameNPOFSView 
GO
DROP VIEW ResourceNameNPOProbeView 
GO
DROP VIEW ResourceNameNPOTSView 
GO
DROP VIEW ResourceNameNPOWCView 
GO
DROP VIEW ResourceNameNPOWSView 
GO
DROP VIEW ResourceNameRMON2View 
GO
DROP VIEW ResourceNameRMONView 
GO
DROP VIEW ResourceNameServerView 
GO
DROP VIEW ResourceNameWANView 
GO
DROP VIEW RMON2AlHostDayView 
GO
DROP VIEW RMON2AlHostHourView 
GO
DROP VIEW RMON2AlHostLastDayView 
GO
DROP VIEW RMON2AlHostLastWeekView 
GO
DROP VIEW RMON2AlHostMinuteView 
GO
DROP VIEW RMON2AlHostMonthView 
GO
DROP VIEW RMON2AlHostPSDayView 
GO
DROP VIEW RMON2AlHostPSHourView 
GO
DROP VIEW RMON2AlHostPSMinuteView 
GO
DROP VIEW RMON2AlHostPSMonthView 
GO
DROP VIEW RMON2NlMatrixDayView 
GO
DROP VIEW RMON2NlMatrixHourView 
GO
DROP VIEW RMON2NlMatrixLastDayView 
GO
DROP VIEW RMON2NlMatrixLastWeekView 
GO
DROP VIEW RMON2NlMatrixMinuteView 
GO
DROP VIEW RMON2NlMatrixMonthView 
GO
DROP VIEW RMON2NlMatrixPSDayView 
GO
DROP VIEW RMON2NlMatrixPSHourView 
GO
DROP VIEW RMON2NlMatrixPSMinuteView 
GO
DROP VIEW RMON2NlMatrixPSMonthView 
GO
DROP VIEW RMON2ProtocolDistDayView 
GO
DROP VIEW RMON2ProtocolDistHourView 
GO
DROP VIEW RMON2ProtocolDistLastDayView 
GO
DROP VIEW RMON2ProtocolDistLastWeekView 
GO
DROP VIEW RMON2ProtocolDistMinuteView 
GO
DROP VIEW RMON2ProtocolDistMonthView 
GO
DROP VIEW RMON2ProtocolDistPSDayView 
GO
DROP VIEW RMON2ProtocolDistPSHourView 
GO
DROP VIEW RMON2ProtocolDistPSMinuteView 
GO
DROP VIEW RMON2ProtocolDistPSMonthView 
GO
DROP VIEW RMON2ProtocolDistThView 
GO
DROP VIEW RMON2ScoreBoard 
GO
DROP VIEW RMONAlertView 
GO
DROP VIEW RMONetherStatsStatsDayView 
GO
DROP VIEW RMONetherStatsStatsHourView 
GO
DROP VIEW RMONetherStatsStatsLastDayView 
GO
DROP VIEW RMONetherStatsStatsLastWeekView 
GO
DROP VIEW RMONetherStatsStatsMinuteView 
GO
DROP VIEW RMONetherStatsStatsMonthView 
GO
DROP VIEW RMONetherStatsStatsPSDayView 
GO
DROP VIEW RMONetherStatsStatsPSHourView 
GO
DROP VIEW RMONetherStatsStatsPSMinuteView 
GO
DROP VIEW RMONetherStatsStatsPSMonthView 
GO
DROP VIEW RMONetherStatsStatsThView 
GO
DROP VIEW RMONScoreBoard 
GO
DROP VIEW RTTJitter_statDayView 
GO
DROP VIEW RTTJitter_statHourView 
GO
DROP VIEW RTTJitter_statLastDayView 
GO
DROP VIEW RTTJitter_statLastWeekView 
GO
DROP VIEW RTTJitter_statMinuteView 
GO
DROP VIEW RTTJitter_statMonthView 
GO
DROP VIEW RTTJitter_statPSDayView 
GO
DROP VIEW RTTJitter_statPSHourView 
GO
DROP VIEW RTTJitter_statPSMinuteView 
GO
DROP VIEW RTTJitter_statPSMonthView 
GO
DROP VIEW RTTJitter_statThView 
GO
DROP VIEW RTTStatsCapture_statDayView 
GO
DROP VIEW RTTStatsCapture_statHourView 
GO
DROP VIEW RTTStatsCapture_statLastDayView 
GO
DROP VIEW RTTStatsCapture_statLastWeekView 
GO
DROP VIEW RTTStatsCapture_statMinuteView 
GO
DROP VIEW RTTStatsCapture_statMonthView 
GO
DROP VIEW RTTStatsCapture_statPSDayView 
GO
DROP VIEW RTTStatsCapture_statPSHourView 
GO
DROP VIEW RTTStatsCapture_statPSMinuteView 
GO
DROP VIEW RTTStatsCapture_statPSMonthView 
GO
DROP VIEW RTTStatsCapture_statThView 
GO
DROP VIEW RTTStatsColl_statDayView 
GO
DROP VIEW RTTStatsColl_statHourView 
GO
DROP VIEW RTTStatsColl_statLastDayView 
GO
DROP VIEW RTTStatsColl_statLastWeekView 
GO
DROP VIEW RTTStatsColl_statMinuteView 
GO
DROP VIEW RTTStatsColl_statMonthView 
GO
DROP VIEW RTTStatsColl_statPSDayView 
GO
DROP VIEW RTTStatsColl_statPSHourView 
GO
DROP VIEW RTTStatsColl_statPSMinuteView 
GO
DROP VIEW RTTStatsColl_statPSMonthView 
GO
DROP VIEW RTTStatsColl_statThView 
GO
DROP VIEW RTTStats_stat 
GO
DROP VIEW RTTStats_statDayView 
GO
DROP VIEW RTTStats_statHourView 
GO
DROP VIEW RTTStats_statLastDayView 
GO
DROP VIEW RTTStats_statLastWeekView 
GO
DROP VIEW RTTStats_statMinuteView 
GO
DROP VIEW RTTStats_statMonthView 
GO
DROP VIEW RTTStats_statPSDayView 
GO
DROP VIEW RTTStats_statPSHourView 
GO
DROP VIEW RTTStats_statPSMinuteView 
GO
DROP VIEW RTTStats_statPSMonthView 
GO
DROP VIEW rulebase_list 
GO
DROP VIEW rule_dec_combo_list 
GO
DROP VIEW statview 
GO
DROP VIEW storagefilesystemsum 
GO
DROP VIEW storagefssum 
GO
DROP VIEW tau_mdb 
GO
DROP VIEW ThresholdsView 
GO
DROP VIEW ujo_eventvu 
GO
DROP VIEW ujo_jobst 
GO
DROP VIEW ujo_proc_eventvu 
GO
DROP VIEW usd_compos 
GO
DROP VIEW usd_iprocos 
GO
DROP VIEW usd_vq_target 
GO
DROP VIEW usd_v_agents 
GO
DROP VIEW usd_v_asset_grp 
GO
DROP VIEW usd_v_common_grp 
GO
DROP VIEW usd_v_container_installations 
GO
DROP VIEW usd_v_container_installations_a_s 
GO
DROP VIEW usd_v_container_installations_s 
GO
DROP VIEW usd_v_container_jobs 
GO
DROP VIEW usd_v_container_jobs_a_s 
GO
DROP VIEW usd_v_container_jobs_s 
GO
DROP VIEW usd_v_csite 
GO
DROP VIEW usd_v_group_installed_products 
GO
DROP VIEW usd_v_group_installed_products_a_s 
GO
DROP VIEW usd_v_group_installed_products_s 
GO
DROP VIEW usd_v_group_jobs 
GO
DROP VIEW usd_v_group_jobs_a_s 
GO
DROP VIEW usd_v_group_jobs_s 
GO
DROP VIEW usd_v_installed_products 
GO
DROP VIEW usd_v_installed_products_a_s 
GO
DROP VIEW usd_v_installed_products_s 
GO
DROP VIEW usd_v_ls 
GO
DROP VIEW usd_v_lsg 
GO
DROP VIEW usd_v_nr_of_active_applics 
GO
DROP VIEW usd_v_nr_of_ok_applics 
GO
DROP VIEW usd_v_nr_of_renew_active_applics 
GO
DROP VIEW usd_v_nr_of_renew_ok_applics 
GO
DROP VIEW usd_v_nr_of_renew_wait_applics 
GO
DROP VIEW usd_v_nr_of_waiting_applics 
GO
DROP VIEW usd_v_osim_targets 
GO
DROP VIEW usd_v_osim_targets_all 
GO
DROP VIEW usd_v_osim_targets_a_s 
GO
DROP VIEW usd_v_osim_targets_deleted 
GO
DROP VIEW usd_v_osim_targets_s 
GO
DROP VIEW usd_v_ownsite 
GO
DROP VIEW usd_v_product_jobs 
GO
DROP VIEW usd_v_product_jobs_a_s 
GO
DROP VIEW usd_v_product_jobs_s 
GO
DROP VIEW usd_v_product_procedures 
GO
DROP VIEW usd_v_product_procedures_a_s 
GO
DROP VIEW usd_v_product_procedures_s 
GO
DROP VIEW usd_v_query_del_time 
GO
DROP VIEW usd_v_query_inst_time 
GO
DROP VIEW usd_v_server_grp 
GO
DROP VIEW usd_v_sserver_clients 
GO
DROP VIEW usd_v_sserver_clients_a_s 
GO
DROP VIEW usd_v_sserver_clients_s 
GO
DROP VIEW usd_v_target 
GO
DROP VIEW usd_v_targets_os 
GO
DROP VIEW usd_v_targets_os_a_s 
GO
DROP VIEW usd_v_targets_os_s 
GO
DROP VIEW usd_v_target_jobs 
GO
DROP VIEW usd_v_target_jobs_a_s 
GO
DROP VIEW usd_v_target_jobs_s 
GO
DROP VIEW usd_v_user_dhw_area_sec 
GO
DROP VIEW usd_v_user_dhw_sec 
GO
DROP VIEW UserGroupResourceView 
GO
DROP VIEW UserGroupView 
GO
DROP VIEW userhasreports 
GO
DROP VIEW UserProbeView 
GO
DROP VIEW v$gla_data 
GO
DROP VIEW View_Act_Log 
GO
DROP VIEW View_Audit_Assignee 
GO
DROP VIEW View_Audit_Group 
GO
DROP VIEW View_Audit_Priority 
GO
DROP VIEW View_Audit_Status 
GO
DROP VIEW View_Change 
GO
DROP VIEW View_Change_Act_Log 
GO
DROP VIEW View_Change_to_Assets 
GO
DROP VIEW View_Change_to_Change_Act_Log 
GO
DROP VIEW View_Change_to_Change_WF 
GO
DROP VIEW View_Change_to_Properties 
GO
DROP VIEW View_Change_to_Request 
GO
DROP VIEW View_Contact_Full 
GO
DROP VIEW View_Contact_to_Environment 
GO
DROP VIEW View_Group 
GO
DROP VIEW View_Group_to_Contact 
GO
DROP VIEW View_Issue 
GO
DROP VIEW View_Issue_Act_Log 
GO
DROP VIEW View_Issue_to_Assets 
GO
DROP VIEW View_Issue_to_Issue_Act_Log 
GO
DROP VIEW View_Issue_to_Issue_WF 
GO
DROP VIEW View_Issue_to_Properties 
GO
DROP VIEW View_Request 
GO
DROP VIEW View_Request_to_Act_Log 
GO
DROP VIEW View_Request_to_Properties 
GO
DROP VIEW v_alert 
GO
DROP VIEW v_alldevs 
GO
DROP VIEW v_allifs 
GO
DROP VIEW v_cpuUtil 
GO
DROP VIEW v_ifthruput 
GO
DROP VIEW v_ifutil 
GO
DROP VIEW v_ipthruput 
GO
DROP VIEW WANScoreBoard 
GO
DROP VIEW WatchView 
GO
DROP VIEW wvAccessStax 
GO
DROP VIEW wvAccess_Point 
GO
DROP VIEW wvAcer_Switch 
GO
DROP VIEW wvAdhoc_Access_Point 
GO
DROP VIEW wvAgent 
GO
DROP VIEW wvAggregate_CPU 
GO
DROP VIEW wvAlcatel_IP_Phone 
GO
DROP VIEW wvanoDsc_Agent 
GO
DROP VIEW wvAPC_UPS 
GO
DROP VIEW wvAPMonitors 
GO
DROP VIEW wvApplCache 
GO
DROP VIEW wvApplCacheHf 
GO
DROP VIEW wvApplCacheOf 
GO
DROP VIEW wvApplCursor 
GO
DROP VIEW wvApplCursorBc 
GO
DROP VIEW wvApplCursorRb 
GO
DROP VIEW wvApplDeadLock 
GO
DROP VIEW wvApple_Device 
GO
DROP VIEW wvApplicationHost 
GO
DROP VIEW wvapplLock 
GO
DROP VIEW wvApplLocks 
GO
DROP VIEW wvApplLocksEsc 
GO
DROP VIEW wvApplLocksXEsc 
GO
DROP VIEW wvApplLockTimeOut 
GO
DROP VIEW wvApplSortStatus 
GO
DROP VIEW wvApplSQLTable 
GO
DROP VIEW wvApplStatus 
GO
DROP VIEW wvAppResponse 
GO
DROP VIEW wvAS400 
GO
DROP VIEW wvAsante 
GO
DROP VIEW wvASMO 
GO
DROP VIEW wvASMO_BPV 
GO
DROP VIEW wvATM 
GO
DROP VIEW wvATM_Interface 
GO
DROP VIEW wvATM_LANE 
GO
DROP VIEW wvATM_LINK 
GO
DROP VIEW wvATT_Device 
GO
DROP VIEW wvAvayaAccessPoint 
GO
DROP VIEW wvAWsadmin 
GO
DROP VIEW wvBackupStatus 
GO
DROP VIEW wvBanyan_Device 
GO
DROP VIEW wvBattery 
GO
DROP VIEW wvBayBridge 
GO
DROP VIEW wvBayHub 
GO
DROP VIEW wvBay_Device 
GO
DROP VIEW wvBay_Switch 
GO
DROP VIEW wvBelkinAccessPoint 
GO
DROP VIEW wvBGP_Link 
GO
DROP VIEW wvBillboard 
GO
DROP VIEW wvBreezeCOMAccessPoint 
GO
DROP VIEW wvBridge 
GO
DROP VIEW wvBuffalo_Access_Point 
GO
DROP VIEW wvBull 
GO
DROP VIEW wvBUS 
GO
DROP VIEW wvBUSAGENT 
GO
DROP VIEW wvCabletron 
GO
DROP VIEW wvCabletron_Switch 
GO
DROP VIEW wvcacheHeapFull 
GO
DROP VIEW wvcacheOverFlow 
GO
DROP VIEW wvCACMO_BPV 
GO
DROP VIEW wvCACMO_Cluster 
GO
DROP VIEW wvCACMO_CPU 
GO
DROP VIEW wvCACMO_Folder 
GO
DROP VIEW wvCACMO_HACMP 
GO
DROP VIEW wvCACMO_HACMPHost 
GO
DROP VIEW wvCACMO_HACMPInterface 
GO
DROP VIEW wvCACMO_HACMPResource 
GO
DROP VIEW wvCACMO_HACMPResourceGroup 
GO
DROP VIEW wvCACMO_HPServiceGuard 
GO
DROP VIEW wvCACMO_HPSGFileSystem 
GO
DROP VIEW wvCACMO_HPSGHost 
GO
DROP VIEW wvCACMO_HPSGPackage 
GO
DROP VIEW wvCACMO_HPSGService 
GO
DROP VIEW wvCACMO_Mem 
GO
DROP VIEW wvCACMO_MSClusterService 
GO
DROP VIEW wvCACMO_MSCSHost 
GO
DROP VIEW wvCACMO_MSCSInterface 
GO
DROP VIEW wvCACMO_MSCSNetwork 
GO
DROP VIEW wvCACMO_MSCSQuorum 
GO
DROP VIEW wvCACMO_MSCSResource 
GO
DROP VIEW wvCACMO_MSCSResourceGroup 
GO
DROP VIEW wvCACMO_RedHatCluHost 
GO
DROP VIEW wvCACMO_RedHatCluManager 
GO
DROP VIEW wvCACMO_RedHatCluSer 
GO
DROP VIEW wvCACMO_SCHost 
GO
DROP VIEW wvCACMO_VeritasCluster 
GO
DROP VIEW wvcaiDb2mvsAgt 
GO
DROP VIEW wvcaiDb2mvsAgtInst 
GO
DROP VIEW wvCaiIngA2 
GO
DROP VIEW wvCaiIngA2Inst 
GO
DROP VIEW wvcaiLogA2 
GO
DROP VIEW wvcaiNt4Os 
GO
DROP VIEW wvcaiOraA2 
GO
DROP VIEW wvcaiOraA2Inst 
GO
DROP VIEW wvcaiSybA2 
GO
DROP VIEW wvcaiSybA2Inst 
GO
DROP VIEW wvcaiSysAgtCics 
GO
DROP VIEW wvcaiSysAgtHDS 
GO
DROP VIEW wvcaiSysAgtMqs 
GO
DROP VIEW wvcaiSysAgtMvs 
GO
DROP VIEW wvCaiUxOs 
GO
DROP VIEW wvcaiW2kOs 
GO
DROP VIEW wvCalderaLinux 
GO
DROP VIEW wvcalpara 
GO
DROP VIEW wvcalparaInst 
GO
DROP VIEW wvcamscsa 
GO
DROP VIEW wvcamsvsa 
GO
DROP VIEW wvcarhcla 
GO
DROP VIEW wvcasfha 
GO
DROP VIEW wvcasfhaInst 
GO
DROP VIEW wvcasfma 
GO
DROP VIEW wvcasfmaInst 
GO
DROP VIEW wvcaSunAdrAgent 
GO
DROP VIEW wvcaSunFireHighAgent 
GO
DROP VIEW wvcaSunFireMidAgent 
GO
DROP VIEW wvcavmesxa 
GO
DROP VIEW wvcavmgsxa 
GO
DROP VIEW wvCA_Device 
GO
DROP VIEW wvcellAgent 
GO
DROP VIEW wvChannel_Link 
GO
DROP VIEW wvChargeback 
GO
DROP VIEW wvChassis 
GO
DROP VIEW wvChipcom 
GO
DROP VIEW wvCicsInstance 
GO
DROP VIEW wvCISCO 
GO
DROP VIEW wvCiscoBUS 
GO
DROP VIEW wvCiscoFeederNode 
GO
DROP VIEW wvCiscoHsrpAgt 
GO
DROP VIEW wvCiscoLECS 
GO
DROP VIEW wvCiscoLES 
GO
DROP VIEW wvCiscoRoutingNode 
GO
DROP VIEW wvCisco_Aironet1100_Access_Point 
GO
DROP VIEW wvCisco_Aironet1200_Access_Point 
GO
DROP VIEW wvCisco_Aironet340_Access_Point 
GO
DROP VIEW wvCisco_Aironet350_Access_Point 
GO
DROP VIEW wvCisco_Device 
GO
DROP VIEW wvCISCO_LocalDirector 
GO
DROP VIEW wvCISCO_Manager 
GO
DROP VIEW wvCISCO_SWITCH 
GO
DROP VIEW wvcities 
GO
DROP VIEW wvCity 
GO
DROP VIEW wvClassical_Medium_Skyscraper 
GO
DROP VIEW wvClassical_Tall_Skyscraper 
GO
DROP VIEW wvCmuTek 
GO
DROP VIEW wvCompaq_Access_Point 
GO
DROP VIEW wvCompaq_Device 
GO
DROP VIEW wvConflict_Object 
GO
DROP VIEW wvContemporary_Low_Skyscraper 
GO
DROP VIEW wvContemporary_Medium_Skyscraper 
GO
DROP VIEW wvContemporary_Tall_Skyscraper 
GO
DROP VIEW wvCountry 
GO
DROP VIEW wvCPU 
GO
DROP VIEW wvdatabaseCounting 
GO
DROP VIEW wvdatabaseHeapLog 
GO
DROP VIEW wvdatabaseSort 
GO
DROP VIEW wvdatabaseSQLTable 
GO
DROP VIEW wvDatacomAgt 
GO
DROP VIEW wvDatacomAgtInst 
GO
DROP VIEW wvdb2Agent 
GO
DROP VIEW wvdb2AgentDB2Status 
GO
DROP VIEW wvdb2Manager 
GO
DROP VIEW wvdb2ManagerGenDBMemoryStatus 
GO
DROP VIEW wvdb2ManagerGenSortHeap 
GO
DROP VIEW wvDBCacheStatus 
GO
DROP VIEW wvDBMonitors 
GO
DROP VIEW wvdceStatAgent 
GO
DROP VIEW wvDECBridge 
GO
DROP VIEW wvDECHub 
GO
DROP VIEW wvDECRouter 
GO
DROP VIEW wvDECSystem 
GO
DROP VIEW wvDell_Device 
GO
DROP VIEW wvDell_Switch 
GO
DROP VIEW wvDevice_Disk 
GO
DROP VIEW wvDevice_Disk_350Diskette 
GO
DROP VIEW wvDevice_Disk_525Diskette 
GO
DROP VIEW wvDevice_Disk_IDE 
GO
DROP VIEW wvDevice_Disk_SCSI 
GO
DROP VIEW wvDevice_Optical 
GO
DROP VIEW wvDevice_Optical_CDR 
GO
DROP VIEW wvDevice_Optical_CDROM 
GO
DROP VIEW wvDevice_Optical_Floptical 
GO
DROP VIEW wvDevice_Optical_WORM 
GO
DROP VIEW wvDevice_Tape 
GO
DROP VIEW wvDevice_TapeLibrary 
GO
DROP VIEW wvDevice_Tape_4MM 
GO
DROP VIEW wvDevice_Tape_8MM 
GO
DROP VIEW wvDevice_Tape_CART 
GO
DROP VIEW wvDevice_Tape_DAT 
GO
DROP VIEW wvDevice_Tape_DLT 
GO
DROP VIEW wvDevice_Tape_QIC 
GO
DROP VIEW wvDevice_Tape_REEL 
GO
DROP VIEW wvDG_UX 
GO
DROP VIEW wvDigital 
GO
DROP VIEW wvDiscovered_Link 
GO
DROP VIEW wvDLink_Access_Point 
GO
DROP VIEW wvDomain 
GO
DROP VIEW wvDRO_BPV 
GO
DROP VIEW wvDRO_E10K 
GO
DROP VIEW wvDRO_E10K_CB_Folder 
GO
DROP VIEW wvDRO_E10K_Domains 
GO
DROP VIEW wvDRO_E10K_Domain_Folder 
GO
DROP VIEW wvDRO_E10K_Fans 
GO
DROP VIEW wvDRO_E10K_Primary_CB 
GO
DROP VIEW wvDRO_E10K_Spare_CB 
GO
DROP VIEW wvDRO_E10K_SSP 
GO
DROP VIEW wvDRO_E10K_SSP_Main 
GO
DROP VIEW wvDRO_E10K_SSP_Spare 
GO
DROP VIEW wvDRO_E10K_System_Boards 
GO
DROP VIEW wvDRO_E10K_System_Board_Folder 
GO
DROP VIEW wvDRO_E10K_Trays 
GO
DROP VIEW wvDRO_E10K_Tray_Folder 
GO
DROP VIEW wvDRO_IBMLPAR 
GO
DROP VIEW wvDRO_PHMC 
GO
DROP VIEW wvDRO_PLCPU 
GO
DROP VIEW wvDRO_PLFolder 
GO
DROP VIEW wvDRO_PLPAR 
GO
DROP VIEW wvDRO_PLPartition 
GO
DROP VIEW wvDRO_PLProfile 
GO
DROP VIEW wvDRO_PLSlot 
GO
DROP VIEW wvDRO_PLVEthernet 
GO
DROP VIEW wvDRO_PLVSCSI 
GO
DROP VIEW wvDRO_PLVSerial 
GO
DROP VIEW wvDRO_Starfire 
GO
DROP VIEW wvDRO_SunEnterprise 
GO
DROP VIEW wvDRO_SunFire 
GO
DROP VIEW wvDRO_SunFire_CB_Folder 
GO
DROP VIEW wvDRO_SunFire_Domain_Folder 
GO
DROP VIEW wvDRO_SunFire_HighEnd 
GO
DROP VIEW wvDRO_SunFire_HighEnd_Domain 
GO
DROP VIEW wvDRO_SunFire_HighEnd_Fans 
GO
DROP VIEW wvDRO_SunFire_HighEnd_Main_SC 
GO
DROP VIEW wvDRO_SunFire_HighEnd_SB_CPU 
GO
DROP VIEW wvDRO_SunFire_HighEnd_SB_IO 
GO
DROP VIEW wvDRO_SunFire_HighEnd_Spare_SC 
GO
DROP VIEW wvDRO_SunFire_HighEnd_Trays 
GO
DROP VIEW wvDRO_SunFire_MidRange 
GO
DROP VIEW wvDRO_SunFire_MidRange_Domain 
GO
DROP VIEW wvDRO_SunFire_MidRange_Fans 
GO
DROP VIEW wvDRO_SunFire_MidRange_PRI_CB 
GO
DROP VIEW wvDRO_SunFire_MidRange_SB_CPU 
GO
DROP VIEW wvDRO_SunFire_MidRange_SB_IO 
GO
DROP VIEW wvDRO_SunFire_MidRange_SB_Others 
GO
DROP VIEW wvDRO_SunFire_MidRange_SPR_CB 
GO
DROP VIEW wvDRO_SunFire_MidRange_Trays 
GO
DROP VIEW wvDRO_SunFire_MSP 
GO
DROP VIEW wvDRO_SunFire_MSP_Main 
GO
DROP VIEW wvDRO_SunFire_SB_Folder 
GO
DROP VIEW wvDRO_SunFire_Tray_Folder 
GO
DROP VIEW wvDynamicBPV 
GO
DROP VIEW wvELAN 
GO
DROP VIEW wvElementManagers 
GO
DROP VIEW wvEnterasys_Switch 
GO
DROP VIEW wvEntrasys_Access_Point 
GO
DROP VIEW wvepComSMPNodeGroup 
GO
DROP VIEW wvepWorldSpace 
GO
DROP VIEW wvepWorldSpaceRoot 
GO
DROP VIEW wvepWorldSpaceUnicenterProfile 
GO
DROP VIEW wvepWorld_eCS_c6 
GO
DROP VIEW wvepWorld_eCS_pc 
GO
DROP VIEW wvepWorld_eCS_s1 
GO
DROP VIEW wvepWorld_eCS_s2 
GO
DROP VIEW wvepWorld_eCS_s3 
GO
DROP VIEW wvepWorld_eCS_s4 
GO
DROP VIEW wvepWorld_eCS_s5 
GO
DROP VIEW wvepWorld_ePortal_c5 
GO
DROP VIEW wvepWorld_ePortal_c8 
GO
DROP VIEW wvepWorld_ePortal_pc 
GO
DROP VIEW wvepWorld_ePortal_s10 
GO
DROP VIEW wvepWorld_ePortal_s11 
GO
DROP VIEW wvepWorld_ePortal_s12 
GO
DROP VIEW wvepWorld_ePortal_s14 
GO
DROP VIEW wvepWorld_ePortal_s15 
GO
DROP VIEW wvepWorld_ePortal_s2 
GO
DROP VIEW wvepWorld_ePortal_s3 
GO
DROP VIEW wvepWorld_ePortal_s6 
GO
DROP VIEW wvepWorld_ePortal_s7 
GO
DROP VIEW wvepWorld_iTech_c3 
GO
DROP VIEW wvepWorld_iTech_c4 
GO
DROP VIEW wvepWorld_iTech_pc 
GO
DROP VIEW wvepWorld_iTech_s5 
GO
DROP VIEW wvepWorld_iTech_s7 
GO
DROP VIEW wvepWorld_MSWin_c2 
GO
DROP VIEW wvepWorld_MSWin_c3 
GO
DROP VIEW wvepWorld_MSWin_pc 
GO
DROP VIEW wvepWorld_MSWin_s1 
GO
DROP VIEW wvepWorld_TSEnbl_pc 
GO
DROP VIEW wvepWorld_TSEnbl_s1 
GO
DROP VIEW wvEricsson_Access_Point 
GO
DROP VIEW wvEthAirNetAccessPoint 
GO
DROP VIEW wvETSMIM 
GO
DROP VIEW wvExtreme_Switch 
GO
DROP VIEW wvFlowChart 
GO
DROP VIEW wvFolder 
GO
DROP VIEW wvFore_Switch 
GO
DROP VIEW wvFoundry 
GO
DROP VIEW wvFoundry_Switch 
GO
DROP VIEW wvFrameRelayTrunk 
GO
DROP VIEW wvFrameRelay_Link 
GO
DROP VIEW wvFrameRelay_PVC_EndPoint 
GO
DROP VIEW wvFrameRelay_Switch 
GO
DROP VIEW wvfrLink 
GO
DROP VIEW wvFUJIUxp 
GO
DROP VIEW wvFuture 
GO
DROP VIEW wvGanttChart 
GO
DROP VIEW wvGatorStar 
GO
DROP VIEW wvGenericPC 
GO
DROP VIEW wvGray_Office_Park 
GO
DROP VIEW wvHawking_Access_Point 
GO
DROP VIEW wvHitachi_Device 
GO
DROP VIEW wvHost 
GO
DROP VIEW wvHPBridge 
GO
DROP VIEW wvHpeNgent 
GO
DROP VIEW wvHPHub 
GO
DROP VIEW wvHPServer 
GO
DROP VIEW wvHPUnix 
GO
DROP VIEW wvHpxAgent 
GO
DROP VIEW wvHP_Device 
GO
DROP VIEW wvHP_Printer 
GO
DROP VIEW wvHP_Switch 
GO
DROP VIEW wvHTTP 
GO
DROP VIEW wvHub 
GO
DROP VIEW wvIBM 
GO
DROP VIEW wvIBM3090 
GO
DROP VIEW wvIBM_8260 
GO
DROP VIEW wvIBM_8265 
GO
DROP VIEW wvIBM_8271 
GO
DROP VIEW wvIBM_8371 
GO
DROP VIEW wvIBM_Access_Point 
GO
DROP VIEW wvIBM_Device 
GO
DROP VIEW wvIBM_MSS 
GO
DROP VIEW wvICLUnix 
GO
DROP VIEW wvICSSNMP 
GO
DROP VIEW wvIdmsAgent 
GO
DROP VIEW wvIdmsInstance 
GO
DROP VIEW wvImxAgent 
GO
DROP VIEW wvImxAgentInst 
GO
DROP VIEW wvInformix 
GO
DROP VIEW wvIngAgent 
GO
DROP VIEW wvIngres 
GO
DROP VIEW wvintegrity 
GO
DROP VIEW wvIntel_Access_Point 
GO
DROP VIEW wvIntel_Device 
GO
DROP VIEW wvIntel_PSN 
GO
DROP VIEW wvInterActive 
GO
DROP VIEW wvIntergraph_Device 
GO
DROP VIEW wvIP 
GO
DROP VIEW wvIPX_Bus 
GO
DROP VIEW wvIPX_Domain 
GO
DROP VIEW wvIPX_Generic_Interface 
GO
DROP VIEW wvIPX_Host 
GO
DROP VIEW wvIPX_Network 
GO
DROP VIEW wvIPX_PrintServer 
GO
DROP VIEW wvIP_Interface 
GO
DROP VIEW wvIP_Network 
GO
DROP VIEW wvIP_Phone 
GO
DROP VIEW wvIP_Subnet 
GO
DROP VIEW wvIRM2SNMP 
GO
DROP VIEW wvKarlNetAccessPoint 
GO
DROP VIEW wvLANE 
GO
DROP VIEW wvLANManager_Device 
GO
DROP VIEW wvLanProbe 
GO
DROP VIEW wvLargeCity 
GO
DROP VIEW wvLarge_Brownstone 
GO
DROP VIEW wvLarge_Factory 
GO
DROP VIEW wvLarge_Warehouse 
GO
DROP VIEW wvLaserPrinter 
GO
DROP VIEW wvLEC 
GO
DROP VIEW wvLECAGENT 
GO
DROP VIEW wvLECS 
GO
DROP VIEW wvLECSAGENT 
GO
DROP VIEW wvLES 
GO
DROP VIEW wvLESAGENT 
GO
DROP VIEW wvLinksysAccessPoint 
GO
DROP VIEW wvLinux 
GO
DROP VIEW wvlockCurrentHeld 
GO
DROP VIEW wvlockEscStatus 
GO
DROP VIEW wvlocking 
GO
DROP VIEW wvlockMemStatus 
GO
DROP VIEW wvlockTimeOut 
GO
DROP VIEW wvlockXEscStatus 
GO
DROP VIEW wvLogAgentNT_v30 
GO
DROP VIEW wvLogAgentTand_v30 
GO
DROP VIEW wvLogAgent_v30 
GO
DROP VIEW wvLUN 
GO
DROP VIEW wvMacintosh 
GO
DROP VIEW wvManagedObject 
GO
DROP VIEW wvManagedObjectRoot 
GO
DROP VIEW wvManagedPC 
GO
DROP VIEW wvmaxHeapUsed 
GO
DROP VIEW wvmaxTotalLog 
GO
DROP VIEW wvMcData_EFCManager 
GO
DROP VIEW wvMediumCity 
GO
DROP VIEW wvMedium_Brownstone 
GO
DROP VIEW wvMedium_Warehouse 
GO
DROP VIEW wvMib2 
GO
DROP VIEW wvMicom 
GO
DROP VIEW wvMicrosoftADSDevice 
GO
DROP VIEW wvMicrosoftADSDevice_2000 
GO
DROP VIEW wvMicrosoftADSDevice_2003 
GO
DROP VIEW wvmkAgent 
GO
DROP VIEW wvmkExpInv 
GO
DROP VIEW wvmkInvExp 
GO
DROP VIEW wvmkLateCustPay 
GO
DROP VIEW wvmkLateCustShip 
GO
DROP VIEW wvmkLateProdOrd 
GO
DROP VIEW wvmkLateVendShip 
GO
DROP VIEW wvMmoAgent 
GO
DROP VIEW wvMmoAgentInst 
GO
DROP VIEW wvMmsAgent 
GO
DROP VIEW wvMmsAgentInst 
GO
DROP VIEW wvMMsapAgent 
GO
DROP VIEW wvMobileDevice 
GO
DROP VIEW wvMqAliasQ 
GO
DROP VIEW wvMqAliasQInst 
GO
DROP VIEW wvMqChanInit 
GO
DROP VIEW wvMqChanInitInst 
GO
DROP VIEW wvMqChannel 
GO
DROP VIEW wvMqChannelInst 
GO
DROP VIEW wvMqDLQ 
GO
DROP VIEW wvMqDLQInst 
GO
DROP VIEW wvMqMgr 
GO
DROP VIEW wvMqMgrInst 
GO
DROP VIEW wvMqModelQ 
GO
DROP VIEW wvMqModelQInst 
GO
DROP VIEW wvMqProcess 
GO
DROP VIEW wvMqProcessInst 
GO
DROP VIEW wvMqPSID 
GO
DROP VIEW wvMqPSIDInst 
GO
DROP VIEW wvMqQueue 
GO
DROP VIEW wvMqQueueInst 
GO
DROP VIEW wvMqRemoteQ 
GO
DROP VIEW wvMqRemoteQInst 
GO
DROP VIEW wvMqRoute 
GO
DROP VIEW wvMqRouteInst 
GO
DROP VIEW wvMqsInstance 
GO
DROP VIEW wvMSSQLServer 
GO
DROP VIEW wvMultiNet 
GO
DROP VIEW wvMultiNet_Device 
GO
DROP VIEW wvMulti_Port 
GO
DROP VIEW wvMulti_Protocol_Host 
GO
DROP VIEW wvMvsInstance 
GO
DROP VIEW wvNBase_Switch 
GO
DROP VIEW wvNCD17c 
GO
DROP VIEW wvNCD_Device 
GO
DROP VIEW wvNCRUnix 
GO
DROP VIEW wvNCR_Xterm 
GO
DROP VIEW wvNEC_Device 
GO
DROP VIEW wvNetBIOSIP 
GO
DROP VIEW wvNetBIOSIPServers 
GO
DROP VIEW wvNetBotz_Device 
GO
DROP VIEW wvNetgearAccessPoint 
GO
DROP VIEW wvNetGeneral 
GO
DROP VIEW wvNetJet_PrinterServer 
GO
DROP VIEW wvNetQue_PrinterServer 
GO
DROP VIEW wvNetScout 
GO
DROP VIEW wvNetSNMP 
GO
DROP VIEW wvNetwork 
GO
DROP VIEW wvNetwork_Connectivity 
GO
DROP VIEW wvNetWorth 
GO
DROP VIEW wvNeugentBase 
GO
DROP VIEW wvNeugentDevices 
GO
DROP VIEW wvNeugentRouter 
GO
DROP VIEW wvNeugent_Interface 
GO
DROP VIEW wvNGSniffer 
GO
DROP VIEW wvNode 
GO
DROP VIEW wvNortel_Access_Point 
GO
DROP VIEW wvNovell 
GO
DROP VIEW wvNovellHub 
GO
DROP VIEW wvNovell_Device 
GO
DROP VIEW wvNovell_Probe 
GO
DROP VIEW wvnpoTrapAgent 
GO
DROP VIEW wvOpenVMS 
GO
DROP VIEW wvOpenVMS_CCI 
GO
DROP VIEW wvOpenVMS_CommonMgr 
GO
DROP VIEW wvOpenVMS_ConsoleEventDaemon 
GO
DROP VIEW wvOpenVMS_ConsoleMgr 
GO
DROP VIEW wvOpenVMS_ENF 
GO
DROP VIEW wvOpenVMS_EventLinksDaemon 
GO
DROP VIEW wvOpenVMS_EventManagementDaemon 
GO
DROP VIEW wvOpenVMS_GatewayDaemon 
GO
DROP VIEW wvOpenVMS_JobflowDaemon 
GO
DROP VIEW wvOpenVMS_PerformanceAgent 
GO
DROP VIEW wvOpenVMS_PerformanceCubeDaemon 
GO
DROP VIEW wvOpenVMS_PerformanceMgr 
GO
DROP VIEW wvOpenVMS_SystemMonitor 
GO
DROP VIEW wvOpenVMS_System_Monitor 
GO
DROP VIEW wvOpenVMS_WorkloadAgent 
GO
DROP VIEW wvOpenVMS_WorkloadAgentX 
GO
DROP VIEW wvOpenVMS_WorkloadMgr 
GO
DROP VIEW wvOraAgtVMS 
GO
DROP VIEW wvOracle 
GO
DROP VIEW wvOracle_Device 
GO
DROP VIEW wvOrinocoAccessPoint 
GO
DROP VIEW wvOS2 
GO
DROP VIEW wvOsAgentTand_v30 
GO
DROP VIEW wvOsAgent_v30 
GO
DROP VIEW wvOSPF_Area 
GO
DROP VIEW wvOSPF_Link 
GO
DROP VIEW wvOSPF_Router 
GO
DROP VIEW wvOSPF_View
GO
DROP VIEW wvOtherDevices 
GO
DROP VIEW wvOverlapInterface 
GO
DROP VIEW wvPalm 
GO
DROP VIEW wvPCNIU 
GO
DROP VIEW wvPerformance 
GO
DROP VIEW wvPerformanceConfig 
GO
DROP VIEW wvPerformanceScope 
GO
DROP VIEW wvPerformanceTrend 
GO
DROP VIEW wvPertChart 
GO
DROP VIEW wvPing 
GO
DROP VIEW wvPingIP 
GO
DROP VIEW wvPocketPC 
GO
DROP VIEW wvpplAgent 
GO
DROP VIEW wvpplInstance 
GO
DROP VIEW wvPrinters 
GO
DROP VIEW wvProAgentTand_v30 
GO
DROP VIEW wvProAgent_v30 
GO
DROP VIEW wvProbe 
GO
DROP VIEW wvProfileDomainServer 
GO
DROP VIEW wvProxim_Access_Point 
GO
DROP VIEW wvPV705N 
GO
DROP VIEW wvQLogic_Switch 
GO
DROP VIEW wvRedHatLinux 
GO
DROP VIEW wvResponseManagerAppServers 
GO
DROP VIEW wvResponseManagerCollector 
GO
DROP VIEW wvResponseManagerFileServers 
GO
DROP VIEW wvResponseManagerProbe 
GO
DROP VIEW wvResponseManagerProbeHost 
GO
DROP VIEW wvResponseManagerProbes 
GO
DROP VIEW wvRISC6000 
GO
DROP VIEW wvRMNovell 
GO
DROP VIEW wvRMNovellServers 
GO
DROP VIEW wvRMON_Probe 
GO
DROP VIEW wvRMSNMP_CISCO 
GO
DROP VIEW wvRMSNMP_Ethernet 
GO
DROP VIEW wvRMSNMP_Interfaces 
GO
DROP VIEW wvRMSNMP_IP 
GO
DROP VIEW wvRoamAboutAccessPoint 
GO
DROP VIEW wvRogue_Access_Point 
GO
DROP VIEW wvRouter 
GO
DROP VIEW wvRouter_Interface 
GO
DROP VIEW wvRouter_Manager 
GO
DROP VIEW wvSamsung 
GO
DROP VIEW wvsapAgent 
GO
DROP VIEW wvsapAgent4 
GO
DROP VIEW wvSapInstance 
GO
DROP VIEW wvsapInstance4 
GO
DROP VIEW wvSCOUnix 
GO
DROP VIEW wvSDLC_Link 
GO
DROP VIEW wvsecondaryLog 
GO
DROP VIEW wvsecondaryLogAlloc 
GO
DROP VIEW wvSequent_Server 
GO
DROP VIEW wvSiemens_Device 
GO
DROP VIEW wvSiemens_optiPoint 
GO
DROP VIEW wvSiemenUX 
GO
DROP VIEW wvSilicon 
GO
DROP VIEW wvSmallCity 
GO
DROP VIEW wvSmall_Brownstone 
GO
DROP VIEW wvSmall_Warehouse 
GO
DROP VIEW wvSMCAccessPoint 
GO
DROP VIEW wvSMO_Link 
GO
DROP VIEW wvSolaris 
GO
DROP VIEW wvSQLServerAgt 
GO
DROP VIEW wvSSIP_Network 
GO
DROP VIEW wvSSIP_Subnet 
GO
DROP VIEW wvStorageSubsystem 
GO
DROP VIEW wvSubnet 
GO
DROP VIEW wvSUN 
GO
DROP VIEW wvSunOS 
GO
DROP VIEW wvSUN_Device 
GO
DROP VIEW wvSuperPingAgent 
GO
DROP VIEW wvSuSELinux 
GO
DROP VIEW wvSuspectAccessPoint 
GO
DROP VIEW wvSVP_ElementManager 
GO
DROP VIEW wvSw56Kbps 
GO
DROP VIEW wvSwitch 
GO
DROP VIEW wvSwitch_Interface 
GO
DROP VIEW wvSwitch_Manager 
GO
DROP VIEW wvSybase 
GO
DROP VIEW wvSybaseAgt 
GO
DROP VIEW wvSymbol80211_11m_Access_Point 
GO
DROP VIEW wvSymbol80211_1_2m_Access_Point 
GO
DROP VIEW wvSymbol_1m_Access_Point 
GO
DROP VIEW wvSynOptics 
GO
DROP VIEW wvSynOptics_Bridge 
GO
DROP VIEW wvSynOptics_Device 
GO
DROP VIEW wvSynOptics_Switch 
GO
DROP VIEW wvSysAgtAS400 
GO
DROP VIEW wvSysAgtNetWare 
GO
DROP VIEW wvSysAgtNT 
GO
DROP VIEW wvSysAgtVMS 
GO
DROP VIEW wvSysAgtWin9x 
GO
DROP VIEW wvT1 
GO
DROP VIEW wvTandem 
GO
DROP VIEW wvTandem_Device 
GO
DROP VIEW wvTapeSubsystem 
GO
DROP VIEW wvTektronix_Device 
GO
DROP VIEW wvTelebit 
GO
DROP VIEW wvTelnet 
GO
DROP VIEW wvTelnetServers 
GO
DROP VIEW wvTokenRing_Link 
GO
DROP VIEW wvToshiba_Device 
GO
DROP VIEW wvTrunk_Multi_Ethernet 
GO
DROP VIEW wvTrunk_Multi_FDDI 
GO
DROP VIEW wvTrunk_Multi_TokenRing 
GO
DROP VIEW wvTSBufferIndexWrites 
GO
DROP VIEW wvTSBufferWrites 
GO
DROP VIEW wvTSioDirectWriteREQ 
GO
DROP VIEW wvTSioWrittenDirect 
GO
DROP VIEW wvTSMonitors 
GO
DROP VIEW wvTSPhysicalSpace 
GO
DROP VIEW wvTurboLinux 
GO
DROP VIEW wvUBEMPower 
GO
DROP VIEW wvUBNIU 
GO
DROP VIEW wvUB_Device 
GO
DROP VIEW wvUnclassified_TCP 
GO
DROP VIEW wvUnicenterFileTransferDaemon 
GO
DROP VIEW wvUnicenterMessageDaemon 
GO
DROP VIEW wvUnicenter_OpenVMS 
GO
DROP VIEW wvUnicenter_OpenVMSManagedObject 
GO
DROP VIEW wvUnicenter_OpenVMS_Console 
GO
DROP VIEW wvUnicenter_OpenVMS_Performance 
GO
DROP VIEW wvUnicenter_OpenVMS_Workload 
GO
DROP VIEW wvUnispace 
GO
DROP VIEW wvUnisys 
GO
DROP VIEW wvUnix 
GO
DROP VIEW wvUnixWare 
GO
DROP VIEW wvUPS 
GO
DROP VIEW wvURM 
GO
DROP VIEW wvURMAIXAlarmResource 
GO
DROP VIEW wvURMAIXGenAlarm 
GO
DROP VIEW wvURMAIXInstAlarm 
GO
DROP VIEW wvURMAIXPerfAlarm 
GO
DROP VIEW wvURMHPAlarmResource 
GO
DROP VIEW wvURMHPGenAlarm 
GO
DROP VIEW wvURMHPInstAlarm 
GO
DROP VIEW wvURMHPPerfAlarm 
GO
DROP VIEW wvURMIPAlarmResource 
GO
DROP VIEW wvURMIPGenAlarm 
GO
DROP VIEW wvURMIPPortAlarm 
GO
DROP VIEW wvURMIPRes 
GO
DROP VIEW wvURMLINUXAlarmResource 
GO
DROP VIEW wvURMLINUXGenAlarm 
GO
DROP VIEW wvURMLINUXInstAlarm 
GO
DROP VIEW wvURMLINUXPerfAlarm 
GO
DROP VIEW wvURMMACAlarmResource 
GO
DROP VIEW wvURMMacOSXGenAlarm 
GO
DROP VIEW wvURMMacOSXInstAlarm 
GO
DROP VIEW wvURMMacOSXPerfAlarm 
GO
DROP VIEW wvURMMacRes 
GO
DROP VIEW wvURMSUNAlarmResource 
GO
DROP VIEW wvURMSUNGenAlarm 
GO
DROP VIEW wvURMSUNInstAlarm 
GO
DROP VIEW wvURMSUNPerfAlarm 
GO
DROP VIEW wvURMTru64AlarmResource 
GO
DROP VIEW wvURMTru64GenAlarm 
GO
DROP VIEW wvURMTru64InstAlarm 
GO
DROP VIEW wvURMTru64PerfAlarm 
GO
DROP VIEW wvURMUnixRes 
GO
DROP VIEW wvURMWinAlarmResource 
GO
DROP VIEW wvURMWinGenAlarm 
GO
DROP VIEW wvURMWinPerfAlarm 
GO
DROP VIEW wvURMWinProcAlarm 
GO
DROP VIEW wvURMWinRes 
GO
DROP VIEW wvURMWinRKeyAlarm 
GO
DROP VIEW wvURMWinServAlarm 
GO
DROP VIEW wvURMWinSnapAlarm 
GO
DROP VIEW wvUserDefApplicationsServers 
GO
DROP VIEW wvUserDefined 
GO
DROP VIEW wvUserDefinedApplications 
GO
DROP VIEW wvUserDefinedServers 
GO
DROP VIEW wvUSR_Access_Point 
GO
DROP VIEW wvVCP_1000 
GO
DROP VIEW wvvIP_Interface 
GO
DROP VIEW wvVitalink 
GO
DROP VIEW wvVitalink_Device 
GO
DROP VIEW wvVlan 
GO
DROP VIEW wvVLAN_Domain 
GO
DROP VIEW wvVLAN_Domain_view 
GO
DROP VIEW wvVLAN_Interface 
GO
DROP VIEW wvVlan_Switch 
GO
DROP VIEW wvVMO 
GO
DROP VIEW wvVMO_BPV 
GO
DROP VIEW wvVMO_CPU 
GO
DROP VIEW wvVMO_Disk_IO 
GO
DROP VIEW wvVMO_GuestOS 
GO
DROP VIEW wvVMO_HB 
GO
DROP VIEW wvVMO_HostOS 
GO
DROP VIEW wvVMO_Linux 
GO
DROP VIEW wvVMO_Linux_HostOS 
GO
DROP VIEW wvVMO_Mem 
GO
DROP VIEW wvVMO_MSDOS 
GO
DROP VIEW wvVMO_Netware4 
GO
DROP VIEW wvVMO_Netware5 
GO
DROP VIEW wvVMO_Netware6 
GO
DROP VIEW wvVMO_Network_IO 
GO
DROP VIEW wvVMO_Other 
GO
DROP VIEW wvVMO_Power 
GO
DROP VIEW wvVMO_Win2K3ES 
GO
DROP VIEW wvVMO_Win2K3S 
GO
DROP VIEW wvVMO_Win2K3WS 
GO
DROP VIEW wvVMO_Win2KAS 
GO
DROP VIEW wvVMO_Win2KP 
GO
DROP VIEW wvVMO_Win2KS 
GO
DROP VIEW wvVMO_Win31 
GO
DROP VIEW wvVMO_Win95 
GO
DROP VIEW wvVMO_Win98 
GO
DROP VIEW wvVMO_Windows_HostOS 
GO
DROP VIEW wvVMO_WinME 
GO
DROP VIEW wvVMO_WinNT 
GO
DROP VIEW wvVMO_WinXPH 
GO
DROP VIEW wvVMO_WinXPP 
GO
DROP VIEW wvVN_ElementManager 
GO
DROP VIEW wvWBEM 
GO
DROP VIEW wvWellfleet 
GO
DROP VIEW wvwfVrrpAgt 
GO
DROP VIEW wvWhite_Office_Park 
GO
DROP VIEW wvWindows 
GO
DROP VIEW wvWindows2000 
GO
DROP VIEW wvWindows2000_Server 
GO
DROP VIEW wvWindows9x 
GO
DROP VIEW wvWindows9x_ManagedPC 
GO
DROP VIEW wvWindowsNT 
GO
DROP VIEW wvWindowsNT_ManagedPC 
GO
DROP VIEW wvWindowsNT_Server 
GO
DROP VIEW wvWindowsXP 
GO
DROP VIEW wvWindows_NetServer 
GO
DROP VIEW wvWireless 
GO
DROP VIEW wvWirelessUnit 
GO
DROP VIEW wvWireless_Domain 
GO
DROP VIEW wvWireless_Network 
GO
DROP VIEW wvWorkload_EventDaemon 
GO
DROP VIEW wvWorkstation 
GO
DROP VIEW wvXerox_Device 
GO
DROP VIEW wvXircom_Device 
GO
DROP VIEW wvXterm 
GO
DROP VIEW wvXylan_Switch 
GO
DROP VIEW wvXylogics_Device 
GO
DROP VIEW wvXyplex_Device 
GO
DROP VIEW wvZone 
GO
DROP VIEW wvZoneSet 
GO
DROP VIEW wv_3COM 
GO
DROP VIEW wv_3COM_Access_Point 
GO
DROP VIEW wv_3COM_Device 
GO
DROP VIEW wv_3COM_Switch
GO

PRINT  'Drop User Defined Types' 
GO

sp_droptype ACCESS_TYPE 
GO
sp_droptype BOOLEAN_FLAG 
GO
sp_droptype CALCULATION_TYPE 
GO
sp_droptype CAPABILITIES_MASK 
GO
sp_droptype COMPILE_STATUS_TYPE 
GO
sp_droptype DATABASE_TYPE 
GO
sp_droptype DATETIME_TYPE 
GO
sp_droptype DAY_TYPE 
GO
sp_droptype DES_GLOBVALUE_TYPE 
GO
sp_droptype DES_PASSWORD_TYPE 
GO
sp_droptype DES_TEXT_TYPE 
GO
sp_droptype DOW_TYPE 
GO
sp_droptype ERRORMSG_TYPE 
GO
sp_droptype HANDLER_KEYS_TYPE 
GO
sp_droptype HOUR_TYPE 
GO
sp_droptype IDENTIFIER_TYPE 
GO
sp_droptype LONG_NAME_TYPE 
GO
sp_droptype MESSAGE_TYPE 
GO
sp_droptype MINUTE_TYPE 
GO
sp_droptype MONTH_TYPE 
GO
sp_droptype NAME_TYPE 
GO
sp_droptype NOTE_TYPE 
GO
sp_droptype OBJECT_TYPE 
GO
sp_droptype PARAMETER_VALUE_TYPE 
GO
sp_droptype PASSWORD_TYPE 
GO
sp_droptype PERMISSION_MASK 
GO
sp_droptype PROVIDER_TYPE 
GO
sp_droptype PROV_KEYS_TYPE 
GO
sp_droptype QUERY_TYPE 
GO
sp_droptype USER_TYPE 
GO
sp_droptype UUID

PRINT  'Enable Constraints' 
GO

exec sp_MSforeachtable 'ALTER TABLE ? CHECK CONSTRAINT ALL' 
GO
exec sp_MSforeachtable 'ALTER TABLE ? ENABLE TRIGGER ALL' 
GO

PRINT  'MDB Database Clean Complete' 
GO