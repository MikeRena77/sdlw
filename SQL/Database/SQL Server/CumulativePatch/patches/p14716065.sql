SET LOCK_TIMEOUT 300000
GO
SET DEADLOCK_PRIORITY LOW
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
SET XACT_ABORT OFF
GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO
BEGIN TRANSACTION 
GO

/****************************************************************************/
/*                                                                          */
/* Star 14716065 new mdb tables for ASM                          	    */
/*                                                                          */
/****************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */

Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

declare @sql nvarchar(4000)

set @sql = N'CREATE TABLE [dbo].[wtDRO_PLVEthernet] (
	[uuid] [binary] (16) NOT NULL ,
	[Platform_Name] [varchar] (64) COLLATE !!insensitive NULL ,
	[Platform_Type] [varchar] (64) COLLATE !!insensitive NULL ,
	[IO1] [float] NULL ,
	[IO2] [float] NULL ,
	[IO3] [float] NULL ,
	[IO4] [float] NULL ,
	[IO1_Min] [float] NULL ,
	[IO1_Max] [float] NULL ,
	[IO1_COEF] [float] NULL ,
	[IO2_Min] [float] NULL ,
	[IO2_Max] [float] NULL ,
	[IO2_COEF] [float] NULL ,
	[IO3_Min] [float] NULL ,
	[IO3_Max] [float] NULL ,
	[IO3_COEF] [float] NULL ,
	[IO4_Min] [float] NULL ,
	[IO4_Max] [float] NULL ,
	[IO4_COEF] [float] NULL ,
	[Disk1] [float] NULL ,
	[Disk2] [float] NULL ,
	[Disk1_Min] [float] NULL ,
	[Disk1_Max] [float] NULL ,
	[Disk1_COEF] [float] NULL ,
	[Disk2_Min] [float] NULL ,
	[Disk2_Max] [float] NULL ,
	[Disk2_COEF] [float] NULL ,
	[Mem2] [float] NULL ,
	[Mem3] [float] NULL ,
	[Mem2_Min] [float] NULL ,
	[Mem2_Max] [float] NULL ,
	[Mem2_COEF] [float] NULL ,
	[Mem3_Min] [float] NULL ,
	[Mem3_Max] [float] NULL ,
	[Mem3_COEF] [float] NULL ,
	[CPU2] [float] NULL ,
	[CPU2_Min] [float] NULL ,
	[CPU2_Max] [float] NULL ,
	[CPU2_COEF] [float] NULL ,
	[Net1] [float] NULL ,
	[Net2] [float] NULL ,
	[Net1_Min] [float] NULL ,
	[Net1_Max] [float] NULL ,
	[Net1_COEF] [float] NULL ,
	[Net2_Min] [float] NULL ,
	[Net2_Max] [float] NULL ,
	[Net2_COEF] [float] NULL ,
	[Manage_Platform] [int] NULL ,
	[Free_Memory] [int] NULL ,
	[DRSL] [varchar] (64) COLLATE !!insensitive NULL ,
	[DRSLG] [varchar] (64) COLLATE !!insensitive NULL ,
	[Analysis_Interval] [int] NULL ,
	[Poll_Interval] [int] NULL ,
	[HMC_Name] [varchar] (64) COLLATE !!insensitive NULL ,
	[Memory_Usage] [float] NULL ,
	[CPU_Usage] [float] NULL ,
	[Capacity_PLPAR] [float] NULL ,
	[Crit_Capacity_Plat_Thresh] [int] NULL ,
	[Min_Capacity_Plat_Thresh] [int] NULL ,
	[DebugLevel] [int] NULL ,
	[Console_Message_Level] [int] NULL ,
	[LogFileSize] [int] NULL ,
	[Number_Of_CPUs] [int] NULL ,
	[Plat_Free_LMBs] [int] NULL ,
	[Plat_Total_LMBs] [int] NULL ,
	[SYS_IP_Address] [varchar] (255) COLLATE !!insensitive NULL ,
	[Capacity_On_Demand_CPU_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Capacity_On_Demand_MEM_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[OS400_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Micro_LPAR_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Virtual_IO_Server_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property1] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property2] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property3] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPARName] [varchar] (255) COLLATE !!insensitive NULL ,
	[PortVLAN] [varchar] (255) COLLATE !!insensitive NULL ,
	[AdditionalVLAN] [varchar] (255) COLLATE !!insensitive NULL ,
	[TrunkAdapter] [varchar] (255) COLLATE !!insensitive NULL ,
	[Required] [varchar] (255) COLLATE !!insensitive NULL ,
	[MACAddress] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPARID] [int] NULL ,
	[SlotNum] [int] NULL ,
	[EthernetIEEE] [int] NULL 
) ON [PRIMARY]'

execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'CREATE TABLE [dbo].[wtDRO_PLVSCSI] (
	[uuid] [binary] (16) NOT NULL ,
	[Platform_Name] [varchar] (64) COLLATE !!insensitive NULL ,
	[Platform_Type] [varchar] (64) COLLATE !!insensitive NULL ,
	[IO1] [float] NULL ,
	[IO2] [float] NULL ,
	[IO3] [float] NULL ,
	[IO4] [float] NULL ,
	[IO1_Min] [float] NULL ,
	[IO1_Max] [float] NULL ,
	[IO1_COEF] [float] NULL ,
	[IO2_Min] [float] NULL ,
	[IO2_Max] [float] NULL ,
	[IO2_COEF] [float] NULL ,
	[IO3_Min] [float] NULL ,
	[IO3_Max] [float] NULL ,
	[IO3_COEF] [float] NULL ,
	[IO4_Min] [float] NULL ,
	[IO4_Max] [float] NULL ,
	[IO4_COEF] [float] NULL ,
	[Disk1] [float] NULL ,
	[Disk2] [float] NULL ,
	[Disk1_Min] [float] NULL ,
	[Disk1_Max] [float] NULL ,
	[Disk1_COEF] [float] NULL ,
	[Disk2_Min] [float] NULL ,
	[Disk2_Max] [float] NULL ,
	[Disk2_COEF] [float] NULL ,
	[Mem2] [float] NULL ,
	[Mem3] [float] NULL ,
	[Mem2_Min] [float] NULL ,
	[Mem2_Max] [float] NULL ,
	[Mem2_COEF] [float] NULL ,
	[Mem3_Min] [float] NULL ,
	[Mem3_Max] [float] NULL ,
	[Mem3_COEF] [float] NULL ,
	[CPU2] [float] NULL ,
	[CPU2_Min] [float] NULL ,
	[CPU2_Max] [float] NULL ,
	[CPU2_COEF] [float] NULL ,
	[Net1] [float] NULL ,
	[Net2] [float] NULL ,
	[Net1_Min] [float] NULL ,
	[Net1_Max] [float] NULL ,
	[Net1_COEF] [float] NULL ,
	[Net2_Min] [float] NULL ,
	[Net2_Max] [float] NULL ,
	[Net2_COEF] [float] NULL ,
	[Manage_Platform] [int] NULL ,
	[Free_Memory] [int] NULL ,
	[DRSL] [varchar] (64) COLLATE !!insensitive NULL ,
	[DRSLG] [varchar] (64) COLLATE !!insensitive NULL ,
	[Analysis_Interval] [int] NULL ,
	[Poll_Interval] [int] NULL ,
	[HMC_Name] [varchar] (64) COLLATE !!insensitive NULL ,
	[Memory_Usage] [float] NULL ,
	[CPU_Usage] [float] NULL ,
	[Capacity_PLPAR] [float] NULL ,
	[Crit_Capacity_Plat_Thresh] [int] NULL ,
	[Min_Capacity_Plat_Thresh] [int] NULL ,
	[DebugLevel] [int] NULL ,
	[Console_Message_Level] [int] NULL ,
	[LogFileSize] [int] NULL ,
	[Number_Of_CPUs] [int] NULL ,
	[Plat_Free_LMBs] [int] NULL ,
	[Plat_Total_LMBs] [int] NULL ,
	[SYS_IP_Address] [varchar] (255) COLLATE !!insensitive NULL ,
	[Capacity_On_Demand_CPU_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Capacity_On_Demand_MEM_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[OS400_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Micro_LPAR_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Virtual_IO_Server_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property1] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property2] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property3] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPARName] [varchar] (255) COLLATE !!insensitive NULL ,
	[AdapterType] [varchar] (255) COLLATE !!insensitive NULL ,
	[RemoteLPARID] [varchar] (255) COLLATE !!insensitive NULL ,
	[RemoteLPARName] [varchar] (255) COLLATE !!insensitive NULL ,
	[RemoteLPARSlotNum] [varchar] (255) COLLATE !!insensitive NULL ,
	[Required] [varchar] (255) COLLATE !!insensitive NULL ,
	[SCSIBackingDevice] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPARID] [int] NULL ,
	[SlotNum] [int] NULL 
) ON [PRIMARY]'

execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'CREATE TABLE [dbo].[wtDRO_PLVSerial] (
	[uuid] [binary] (16) NOT NULL ,
	[Platform_Name] [varchar] (64) COLLATE !!insensitive NULL ,
	[Platform_Type] [varchar] (64) COLLATE !!insensitive NULL ,
	[IO1] [float] NULL ,
	[IO2] [float] NULL ,
	[IO3] [float] NULL ,
	[IO4] [float] NULL ,
	[IO1_Min] [float] NULL ,
	[IO1_Max] [float] NULL ,
	[IO1_COEF] [float] NULL ,
	[IO2_Min] [float] NULL ,
	[IO2_Max] [float] NULL ,
	[IO2_COEF] [float] NULL ,
	[IO3_Min] [float] NULL ,
	[IO3_Max] [float] NULL ,
	[IO3_COEF] [float] NULL ,
	[IO4_Min] [float] NULL ,
	[IO4_Max] [float] NULL ,
	[IO4_COEF] [float] NULL ,
	[Disk1] [float] NULL ,
	[Disk2] [float] NULL ,
	[Disk1_Min] [float] NULL ,
	[Disk1_Max] [float] NULL ,
	[Disk1_COEF] [float] NULL ,
	[Disk2_Min] [float] NULL ,
	[Disk2_Max] [float] NULL ,
	[Disk2_COEF] [float] NULL ,
	[Mem2] [float] NULL ,
	[Mem3] [float] NULL ,
	[Mem2_Min] [float] NULL ,
	[Mem2_Max] [float] NULL ,
	[Mem2_COEF] [float] NULL ,
	[Mem3_Min] [float] NULL ,
	[Mem3_Max] [float] NULL ,
	[Mem3_COEF] [float] NULL ,
	[CPU2] [float] NULL ,
	[CPU2_Min] [float] NULL ,
	[CPU2_Max] [float] NULL ,
	[CPU2_COEF] [float] NULL ,
	[Net1] [float] NULL ,
	[Net2] [float] NULL ,
	[Net1_Min] [float] NULL ,
	[Net1_Max] [float] NULL ,
	[Net1_COEF] [float] NULL ,
	[Net2_Min] [float] NULL ,
	[Net2_Max] [float] NULL ,
	[Net2_COEF] [float] NULL ,
	[Manage_Platform] [int] NULL ,
	[Free_Memory] [int] NULL ,
	[DRSL] [varchar] (64) COLLATE !!insensitive NULL ,
	[DRSLG] [varchar] (64) COLLATE !!insensitive NULL ,
	[Analysis_Interval] [int] NULL ,
	[Poll_Interval] [int] NULL ,
	[HMC_Name] [varchar] (64) COLLATE !!insensitive NULL ,
	[Memory_Usage] [float] NULL ,
	[CPU_Usage] [float] NULL ,
	[Capacity_PLPAR] [float] NULL ,
	[Crit_Capacity_Plat_Thresh] [int] NULL ,
	[Min_Capacity_Plat_Thresh] [int] NULL ,
	[DebugLevel] [int] NULL ,
	[Console_Message_Level] [int] NULL ,
	[LogFileSize] [int] NULL ,
	[Number_Of_CPUs] [int] NULL ,
	[Plat_Free_LMBs] [int] NULL ,
	[Plat_Total_LMBs] [int] NULL ,
	[SYS_IP_Address] [varchar] (255) COLLATE !!insensitive NULL ,
	[Capacity_On_Demand_CPU_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Capacity_On_Demand_MEM_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[OS400_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Micro_LPAR_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[Virtual_IO_Server_Capable] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property1] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property2] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPAR_Property3] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPARName] [varchar] (255) COLLATE !!insensitive NULL ,
	[AdapterType] [varchar] (255) COLLATE !!insensitive NULL ,
	[RemoteLPARID] [varchar] (255) COLLATE !!insensitive NULL ,
	[RemoteLPARName] [varchar] (255) COLLATE !!insensitive NULL ,
	[RemoteLPARSlotNum] [varchar] (255) COLLATE !!insensitive NULL ,
	[Required] [varchar] (255) COLLATE !!insensitive NULL ,
	[SupportsHMC] [varchar] (255) COLLATE !!insensitive NULL ,
	[LPARID] [int] NULL ,
	[SlotNum] [int] NULL 
) ON [PRIMARY]'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'CREATE VIEW dbo.wvDRO_PLVEthernet AS SELECT a.name, a.label, a.address, a.class_name, a.interface_type, a.autoarrange_type, a.hidden, a.propagate_status, a.status_no, a.severity, a.tng_delete_flag, a.posted, a.acknowledge, a.ip_address_hex, a.mac_address, a.subnet_mask, a.date_ins, a.date_modify, a.alarmset_name, a.code_page, a.admin_status, a.DSM_Server, a.propagated_status_no, a.propagated_sev, a.DSM_Address, a.license_machine_type, a.create_bpv, a.override_imagelarge, a.override_imagesmall, a.override_imagedecal, a.override_imagetintbool, a.override_model, a.background_image, a.weight, a.weighted_severity, a.Max_Sev, a.user_reclass, a.Asset_uuid, a.source_repository, a.dnsname, a.last_seen_time, AMSServer, EMServer, b.* FROM dbo.tng_managedobject a, dbo.wtDRO_PLVEthernet b where a.uuid = b.uuid '
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'CREATE VIEW dbo.wvDRO_PLVSCSI AS SELECT a.name, a.label, a.address, a.class_name, a.interface_type, a.autoarrange_type, a.hidden, a.propagate_status, a.status_no, a.severity, a.tng_delete_flag, a.posted, a.acknowledge, a.ip_address_hex, a.mac_address, a.subnet_mask, a.date_ins, a.date_modify, a.alarmset_name, a.code_page, a.admin_status, a.DSM_Server, a.propagated_status_no, a.propagated_sev, a.DSM_Address, a.license_machine_type, a.create_bpv, a.override_imagelarge, a.override_imagesmall, a.override_imagedecal, a.override_imagetintbool, a.override_model, a.background_image, a.weight, a.weighted_severity, a.Max_Sev, a.user_reclass, a.Asset_uuid, a.source_repository, a.dnsname, a.last_seen_time, AMSServer, EMServer, b.* FROM dbo.tng_managedobject a, dbo.wtDRO_PLVSCSI b where a.uuid = b.uuid'
execute sp_executesql @sql
GO

declare @sql nvarchar(4000)

set @sql = N'CREATE VIEW dbo.wvDRO_PLVSerial AS SELECT a.name, a.label, a.address, a.class_name, a.interface_type, a.autoarrange_type, a.hidden, a.propagate_status, a.status_no, a.severity, a.tng_delete_flag, a.posted, a.acknowledge, a.ip_address_hex, a.mac_address, a.subnet_mask, a.date_ins, a.date_modify, a.alarmset_name, a.code_page, a.admin_status, a.DSM_Server, a.propagated_status_no, a.propagated_sev, a.DSM_Address, a.license_machine_type, a.create_bpv, a.override_imagelarge, a.override_imagesmall, a.override_imagedecal, a.override_imagetintbool, a.override_model, a.background_image, a.weight, a.weighted_severity, a.Max_Sev, a.user_reclass, a.Asset_uuid, a.source_repository, a.dnsname, a.last_seen_time, AMSServer, EMServer, b.* FROM dbo.tng_managedobject a, dbo.wtDRO_PLVSerial b where a.uuid = b.uuid'
execute sp_executesql @sql
GO

/*****************************************************************************/
/*                                                                           */
/* Register patch                                                      	     */
/*                                                                           */
/*****************************************************************************/

insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14716065, getdate(), 1, 4, 'Star 14716065 (MODIFIED 16208491 v3) new mdb tables for ASM' );

commit transaction
GO
