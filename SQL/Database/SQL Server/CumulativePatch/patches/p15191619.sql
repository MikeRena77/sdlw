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
/* Star 15191619 DSM: USD views and usd_vq_target					*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO

/* Start of locks for dependent tables */

/* End of lines added to convert to online lock */

/* ************************** 11613 begin  **************/

ALTER  view usd_v_ownsite as
select distinct CNT.domain_uuid as objectid, CNT.version_number+1 as version,
CNT.creation_user as creation_user, CNT.label as siteid, CNT.contact_information,
MAX(MC.manager_comp_version) as asmversion, CNT.creation_date as creationtime,
CNT.last_update_date as changetime, M.host_name as remoteaddress,
CNT.description as usercomment, M.host_uuid as uuid, CNT.domain_uuid
from ca_n_tier CNT, ca_manager M, ca_manager_component MC, ca_settings S
where S.set_id = 1 /* My own domain */
and CNT.domain_uuid = M.domain_uuid
and CNT.domain_uuid = MC.domain_uuid
and CNT.domain_uuid = S.set_val_uuid
and (MC.manager_comp_id = 42
or MC.manager_comp_id = 43
or MC.manager_comp_id = 44
or MC.manager_comp_id = 45
or MC.manager_comp_id = 50)
group by CNT.domain_uuid, CNT.version_number,CNT.creation_user, CNT.label, 
CNT.contact_information,CNT.creation_date,CNT.last_update_date, 
M.host_name,CNT.description, M.host_uuid, CNT.domain_uuid
go


ALTER  view usd_v_csite as
select distinct CNT.domain_uuid as objectid, CNT.version_number+1 as version,
CNT.creation_user as creation_user, CNT.label as siteid, CNT.contact_information,
MAX(MC.manager_comp_version) as asmversion, CNT.creation_date as creationtime,
CNT.last_update_date as changetime, M.host_name as remoteaddress,
CNT.description as usercomment, M.host_uuid as uuid, CNT.domain_uuid
from ca_n_tier CNT, ca_manager M, ca_manager_component MC, ca_settings S
where S.set_id = 1 /* My own domain */
and CNT.domain_uuid <> S.set_val_uuid
and CNT.domain_type = 1   /* Domain = 1 */
and CNT.domain_uuid = M.domain_uuid
and CNT.domain_uuid = MC.domain_uuid
and (MC.manager_comp_id = 42
or MC.manager_comp_id = 43
or MC.manager_comp_id = 44
or MC.manager_comp_id = 45
or MC.manager_comp_id = 50)
group by CNT.domain_uuid, CNT.version_number,CNT.creation_user, CNT.label, 
CNT.contact_information,CNT.creation_date,CNT.last_update_date, 
M.host_name,CNT.description, M.host_uuid, CNT.domain_uuid
go

ALTER  view usd_v_ls as
select distinct CNT.domain_uuid as objectid, CNT.version_number+1 as version,
CNT.creation_user as creation_user, CNT.label as siteid, CNT.contact_information,
MAX(MC.manager_comp_version) as asmversion, CNT.creation_date as creationtime,
CNT.last_update_date as changetime, M.host_name as remoteaddress,
CNT.description as usercomment, M.host_uuid as uuid, CNT.domain_uuid
from ca_n_tier CNT, ca_manager M, ca_manager_component MC, ca_settings S
where S.set_id = 1 /* My own domain */
and CNT.domain_uuid <> S.set_val_uuid
and CNT.domain_type = 0   /* Domain = 0 */
and CNT.domain_uuid = M.domain_uuid
and CNT.domain_uuid = MC.domain_uuid
and (MC.manager_comp_id = 42
or MC.manager_comp_id = 43
or MC.manager_comp_id = 44
or MC.manager_comp_id = 45
or MC.manager_comp_id = 50)
group by CNT.domain_uuid, CNT.version_number,CNT.creation_user, CNT.label, 
CNT.contact_information,CNT.creation_date,CNT.last_update_date, 
M.host_name,CNT.description, M.host_uuid, CNT.domain_uuid
go



/* ************************** 11613 end **************/
/* ************************** 11614 begin **************/

alter view usd_vq_target
as
select agent_name as lanname, object_uuid as objectid, NULL as dis_hw_uuid, agent_type
from ca_agent a
where a.agent_type = 1 or a.agent_type = 4
go


/* ************************** 11614 end **************/

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15191619, getdate(), 1, 4, 'Star 15191619 DSM: USD view and usd_vq_target' )
GO

COMMIT TRANSACTION 
GO



