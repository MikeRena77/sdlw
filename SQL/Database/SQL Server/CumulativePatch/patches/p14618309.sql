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
/* Star 14618309 DSM : MSSQL Update to view usd_v_target                                */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

/* ******************** 9788 begin *************************** */

ALTER  view usd_v_target as
	select T.objectid as objectid,
		T.version as version,
		A.creation_user as creation_user,
		T.managementtype as managementtype,
		/* S.label as ssname, 9362 */
		S.host_name as ssname,
		A.agent_name as lanname,
		case when DH.primary_network_address is null then DH2.primary_network_address
		else DH.primary_network_address
		end as lanaddress,
		A.ip_address as ip_address,
		A.creation_date as creationtime,
		A.last_run_date as changetime,
		A.registration_type as regflag,
		case when DH.dis_hw_uuid = S.dis_hw_uuid then 5  /* Old USD server type */
			when AC.agent_comp_id = 46 then 7        /* Old USD docking type */
			else A.agent_type
		end as type,
		T.state as state,
		A.proc_os_id as curros,
		A.description as comment,
		T.calendar as calendar,
		S.dis_hw_uuid as ssid,
		AC.agent_component_version as sdver,
		case when DH.host_uuid is null then DH2.host_uuid
		else DH.host_uuid
		end as uuid,
		A.prev_manager as prevls,
		A.agent_ref_count as agrefcnt,
		T.locks as locks,
		T.download_method as download_method,
		case when DH.dis_hw_uuid is null then HWU.dis_hw_uuid
		else DH.dis_hw_uuid 
		end as dis_hw_uuid,
		A.agent_type,
		A.user_def1,
		A.user_def2,
		A.user_def3,
		S.server_uuid,
		HWU.user_uuid
	from 	((((usd_target T left join ca_link_dis_hw_user HWU on T.objectid = HWU.link_dis_hw_user_uuid) join
		(ca_agent A left join ca_server S on A.server_uuid = S.server_uuid) on T.objectid = A.object_uuid) left join
		ca_discovered_hardware DH on T.objectid = DH.dis_hw_uuid)) left join 
		ca_discovered_hardware DH2 on HWU.dis_hw_uuid = DH2.dis_hw_uuid,
		ca_agent_component AC
	where T.objectid = AC.object_uuid
	and (A.agent_type = 1 or A.agent_type = 4)      	/* 1=computer 4=computer-user*/
	and (AC.agent_comp_id = 40 or AC.agent_comp_id = 46)    /* 40=USD agent, 46=USD docking device */

GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14618309, getdate(), 1, 4, 'Star 14618309 DSM : MSSQL Update to view usd_v_target' )
GO

COMMIT TRANSACTION 
GO


