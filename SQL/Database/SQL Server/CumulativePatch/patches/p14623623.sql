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
/* Star 14623623 DSM : MSSQL Indexes on Inventory tables                                */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from inv_generalinventory_tree with (tablockx)
GO
 
Select top 1 1 from inv_generalinventory_item with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

/* ************************************** 9758 begin ****************** */

if exists ( select o.name,i.name from sysindexes i, sysobjects o 									
	where i.name = 'inv_generalinventory_browse' 													
	and i.id=o.id and o.name='inv_generalinventory_tree' )											
BEGIN    																							
drop index [dbo].[inv_generalinventory_tree].[inv_generalinventory_browse]    					

END    																							
GO    																								
  																									
CREATE NONCLUSTERED INDEX [inv_generalinventory_browse] 											
	ON [dbo].[inv_generalinventory_tree] (															
		[item_root_name_id] ASC, [item_parent_name_id] ASC , 										
			[item_indent] asc,[item_flag] asc, [domain_uuid] asc,									
			[item_name_id] ASC)																		
GO    																								
 																									
 																									
if exists ( select o.name,i.name from sysindexes i, sysobjects o 									
	where i.name = 'inv_generalinventory_browse' 													
	and i.id=o.id and o.name='inv_generalinventory_item' )											
BEGIN    																							
drop index [dbo].[inv_generalinventory_item].[inv_generalinventory_browse]    					

END																								
GO																									
CREATE NONCLUSTERED INDEX [inv_generalinventory_browse] 											
	ON [dbo].[inv_generalinventory_item] (															
		[item_root_name_id] ASC, [item_parent_name_id] ASC , 										
		[item_index] asc,[domain_uuid] asc, [item_type] ASC,										
		[item_format] ASC, [item_name_id] ASc, [item_value_text] ASC, 								
		[item_value_long] ASC, [item_value_double] ASC)												
																									

GO    																								
  																									
  																									


/* ************************************** 9758 end ****************** */



/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14623623, getdate(), 1, 4, 'Star 14623623 DSM : MSSQL Indexes on Inventory tables ' )
GO

COMMIT TRANSACTION 
GO


