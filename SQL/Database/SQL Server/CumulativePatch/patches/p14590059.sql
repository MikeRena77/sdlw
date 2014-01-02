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
/* Star 14590059 DSM : MSSQL Update for AMS                                             */
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

/* ************************************** 9624 begin ****************** */

GRANT  SELECT   ON [dbo].[ca_application_registration]  TO [ca_itrm_group_ams]
GO
GRANT  INSERT ON [dbo].[ca_application_registration]  TO [ca_itrm_group_ams]
GO
GRANT  UPDATE   ON [dbo].[ca_application_registration]  TO [ca_itrm_group_ams]
GO
GRANT  DELETE   ON [dbo].[ca_application_registration]  TO [ca_itrm_group_ams]
GO
/* ************************************** 9624 end ****************** */



/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14590059, getdate(), 1, 4, 'Star 14590059 DSM : MSSQL Update for AMS' )
GO

COMMIT TRANSACTION 
GO

