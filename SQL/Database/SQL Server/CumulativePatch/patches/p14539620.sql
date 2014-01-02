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
/* Patch Star 14539620 NSM: New aec_hist_report_v2 table for NSM-AEC                    */
/*                                                                                      */
/****************************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */

CREATE TABLE aec_hist_report_v2 (
       policyname           VARCHAR(50) NOT NULL,
       rulename             VARCHAR(25) NOT NULL,
       ruledesc             VARCHAR(255) NULL,
       ruleuuid             CHAR(128) NULL,
       ruletype             CHAR(15) NULL,
       istemplate           CHAR(15) NULL,
       pipename             VARCHAR(25) NULL,
       pipeuuid             CHAR(128) NULL,
       aecaction            VARCHAR(50) NULL,
       log_date             CHAR(10) NULL,
       log_time             CHAR(8) NULL,
       node                 VARCHAR(64) NULL,
       policycnt            int NULL
);
GO

CREATE INDEX XIE1aec_hist_report_v2 ON aec_hist_report_v2
(
       node                           ASC
);
GO

ALTER TABLE aec_hist_report_v2
       ADD CONSTRAINT XPKaec_hist_report_v2 PRIMARY KEY (policyname, rulename);
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[aec_hist_report_v2]  TO [emadmin]
GO

GRANT  SELECT  ON [dbo].[aec_hist_report_v2]  TO [emuser]
GO

GRANT  SELECT ,  UPDATE ,  INSERT ,  DELETE  ON [dbo].[aec_hist_report_v2]  TO [uniadmin]
GO

GRANT  SELECT  ON [dbo].[aec_hist_report_v2]  TO [uniuser]
GO

/****************************************************************************************/
/*                                                                                      */
/*  register patch                                                                      */
/*                                                                                      */
/****************************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14539620, getdate(), 1, 4, 'Patch Star 14539620 NSM: New aec_hist_report_v2 table for NSM-AEC' )
GO

COMMIT TRANSACTION 
GO


