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
/* Star 14990807 Portalr12: New cmsportallinkdata, cmsaclportallinkdata, cmsrollbkportallinkdata tables	*/
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

CREATE TABLE [dbo].[CMSACLPORTALLINKDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEGROUP] [int] NULL ,
	[UEPERMISSION] [int] NULL ,
	[UERESOURCEID] [int] NULL ,
	[UEUSER] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CMSROLLBKPORTALLINKDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASSETID] [int] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECV_BUNDLE] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEURL] [nvarchar] (1000) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[CMSPORTALLINKDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECV_BUNDLE] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEURL] [nvarchar] (4000) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CMSACLPORTALLINKDATA] WITH NOCHECK ADD 
	CONSTRAINT [CMSPKACLPORTALLINK] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CMSROLLBKPORTALLINKDATA] WITH NOCHECK ADD 
	CONSTRAINT [CMDPKRBPORTALLINK] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CMSPORTALLINKDATA] WITH NOCHECK ADD 
	CONSTRAINT [CMSPKPORTALLINK] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACLPORTALLINKDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBKPORTALLINKDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPORTALLINKDATA]  TO [portaldba_group]
GO
 
/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14990807, getdate(), 1, 4, 'Star 14990807 Portalr12: New cmsportallinkdata, cmsaclportallinkdata, cmsrollbkportallinkdata tables' )
GO

COMMIT TRANSACTION 
GO

