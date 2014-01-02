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
/* Star 14556282 AMO: MSSQL CHANGE TO AMO VIEWS                                         */
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

/* ********************** 9353 begin *************************** */
/* wakup on lan needs the subnet mask to performe the wake up */

drop view csm_v_computer 
go

create view csm_v_computer(uuid, dname, osim_target_type 	) /* Table with OSIM computers */
as
select 	c.uuid, c.dname, 1 as osim_target_type 	/* uuid of the computer */
from csm_object c, csm_property cp_bs 
where c.class=102 	/* computers already registered in DSM and CSM */
	and c.dname!=''
	
	and cp_bs.object=c.id 
	and cp_bs.name='bootstatus' /* OSIM computers have a bootstatus */

union
select c.uuid, cp_mac.value, -1 as osim_target_type 
from csm_object c, csm_property cp_bs, csm_property cp_mac  
where c.class=102 	/* computers reported with a MAC only are not registered in DSM */
	and c.dname=''

	and cp_bs.object=c.id 
	and cp_bs.name='bootstatus' 
	
	and cp_mac.object=c.id  
	and cp_mac.name='macaddr'


GO

GRANT  SELECT  ON [dbo].[csm_v_computer]  TO [ca_itrm_group]
GO


/* ********************** 9353 end *************************** */
/* ********************** 9354 begin *************************** */
/* wakup on lan needs the subnet mask to performe the wake up */

drop view dts_dtasset_view  
go

CREATE VIEW dts_dtasset_view ( object_id,
                               label,
							   asset_host_name,
							   asset_host_uuid,
							   asset_primary_mac_address,
							   asset_primary_network_address,
							   asset_usage_list,
							   asset_source_uuid,
							   asset_ip_address,
							   asset_primary_subnet_mask
							 )
	AS
	SELECT ca_discovered_hardware.dis_hw_uuid,
	       ca_discovered_hardware.label,
		   ca_discovered_hardware.host_name,
		   ca_discovered_hardware.host_uuid,
		   ca_discovered_hardware.primary_mac_address,
		   ca_discovered_hardware.primary_network_address,
		   ca_discovered_hardware.usage_list,
		   ca_discovered_hardware.asset_source_uuid,
		   ca_agent.ip_address,
		   ca_discovered_hardware.primary_subnet_mask
	FROM ( ca_discovered_hardware LEFT OUTER JOIN ca_agent ON ca_discovered_hardware.dis_hw_uuid = ca_agent.object_uuid) 
go
GRANT  SELECT  ON [dbo].[dts_dtasset_view]  TO [ca_itrm_group]
go
GRANT  SELECT  ON [dbo].[dts_dtasset_view]  TO [upmuser_group]
go

/* ********************** 9354 end *************************** */


/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14556282, getdate(), 1, 4, 'Star 14556282 AMO: MSSQL CHANGE TO AMO VIEWS ' )
GO

COMMIT TRANSACTION 
GO


