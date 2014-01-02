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
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************/
/*                                                                                      */
/* Star 15191617 DSM: update procedure sd_cli						*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */

/* Start of lines added to convert to online lock */


Select top 1 1 from mdb_patch with (tablockx)
GO

/* Start of locks for dependent tables */

/* End of lines added to convert to online lock */


/* ************************** 11579 begin **************/

Create view usd_v_user_dhw_area_sec
(uri, user_uuid, domain_uuid, dhw_uuid
)

as
select	distinct ca_discovered_user.uri,
	ca_discovered_user.user_uuid,
	ca_discovered_user.domain_uuid,
	ca_object_ace.object_def_uuid

from 	ca_object_ace, ca_security_profile, ca_link_object_owner,
	ca_link_dis_user_sec_profile, ca_discovered_user

where 	(ca_object_ace.ace & 64) = 64
	AND	ca_object_ace.security_profile_uuid = ca_security_profile.security_profile_uuid 
	AND  ( ( ca_security_profile.security_profile_uuid  	= ca_link_dis_user_sec_profile.security_profile_uuid 	
			AND    ca_link_dis_user_sec_profile.user_uuid	= ca_discovered_user.user_uuid )
	   OR   ( ca_security_profile.security_profile_uuid = ca_link_object_owner.security_profile_uuid 
			AND  	ca_link_object_owner.owner_uuid = ca_discovered_user.user_uuid   )
         )

	AND  
		 ( ca_object_ace.object_def_uuid IN  
			 ( select object_def_uuid 
				from ols_area_ace 
					where ( area_ace & area_mask 
								& [dbo].ols_fn_getAreaAceByUserUuid( ca_discovered_user.user_uuid   )) != 0 
			 )  
		 )  

go

grant select on usd_v_user_dhw_area_sec to  ca_itrm_group 
go
grant select on usd_v_user_dhw_area_sec to  ca_itrm_group_ams
go


/************************************************************************
	view 	usd_v_container_installations
	displays the installation done via a container
	
	view 	usd_v_container_installations_s
	is used for security impacts

************************************************************************/




Create view usd_v_container_installations_a_s
(	uri, user_uuid, 
	containername, containercomment, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion)

as
select 	uri, user_uuid, 
	containername, containercomment, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_container_installations 

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_container_installations.agent_uuid
     
go

grant select on usd_v_container_installations_a_s to ca_itrm_group  
go
grant select on usd_v_container_installations_a_s to ca_itrm_group_ams
go


/************************************************************************
	view 	usd_v_container_jobs
	displays the (failed and non-installation) jobs
	of a container.

	view 	usd_v_container_jobs_s 
	is the security form.
************************************************************************/



/************************************************************************
	view 

************************************************************************/


Create view usd_v_container_jobs_a_s
(	uri, user_uuid, 
	containername, containercomment,
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion)


as
select 	uri, user_uuid, 
	containername, containercomment,
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_container_jobs

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_container_jobs.agent_uuid
     
go

grant select on usd_v_container_jobs_a_s to  ca_itrm_group  
go
grant select on usd_v_container_jobs_a_s to  ca_itrm_group_ams
go





/************************************************************************
	view 	usd_v_group_installed_products
	displays the installed products in a group of targets

	view 	usd_v_group_installed_products_s
	is used for security impacts
************************************************************************/


/************************************************************************
 view 	

************************************************************************/

Create view usd_v_group_installed_products_a_s
(	uri, user_uuid, 
	group_name, agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	"procedure", procedureversion)

as
select 	uri, user_uuid, 
	group_name, agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	"procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_group_installed_products

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_group_installed_products.agent_uuid
     
go

grant select on usd_v_group_installed_products_a_s to  ca_itrm_group  
go
grant select on usd_v_group_installed_products_a_s to  ca_itrm_group_ams
go



/************************************************************************
	view 	usd_v_group_jobs
	displays the jobs distributed to a group
	of targets. Jobs means the failed installation jobs
	and other usd jobs.
	
	view 	usd_v_group_jobs_s
	is used for security impacts

************************************************************************/



/************************************************************************
  view 
 ************************************************************************/


Create view usd_v_group_jobs_a_s
(	uri, user_uuid, 
	group_name, agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion)


as
select 	uri, user_uuid, 
	group_name, agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_group_jobs

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_group_jobs.agent_uuid
     
go

grant select on usd_v_group_jobs_a_s to  ca_itrm_group  
go
grant select on usd_v_group_jobs_a_s to  ca_itrm_group_ams
go


grant select on usd_v_osim_targets_all to  ca_itrm_group  
go
grant select on usd_v_osim_targets_all to  ca_itrm_group_ams  
go

grant select on usd_v_osim_targets_deleted to  ca_itrm_group  
go
grant select on usd_v_osim_targets_deleted to  ca_itrm_group_ams
go

/************************************************************************
	view 

************************************************************************/



/************************************************************************
	view 

************************************************************************/



create view usd_v_osim_targets_a_s
(
	uri, user_uuid, 
	agent_name, agent_uuid, bootserver, mac_address
)


as
select 	uri, user_uuid, 
	agent_name, agent_uuid, bootserver, mac_address

from 	usd_v_user_dhw_area_sec, usd_v_osim_targets

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_osim_targets.agent_uuid
     
go

grant select on usd_v_osim_targets_a_s to  ca_itrm_group  
go
grant select on usd_v_osim_targets_a_s to  ca_itrm_group_ams  
go



/************************************************************************
	view 	usd_v_installed_products
	displays the installed products on a system

	usd_v_installed_products_s
	is used for security impacts

************************************************************************/



/************************************************************************
	view 

************************************************************************/



Create view usd_v_installed_products_a_s
(	uri, user_uuid, 
	agent_name, agent_type, agent_uuid, 
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	"procedure", procedureversion)


as
select 	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	"procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_installed_products

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_installed_products.agent_uuid
go

grant select on usd_v_installed_products_a_s to  ca_itrm_group  
go
grant select on usd_v_installed_products_a_s to  ca_itrm_group_ams  
go


/************************************************************************
	view 	usd_v_target_jobs
	displays the jobs on a system
	It contains the succeeded and failed installation jobs

	usd_v_target_jobs_s
	is used for security impacts
************************************************************************/

/************************************************************************
	view 

************************************************************************/





Create view usd_v_target_jobs_a_s
(	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion)


as
select 	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_target_jobs

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_target_jobs.agent_uuid
     
go

grant select on usd_v_target_jobs_a_s to  ca_itrm_group  
go
grant select on usd_v_target_jobs_a_s to  ca_itrm_group_ams
go






/************************************************************************
	view 	usd_v_targets_os
	displays the usd relavant target systems
	and their OS
	
	view 	usd_v_targets_os_s
	is used for security impacts

************************************************************************/




/************************************************************************
	view 

************************************************************************/




Create view usd_v_targets_os_a_s
(	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	proc_os_name,
        is_boot_server, is_staging_server, is_user, is_computer, server_label)

as
select 	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	proc_os_name,
        is_boot_server, is_staging_server, is_user, is_computer, server_label

from 	usd_v_user_dhw_area_sec, usd_v_targets_os

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_targets_os.agent_uuid
     
go

grant select on usd_v_targets_os_a_s to  ca_itrm_group  
go
grant select on usd_v_targets_os_a_s to  ca_itrm_group_ams
go



/************************************************************************
	view 	usd_v_sserver_clients
	displays the clients (user and computer) on a sector server
	
	view 	usd_v_sserver_clients_s
	is used for security impacts

************************************************************************/



/************************************************************************
	view 

************************************************************************/




Create view usd_v_sserver_clients_a_s
( uri, user_uuid, server_name, agent_name, object_uuid )	
as
select 	uri, user_uuid, server_name, agent_name, object_uuid

from 	usd_v_user_dhw_area_sec, usd_v_sserver_clients

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_sserver_clients.object_uuid
go

grant select on usd_v_sserver_clients_a_s to  ca_itrm_group  
go
grant select on usd_v_sserver_clients_a_s to  ca_itrm_group_ams
go




/************************************************************************
	view 	usd_v_product_jobs
	displays the jobs contained in a product
	and their OS
	this view displays only jobs, for which 
	an activity and therfore a container exists
	
	view 	usd_v_product_jobs_s
	is used for security impacts

************************************************************************/


/************************************************************************
	view 

************************************************************************/

grant select on usd_v_product_jobs_s to  ca_itrm_group  
go
grant select on usd_v_product_jobs_s to  ca_itrm_group_ams  
go

 
Create view usd_v_product_jobs_a_s
(	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion)

as
select  uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, packagetype,
	jobname, "procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_product_jobs

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_product_jobs.agent_uuid
     

go
grant select on usd_v_product_jobs_a_s to  ca_itrm_group  
go
grant select on usd_v_product_jobs_a_s to  ca_itrm_group_ams
go


/************************************************************************
	view 	usd_v_product_procedures
	displays the procedures contained in a product
	and their OS
	
	view 	usd_v_product_procedures_s
	is used for security impacts

************************************************************************/


 
Create view usd_v_product_procedures_a_s
(	uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, uninstallstate, packagetype,
	"procedure", procedureversion)

as
select  uri, user_uuid, 
	agent_name, agent_type, agent_uuid,
	productname, productversion,
	object_uuid, task, state, 
	errorcause, errorparam,
	activationtime,
	creationtime, completiontime,
	userparams, uninstallstate, packagetype,
	"procedure", procedureversion

from 	usd_v_user_dhw_area_sec, usd_v_product_procedures

where	usd_v_user_dhw_area_sec.dhw_uuid
		= usd_v_product_procedures.agent_uuid
     

go
grant select on usd_v_product_procedures_a_s to  ca_itrm_group  
go
grant select on usd_v_product_procedures_a_s to  ca_itrm_group_ams
go





/************************************************************************
	procedure 	usd_p_container_installations
	displays the installation done via a container
	
	procedure 	usd_p_container_installations_s
	is used for security impacts

************************************************************************/




/************************************************************************
	procedure

************************************************************************/


alter procedure usd_p_container_installations_s
(	@__uri nvarchar(255), @__containername nvarchar(129) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			containername, 
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_container_installations_s

		where  	user_uuid= @__user_uuid and containername like @__containername
		
		order by containername, jobname,
				productname, productversion, "procedure";

	else 

		select 	
			containername, 
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_container_installations_a_s

		where  	user_uuid = @__user_uuid and containername like @__containername
		
		order by containername, jobname,
				productname, productversion, "procedure";



end
go
grant execute on  usd_p_container_installations_s to  ca_itrm_group  
go




/************************************************************************
	procedure 	usd_p_container_jobs
	displays the (failed and non-installation) jobs
	of a container.

	procedure 	usd_p_container_jobs_s 
	is the security form.
************************************************************************/




/************************************************************************
	procedure

************************************************************************/



alter procedure usd_p_container_jobs_s (@__uri nvarchar(255), @__containername nvarchar(129) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			containername, 
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		from usd_v_container_jobs_s

		where  	user_uuid=@__user_uuid and containername like @__containername

		order by jobname, productname, productversion, "procedure"
	     
	else 

		select 	
			containername, 
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		from usd_v_container_jobs_a_s

		where  	user_uuid=@__user_uuid and containername like @__containername

		order by jobname, productname, productversion, "procedure"
	     

end
go
grant execute on  usd_p_container_jobs_s to  ca_itrm_group  
go



/************************************************************************
	procedure 	usd_p_container__fd_jobs
	displays the (failed and non-installation) jobs
	of a container.

	procedure 	usd_p_container_fd_jobs_s 
	is the security form.
************************************************************************/



/************************************************************************
	procedure

************************************************************************/


alter procedure usd_p_container_fd_jobs_s (	@__uri nvarchar(255), @__containername nvarchar(129) )
as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )

		 select 	
			containername, 
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_container_jobs_s

		where  	user_uuid=@__user_uuid and containername like @__containername
			and ( state = 10 or state = 5 or state = 14 )

		order by jobname, productname, productversion, "procedure"
	     
	else 

		 select 	
			containername, 
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_container_jobs_a_s

		where  	user_uuid=@__user_uuid and containername like @__containername
			and ( state = 10 or state = 5 or state = 14 )

		order by jobname, productname, productversion, "procedure"
	     
	
end
go
grant execute on  usd_p_container_fd_jobs_s to  ca_itrm_group  
go





/************************************************************************
	procedure 	usd_p_group_installed_products
	displays the installed products in a group of targets

	procedure 	usd_p_group_installed_products_s
	is used for security impacts
************************************************************************/





/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_group_installed_products_s (@__uri nvarchar(255), @__group_name nvarchar(155) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			group_name, agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			"procedure", procedureversion
		
		from usd_v_group_installed_products_s

		where  	user_uuid=@__user_uuid and group_name like @__group_name 
			 
		order by productname, productversion, "procedure"

	else 

		select 	
			group_name, agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			"procedure", procedureversion
		
		from usd_v_group_installed_products_a_s

		where  	user_uuid=@__user_uuid and group_name like @__group_name 
			 
		order by productname, productversion, "procedure"


end
go
grant execute on  usd_p_group_installed_products_s to  ca_itrm_group  
go



/************************************************************************
	procedure 	usd_p_group_jobs
	displays the jobs distributed to a group
	of targets. Jobs means the failed installation jobs
	and other usd jobs.
	
	procedure 	usd_p_group_jobs_s
	is used for security impacts

************************************************************************/




/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_group_jobs_s
(	@__uri nvarchar(255), @__group_name nvarchar(155) )


as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			group_name, agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_group_jobs_s

		where  	user_uuid=@__user_uuid and group_name like @__group_name

		order by jobname, productname, productversion, "procedure"
	     
	else 

		select 	
			group_name, agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_group_jobs_a_s

		where  	user_uuid=@__user_uuid and group_name like @__group_name

		order by jobname, productname, productversion, "procedure"
	     
end
go

grant execute on  usd_p_group_jobs_s to  ca_itrm_group  
go


/************************************************************************
	procedure 	usd_p_group_fd_jobs
	displays the jobs distributed to a group
	of targets. Jobs means the failed installation jobs.
	
	procedure 	usd_p_group_fd_jobs_s
	is used for security impacts

************************************************************************/
	


/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_group_fd_jobs_s(	@__uri nvarchar(255), @__group_name nvarchar(155) )


as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			group_name, agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		
		from usd_v_group_jobs_s

		where  	user_uuid=@__user_uuid and group_name like @__group_name
			and ( state = 10 or state = 5 or state = 14 )

		order by jobname, productname, productversion, "procedure"
	     
	else 

		select 	
			group_name, agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		
		from usd_v_group_jobs_a_s

		where  	user_uuid=@__user_uuid and group_name like @__group_name
			and ( state = 10 or state = 5 or state = 14 )

		order by jobname, productname, productversion, "procedure"
	     
	
end
go

grant execute on  usd_p_group_fd_jobs_s to  ca_itrm_group  
go






/************************************************************************
	procedure 	usd_p_osim_targets
	displays the csm known computers, which are
	not managed by csm

	procedure 	usd_p_osim_targets_s
	is used for security impacts
************************************************************************/

/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_osim_targets_s(	@__uri nvarchar(255) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_uuid, bootserver, mac_address
		from usd_v_osim_targets_s

		where  uri=@__uri 	
	
	else 

		select 	
			agent_name, agent_uuid, bootserver, mac_address
		from usd_v_osim_targets_a_s

		where  uri=@__uri 	
	
end
go
grant execute on  usd_p_osim_targets_s to  ca_itrm_group  
go




/************************************************************************
	procedure 	usd_p_installed_products
	displays the installed products on a system

	usd_p_installed_products_s
	is used for security impacts

************************************************************************/


/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_installed_products_s(@__uri nvarchar(255), @__agent_name nvarchar(192) )


as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			"procedure", procedureversion
		
		from usd_v_installed_products_s

		where  	user_uuid=@__user_uuid and agent_name like @__agent_name

		order by productname, productversion, "procedure"
	
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			"procedure", procedureversion
		
		from usd_v_installed_products_a_s

		where  	user_uuid=@__user_uuid and agent_name like @__agent_name

		order by productname, productversion, "procedure"
	

end
go
grant execute on  usd_p_installed_products_s to  ca_itrm_group  
go



/************************************************************************
	procedure 	usd_p_target_jobs
	displays the jobs on a system
	It contains the succeeded and failed installation jobs

	usd_p_target_jobs_s
	is used for security impacts
************************************************************************/






/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_target_jobs_s(@__uri nvarchar(255), @__agent_name nvarchar(192) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_target_jobs_s

		where  	user_uuid=@__user_uuid and agent_name like @__agent_name

		order by jobname, productname, productversion, "procedure"
	     
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_target_jobs_a_s

		where  	user_uuid=@__user_uuid and agent_name like @__agent_name

		order by jobname, productname, productversion, "procedure"
	     

	
end
go
grant execute on  usd_p_target_jobs_s to  ca_itrm_group  
go


/************************************************************************
	procedure 	usd_p_target_fd_jobs
	displays the jobs on a system
	It contains the failed installation jobs

	usd_p_target_fd_jobs_s
	is used for security impacts
************************************************************************/





/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_target_fd_jobs_s(@__uri nvarchar(255), @__agent_name nvarchar(192) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
			
		from usd_v_target_jobs_s

		where  	user_uuid=@__user_uuid and agent_name like @__agent_name
			and ( state = 10 or state = 5 or state = 14 )

		order by jobname, productname, productversion, "procedure"
	     
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
			
		from usd_v_target_jobs_a_s

		where  	user_uuid=@__user_uuid and agent_name like @__agent_name
			and ( state = 10 or state = 5 or state = 14 )

		order by jobname, productname, productversion, "procedure"
	     

	
end
go

grant execute on  usd_p_target_fd_jobs_s to  ca_itrm_group  
go






/************************************************************************
	procedure 	usd_p_targets_os
	displays the usd relavant target systems
	and their OS
	
	procedure 	usd_p_targets_os_s
	is used for security impacts

************************************************************************/





/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_targets_os_s (@__uri nvarchar(255) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			proc_os_name,
				is_boot_server, is_staging_server, is_user, is_computer,
			server_label
		
		from usd_v_targets_os_s

		where  uri=@__uri 	

		order by agent_name

	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			proc_os_name,
				is_boot_server, is_staging_server, is_user, is_computer,
			server_label
		
		from usd_v_targets_os_a_s

		where  uri=@__uri 	

		order by agent_name


end
go

grant execute on  usd_p_targets_os_s to  ca_itrm_group  
go


/************************************************************************
	procedure 	usd_p_product_jobs
	displays the jobs contained in a product
	It contains the succeeded and failed installation jobs

	usd_p_product_jobs_s
	is used for security impacts
************************************************************************/






/************************************************************************
	procedure

************************************************************************/


alter procedure usd_p_product_jobs_s (	@__uri nvarchar(255), @__productname nvarchar(129), @__productversion nvarchar(129) )

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_product_jobs_s

		where  	user_uuid=@__user_uuid 
			and productname like @__productname 
			and productversion like @__productversion

		order by productname, productversion, "procedure", agent_name, jobname
	     
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_product_jobs_a_s

		where  	user_uuid=@__user_uuid 
			and productname like @__productname 
			and productversion like @__productversion

		order by productname, productversion, "procedure", agent_name, jobname
	     


end
go
grant execute on  usd_p_product_jobs_s to  ca_itrm_group  
go


/************************************************************************
	procedure 	usd_p_product_fd_jobs
	displays the failed jobs contained in a product

	usd_p_product_fd_jobs_s
	is used for security impacts
************************************************************************/

alter procedure usd_p_product_fd_jobs (@__productname nvarchar(129) , @__productversion  nvarchar(129))

as 
begin
	select	agent_name, agent_type, agent_uuid,
		productname, productversion,
		object_uuid, task, state, 
		errorcause, errorparam,
		activationtime,
		creationtime, completiontime,
		userparams, packagetype,
		jobname, "procedure", procedureversion
	
	from usd_v_product_jobs

	where  productname like @__productname
		and productversion like @__productversion
		and ( state = 10 or state = 5 or state = 14 )

	order by productname, productversion, "procedure", agent_name, jobname
	

end
go
grant execute on  usd_p_product_fd_jobs to  ca_itrm_group  
go


/************************************************************************
	procedure

************************************************************************/


alter procedure usd_p_product_fd_jobs_s (@__uri nvarchar(255), @__productname nvarchar(129) , @__productversion  nvarchar(129))

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_product_jobs_s

		where  	user_uuid=@__user_uuid 
			and productname  like @__productname 
			and productversion like @__productversion
			and ( state = 10 or state = 5 or state = 14 )

		order by productname, productversion, "procedure", agent_name, jobname
	     
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, packagetype,
			jobname, "procedure", procedureversion
		
		from usd_v_product_jobs_a_s

		where  	user_uuid=@__user_uuid 
			and productname  like @__productname 
			and productversion like @__productversion
			and ( state = 10 or state = 5 or state = 14 )

		order by productname, productversion, "procedure", agent_name, jobname
	     

end
go
grant execute on  usd_p_product_fd_jobs_s to  ca_itrm_group  
go

/************************************************************************
	procedure 	usd_p_product_procedures
	displays the jobs contained in a product
	It contains the succeeded and failed installation jobs

	usd_p_product_procedures_s
	is used for security impacts
************************************************************************/


/************************************************************************
	procedure

************************************************************************/


alter procedure usd_p_product_procedures_s (@__uri nvarchar(255), 
					@__productname nvarchar(129), 
					@__productversion nvarchar(129), 
					@__procedure nvarchar(129),
					@__task integer)

as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, uninstallstate, packagetype,
			"procedure", procedureversion
		
		from usd_v_product_procedures_s

		where  	user_uuid=@__user_uuid and 
			productname like @__productname 
			and productversion like @__productversion
			and "procedure" like @__procedure
			and substring(cast(task as binary), 0, 4) like 
				case when @__task < 255 then substring(cast(@__task as binary), 0, 4) else '%' end

		order by productname, productversion, "procedure", agent_name
	     
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, uninstallstate, packagetype,
			"procedure", procedureversion
		
		from usd_v_product_procedures_a_s

		where  	user_uuid=@__user_uuid and 
			productname like @__productname 
			and productversion like @__productversion
			and "procedure" like @__procedure
			and substring(cast(task as binary), 0, 4) like 
				case when @__task < 255 then substring(cast(@__task as binary), 0, 4) else '%' end

		order by productname, productversion, "procedure", agent_name
	     


end
go
grant execute on  usd_p_product_procedures_s to  ca_itrm_group  
go


/************************************************************************
	procedure 	usd_p_product_fd_procedures
	displays the failed procedures contained in a product

	usd_p_product_fd_procedures_s
	is used for security impacts
************************************************************************/


/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_product_fd_procedures_s (@__uri nvarchar(255), 
						@__productname nvarchar(129), 
						@__procedure nvarchar(129),
						@__task integer)


as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, uninstallstate, packagetype,
			"procedure", procedureversion
		
		from usd_v_product_procedures_s

		where  	user_uuid=@__user_uuid 
			and productname  like @__productname 
			and ( state = 10 or state = 5 or state = 14 )
			and "procedure"  like @__procedure 
			and substring(cast(task as binary), 0, 4) like 
				case when @__task < 255 then (substring(cast(@__task as binary), 0, 4)) else '%' end

		order by productname, productversion, "procedure", agent_name
	     
	else 
	
		select 	
			agent_name, agent_type, agent_uuid,
			productname, productversion,
			object_uuid, task, state, 
			errorcause, errorparam,
			activationtime,
			creationtime, completiontime,
			userparams, uninstallstate, packagetype,
			"procedure", procedureversion
		
		from usd_v_product_procedures_a_s

		where  	user_uuid=@__user_uuid 
			and productname  like @__productname 
			and ( state = 10 or state = 5 or state = 14 )
			and "procedure"  like @__procedure 
			and substring(cast(task as binary), 0, 4) like 
				case when @__task < 255 then (substring(cast(@__task as binary), 0, 4)) else '%' end

		order by productname, productversion, "procedure", agent_name
	     


end
go
grant execute on  usd_p_product_fd_procedures_s to  ca_itrm_group  
go

/************************************************************************
	procedure 	usd_p_sserver_clients
	displays the clients (user and computer) on a staging server

	usd_p_sserver_clients
	is used for security impacts
************************************************************************/


/************************************************************************
	procedure

************************************************************************/

alter procedure usd_p_sserver_clients_s
(	@__uri nvarchar(255), @__server_name nvarchar(129) )


as 
begin
declare @__is_area_enabled integer;
declare @__user_uuid binary(16);


	SELECT @__user_uuid=user_uuid, @__is_area_enabled=is_area_enabled FROM ols_v_user WHERE  uri = @__uri;

	if ( @__is_area_enabled = 0 )
	
		select 	
			agent_name
		
		from usd_v_sserver_clients_s

		where  	user_uuid=@__user_uuid and 
			server_name like @__server_name 

		order by agent_name
	     
	else 
	
		select 	
			agent_name
		
		from usd_v_sserver_clients_a_s

		where  	user_uuid=@__user_uuid and 
			server_name like @__server_name 

		order by agent_name
	     


end
go
grant execute on  usd_p_sserver_clients_s to  ca_itrm_group  
go

/* ************************** 11579 end **************/
/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 15191617, getdate(), 1, 4, 'Star 15191617 DSM: update procedure sd_cli' )
GO

COMMIT TRANSACTION 
GO

