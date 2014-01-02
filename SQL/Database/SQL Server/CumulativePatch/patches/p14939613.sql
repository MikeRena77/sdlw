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
/* Star 14939613 Portalr12: Add a portal instance id column                             */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from cmsacl10003data with (tablockx)
GO
 
Select top 1 1 from cmsacl10010data with (tablockx)
GO
 
Select top 1 1 from cmsacl10046data with (tablockx)
GO
 
Select top 1 1 from cmsacl10074data with (tablockx)
GO
 
Select top 1 1 from cmsacl10085data with (tablockx)
GO
 
Select top 1 1 from cmsacl10093data with (tablockx)
GO
 
Select top 1 1 from cmsacl10108data with (tablockx)
GO
 
Select top 1 1 from cmsacl10115data with (tablockx)
GO
 
Select top 1 1 from cmsacl10122data with (tablockx)
GO
 
Select top 1 1 from cmsacl10130data with (tablockx)
GO
 
Select top 1 1 from cmsacl10153data with (tablockx)
GO
 
Select top 1 1 from cmsacl10160data with (tablockx)
GO
 
Select top 1 1 from cmsacl10167data with (tablockx)
GO
 
Select top 1 1 from cmsacl10175data with (tablockx)
GO
 
Select top 1 1 from cmsacl10182data with (tablockx)
GO
 
Select top 1 1 from cmsacl10190data with (tablockx)
GO
 
Select top 1 1 from cmsacl10197data with (tablockx)
GO
 
Select top 1 1 from cmsacl10205data with (tablockx)
GO
 
Select top 1 1 from cmsacl10219data with (tablockx)
GO
 
Select top 1 1 from cmsacl10226data with (tablockx)
GO
 
Select top 1 1 from cmsacl10233data with (tablockx)
GO
 
Select top 1 1 from cmsadminassetresourcedata with (tablockx)
GO
 
Select top 1 1 from cmsadminresourcebackbonedata with (tablockx)
GO
 
Select top 1 1 from cmsaiffdata with (tablockx)
GO
 
Select top 1 1 from cmsaionrulemanagerdata with (tablockx)
GO
 
Select top 1 1 from cmsapprovalchaindata with (tablockx)
GO
 
Select top 1 1 from cmsassetdata with (tablockx)
GO
 
Select top 1 1 from cmsassetfilemapdata with (tablockx)
GO
 
Select top 1 1 from cmsavidata with (tablockx)
GO
 
Select top 1 1 from cmscollectiondata with (tablockx)
GO
 
Select top 1 1 from cmscpcmconfig with (tablockx)
GO
 
Select top 1 1 from cmsdblog with (tablockx)
GO
 
Select top 1 1 from cmserrordata with (tablockx)
GO
 
Select top 1 1 from cmsfastconfig with (tablockx)
GO
 
Select top 1 1 from cmsgroupdata with (tablockx)
GO
 
Select top 1 1 from cmsimagedata with (tablockx)
GO
 
Select top 1 1 from cmsmdidcolumnsdata with (tablockx)
GO
 
Select top 1 1 from cmsmdiddata with (tablockx)
GO
 
Select top 1 1 from cmsmp3data with (tablockx)
GO
 
Select top 1 1 from cmsmpegdata with (tablockx)
GO
 
Select top 1 1 from cmsmsofficedata with (tablockx)
GO
 
Select top 1 1 from cmspdfdata with (tablockx)
GO
 
Select top 1 1 from cmspersistantstateinformationdata with (tablockx)
GO
 
Select top 1 1 from cmspersonalizationdata with (tablockx)
GO
 
Select top 1 1 from cmsphotoshopdata with (tablockx)
GO
 
Select top 1 1 from cmsportalpagedata with (tablockx)
GO
 
Select top 1 1 from cmspostscriptdata with (tablockx)
GO
 
Select top 1 1 from cmsquicktimedata with (tablockx)
GO
 
Select top 1 1 from cmsrealaudiodata with (tablockx)
GO
 
Select top 1 1 from cmsrealmediadata with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10010data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10046data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10074data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10085data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10093data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10108data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10115data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10122data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10130data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10153data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10160data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10167data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10175data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10182data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10190data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10197data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10205data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10219data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10226data with (tablockx)
GO
 
Select top 1 1 from cmsrollbk10233data with (tablockx)
GO
 
Select top 1 1 from cmsshockwavedata with (tablockx)
GO
 
Select top 1 1 from cmsstdtriggerdata with (tablockx)
GO
 
Select top 1 1 from cmsurldata with (tablockx)
GO
 
Select top 1 1 from cmsuserdata with (tablockx)
GO
 
Select top 1 1 from cmsviewfilesdata with (tablockx)
GO
 
Select top 1 1 from cmswavdata with (tablockx)
GO
 
Select top 1 1 from cmswfacldata with (tablockx)
GO
 
Select top 1 1 from cmswfactivitydata with (tablockx)
GO
 
Select top 1 1 from cmswfactivitydefdata with (tablockx)
GO
 
Select top 1 1 from cmswfattributedata with (tablockx)
GO
 
Select top 1 1 from cmswfprocessdata with (tablockx)
GO
 
Select top 1 1 from cmswfprocessdefdata with (tablockx)
GO
 
Select top 1 1 from cmswfworkitemdata with (tablockx)
GO
 
Select top 1 1 from cmswindowsmediadata with (tablockx)
GO
 
Select top 1 1 from cmswsstoragedata with (tablockx)
GO
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

DROP TABLE [dbo].[CMSACL10003DATA]
GO

DROP TABLE [dbo].[CMSACL10010DATA]
GO

DROP TABLE [dbo].[CMSACL10046DATA]
GO

DROP TABLE [dbo].[CMSACL10074DATA]
GO

DROP TABLE [dbo].[CMSACL10085DATA]
GO

DROP TABLE [dbo].[CMSACL10093DATA]
GO

DROP TABLE [dbo].[CMSACL10108DATA]
GO

DROP TABLE [dbo].[CMSACL10115DATA]
GO

DROP TABLE [dbo].[CMSACL10122DATA]
GO

DROP TABLE [dbo].[CMSACL10130DATA]
GO

DROP TABLE [dbo].[CMSACL10153DATA]
GO

DROP TABLE [dbo].[CMSACL10160DATA]
GO

DROP TABLE [dbo].[CMSACL10167DATA]
GO

DROP TABLE [dbo].[CMSACL10175DATA]
GO

DROP TABLE [dbo].[CMSACL10182DATA]
GO

DROP TABLE [dbo].[CMSACL10190DATA]
GO

DROP TABLE [dbo].[CMSACL10197DATA]
GO

DROP TABLE [dbo].[CMSACL10205DATA]
GO

DROP TABLE [dbo].[CMSACL10219DATA]
GO

DROP TABLE [dbo].[CMSACL10226DATA]
GO

DROP TABLE [dbo].[CMSACL10233DATA]
GO

DROP TABLE [dbo].[CMSADMINASSETRESOURCEDATA]
GO

DROP TABLE [dbo].[CMSADMINRESOURCEBACKBONEDATA]
GO

DROP TABLE [dbo].[CMSAIFFDATA]
GO

DROP TABLE [dbo].[CMSAIONRULEMANAGERDATA]
GO

DROP TABLE [dbo].[CMSAPPROVALCHAINDATA]
GO

DROP TABLE [dbo].[CMSASSETDATA]
GO

DROP TABLE [dbo].[CMSASSETFILEMAPDATA]
GO

DROP TABLE [dbo].[CMSAVIDATA]
GO

DROP TABLE [dbo].[CMSCOLLECTIONDATA]
GO

DROP TABLE [dbo].[cmscpcmconfig]
GO

DROP TABLE [dbo].[CMSDBLOG]
GO

DROP TABLE [dbo].[CMSERRORDATA]
GO

DROP TABLE [dbo].[cmsfastconfig]
GO

DROP TABLE [dbo].[CMSGROUPDATA]
GO

DROP TABLE [dbo].[CMSIMAGEDATA]
GO

DROP TABLE [dbo].[CMSMDIDCOLUMNSDATA]
GO

DROP TABLE [dbo].[CMSMDIDDATA]
GO

DROP TABLE [dbo].[CMSMP3DATA]
GO

DROP TABLE [dbo].[CMSMPEGDATA]
GO

DROP TABLE [dbo].[CMSMSOFFICEDATA]
GO

DROP TABLE [dbo].[CMSPDFDATA]
GO

DROP TABLE [dbo].[CMSPERSISTANTSTATEINFORMATIONDATA]
GO

DROP TABLE [dbo].[CMSPERSONALIZATIONDATA]
GO

DROP TABLE [dbo].[CMSPHOTOSHOPDATA]
GO

DROP TABLE [dbo].[CMSPORTALPAGEDATA]
GO

DROP TABLE [dbo].[CMSPOSTSCRIPTDATA]
GO

DROP TABLE [dbo].[CMSQUICKTIMEDATA]
GO

DROP TABLE [dbo].[CMSREALAUDIODATA]
GO

DROP TABLE [dbo].[CMSREALMEDIADATA]
GO

DROP TABLE [dbo].[CMSROLLBK10010DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10046DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10074DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10085DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10093DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10108DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10115DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10122DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10130DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10153DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10160DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10167DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10175DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10182DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10190DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10197DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10205DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10219DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10226DATA]
GO

DROP TABLE [dbo].[CMSROLLBK10233DATA]
GO

DROP TABLE [dbo].[CMSSHOCKWAVEDATA]
GO

DROP TABLE [dbo].[CMSSTDTRIGGERDATA]
GO

DROP TABLE [dbo].[CMSURLDATA]
GO

DROP TABLE [dbo].[CMSUSERDATA]
GO

DROP TABLE [dbo].[CMSVIEWFILESDATA]
GO

DROP TABLE [dbo].[CMSWAVDATA]
GO

DROP TABLE [dbo].[CMSWFACLDATA]
GO

DROP TABLE [dbo].[CMSWFACTIVITYDATA]
GO

DROP TABLE [dbo].[CMSWFACTIVITYDEFDATA]
GO

DROP TABLE [dbo].[CMSWFATTRIBUTEDATA]
GO

DROP TABLE [dbo].[CMSWFPROCESSDATA]
GO

DROP TABLE [dbo].[CMSWFPROCESSDEFDATA]
GO

DROP TABLE [dbo].[CMSWFWORKITEMDATA]
GO

DROP TABLE [dbo].[CMSWINDOWSMEDIADATA]
GO

DROP TABLE [dbo].[CMSWSSTORAGEDATA]
GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10003DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10003DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10010DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10010DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10046DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10046DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10074DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10074DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10085DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10085DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10093DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10093DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10108DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10108DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10115DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10115DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10122DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10122DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10130DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10130DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10153DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10153DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10160DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10160DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10167DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10167DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10175DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10175DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10182DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN

CREATE TABLE [dbo].[CMSACL10182DATA] (
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
END

GO

if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10190DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10190DATA] (
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
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10197DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10197DATA] (
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
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10205DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10205DATA] (
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
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10219DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10219DATA] (
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
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10226DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10226DATA] (
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
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSACL10233DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSACL10233DATA] (
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
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSADMINASSETRESOURCEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSADMINASSETRESOURCEDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASSETNAME] [varchar] (255) NULL ,
	[UECCITEMFIELDNAME] [varchar] (255) NULL ,
	[UECCITEMID] [int] NULL ,
	[UECCITEMTABLENAME] [varchar] (255) NULL ,
	[UECONTAINERPATH] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSADMINRESOURCEBACKBONEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSADMINRESOURCEBACKBONEDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEACTIVATION] [datetime] NULL ,
	[UECCITEMFIELDNAME] [varchar] (255) NULL ,
	[UECCITEMID] [int] NULL ,
	[UECCITEMTABLENAME] [varchar] (255) NULL ,
	[UEEXPIRATION] [datetime] NULL ,
	[UEEXPSTATUS] [int] NULL ,
	[UELASTEXPNOTIFICAT] [datetime] NULL ,
	[UEOWNER] [nvarchar] (255) NULL ,
	[UEPARENTPATH] [nvarchar] (255) NULL ,
	[UERESOURCENAME] [nvarchar] (255) NULL ,
	[UERESOURCENAMEUP] [nvarchar] (255) NULL ,
	[UERESOURCETITLE] [nvarchar] (255) NULL ,
	[UERESOURCETITLEUP] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSAIFFDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSAIFFDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAIFF_AUTHOR] [nvarchar] (255) NULL ,
	[UEAIFF_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEAIFF_KEYWORDS] [nvarchar] (255) NULL ,
	[UEAIFF_TITLE] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOMPRESSION_TYPE] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESAMPLE_FRAMES] [int] NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESAMPLE_SIZE] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSAIONRULEMANAGERDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSAIONRULEMANAGERDATA] (
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
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEENDDATE] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRIORITY] [nvarchar] (255) NULL ,
	[UESTARTDATE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UETYPE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSAPPROVALCHAINDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSAPPROVALCHAINDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEABOUT] [varchar] (1000) NULL ,
	[UEAPPCHAINNAME] [varchar] (255) NOT NULL ,
	[UESTATES] [varchar] (1000) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSASSETDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSASSETDATA] (
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
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSASSETFILEMAPDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSASSETFILEMAPDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASSETCLSID] [int] NULL ,
	[UEDEFAULT] [bit] NULL ,
	[UEFILEEXT] [varchar] (255) NULL ,
	[UEMAJORMIME] [varchar] (255) NULL ,
	[UEMINORMIME] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSAVIDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSAVIDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUDIO_CODEC] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEAVI_AUTHOR] [nvarchar] (255) NULL ,
	[UEAVI_CREATE_DATE] [datetime] NULL ,
	[UEAVI_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEAVI_KEYWORDS] [nvarchar] (255) NULL ,
	[UEAVI_SUBJECT] [nvarchar] (255) NULL ,
	[UEAVI_TITLE] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOLOR_DEPTH] [int] NULL ,
	[UECOMMISSIONED] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECROPPED] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEDIMENSIONS] [int] NULL ,
	[UEDOTS_PER_INCH] [nvarchar] (255) NULL ,
	[UEENGINEER] [nvarchar] (255) NULL ,
	[UEFRAME_NUMBER] [int] NULL ,
	[UEFRAME_RATE] [int] NULL ,
	[UEGENRE] [nvarchar] (255) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UELIGHTNESS] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMEDIUM] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UENAME_OF_SUBJECT] [nvarchar] (255) NULL ,
	[UEPALETTE] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRODUCT] [nvarchar] (255) NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESAMPLE_SIZE] [int] NULL ,
	[UESHARPNESS] [nvarchar] (255) NULL ,
	[UESOFTWARE] [nvarchar] (255) NULL ,
	[UESOURCE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETECHNICIAN] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVIDEO_CODEC] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSCOLLECTIONDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSCOLLECTIONDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[cmscpcmconfig]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[cmscpcmconfig] (
	[param_name] [varchar] (255) NOT NULL ,
	[param_value] [varchar] (255) NULL,
	[ueporinstanceid] [nvarchar] (255) NOT NULL
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSDBLOG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSDBLOG] (
	[UEAREA] [int] NULL ,
	[UEPRIORITY] [int] NULL ,
	[UEMESSAGE] [text] NULL ,
	[UESUBSYSTEM] [int] NULL ,
	[UETYPE] [int] NULL ,
	[UETIMESTAMP] [datetime] NULL ,
	[UEPARAMS] [text] NULL ,
	[UEUNIQUEID] [numeric](18, 0) NOT NULL,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSERRORDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSERRORDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UECODE] [int] NULL ,
	[UELEVEL] [int] NULL ,
	[UEMESSAGE] [varchar] (1000) NULL ,
	[UETEMPLATE] [varchar] (255) NULL ,
	[UETYPE] [int] NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[cmsfastconfig]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[cmsfastconfig] (
	[param_name] [varchar] (255) NOT NULL ,
	[param_value] [varchar] (255) NULL,
	[ueporinstanceid] [nvarchar] (255) NOT NULL
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSGROUPDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSGROUPDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEDESCRIPTION] [varchar] (1000) NULL ,
	[UEGROUPNAME] [nvarchar] (255) NOT NULL ,
	[UEGROUPS] [varchar] (1000) NULL ,
	[UEUSERS] [varchar] (1000) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSIMAGEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSIMAGEDATA] (
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
	[UECOLOR_DEPTH] [int] NULL ,
	[UECOMPRESSION_TYPE] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSMDIDCOLUMNSDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSMDIDCOLUMNSDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEFIELD0] [ntext] NULL ,
	[UEFIELD1] [ntext] NULL ,
	[UEFIELD10] [ntext] NULL ,
	[UEFIELD11] [ntext] NULL ,
	[UEFIELD12] [ntext] NULL ,
	[UEFIELD13] [ntext] NULL ,
	[UEFIELD14] [ntext] NULL ,
	[UEFIELD15] [ntext] NULL ,
	[UEFIELD16] [ntext] NULL ,
	[UEFIELD17] [ntext] NULL ,
	[UEFIELD18] [ntext] NULL ,
	[UEFIELD19] [ntext] NULL ,
	[UEFIELD2] [ntext] NULL ,
	[UEFIELD20] [ntext] NULL ,
	[UEFIELD21] [ntext] NULL ,
	[UEFIELD22] [ntext] NULL ,
	[UEFIELD23] [ntext] NULL ,
	[UEFIELD24] [ntext] NULL ,
	[UEFIELD25] [ntext] NULL ,
	[UEFIELD26] [ntext] NULL ,
	[UEFIELD27] [ntext] NULL ,
	[UEFIELD28] [ntext] NULL ,
	[UEFIELD29] [ntext] NULL ,
	[UEFIELD3] [ntext] NULL ,
	[UEFIELD30] [ntext] NULL ,
	[UEFIELD31] [ntext] NULL ,
	[UEFIELD32] [ntext] NULL ,
	[UEFIELD33] [ntext] NULL ,
	[UEFIELD34] [ntext] NULL ,
	[UEFIELD35] [ntext] NULL ,
	[UEFIELD36] [ntext] NULL ,
	[UEFIELD37] [ntext] NULL ,
	[UEFIELD38] [ntext] NULL ,
	[UEFIELD39] [ntext] NULL ,
	[UEFIELD4] [ntext] NULL ,
	[UEFIELD40] [ntext] NULL ,
	[UEFIELD41] [ntext] NULL ,
	[UEFIELD42] [ntext] NULL ,
	[UEFIELD43] [ntext] NULL ,
	[UEFIELD44] [ntext] NULL ,
	[UEFIELD45] [ntext] NULL ,
	[UEFIELD46] [ntext] NULL ,
	[UEFIELD47] [ntext] NULL ,
	[UEFIELD48] [ntext] NULL ,
	[UEFIELD49] [ntext] NULL ,
	[UEFIELD5] [ntext] NULL ,
	[UEFIELD50] [ntext] NULL ,
	[UEFIELD51] [ntext] NULL ,
	[UEFIELD52] [ntext] NULL ,
	[UEFIELD53] [ntext] NULL ,
	[UEFIELD54] [ntext] NULL ,
	[UEFIELD55] [ntext] NULL ,
	[UEFIELD56] [ntext] NULL ,
	[UEFIELD57] [ntext] NULL ,
	[UEFIELD58] [ntext] NULL ,
	[UEFIELD59] [ntext] NULL ,
	[UEFIELD6] [ntext] NULL ,
	[UEFIELD60] [ntext] NULL ,
	[UEFIELD61] [ntext] NULL ,
	[UEFIELD62] [ntext] NULL ,
	[UEFIELD63] [ntext] NULL ,
	[UEFIELD64] [ntext] NULL ,
	[UEFIELD65] [ntext] NULL ,
	[UEFIELD66] [ntext] NULL ,
	[UEFIELD67] [ntext] NULL ,
	[UEFIELD68] [ntext] NULL ,
	[UEFIELD69] [ntext] NULL ,
	[UEFIELD7] [ntext] NULL ,
	[UEFIELD8] [ntext] NULL ,
	[UEFIELD9] [ntext] NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSMDIDDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSMDIDDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UECACHE] [bit] NULL ,
	[UEDESCRIPTION] [varchar] (1000) NULL ,
	[UEKEYNAME1] [varchar] (255) NULL ,
	[UEKEYNAME2] [varchar] (255) NULL ,
	[UEKEYNAME3] [varchar] (255) NULL ,
	[UENAME] [varchar] (255) NOT NULL ,
	[UENAMEPLURAL] [varchar] (255) NULL ,
	[UEPARAMS] [nvarchar] (4000) NULL ,
	[UEPUBLICATIONSTAGE] [int] NULL ,
	[UEREADPERMISSION] [varchar] (1000) NULL ,
	[UETABLENAME] [varchar] (255) NOT NULL ,
	[UEWRITEPERMISSION] [varchar] (1000) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSMP3DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSMP3DATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEEMPHASIS] [nvarchar] (255) NULL ,
	[UEFRAMES] [int] NULL ,
	[UEGENRE] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELAYER] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMP3_AUTHOR] [nvarchar] (255) NULL ,
	[UEMP3_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEMP3_SUBJECT] [nvarchar] (255) NULL ,
	[UEMP3_TITLE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEORIGINAL] [bit] NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRIVATE] [bit] NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION_ID] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL ,
	[UEYEAR] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSMPEGDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSMPEGDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASPECT_RATIO] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHROMA_FORMAT] [nvarchar] (255) NULL ,
	[UECOLOR_PRIMARIES] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDCT_PREDICTION] [int] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFRAME_RATE] [nvarchar] (255) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEINTRA_DC_PREC] [nvarchar] (255) NULL ,
	[UEINTRA_VLC_FMT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMATRIX_COEFFS] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMPEG_VERSION] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPROG_FRAME] [nvarchar] (255) NULL ,
	[UEPROG_SEQUENCE] [int] NULL ,
	[UESTREAM_TYPE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UETRANSFER_CHARS] [nvarchar] (255) NULL ,
	[UEVBF_BUFFER_SIZE] [int] NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVIDEO_FORMAT] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSMSOFFICEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSMSOFFICEDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAPP_NAME] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECATEGORY] [nvarchar] (255) NULL ,
	[UECHAR_COUNT] [int] NULL ,
	[UECOMPANY] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEEDIT_TIME] [nvarchar] (255) NULL ,
	[UEHIDDEN_COUNT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_EDITOR] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELAST_PRINT_TIME] [datetime] NULL ,
	[UELAST_SAVED_TIME] [datetime] NULL ,
	[UELINE_COUNT] [int] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMANAGER] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMMCLIPS] [int] NULL ,
	[UEMS_AUTHOR] [nvarchar] (255) NULL ,
	[UEMS_COMMENTS] [nvarchar] (1000) NULL ,
	[UEMS_CREATION_DATE] [datetime] NULL ,
	[UEMS_KEYWORDS] [nvarchar] (255) NULL ,
	[UEMS_SUBJECT] [nvarchar] (255) NULL ,
	[UEMS_TITLE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UENOTE_COUNT] [int] NULL ,
	[UEPAGE_COUNT] [int] NULL ,
	[UEPARA_COUNT] [int] NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRES_FORMAT] [nvarchar] (255) NULL ,
	[UEREV_NUMBER] [nvarchar] (255) NULL ,
	[UESECURITY] [nvarchar] (255) NULL ,
	[UESLIDE_COUNT] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETEMPLATE_NAME] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORD_COUNT] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSPDFDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSPDFDATA] (
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
	[UECREATOR] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPDF_AUTHOR] [nvarchar] (255) NULL ,
	[UEPDF_CREATION_DAT] [datetime] NULL ,
	[UEPDF_KEYWORDS] [nvarchar] (255) NULL ,
	[UEPDF_MODIFICATION] [datetime] NULL ,
	[UEPDF_SUBJECT] [nvarchar] (255) NULL ,
	[UEPDF_TITLE] [nvarchar] (255) NULL ,
	[UEPRODUCER] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSPERSISTANTSTATEINFORMATIONDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSPERSISTANTSTATEINFORMATIONDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEBUILDID] [varchar] (255) NULL ,
	[UEBUILDTIME] [datetime] NULL ,
	[UEDBVERSION] [int] NULL ,
	[UEGENSYM] [int] NULL ,
	[UENUMFIELDS] [int] NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSPERSONALIZATIONDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSPERSONALIZATIONDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEATTRIBUTENAME] [varchar] (255) NOT NULL ,
	[UEBOOLEANVALUE] [bit] NULL ,
	[UEDATACOLUMNNAME] [varchar] (255) NULL ,
	[UEDBIDLVALUE] [varchar] (1000) NULL ,
	[UEDBIDVALUE] [int] NULL ,
	[UEINTVALUE] [int] NULL ,
	[UETEXTSTORYVALUE] [varchar] (8000) NULL ,
	[UETEXTVALUE] [varchar] (255) NULL ,
	[UEUSERDBID] [int] NOT NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSPHOTOSHOPDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSPHOTOSHOPDATA] (
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
	[UECOLOR_DEPTH] [int] NULL ,
	[UECOMPRESSION_TYPE] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSPORTALPAGEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSPORTALPAGEDATA] (
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
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSPOSTSCRIPTDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSPOSTSCRIPTDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBOUNDING_BOX] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECREATOR] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEDOCUMENT_DATA] [nvarchar] (255) NULL ,
	[UEHEADER] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELANGUAGE_LEVEL] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPAGES] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPS_CREATION_DATE] [nvarchar] (255) NULL ,
	[UEPS_TITLE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSQUICKTIMEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSQUICKTIMEDATA] (
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
	[UECHAPTER] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEDIRECTOR] [nvarchar] (255) NULL ,
	[UEDISCLAIMER] [nvarchar] (255) NULL ,
	[UEEDIT_DATE] [datetime] NULL ,
	[UEFRAME_NUMBER] [int] NULL ,
	[UEFRAME_RATE] [int] NULL ,
	[UEFULL_NAME] [nvarchar] (1000) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEHOST_COMPUTER] [nvarchar] (255) NULL ,
	[UEINFORMATION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMAKE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMODEL] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEORIGINAL_FORMAT] [nvarchar] (255) NULL ,
	[UEORIGINAL_SOURCE] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPERFORMERS] [nvarchar] (255) NULL ,
	[UEPLAYBACK_REQ] [nvarchar] (1000) NULL ,
	[UEPRODUCER] [nvarchar] (255) NULL ,
	[UEPRODUCT] [nvarchar] (255) NULL ,
	[UEQT_AUTHOR] [nvarchar] (255) NULL ,
	[UEQT_CREATION_DATE] [datetime] NULL ,
	[UEQT_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEQT_KEYWORDS] [nvarchar] (255) NULL ,
	[UEQT_TITLE] [nvarchar] (255) NULL ,
	[UESOFTWARE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVOLUME] [int] NULL ,
	[UEWARNING] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL ,
	[UEWRITER] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSREALAUDIODATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSREALAUDIODATA] (
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
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UERA_AUTHOR] [nvarchar] (255) NULL ,
	[UERA_TITLE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSREALMEDIADATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSREALMEDIADATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEALLOW_RECORDING] [bit] NULL ,
	[UEAUDIO_FORMAT] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEAVG_BITRATE] [int] NULL ,
	[UEAVG_PACKET_SIZE] [int] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATA_OFFSET] [int] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFLAGS] [int] NULL ,
	[UEGENERATED_BY] [nvarchar] (255) NULL ,
	[UEHAS_AUDIO] [bit] NULL ,
	[UEHAS_EVENT] [bit] NULL ,
	[UEHAS_IMAGE_MAP] [bit] NULL ,
	[UEHAS_VIDEO] [bit] NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEINDEX_OFFSET] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMAX_BITRATE] [int] NULL ,
	[UEMAX_PACKET_SIZE] [int] NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMOBILE_PLAYBACK] [bit] NULL ,
	[UEMOD_DATE] [datetime] NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UENUM_OF_STREAMS] [int] NULL ,
	[UENUM_PACKETS] [int] NULL ,
	[UEOBJECT_VERSION] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPERFECT_PLAY] [bit] NULL ,
	[UEPREROLL] [int] NULL ,
	[UERM_AUTHOR] [nvarchar] (255) NULL ,
	[UERM_CREATION_DATE] [datetime] NULL ,
	[UERM_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UERM_SUBJECT] [nvarchar] (255) NULL ,
	[UERM_TITLE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETARGET_AUDIENCES] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVIDEO_QUALITY] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10010DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10010DATA] (
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
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10046DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10046DATA] (
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
	[UEURLFIELD] [nvarchar] (1000) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10074DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10074DATA] (
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
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEENDDATE] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRIORITY] [nvarchar] (255) NULL ,
	[UESTARTDATE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UETYPE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10085DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10085DATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAIFF_AUTHOR] [nvarchar] (255) NULL ,
	[UEAIFF_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEAIFF_KEYWORDS] [nvarchar] (255) NULL ,
	[UEAIFF_TITLE] [nvarchar] (255) NULL ,
	[UEASSETID] [int] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOMPRESSION_TYPE] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESAMPLE_FRAMES] [int] NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESAMPLE_SIZE] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10093DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10093DATA] (
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
	[UECOLOR_DEPTH] [int] NULL ,
	[UECOMPRESSION_TYPE] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10108DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10108DATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASSETID] [int] NULL ,
	[UEAUDIO_CODEC] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEAVI_AUTHOR] [nvarchar] (255) NULL ,
	[UEAVI_CREATE_DATE] [datetime] NULL ,
	[UEAVI_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEAVI_KEYWORDS] [nvarchar] (255) NULL ,
	[UEAVI_SUBJECT] [nvarchar] (255) NULL ,
	[UEAVI_TITLE] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOLOR_DEPTH] [int] NULL ,
	[UECOMMISSIONED] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECROPPED] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEDIMENSIONS] [int] NULL ,
	[UEDOTS_PER_INCH] [nvarchar] (255) NULL ,
	[UEENGINEER] [nvarchar] (255) NULL ,
	[UEFRAME_NUMBER] [int] NULL ,
	[UEFRAME_RATE] [int] NULL ,
	[UEGENRE] [nvarchar] (255) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UELIGHTNESS] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMEDIUM] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UENAME_OF_SUBJECT] [nvarchar] (255) NULL ,
	[UEPALETTE] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRODUCT] [nvarchar] (255) NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESAMPLE_SIZE] [int] NULL ,
	[UESHARPNESS] [nvarchar] (255) NULL ,
	[UESOFTWARE] [nvarchar] (255) NULL ,
	[UESOURCE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETECHNICIAN] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEVIDEO_CODEC] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10115DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10115DATA] (
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
	[UEBITRATE] [float] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEEMPHASIS] [nvarchar] (255) NULL ,
	[UEFRAMES] [int] NULL ,
	[UEGENRE] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELAYER] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMP3_AUTHOR] [nvarchar] (255) NULL ,
	[UEMP3_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEMP3_SUBJECT] [nvarchar] (255) NULL ,
	[UEMP3_TITLE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEORIGINAL] [bit] NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRIVATE] [bit] NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEVERSION_ID] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL ,
	[UEYEAR] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10122DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10122DATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASPECT_RATIO] [nvarchar] (255) NULL ,
	[UEASSETID] [int] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHROMA_FORMAT] [nvarchar] (255) NULL ,
	[UECOLOR_PRIMARIES] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDCT_PREDICTION] [int] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFRAME_RATE] [nvarchar] (255) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEINTRA_DC_PREC] [nvarchar] (255) NULL ,
	[UEINTRA_VLC_FMT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMATRIX_COEFFS] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMPEG_VERSION] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPROG_FRAME] [nvarchar] (255) NULL ,
	[UEPROG_SEQUENCE] [int] NULL ,
	[UESTREAM_TYPE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UETRANSFER_CHARS] [nvarchar] (255) NULL ,
	[UEVBF_BUFFER_SIZE] [int] NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEVIDEO_FORMAT] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10130DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10130DATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAPP_NAME] [nvarchar] (255) NULL ,
	[UEASSETID] [int] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECATEGORY] [nvarchar] (255) NULL ,
	[UECHAR_COUNT] [int] NULL ,
	[UECOMPANY] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEEDIT_TIME] [nvarchar] (255) NULL ,
	[UEHIDDEN_COUNT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_EDITOR] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELAST_PRINT_TIME] [datetime] NULL ,
	[UELAST_SAVED_TIME] [datetime] NULL ,
	[UELINE_COUNT] [int] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMANAGER] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMMCLIPS] [int] NULL ,
	[UEMS_AUTHOR] [nvarchar] (255) NULL ,
	[UEMS_COMMENTS] [nvarchar] (1000) NULL ,
	[UEMS_CREATION_DATE] [datetime] NULL ,
	[UEMS_KEYWORDS] [nvarchar] (255) NULL ,
	[UEMS_SUBJECT] [nvarchar] (255) NULL ,
	[UEMS_TITLE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UENOTE_COUNT] [int] NULL ,
	[UEPAGE_COUNT] [int] NULL ,
	[UEPARA_COUNT] [int] NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPRES_FORMAT] [nvarchar] (255) NULL ,
	[UEREV_NUMBER] [nvarchar] (255) NULL ,
	[UESECURITY] [nvarchar] (255) NULL ,
	[UESLIDE_COUNT] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETEMPLATE_NAME] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORD_COUNT] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10153DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10153DATA] (
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
	[UECREATOR] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPDF_AUTHOR] [nvarchar] (255) NULL ,
	[UEPDF_CREATION_DAT] [datetime] NULL ,
	[UEPDF_KEYWORDS] [nvarchar] (255) NULL ,
	[UEPDF_MODIFICATION] [datetime] NULL ,
	[UEPDF_SUBJECT] [nvarchar] (255) NULL ,
	[UEPDF_TITLE] [nvarchar] (255) NULL ,
	[UEPRODUCER] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10160DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10160DATA] (
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
	[UECOLOR_DEPTH] [int] NULL ,
	[UECOMPRESSION_TYPE] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10167DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10167DATA] (
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
	[UEBOUNDING_BOX] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECREATOR] [nvarchar] (255) NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEDOCUMENT_DATA] [nvarchar] (255) NULL ,
	[UEHEADER] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELANGUAGE_LEVEL] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPAGES] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPS_CREATION_DATE] [nvarchar] (255) NULL ,
	[UEPS_TITLE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10175DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10175DATA] (
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
	[UECHAPTER] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEDIRECTOR] [nvarchar] (255) NULL ,
	[UEDISCLAIMER] [nvarchar] (255) NULL ,
	[UEEDIT_DATE] [datetime] NULL ,
	[UEFRAME_NUMBER] [int] NULL ,
	[UEFRAME_RATE] [int] NULL ,
	[UEFULL_NAME] [nvarchar] (1000) NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEHOST_COMPUTER] [nvarchar] (255) NULL ,
	[UEINFORMATION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMAKE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMODEL] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEORIGINAL_FORMAT] [nvarchar] (255) NULL ,
	[UEORIGINAL_SOURCE] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPERFORMERS] [nvarchar] (255) NULL ,
	[UEPLAYBACK_REQ] [nvarchar] (1000) NULL ,
	[UEPRODUCER] [nvarchar] (255) NULL ,
	[UEPRODUCT] [nvarchar] (255) NULL ,
	[UEQT_AUTHOR] [nvarchar] (255) NULL ,
	[UEQT_CREATION_DATE] [datetime] NULL ,
	[UEQT_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEQT_KEYWORDS] [nvarchar] (255) NULL ,
	[UEQT_TITLE] [nvarchar] (255) NULL ,
	[UESOFTWARE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEVOLUME] [int] NULL ,
	[UEWARNING] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL ,
	[UEWRITER] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10182DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10182DATA] (
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
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UERA_AUTHOR] [nvarchar] (255) NULL ,
	[UERA_TITLE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10190DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10190DATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEALLOW_RECORDING] [bit] NULL ,
	[UEASSETID] [int] NULL ,
	[UEAUDIO_FORMAT] [nvarchar] (255) NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEAVG_BITRATE] [int] NULL ,
	[UEAVG_PACKET_SIZE] [int] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATA_OFFSET] [int] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFLAGS] [int] NULL ,
	[UEGENERATED_BY] [nvarchar] (255) NULL ,
	[UEHAS_AUDIO] [bit] NULL ,
	[UEHAS_EVENT] [bit] NULL ,
	[UEHAS_IMAGE_MAP] [bit] NULL ,
	[UEHAS_VIDEO] [bit] NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEINDEX_OFFSET] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMAX_BITRATE] [int] NULL ,
	[UEMAX_PACKET_SIZE] [int] NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UEMOBILE_PLAYBACK] [bit] NULL ,
	[UEMOD_DATE] [datetime] NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UENUM_OF_STREAMS] [int] NULL ,
	[UENUM_PACKETS] [int] NULL ,
	[UEOBJECT_VERSION] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEPERFECT_PLAY] [bit] NULL ,
	[UEPREROLL] [int] NULL ,
	[UERM_AUTHOR] [nvarchar] (255) NULL ,
	[UERM_CREATION_DATE] [datetime] NULL ,
	[UERM_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UERM_SUBJECT] [nvarchar] (255) NULL ,
	[UERM_TITLE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETARGET_AUDIENCES] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEVIDEO_QUALITY] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10197DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10197DATA] (
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
	[UEBITRATE] [float] NULL ,
	[UEBLOCK_ALIGN] [int] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFORMAT] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESAMPLE_SIZE] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWAV_AUTHOR] [nvarchar] (255) NULL ,
	[UEWAV_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEWAV_KEYWORDS] [nvarchar] (255) NULL ,
	[UEWAV_SUBJECT] [nvarchar] (255) NULL ,
	[UEWAV_TITLE] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10205DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10205DATA] (
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
	[UEBITRATE] [float] NULL ,
	[UEBROADCAST] [bit] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECURRENT_BITRATE] [float] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEHAS_AUDIO] [bit] NULL ,
	[UEHAS_EVENT] [bit] NULL ,
	[UEHAS_IMAGE] [bit] NULL ,
	[UEHAS_VIDEO] [bit] NULL ,
	[UEIS_PROTECTED] [bit] NULL ,
	[UEIS_TRUSTED] [bit] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEOPTIMAL_BITRATE] [float] NULL ,
	[UEPARENTID] [int] NULL ,
	[UERATING] [nvarchar] (255) NULL ,
	[UESEEKABLE] [bit] NULL ,
	[UESIGNATURE_NAME] [nvarchar] (255) NULL ,
	[UESTRIDABLE] [bit] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWM_AUTHOR] [nvarchar] (255) NULL ,
	[UEWM_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEWM_TITLE] [nvarchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10219DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10219DATA] (
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
	[UEBASE] [nvarchar] (255) NULL ,
	[UEBGCOLOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFRAME_NUMBER] [int] NULL ,
	[UEFRAME_RATE] [int] NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELOOP] [bit] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMENU] [bit] NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEQUALITY] [nvarchar] (255) NULL ,
	[UESALIGN] [nvarchar] (255) NULL ,
	[UESCALE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UESWF_VERSION] [int] NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10226DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10226DATA] (
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
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSROLLBK10233DATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSROLLBK10233DATA] (
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
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEVERSION] [int] NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSSHOCKWAVEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSSHOCKWAVEDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBASE] [nvarchar] (255) NULL ,
	[UEBGCOLOR] [nvarchar] (255) NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFRAME_NUMBER] [int] NULL ,
	[UEFRAME_RATE] [int] NULL ,
	[UEHEIGHT] [int] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELOOP] [bit] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMENU] [bit] NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UEQUALITY] [nvarchar] (255) NULL ,
	[UESALIGN] [nvarchar] (255) NULL ,
	[UESCALE] [nvarchar] (255) NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UESWF_VERSION] [int] NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWIDTH] [int] NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSSTDTRIGGERDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSSTDTRIGGERDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEDESC] [nvarchar] (1000) NULL ,
	[UEFOLDERPATH] [varchar] (255) NULL ,
	[UEMAJORTYPE] [varchar] (255) NULL ,
	[UEMINORTYPE] [varchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEOP] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSURLDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSURLDATA] (
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
	[UEURLFIELD] [nvarchar] (4000) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSUSERDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSUSERDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEBROWSESCREENSIZE] [int] NULL ,
	[UECANASSIGNTODO] [bit] NULL ,
	[UEEMAIL] [varchar] (255) NULL ,
	[UEFAX] [varchar] (255) NULL ,
	[UEFIRSTNAME] [varchar] (255) NULL ,
	[UEFONTSIZE] [int] NULL ,
	[UEINCONTEXTEDIT] [bit] NULL ,
	[UELASTNAME] [varchar] (255) NULL ,
	[UELDAPUSER] [bit] NULL ,
	[UELONGCHOOSETHRESH] [int] NULL ,
	[UEPASSWORD] [varchar] (8) NULL ,
	[UEPHONE] [varchar] (255) NULL ,
	[UEUSEAPPLETS] [bit] NULL ,
	[UEUSERNAME] [nvarchar] (255) NOT NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSVIEWFILESDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSVIEWFILESDATA] (
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
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWAVDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWAVDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBLOCK_ALIGN] [int] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECHANNEL_MODE] [nvarchar] (255) NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEFORMAT] [nvarchar] (255) NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEPARENTID] [int] NULL ,
	[UESAMPLE_RATE] [float] NULL ,
	[UESAMPLE_SIZE] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWAV_AUTHOR] [nvarchar] (255) NULL ,
	[UEWAV_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEWAV_KEYWORDS] [nvarchar] (255) NULL ,
	[UEWAV_SUBJECT] [nvarchar] (255) NULL ,
	[UEWAV_TITLE] [nvarchar] (255) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFACLDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFACLDATA] (
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
	[UEPROCESSDEFID] [varchar] (255) NULL ,
	[UEUSER] [int] NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFACTIVITYDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFACTIVITYDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEACTDEF] [int] NULL ,
	[UEACTION] [varchar] (255) NULL ,
	[UEATTR] [varchar] (8000) NULL ,
	[UEDESC] [nvarchar] (1000) NULL ,
	[UEGROUPS] [varchar] (8000) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEORDER] [int] NULL ,
	[UESTATE] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UEUSERS] [varchar] (8000) NULL ,
	[UEWORKITEM] [int] NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFACTIVITYDEFDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFACTIVITYDEFDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEACTION] [varchar] (255) NULL ,
	[UEATTR] [varchar] (8000) NULL ,
	[UEDESC] [nvarchar] (1000) NULL ,
	[UEGROUPS] [varchar] (8000) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEORDER] [int] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UEUSERS] [varchar] (8000) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFATTRIBUTEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFATTRIBUTEDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UETYPE] [varchar] (255) NULL ,
	[UEVALUE] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFPROCESSDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFPROCESSDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEACTV] [varchar] (8000) NULL ,
	[UEATTR] [varchar] (8000) NULL ,
	[UEDESC] [nvarchar] (1000) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEOWNER] [int] NULL ,
	[UEPROCDEF] [varchar] (255) NULL ,
	[UESTATE] [bit] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFPROCESSDEFDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFPROCESSDEFDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEACTV] [varchar] (8000) NULL ,
	[UEATTR] [varchar] (8000) NULL ,
	[UEDESC] [nvarchar] (1000) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UESTATE] [bit] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWFWORKITEMDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWFWORKITEMDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASSIGNED] [bit] NULL ,
	[UEMSG] [nvarchar] (255) NULL ,
	[UESDATE] [datetime] NULL ,
	[UEUSERID] [int] NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWINDOWSMEDIADATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWINDOWSMEDIADATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEAUTHOR] [nvarchar] (255) NULL ,
	[UEBITRATE] [float] NULL ,
	[UEBROADCAST] [bit] NULL ,
	[UEBYTE_COUNT] [int] NULL ,
	[UECOPYRIGHTED] [nvarchar] (255) NULL ,
	[UECREATED_BY] [nvarchar] (255) NULL ,
	[UECREATION_DATE] [datetime] NULL ,
	[UECURRENT_BITRATE] [float] NULL ,
	[UEDATE_EXPIRES] [datetime] NULL ,
	[UEDESCRIPTION] [nvarchar] (1000) NULL ,
	[UEHAS_AUDIO] [bit] NULL ,
	[UEHAS_EVENT] [bit] NULL ,
	[UEHAS_IMAGE] [bit] NULL ,
	[UEHAS_VIDEO] [bit] NULL ,
	[UEIS_PROTECTED] [bit] NULL ,
	[UEIS_TRUSTED] [bit] NULL ,
	[UEKEYWORDS] [nvarchar] (255) NULL ,
	[UELAST_MODIFIED_BY] [nvarchar] (255) NULL ,
	[UELENGTH] [float] NULL ,
	[UEMAJOR_TYPE] [nvarchar] (255) NULL ,
	[UEMINOR_TYPE] [nvarchar] (255) NULL ,
	[UENAME] [nvarchar] (255) NULL ,
	[UEOPTIMAL_BITRATE] [float] NULL ,
	[UEPARENTID] [int] NULL ,
	[UERATING] [nvarchar] (255) NULL ,
	[UESEEKABLE] [bit] NULL ,
	[UESIGNATURE_NAME] [nvarchar] (255) NULL ,
	[UESTRIDABLE] [bit] NULL ,
	[UESUBJECT] [nvarchar] (255) NULL ,
	[UETITLE] [nvarchar] (255) NULL ,
	[UEVERCOMMENT] [nvarchar] (1000) NULL ,
	[UEWFPROC_ID] [varchar] (255) NULL ,
	[UEWM_AUTHOR] [nvarchar] (255) NULL ,
	[UEWM_DESCRIPTION] [nvarchar] (1000) NULL ,
	[UEWM_TITLE] [nvarchar] (255) NULL ,
	[UEWORKFLOW_ID] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO


if not exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CMSWSSTORAGEDATA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
 BEGIN
CREATE TABLE [dbo].[CMSWSSTORAGEDATA] (
	[UECHECKEDOUT] [int] NULL ,
	[UECHECKEDOUTTIME] [datetime] NULL ,
	[UEDBID] [int] NOT NULL ,
	[UEMODTIME] [datetime] NULL ,
	[UENUMEMPTYREQUIRED] [int] NULL ,
	[UEPORINSTANCEID] [nvarchar] (255) NOT NULL ,
	[UEPUBSTAGE] [int] NULL ,
	[UEPUBTIME] [datetime] NULL ,
	[UEASSET_DATE] [nvarchar] (255) NULL ,
	[UEASSET_NAME] [nvarchar] (255) NULL ,
	[UEASSET_PATH] [nvarchar] (255) NULL ,
	[UEASSET_TITLE] [nvarchar] (255) NULL ,
	[UEITEM] [varchar] (255) NULL ,
	[UEPROC] [varchar] (255) NULL 
) ON [PRIMARY]
END

GO
 

ALTER TABLE [dbo].[CMSACL10003DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7ea] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10010DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7ed] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10046DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f1] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10074DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7fe] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10085DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c803] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO



ALTER TABLE [dbo].[CMSACL10093DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c808] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10108DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c80d] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10115DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c812] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10122DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c817] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10130DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c81c] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10153DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c821] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10160DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c826] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10167DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c82b] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10175DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c830] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10182DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c835] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10190DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c83a] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10197DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c83f] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10205DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c844] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10219DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c849] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10226DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c84e] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSACL10233DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c853] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSADMINASSETRESOURCEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7e4] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSADMINRESOURCEBACKBONEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7e5] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSAIFFDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c805] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSAIONRULEMANAGERDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c800] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSAPPROVALCHAINDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7db] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSASSETDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7ec] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSASSETFILEMAPDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7e9] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSAVIDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c80f] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSCOLLECTIONDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7e8] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[cmscpcmconfig] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[param_name],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSDBLOG] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[UEUNIQUEID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSERRORDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7e1] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[cmsfastconfig] WITH NOCHECK ADD 
	 PRIMARY KEY  CLUSTERED 
	(
		[param_name],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSGROUPDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7df] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSIMAGEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c80a] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSMDIDCOLUMNSDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7d7] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSMDIDDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7d8] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSMP3DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c814] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSMPEGDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c819] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSMSOFFICEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c81e] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSPDFDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c823] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSPERSISTANTSTATEINFORMATIONDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7d6] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSPERSONALIZATIONDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7e2] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSPHOTOSHOPDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c828] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSPORTALPAGEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c855] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSPOSTSCRIPTDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c82d] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSQUICKTIMEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c832] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSREALAUDIODATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c837] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSREALMEDIADATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c83c] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10010DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7ee] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10046DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f2] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10074DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7ff] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10085DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c804] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10093DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c809] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10108DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c80e] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10115DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c813] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10122DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c818] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10130DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c81d] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10153DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c822] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10160DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c827] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10167DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c82c] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10175DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c831] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10182DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c836] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10190DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c83b] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10197DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c840] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10205DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c845] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10219DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c84a] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10226DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c84f] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSROLLBK10233DATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c854] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSSHOCKWAVEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c84b] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSSTDTRIGGERDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7fb] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSURLDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f0] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSUSERDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7dd] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSVIEWFILESDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c850] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWAVDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c841] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFACLDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f9] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFACTIVITYDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f6] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFACTIVITYDEFDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f4] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFATTRIBUTEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f3] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFPROCESSDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f7] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFPROCESSDEFDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f5] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWFWORKITEMDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7f8] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWINDOWSMEDIADATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c846] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSWSSTORAGEDATA] WITH NOCHECK ADD 
	CONSTRAINT [UE107d798c7fa] PRIMARY KEY  CLUSTERED 
	(
		[UEDBID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CMSADMINRESOURCEBACKBONEDATA] ADD 
	CONSTRAINT [UE107d798c7e6] UNIQUE  NONCLUSTERED 
	(
		[UECCITEMID],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CMSGROUPDATA] ADD 
	CONSTRAINT [UE107d798c7e0] UNIQUE  NONCLUSTERED 
	(
		[UEGROUPNAME],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CMSMDIDDATA] ADD 
	CONSTRAINT [UE107d798c7d9] UNIQUE  NONCLUSTERED 
	(
		[UENAME],[UEPORINSTANCEID]
	)  ON [PRIMARY] ,
	CONSTRAINT [UE107d798c7da] UNIQUE  NONCLUSTERED 
	(
		[UETABLENAME],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


ALTER TABLE [dbo].[CMSUSERDATA] ADD 
	CONSTRAINT [UE107d798c7de] UNIQUE  NONCLUSTERED 
	(
		[UEUSERNAME],[UEPORINSTANCEID]
	)  ON [PRIMARY] 
GO


CREATE  INDEX [idx_cmsbbparentpath] ON [dbo].[CMSADMINRESOURCEBACKBONEDATA]([UEPARENTPATH]) ON [PRIMARY]
GO
CREATE  INDEX [IDX_CMSBBNAMEUP] ON [dbo].[CMSADMINRESOURCEBACKBONEDATA]([UERESOURCENAMEUP]) ON [PRIMARY]
GO
CREATE  INDEX [IDX_CMSBBTITLEUP] ON [dbo].[CMSADMINRESOURCEBACKBONEDATA]([UERESOURCETITLEUP]) ON [PRIMARY]
GO
CREATE  INDEX [IDX_CMSGROUPNAME] ON [dbo].[CMSGROUPDATA]([UEGROUPNAME]) ON [PRIMARY]
GO
CREATE  INDEX [IDX_CMSMDIDNAME] ON [dbo].[CMSMDIDDATA]([UENAME]) ON [PRIMARY]
GO
CREATE  INDEX [IDX_CMSMDIDTABLENAME] ON [dbo].[CMSMDIDDATA]([UETABLENAME]) ON [PRIMARY]
GO
CREATE  INDEX [IDX_CMSUSERNAME] ON [dbo].[CMSUSERDATA]([UEUSERNAME]) ON [PRIMARY]
GO



GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10003DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSADMINASSETRESOURCEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSADMINRESOURCEBACKBONEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSAIFFDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSAIONRULEMANAGERDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSAPPROVALCHAINDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSASSETDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSASSETFILEMAPDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSAVIDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSCOLLECTIONDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[cmscpcmconfig]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSDBLOG]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSERRORDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[cmsfastconfig]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSGROUPDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSIMAGEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSMDIDCOLUMNSDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSMDIDDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSMP3DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSMPEGDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSMSOFFICEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPDFDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPERSONALIZATIONDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPHOTOSHOPDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPOSTSCRIPTDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSQUICKTIMEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSREALAUDIODATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSREALMEDIADATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSSHOCKWAVEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSSTDTRIGGERDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSURLDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSUSERDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWAVDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFACLDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFACTIVITYDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFACTIVITYDEFDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFATTRIBUTEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFPROCESSDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFPROCESSDEFDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWFWORKITEMDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWINDOWSMEDIADATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSWSSTORAGEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10010DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10046DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10074DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10085DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10093DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10108DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10115DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10122DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10130DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10153DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10160DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10167DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10175DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10182DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10190DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10197DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10205DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10219DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10226DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSACL10233DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPERSISTANTSTATEINFORMATIONDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSPORTALPAGEDATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10010DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10046DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10074DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10085DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10093DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10108DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10115DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10122DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10130DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10153DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10160DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10167DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10175DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10182DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10190DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10197DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10205DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10219DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10226DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSROLLBK10233DATA]  TO [portaldba_group]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[CMSVIEWFILESDATA]  TO [portaldba_group]
GO
 
/****************************************************************************************/
/*                                                                                      */
/* Register patch                                                               	*/
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14939613, getdate(), 1, 4, 'Star 14939613 Portalr12: Add a portal instance id column' )
GO

COMMIT TRANSACTION 
GO
