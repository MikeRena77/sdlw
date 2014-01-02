set echo off
set feedback off
set serveroutput on
set pagesize 0

spool C:\oracle\product\10.1.0\db_1\hardev1.aafes.com_hardev1\sysman\emd\reorg33.log

-- Script Header Section
-- ==============================================

-- functions and procedures

CREATE OR REPLACE PROCEDURE mgmt$reorg_sendMsg (msg IN VARCHAR2) IS
    msg1 VARCHAR2(255);
    len INTEGER := length(msg);
    i INTEGER := 1;
BEGIN
    dbms_output.enable (1000000);

    LOOP
      msg1 := SUBSTR (msg, i, 255);
      dbms_output.put_line (msg1);
      len := len - 255;
      i := i + 255;
    EXIT WHEN len <= 0;
    END LOOP;
END mgmt$reorg_sendMsg;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_errorExit (msg IN VARCHAR2) IS
BEGIN
    mgmt$reorg_sendMsg (msg);
    mgmt$reorg_sendMsg ('errorExit!');
END mgmt$reorg_errorExit;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_errorExitOraError (msg IN VARCHAR2, errMsg IN VARCHAR2) IS
BEGIN
    mgmt$reorg_sendMsg (msg);
    mgmt$reorg_sendMsg (errMsg);
    mgmt$reorg_sendMsg ('errorExitOraError!');
END mgmt$reorg_errorExitOraError;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_checkDBAPrivs (user_name IN VARCHAR2)
AUTHID CURRENT_USER IS
    granted_role REAL := 0;
BEGIN
    EXECUTE IMMEDIATE 'SELECT 1 FROM SYS.DBA_ROLE_PRIVS WHERE GRANTED_ROLE = ''DBA'' AND GRANTEE = (SELECT USER FROM DUAL)'
      INTO granted_role;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
      mgmt$reorg_sendMsg ( 'WARNING checking privileges... User Name: ' || user_name);
      mgmt$reorg_sendMsg ( 'User does not have DBA privs. ' );
      mgmt$reorg_sendMsg ( 'The script will fail if it tries to perform operations for which the user lacks the appropriate privilege. ' );
END mgmt$reorg_checkDBAPrivs;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_setUpJobTable (script_id IN INTEGER, job_table IN VARCHAR2, step_num OUT INTEGER)
AUTHID CURRENT_USER IS
    ctsql_text VARCHAR2(200) := 'CREATE TABLE ' || job_table || '(SCRIPT_ID NUMBER, LAST_STEP NUMBER, unique (SCRIPT_ID))';
    itsql_text VARCHAR2(200) := 'INSERT INTO ' || job_table || ' (SCRIPT_ID, LAST_STEP) values (:1, :2)';
    stsql_text VARCHAR2(200) := 'SELECT last_step FROM ' || job_table || ' WHERE script_id = :1';

    TYPE CurTyp IS REF CURSOR;  -- define weak REF CURSOR type
    stsql_cur CurTyp;  -- declare cursor variable

BEGIN
    step_num := 0;
    BEGIN
      EXECUTE IMMEDIATE ctsql_text;
    EXCEPTION
      WHEN OTHERS THEN
        NULL;
    END;

    BEGIN
      OPEN stsql_cur FOR  -- open cursor variable
        stsql_text USING  script_id;
      FETCH stsql_cur INTO step_num;
      IF stsql_cur%FOUND THEN
        NULL;
      ELSE
        EXECUTE IMMEDIATE itsql_text USING script_id, step_num;
        COMMIT;
        step_num := 1;
      END IF;
      CLOSE stsql_cur;
    EXCEPTION
      WHEN OTHERS THEN
        mgmt$reorg_errorExit ('ERROR selecting or inserting from table: ' || job_table);
        return;
    END;

    return;

EXCEPTION
      WHEN OTHERS THEN
        mgmt$reorg_errorExit ('ERROR accessing table: ' || job_table);
        return;
END mgmt$reorg_setUpJobTable;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_deleteJobTableEntry(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN INTEGER, highest_step IN INTEGER)
AUTHID CURRENT_USER IS
    delete_text VARCHAR2(200) := 'DELETE FROM ' || job_table || ' WHERE SCRIPT_ID = :1';
BEGIN

    IF step_num <= highest_step THEN
      return;
    END IF;

    BEGIN
      EXECUTE IMMEDIATE delete_text USING script_id;
      IF SQL%NOTFOUND THEN
        mgmt$reorg_errorExit ('ERROR deleting entry from table: ' || job_table);
        return;
      END IF;
    EXCEPTION
        WHEN OTHERS THEN
          mgmt$reorg_errorExit ('ERROR deleting entry from table: ' || job_table);
          return;
    END;

    COMMIT;
END mgmt$reorg_deleteJobTableEntry;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_setStep (script_id IN INTEGER, job_table IN VARCHAR2, step_num IN INTEGER)
AUTHID CURRENT_USER IS
    update_text VARCHAR2(200) := 'UPDATE ' || job_table || ' SET last_step = :1 WHERE script_id = :2';
BEGIN
    -- update job table
    EXECUTE IMMEDIATE update_text USING step_num, script_id;
    IF SQL%NOTFOUND THEN
      mgmt$reorg_sendMsg ('NOTFOUND EXCEPTION of sql_text: ' || update_text);
      mgmt$reorg_errorExit ('ERROR accessing table: ' || job_table);
      return;
    END IF;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
      mgmt$reorg_errorExit ('ERROR accessing table: ' || job_table);
      return;
END mgmt$reorg_setStep;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_dropTbsp (tbsp_name IN VARCHAR2)
AUTHID CURRENT_USER IS
  sql_text VARCHAR2(2000) := 'SELECT count(*) FROM sys.seg$ s, sys.ts$ t ' ||
                             'WHERE s.ts# = t.ts# and t.name = :1 and rownum = 1';
  seg_count INTEGER := 1;
  tbsp_name_r VARCHAR2(30);
BEGIN
  tbsp_name_r := REPLACE(tbsp_name, '"', '');
  EXECUTE IMMEDIATE sql_text INTO seg_count USING tbsp_name_r;
  IF (seg_count = 0) THEN
    mgmt$reorg_sendMsg ('DROP TABLESPACE ' || tbsp_name || ' INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS');
    EXECUTE IMMEDIATE 'DROP TABLESPACE ' || tbsp_name || ' INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS';
  ELSE
    mgmt$reorg_sendMsg ('DROP TABLESPACE ' || tbsp_name);
    EXECUTE IMMEDIATE 'DROP TABLESPACE ' || tbsp_name;
  END IF;
END mgmt$reorg_dropTbsp;
/

CREATE OR REPLACE PROCEDURE mgmt$step_1_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 1 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('CREATE  SMALLFILE  TABLESPACE "HARVESTBLOB_REORG0" DATAFILE ''C:\WINDOWS\SYSTEM32\HARDEV1BLOB_reorg0.ORA'' SIZE 250M REUSE  AUTOEXTEND ON NEXT 5120K MAXSIZE 32767M LOGGING  EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  MANUAL ');
      EXECUTE IMMEDIATE 'CREATE  SMALLFILE  TABLESPACE "HARVESTBLOB_REORG0" DATAFILE ''C:\WINDOWS\SYSTEM32\HARDEV1BLOB_reorg0.ORA'' SIZE 250M REUSE  AUTOEXTEND ON NEXT 5120K MAXSIZE 32767M LOGGING  EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  MANUAL ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_1_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_2_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 2 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_SERVER_ALERT.SET_THRESHOLD(9000,NULL,NULL,NULL,NULL,1,1,NULL,5,''HARVESTBLOB_REORG0''); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_SERVER_ALERT.SET_THRESHOLD(9000,NULL,NULL,NULL,NULL,1,1,NULL,5,''HARVESTBLOB_REORG0''); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_2_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_3_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 3 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER USER "HRVSTUSER" QUOTA UNLIMITED ON "HARVESTBLOB_REORG0"');
      EXECUTE IMMEDIATE 'ALTER USER "HRVSTUSER" QUOTA UNLIMITED ON "HARVESTBLOB_REORG0"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_3_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_4_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 4 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARVERSIONDELTA" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("VERSIONDELTA") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARVERSIONDELTA" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("VERSIONDELTA") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_4_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_5_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 5 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PARENT" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PARENT" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_5_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_6_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 6 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_6_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_7_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 7 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONDELTA"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONDELTA"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_7_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_8_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 8 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARVERSIONDATA" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("VERSIONDATA") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARVERSIONDATA" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("VERSIONDATA") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_8_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_9_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 9 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_ITMID_FK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_ITMID_FK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_9_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_10_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 10 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_10_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_11_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 11 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONDATA"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONDATA"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_11_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_12_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 12 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPASSWORDHISTORY" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("PREVPSSWDS") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPASSWORDHISTORY" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("PREVPSSWDS") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_12_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_13_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 13 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPASSWORDHISTORY_PK" REBUILD TABLESPACE "HARVESTBLOB_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPASSWORDHISTORY_PK" REBUILD TABLESPACE "HARVESTBLOB_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_13_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_14_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 14 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPASSWORDHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPASSWORDHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_14_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_15_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 15 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFORMATTACHMENT" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("FILEDATA") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFORMATTACHMENT" MOVE TABLESPACE "HARVESTBLOB_REORG0" LOB ("FILEDATA") STORE AS (TABLESPACE "HARVESTBLOB_REORG0") ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_15_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_16_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 16 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_16_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_17_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 17 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND2" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND2" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_17_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_18_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 18 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_18_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_19_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 19 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_19_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_20_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 20 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER USER "HRVSTUSER" QUOTA 0K ON "HARVESTBLOB"');
      EXECUTE IMMEDIATE 'ALTER USER "HRVSTUSER" QUOTA 0K ON "HARVESTBLOB"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_20_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_21_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 21 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_dropTbsp('"HARVESTBLOB"');
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_21_33;
/

CREATE OR REPLACE PROCEDURE mgmt$step_22_33(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 22 THEN
      return;
    END IF;

    mgmt$reorg_setStep (33, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLESPACE "HARVESTBLOB_REORG0" RENAME TO "HARVESTBLOB"');
      EXECUTE IMMEDIATE 'ALTER TABLESPACE "HARVESTBLOB_REORG0" RENAME TO "HARVESTBLOB"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_22_33;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_cleanup_33 (script_id IN INTEGER, job_table IN VARCHAR2, step_num IN INTEGER, highest_step IN INTEGER)
AUTHID CURRENT_USER IS
BEGIN
    IF step_num <= highest_step THEN
      return;
    END IF;

    mgmt$reorg_sendMsg ('Starting cleanup of recovery tables');

    mgmt$reorg_deleteJobTableEntry(script_id, job_table, step_num, highest_step);

    mgmt$reorg_sendMsg ('Completed cleanup of recovery tables');
END mgmt$reorg_cleanup_33;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_commentheader_33 IS
BEGIN
     mgmt$reorg_sendMsg ('--   Target database:	hardev1');
     mgmt$reorg_sendMsg ('--   Script generated at:	02-FEB-2007   08:46');
END mgmt$reorg_commentheader_33;
/

-- Script Execution Controller
-- ==============================================

variable step_num number;
exec mgmt$reorg_commentheader_33;
exec mgmt$reorg_sendMsg ('Starting reorganization');
exec mgmt$reorg_sendMsg ('Executing as user: ' || 'SYS');
exec mgmt$reorg_checkDBAPrivs ('SYS');
exec mgmt$reorg_setupJobTable (33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);

exec mgmt$step_1_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_2_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_3_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_4_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_5_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_6_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_7_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_8_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_9_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_10_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_11_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_12_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_13_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_14_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_15_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_16_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_17_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_18_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_19_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_20_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_21_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_22_33(33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);

exec mgmt$reorg_sendMsg ('Completed Reorganization.  Starting cleanup phase.');

exec mgmt$reorg_cleanup_33 (33, 'SYS.MGMT$REORG_CHECKPOINT', :step_num, 22);

exec mgmt$reorg_sendMsg ('Starting cleanup of generated procedures');

DROP PROCEDURE mgmt$step_1_33;
DROP PROCEDURE mgmt$step_2_33;
DROP PROCEDURE mgmt$step_3_33;
DROP PROCEDURE mgmt$step_4_33;
DROP PROCEDURE mgmt$step_5_33;
DROP PROCEDURE mgmt$step_6_33;
DROP PROCEDURE mgmt$step_7_33;
DROP PROCEDURE mgmt$step_8_33;
DROP PROCEDURE mgmt$step_9_33;
DROP PROCEDURE mgmt$step_10_33;
DROP PROCEDURE mgmt$step_11_33;
DROP PROCEDURE mgmt$step_12_33;
DROP PROCEDURE mgmt$step_13_33;
DROP PROCEDURE mgmt$step_14_33;
DROP PROCEDURE mgmt$step_15_33;
DROP PROCEDURE mgmt$step_16_33;
DROP PROCEDURE mgmt$step_17_33;
DROP PROCEDURE mgmt$step_18_33;
DROP PROCEDURE mgmt$step_19_33;
DROP PROCEDURE mgmt$step_20_33;
DROP PROCEDURE mgmt$step_21_33;
DROP PROCEDURE mgmt$step_22_33;

DROP PROCEDURE mgmt$reorg_cleanup_33;
DROP PROCEDURE mgmt$reorg_commentheader_33;

exec mgmt$reorg_sendMsg ('Completed cleanup of generated procedures');

exec mgmt$reorg_sendMsg ('Script execution complete');

spool off
set pagesize 24
set serveroutput off
set feedback on
set echo on
