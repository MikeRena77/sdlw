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
/* Star 14623658 DSM : MSSQL Indexes on ca_object_ace and ca_group_member               */
/*                                                                                      */
/****************************************************************************************/

BEGIN TRANSACTION 
GO

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from ca_object_ace with (tablockx)
GO
 
Select top 1 1 from ca_group_member with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */



/* modify objects...  */

/* ************************************** 9817 begin ****************** */

CREATE 																	 
 INDEX [ca_object_ace_x1] ON [dbo].[ca_object_ace] 						 
	([object_def_uuid], [security_profile_uuid], [ace])						 
WITH																		 
    DROP_EXISTING															 
ON [PRIMARY]																 				 
GO    																		 
  																			
  																			
if exists ( select o.name,i.name from sysindexes i, sysobjects o 			
	where i.name = 'ca_group_member_x1' 									
	and i.id=o.id and o.name='ca_group_member' )							
BEGIN    																	
drop index [dbo].[ca_group_member].[ca_group_member_x1]    				

END																		
GO																			
CREATE 																	 
 INDEX [ca_group_member_x1] ON [dbo].[ca_group_member] 					 
	([group_uuid], [member_uuid])											 				 
GO    																		 

/* ************************************** 9817 end ****************** */



/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14623658, getdate(), 1, 4, 'Star 14623658 DSM : MSSQL Indexes on ca_object_ace and ca_group_member' )
GO

COMMIT TRANSACTION 
GO


