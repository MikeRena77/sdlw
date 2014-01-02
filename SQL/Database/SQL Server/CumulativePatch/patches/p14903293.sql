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

/*****************************************************************************/
/*                                                                           */
/* Star 14903293 new harvest table hardelpkgproc			     */
/*                                                                           */
/*****************************************************************************/

/* lock objects...  */
 
/* Start of lines added to convert to online lock */
 
 
Select top 1 1 from mdb_patch with (tablockx)
GO
 
/* Start of locks for dependent tables */
 
/* End of lines added to convert to online lock */
 
CREATE TABLE dbo.hardelpkgproc
(
    PROCESSOBJID               INTEGER                         NOT NULL
  , PROCESSNAME                CHAR     (128)                  NOT NULL
  , STATEOBJID                      INTEGER                         NOT NULL
  , CREATIONTIME                 DATETIME                       NOT NULL
  , CREATORID                       INTEGER                         NOT NULL
  , MODIFIEDTIME                  DATETIME                       NOT NULL
  , MODIFIERID                      INTEGER                          NOT NULL
  , NOTE                                 VARCHAR (2000)                  
)
GO


ALTER TABLE dbo.hardelpkgproc ADD CONSTRAINT hardelpkgproc_PK PRIMARY KEY
(
    PROCESSOBJID
)
GO

ALTER TABLE dbo.hardelpkgproc ADD CONSTRAINT hardelpkgproc_SPID_FK FOREIGN KEY
(
    STATEOBJID
  , PROCESSOBJID
)
REFERENCES HARSTATEPROCESS
(
    STATEOBJID
  , PROCESSOBJID
)
ON DELETE CASCADE
GO

grant insert,delete,update,select on dbo.hardelpkgproc to harvest_group
GO

/*****************************************************************************/
/*                                                                           */
/* Register patch                                                      	     */
/*                                                                           */
/*****************************************************************************/
insert into mdb_patch ( patchnumber, installdate,  mdbmajorversion, mdbminorversion, description)
 values ( 14903293, getdate(), 1, 4, 'Star 14903293 new harvest table hardelpkgproc' )
GO

COMMIT TRANSACTION 
GO

