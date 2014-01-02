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
/* Star 14835390 DSM: Set default priority in usd_cont, usd_job_cont and usd_task. New col. in usd_v_target */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from usd_job_cont with (tablockx)
GO
 
Select top 1 1 from usd_cont with (tablockx)
GO
 
Select top 1 1 from usd_task with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

/* ********************** 10217 begin ************************** */

alter table usd_job_cont
add priority integer default 5 with values not null 
go

alter table usd_cont
add priority integer default 5 with values not null 
go

alter table usd_task
add priority integer default 5 with values not null 
go

alter procedure usd_act_jc_name_cltn_ro(@key_value as binary(16)) as
begin
select jc.objectid, jc.version, jc.creation_user, 
jc.qtask, jc.aux, jc.aux2, jc.type, jc.attributes, jc.name, 
jc.comment, jc.credate, jc.cretime, jc.chdate, jc.chtime, jc.propflag,
jc.qcalendar, jc.qevalrate, jc.qnextevaldate, jc.qnextevaltime, 
jc.qevaldate, jc.qevaltime, jc.qtemplfold, jc.qtype, jc.state, 
jc.seal, jc.var, jc.auxtext0, jc.auxtext1, jc.auxtext2, jc.auxtext3, 
jc.queryid, jc.dts_state, jc.priority
from usd_link_jc_act ljca, usd_job_cont jc
where ljca.jcont = jc.objectid
and ljca.activity = @key_value
end
go

alter procedure usd_assetgrp_jc_name_cltn_ro(@key_value as binary(16)) as
begin
select j.objectid, j.version, j.creation_user,
j.qtask, j.aux, j.aux2, j.type, j.attributes, j.name, j.comment, 
j.credate, j.cretime, j.chdate, j.chtime, j.propflag, j.qcalendar, 
j.qevalrate, j.qnextevaldate, j.qnextevaltime, j.qevaldate, 
j.qevaltime, j.qtemplfold, j.qtype, j.state, j.seal, j.var, 
j.auxtext0, j.auxtext1, j.auxtext2, j.auxtext3, j.queryid, j.dts_state,
j.priority
from usd_job_cont j
where j.qtemplfold = @key_value
end
go

alter procedure usd_jc_subgrp_name_cltn_ro(@key_value as binary(16)) as
begin
select jc.objectid, jc.version, jc.creation_user, 
jc.qtask, jc.aux, jc.aux2, jc.type, jc.attributes, jc.name, 
jc.comment, jc.credate, jc.cretime, jc.chdate, jc.chtime, jc.propflag,
jc.qcalendar, jc.qevalrate, jc.qnextevaldate, jc.qnextevaltime, 
jc.qevaldate, jc.qevaltime, jc.qtemplfold, jc.qtype, jc.state, 
jc.seal, jc.var, jc.auxtext0, jc.auxtext1, jc.auxtext2, jc.auxtext3, 
jc.queryid, jc.dts_state, jc.priority
from usd_link_jc ljc, usd_job_cont jc
where ljc.jcchild = jc.objectid
and ljc.jcparent = @key_value
end
go

alter procedure usd_jc_supgrp_name_cltn_ro(@key_value as binary(16)) as
begin
select jc.objectid, jc.version, jc.creation_user, 
jc.qtask, jc.aux, jc.aux2, jc.type, jc.attributes, jc.name, 
jc.comment, jc.credate, jc.cretime, jc.chdate, jc.chtime, jc.propflag,
jc.qcalendar, jc.qevalrate, jc.qnextevaldate, jc.qnextevaltime, 
jc.qevaldate, jc.qevaltime, jc.qtemplfold, jc.qtype, jc.state, 
jc.seal, jc.var, jc.auxtext0, jc.auxtext1, jc.auxtext2, jc.auxtext3, 
jc.queryid, jc.dts_state, jc.priority
from usd_link_jc ljc, usd_job_cont jc
where ljc.jcparent = jc.objectid
and ljc.jcchild = @key_value
end
go

alter procedure usd_cfold_cont_disttime_cltn_ro(@key_value as binary(16)) as
begin
select c.objectid, c.version, c.creation_user, c.name, 
c.overallstatus, c.sendid, c.containerpath, c.distlistpath, 
c.distlisttype, c.distdate, c.disttime, c.credate, c.cretime, 
c.ahdinfo, c.priority
from usd_link_cfold_cont lcfc, usd_cont c
where lcfc.cont = c.objectid
and lcfc.contfold = @key_value
end
go


/* ********************** 10217 end   ************************** */

/* ******************** 9990 begin *************************** */

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
		HWU.user_uuid,
		A.agent_lock
	from 	((((usd_target T left join ca_link_dis_hw_user HWU on T.objectid = HWU.link_dis_hw_user_uuid) join
		(ca_agent A left join ca_server S on A.server_uuid = S.server_uuid) on T.objectid = A.object_uuid) left join
		ca_discovered_hardware DH on T.objectid = DH.dis_hw_uuid)) left join
		ca_discovered_hardware DH2 on HWU.dis_hw_uuid = DH2.dis_hw_uuid,
		ca_agent_component AC
	where T.objectid = AC.object_uuid
	and (A.agent_type = 1 or A.agent_type = 4)      	/* 1=computer 4=computer-user*/
	and (AC.agent_comp_id = 40 or AC.agent_comp_id = 46)    /* 40=USD agent, 46=USD docking device */

GO
/* ******************** 9990 end *************************** */

/* ********************** 10173 begin ************************** */
alter procedure usd_act_cmp_name_cltn_ro(@key_value as binary(16)) as
begin
select c.objectid, c.version, c.creation_user, 
c.managementtype, c.ssname, c.lanname, c.lanaddress, c.ip_address, 
c.creationtime, c.changetime, c.regflag, c.type, c.state, c.curros, 
c.comment, c.calendar, c.ssid, c.sdver, c.uuid, c.prevls, c.agrefcnt, 
c.locks, c.download_method, c.agent_lock
from usd_link_act_cmp lac, usd_v_target c
where lac.comp = c.objectid
and lac.act = @key_value
end
go

alter procedure usd_assetgrp_cmp_name_cltn_ro(@key_value as binary(16)) as
begin
select c.objectid, c.version, c.creation_user,
c.managementtype, c.ssname, c.lanname, c.lanaddress, c.ip_address, 
c.creationtime, c.changetime, c.regflag, c.type, c.state, c.curros, 
c.comment, c.calendar, c.ssid, c.sdver, c.uuid, c.prevls, c.agrefcnt, 
c.locks, c.download_method, c.agent_lock
from ca_group_member gm, usd_v_target c
where gm.member_uuid = c.objectid
and gm.group_uuid = @key_value
and (gm.member_type = 1 or gm.member_type = 4)
end
go

alter procedure usd_cmp_ss_comp_name_cltn_ro(@key_value as binary(16)) as
begin
select objectid, version, creation_user, 
managementtype, ssname, lanname, lanaddress, ip_address, creationtime,
changetime, regflag, type, state, curros, comment, calendar, ssid, 
sdver, uuid, prevls, agrefcnt, locks, download_method, agent_lock
from usd_v_target
where ssid = @key_value
end
go

alter procedure usd_cmpgrp_cmp_name_cltn_ro(@key_value as binary(16)) as
begin
select c.objectid, c.version, c.creation_user, 
c.managementtype, c.ssname, c.lanname, c.lanaddress, c.ip_address, 
c.creationtime, c.changetime, c.regflag, c.type, c.state, c.curros, 
c.comment, c.calendar, c.ssid, c.sdver, c.uuid, c.prevls, c.agrefcnt, 
c.locks, c.download_method, c.agent_lock
from usd_link_grp_cmp lccg, usd_v_target c
where lccg.comp = c.objectid
and lccg.grp = @key_value
end
go

alter procedure usd_servgrp_srv_name_cltn_ro(@key_value as binary(16)) as
begin
select c.objectid, c.version, c.creation_user,
c.managementtype, c.ssname, c.lanname, c.lanaddress, c.ip_address, 
c.creationtime, c.changetime, c.regflag, c.type, c.state, c.curros, 
c.comment, c.calendar, c.ssid, c.sdver, c.uuid, c.prevls, c.agrefcnt, 
c.locks, c.download_method, c.agent_lock
from ca_group_member gm, usd_v_target c, ca_server s
where gm.member_uuid = s.server_uuid
and c.objectid = s.dis_hw_uuid
and gm.group_uuid = @key_value
and gm.member_type = 7
end
go

/* ********************** 10173 end ************************** */

/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14835390, getdate(), 1, 4, 'Star 14835390 DSM: Set default priority in usd_cont, usd_job_cont and usd_task. New col. in usd_v_target' )
GO

COMMIT TRANSACTION 
GO

