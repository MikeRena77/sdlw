/* Formatted by PL/Formatter v2.1.5.2 on 2000/08/18 15:58 */
WHENEVER SQLERROR CONTINUE;
spool &1;

CREATE INDEX HARPACKAGE_IND_ENV 
ON HARPACKAGE (ENVOBJID, STATEOBJID)
TABLESPACE HARVESTINDEX;

CREATE INDEX HARITEMS_IND_TYPE 
ON HARITEMS (ITEMTYPE,PARENTOBJID)
TABLESPACE HARVESTINDEX;

ALTER TABLE HARVERSIONDATA 
MODIFY LOB (VERSIONDATA ) 
( INDEX (  STORAGE ( MAXEXTENTS 500) ) );


CREATE INDEX HARITEMRELATIONSHIP_REFITM_IDX 
ON  HARITEMRELATIONSHIP (REFITEMID) 
TABLESPACE HARVESTINDEX;

COMMIT;
spool off
EXIT