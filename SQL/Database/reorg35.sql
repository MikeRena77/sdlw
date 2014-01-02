set echo off
set feedback off
set serveroutput on
set pagesize 0

spool C:\oracle\product\10.1.0\db_1\hardev1.aafes.com_hardev1\sysman\emd\reorg35.log

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

CREATE OR REPLACE PROCEDURE mgmt$step_1_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 1 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('CREATE  SMALLFILE  TABLESPACE "HARVESTMETA_REORG0" DATAFILE ''C:\WINDOWS\SYSTEM32\HARDEV1META_reorg0.ORA'' SIZE 50M REUSE  AUTOEXTEND ON NEXT 5120K MAXSIZE 32767M LOGGING  EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  MANUAL ');
      EXECUTE IMMEDIATE 'CREATE  SMALLFILE  TABLESPACE "HARVESTMETA_REORG0" DATAFILE ''C:\WINDOWS\SYSTEM32\HARDEV1META_reorg0.ORA'' SIZE 50M REUSE  AUTOEXTEND ON NEXT 5120K MAXSIZE 32767M LOGGING  EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  MANUAL ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_1_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_2_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 2 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_SERVER_ALERT.SET_THRESHOLD(9000,NULL,NULL,NULL,NULL,1,1,NULL,5,''HARVESTMETA_REORG0''); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_SERVER_ALERT.SET_THRESHOLD(9000,NULL,NULL,NULL,NULL,1,1,NULL,5,''HARVESTMETA_REORG0''); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_2_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_3_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 3 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER USER "HRVSTUSER" QUOTA UNLIMITED ON "HARVESTMETA_REORG0"');
      EXECUTE IMMEDIATE 'ALTER USER "HRVSTUSER" QUOTA UNLIMITED ON "HARVESTMETA_REORG0"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_3_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_4_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 4 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."WORKBENCH_PROVIDER" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."WORKBENCH_PROVIDER" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_4_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_5_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 5 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."NDX_WORKBENCH_PROV" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."NDX_WORKBENCH_PROV" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_5_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_6_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 6 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"WORKBENCH_PROVIDER"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"WORKBENCH_PROVIDER"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_6_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_7_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 7 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."WORKBENCH_PRODUCT" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."WORKBENCH_PRODUCT" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_7_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_8_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 8 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_PRODUCT" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_PRODUCT" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_8_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_9_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 9 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"WORKBENCH_PRODUCT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"WORKBENCH_PRODUCT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_9_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_10_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 10 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."USER_PREFERENCES" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."USER_PREFERENCES" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_10_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_11_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 11 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."NDX_USER_PREF" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."NDX_USER_PREF" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_11_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_12_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 12 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_USER_PREFERENCES" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_USER_PREFERENCES" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_12_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_13_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 13 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"USER_PREFERENCES"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"USER_PREFERENCES"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_13_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_14_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 14 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."SETTINGS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."SETTINGS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_14_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_15_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 15 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_SETTINGS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_SETTINGS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_15_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_16_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 16 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"SETTINGS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"SETTINGS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_16_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_17_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 17 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."PROVIDER_USER" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."PROVIDER_USER" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_17_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_18_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 18 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."NDX_PROV_USER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."NDX_PROV_USER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_18_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_19_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 19 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_PROVIDER_USER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_PROVIDER_USER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_19_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_20_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 20 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"PROVIDER_USER"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"PROVIDER_USER"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_20_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_21_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 21 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARVIEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARVIEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_21_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_22_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 22 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_22_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_23_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 23 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_23_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_24_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 24 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_24_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_25_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 25 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_VIEWTYPE" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_VIEWTYPE" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_25_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_26_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 26 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVIEW"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVIEW"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_26_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_27_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 27 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARVEST_SUBPACKAGE_ACTIONS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARVEST_SUBPACKAGE_ACTIONS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_27_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_28_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 28 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_HARVEST_SUBPACKAGE_ACTIONS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_HARVEST_SUBPACKAGE_ACTIONS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_28_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_29_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 29 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVEST_SUBPACKAGE_ACTIONS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVEST_SUBPACKAGE_ACTIONS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_29_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_30_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 30 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARVERSIONS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARVERSIONS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_30_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_31_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 31 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMMAPPED" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMMAPPED" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_31_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_32_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 32 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMOBJID" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMOBJID" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_32_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_33_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 33 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEM_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEM_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_33_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_34_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 34 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_MERGED_IDX" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_MERGED_IDX" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_34_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_35_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 35 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_PAR_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_PAR_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_35_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_36_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 36 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_36_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_37_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 37 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_37_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_38_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 38 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_STATUS" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_STATUS" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_38_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_39_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 39 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_VC" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_VC" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_39_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_40_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 40 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_VERITEM" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_VERITEM" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_40_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_41_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 41 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_VSTATUS" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_VSTATUS" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_41_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_42_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 42 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_42_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_43_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 43 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARVERSIONINVIEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARVERSIONINVIEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_43_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_44_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 44 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_44_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_45_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 45 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIV_VERS_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIV_VERS_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_45_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_46_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 46 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONINVIEW"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARVERSIONINVIEW"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_46_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_47_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 47 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSERSINGROUP" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSERSINGROUP" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_47_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_48_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 48 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005529" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005529" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_48_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_49_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 49 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERSINGROUP"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERSINGROUP"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_49_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_50_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 50 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSERGROUP" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSERGROUP" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_50_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_51_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 51 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSERGROUP_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSERGROUP_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_51_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_52_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 52 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005528" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005528" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_52_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_53_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 53 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERGROUP"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERGROUP"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_53_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_54_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 54 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSERDATA" MOVE TABLESPACE "HARVESTMETA_REORG0" LOB ("ENCRYPTPSSWD") STORE AS (TABLESPACE "HARVESTMETA_REORG0") ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSERDATA" MOVE TABLESPACE "HARVESTMETA_REORG0" LOB ("ENCRYPTPSSWD") STORE AS (TABLESPACE "HARVESTMETA_REORG0") ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_54_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_55_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 55 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSERDATA_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSERDATA_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_55_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_56_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 56 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERDATA"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERDATA"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_56_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_57_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 57 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSERCONTACT" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSERCONTACT" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_57_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_58_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 58 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005526" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005526" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_58_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_59_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 59 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERCONTACT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSERCONTACT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_59_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_60_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 60 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSER" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSER" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_60_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_61_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 61 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSER_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSER_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_61_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_62_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 62 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSER_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSER_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_62_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_63_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 63 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSER"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSER"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_63_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_64_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 64 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDPLATFORMINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDPLATFORMINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_64_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_65_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 65 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDPLATFORMINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDPLATFORMINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_65_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_66_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 66 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDPLATFORMINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDPLATFORMINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_66_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_67_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 67 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDPACKAGENAMES" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDPACKAGENAMES" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_67_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_68_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 68 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDPACKAGENAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDPACKAGENAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_68_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_69_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 69 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGENAMES"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGENAMES"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_69_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_70_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 70 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDPACKAGEINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDPACKAGEINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_70_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_71_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 71 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDPACKAGEINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDPACKAGEINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_71_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_72_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 72 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGEINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGEINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_72_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_73_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 73 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDHISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDHISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_73_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_74_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 74 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_74_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_75_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 75 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDGROUPNAMES" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDGROUPNAMES" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_75_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_76_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 76 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDGROUPNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDGROUPNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_76_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_77_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 77 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDGROUPNAMES"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDGROUPNAMES"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_77_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_78_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 78 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDDEPLOYINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDDEPLOYINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_78_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_79_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 79 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_ATTACH_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_ATTACH_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_79_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_80_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 80 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_80_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_81_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 81 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_81_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_82_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 82 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_82_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_83_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 83 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUSDCOMPUTERNAMES" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUSDCOMPUTERNAMES" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_83_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_84_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 84 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDCOMPUTERNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDCOMPUTERNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_84_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_85_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 85 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDCOMPUTERNAMES"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUSDCOMPUTERNAMES"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_85_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_86_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 86 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARUDP" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARUDP" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_86_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_87_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 87 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005524" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005524" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_87_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_88_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 88 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUDP"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARUDP"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_88_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_89_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 89 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARTESTINGINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARTESTINGINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_89_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_90_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 90 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005523" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005523" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_90_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_91_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 91 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARTESTINGINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARTESTINGINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_91_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_92_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 92 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARTABLEINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARTABLEINFO" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_92_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_93_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 93 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARTABLEINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARTABLEINFO"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_93_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_94_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 94 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARSWITCHPKGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARSWITCHPKGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_94_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_95_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 95 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSWITCHPKGPROC_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSWITCHPKGPROC_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_95_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_96_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 96 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSWITCHPKGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSWITCHPKGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_96_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_97_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 97 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARSTATEPROCESSACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARSTATEPROCESSACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_97_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_98_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 98 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEPROCESSACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEPROCESSACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_98_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_99_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 99 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESSACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESSACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_99_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_100_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 100 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARSTATEPROCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARSTATEPROCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_100_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_101_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 101 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEPROCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEPROCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_101_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_102_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 102 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEPROC_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEPROC_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_102_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_103_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 103 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_103_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_104_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 104 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARSTATEACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARSTATEACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_104_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_105_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 105 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_105_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_106_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 106 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATEACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATEACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_106_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_107_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 107 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARSTATE" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARSTATE" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_107_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_108_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 108 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATE_ENVOBJID" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATE_ENVOBJID" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_108_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_109_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 109 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATE_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATE_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_109_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_110_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 110 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATE_LIST" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATE_LIST" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_110_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_111_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 111 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005519" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005519" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_111_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_112_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 112 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATE"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSTATE"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_112_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_113_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 113 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARSNAPVIEWPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARSNAPVIEWPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_113_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_114_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 114 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005518" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005518" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_114_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_115_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 115 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSNAPVIEWPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARSNAPVIEWPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_115_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_116_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 116 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARREPOSITORYACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARREPOSITORYACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_116_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_117_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 117 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_117_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_118_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 118 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREPOSITORYACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREPOSITORYACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_118_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_119_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 119 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARREPOSITORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARREPOSITORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_119_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_120_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 120 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPOSITORY_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPOSITORY_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_120_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_121_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 121 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPOSITORY_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPOSITORY_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_121_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_122_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 122 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREPOSITORY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREPOSITORY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_122_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_123_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 123 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARREPINVIEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARREPINVIEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_123_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_124_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 124 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_124_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_125_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 125 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPINVIEW_REPID_FK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPINVIEW_REPID_FK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_125_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_126_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 126 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREPINVIEW"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREPINVIEW"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_126_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_127_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 127 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARRENAMEITEMPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARRENAMEITEMPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_127_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_128_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 128 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARRENAMEITEMPROC_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARRENAMEITEMPROC_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_128_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_129_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 129 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARRENAMEITEMPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARRENAMEITEMPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_129_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_130_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 130 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARREMITEMPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARREMITEMPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_130_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_131_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 131 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005513" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005513" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_131_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_132_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 132 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREMITEMPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARREMITEMPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_132_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_133_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 133 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARQANDA" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARQANDA" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_133_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_134_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 134 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005512" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005512" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_134_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_135_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 135 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARQANDA"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARQANDA"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_135_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_136_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 136 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPROMOTEPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPROMOTEPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_136_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_137_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 137 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005511" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005511" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_137_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_138_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 138 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPROMOTEPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPROMOTEPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_138_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_139_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 139 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPROBLEMREPORT" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPROBLEMREPORT" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_139_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_140_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 140 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005510" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005510" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_140_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_141_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 141 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPROBLEMREPORT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPROBLEMREPORT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_141_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_142_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 142 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPMSTATUS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPMSTATUS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_142_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_143_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 143 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005509" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005509" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_143_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_144_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 144 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPMSTATUS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPMSTATUS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_144_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_145_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 145 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPKGSINPKGGRP" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPKGSINPKGGRP" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_145_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_146_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 146 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGSINPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGSINPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_146_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_147_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 147 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005508" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005508" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_147_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_148_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 148 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPKGSINPKGGRP"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPKGSINPKGGRP"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_148_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_149_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 149 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPKGSINCMEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPKGSINCMEW" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_149_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_150_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 150 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGSINCMEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGSINCMEW_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_150_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_151_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 151 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPKGSINCMEW"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPKGSINCMEW"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_151_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_152_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 152 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPKGHISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPKGHISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_152_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_153_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 153 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGHIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGHIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_153_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_154_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 154 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPKGHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPKGHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_154_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_155_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 155 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPATHFULLNAME" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPATHFULLNAME" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_155_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_156_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 156 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PATH" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PATH" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_156_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_157_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 157 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_157_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_158_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 158 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PUPPER" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PUPPER" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_158_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_159_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 159 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_159_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_160_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 160 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPASSWORDPOLICY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPASSWORDPOLICY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_160_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_161_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 161 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPASSWORDPOLICY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPASSWORDPOLICY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_161_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_162_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 162 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPACKAGESTATUS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPACKAGESTATUS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_162_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_163_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 163 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_C_IDX" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_C_IDX" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_163_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_164_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 164 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_164_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_165_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 165 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_S_IDX" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_S_IDX" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_165_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_166_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 166 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_166_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_167_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 167 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPACKAGENAMEGEN" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPACKAGENAMEGEN" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_167_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_168_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 168 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGENAMEGEN_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGENAMEGEN_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_168_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_169_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 169 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGENAMEGEN"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGENAMEGEN"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_169_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_170_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 170 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPACKAGEGROUP" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPACKAGEGROUP" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_170_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_171_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 171 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGEGROUP_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGEGROUP_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_171_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_172_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 172 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_172_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_173_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 173 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGEGROUP"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGEGROUP"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_173_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_174_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 174 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPACKAGE" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPACKAGE" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_174_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_175_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 175 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_175_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_176_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 176 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND_ENV" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND_ENV" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_176_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_177_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 177 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005502" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005502" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_177_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_178_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 178 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGE"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPACKAGE"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_178_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_179_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 179 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARPAC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARPAC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_179_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_180_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 180 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005501" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005501" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_180_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_181_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 181 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPAC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARPAC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_181_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_182_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 182 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HAROBJECTSEQUENCEID" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HAROBJECTSEQUENCEID" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_182_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_183_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 183 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HAROBJECTSEQUENCEID_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HAROBJECTSEQUENCEID_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_183_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_184_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 184 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HAROBJECTSEQUENCEID"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HAROBJECTSEQUENCEID"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_184_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_185_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 185 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARNOTIFYLIST" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARNOTIFYLIST" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_185_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_186_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 186 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARNOTIFYLIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARNOTIFYLIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_186_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_187_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 187 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARNOTIFYLIST"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARNOTIFYLIST"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_187_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_188_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 188 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARNOTIFY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARNOTIFY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_188_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_189_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 189 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005499" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005499" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_189_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_190_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 190 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARNOTIFY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARNOTIFY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_190_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_191_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 191 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARMR" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARMR" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_191_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_192_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 192 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARMR_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARMR_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_192_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_193_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 193 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARMR"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARMR"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_193_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_194_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 194 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARMOVEPKGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARMOVEPKGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_194_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_195_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 195 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005497" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005497" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_195_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_196_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 196 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARMOVEPKGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARMOVEPKGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_196_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_197_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 197 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARLISTVERSPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARLISTVERSPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_197_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_198_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 198 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005496" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005496" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_198_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_199_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 199 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARLISTVERSPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARLISTVERSPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_199_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_200_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 200 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARLISTDIFFPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARLISTDIFFPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_200_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_201_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 201 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005495" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005495" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_201_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_202_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 202 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARLISTDIFFPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARLISTDIFFPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_202_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_203_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 203 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARLINKEDPROCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARLINKEDPROCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_203_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_204_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 204 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_204_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_205_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 205 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_PARENT" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_PARENT" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_205_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_206_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 206 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_POBJID" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_POBJID" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_206_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_207_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 207 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005494" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005494" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_207_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_208_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 208 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_208_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_209_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 209 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARITEMS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARITEMS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_209_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_210_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 210 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_IND_TYPE" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_IND_TYPE" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_210_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_211_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 211 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAME" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAME" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_211_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_212_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 212 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAMEUPPER" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAMEUPPER" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_212_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_213_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 213 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_PARENTTYPE" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_PARENTTYPE" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_213_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_214_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 214 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_PID_FK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_PID_FK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_214_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_215_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 215 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_215_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_216_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 216 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_REPID" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_REPID" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_216_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_217_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 217 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."P_UKEY" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."P_UKEY" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_217_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_218_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 218 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARITEMS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARITEMS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_218_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_219_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 219 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARITEMRELATIONSHIP" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARITEMRELATIONSHIP" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_219_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_220_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 220 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_220_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_221_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 221 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_REFITM_IDX" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_REFITM_IDX" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_221_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_222_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 222 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARITEMRELATIONSHIP"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARITEMRELATIONSHIP"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_222_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_223_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 223 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARITEMACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARITEMACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_223_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_224_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 224 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_224_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_225_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 225 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMACCESS_USRGRP" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMACCESS_USRGRP" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_225_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_226_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 226 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMACCESS_VIEW" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMACCESS_VIEW" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_226_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_227_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 227 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_227_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_228_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 228 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARINTMRGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARINTMRGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_228_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_229_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 229 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005490" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005490" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_229_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_230_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 230 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARINTMRGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARINTMRGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_230_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_231_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 231 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARHARVEST" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARHARVEST" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_231_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_232_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 232 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARHARVEST_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARHARVEST_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_232_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_233_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 233 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARHARVEST"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARHARVEST"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_233_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_234_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 234 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFORMTYPEDEFS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFORMTYPEDEFS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_234_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_235_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 235 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEFS_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEFS_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_235_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_236_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 236 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_ALT" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_ALT" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_236_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_237_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 237 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_COL" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_COL" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_237_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_238_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 238 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005488" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005488" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_238_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_239_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 239 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEFS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEFS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_239_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_240_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 240 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFORMTYPEACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFORMTYPEACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_240_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_241_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 241 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_241_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_242_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 242 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_242_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_243_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 243 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFORMTYPE" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFORMTYPE" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_243_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_244_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 244 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPE_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPE_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_244_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_245_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 245 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005486" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005486" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_245_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_246_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 246 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."UNQ_FORMTABLENAME" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."UNQ_FORMTABLENAME" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_246_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_247_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 247 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMTYPE"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMTYPE"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_247_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_248_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 248 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFORMHISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFORMHISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_248_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_249_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 249 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMHIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMHIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_249_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_250_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 250 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORMHISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_250_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_251_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 251 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFORM" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFORM" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_251_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_252_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 252 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORM_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORM_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_252_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_253_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 253 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORM_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORM_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_253_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_254_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 254 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORM"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFORM"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_254_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_255_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 255 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARFILEEXTENSION" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARFILEEXTENSION" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_255_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_256_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 256 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFILEEXTENSION_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFILEEXTENSION_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_256_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_257_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 257 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFILEEXTENSION"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARFILEEXTENSION"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_257_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_258_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 258 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARESD" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARESD" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_258_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_259_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 259 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005481" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005481" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_259_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_260_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 260 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARESD"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARESD"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_260_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_261_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 261 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARENVIRONMENTACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARENVIRONMENTACCESS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_261_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_262_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 262 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARENVACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARENVACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_262_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_263_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 263 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENTACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENTACCESS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_263_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_264_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 264 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARENVIRONMENT" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARENVIRONMENT" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_264_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_265_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 265 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_265_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_266_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 266 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_266_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_267_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 267 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_267_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_268_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 268 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARDEMOTEPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARDEMOTEPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_268_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_269_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 269 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005478" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005478" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_269_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_270_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 270 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARDEMOTEPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARDEMOTEPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_270_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_271_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 271 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARDELVERSPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARDELVERSPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_271_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_272_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 272 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005477" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005477" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_272_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_273_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 273 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARDELVERSPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARDELVERSPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_273_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_274_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 274 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARDEFECT" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARDEFECT" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_274_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_275_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 275 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005476" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005476" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_275_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_276_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 276 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARDEFECT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARDEFECT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_276_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_277_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 277 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCRSENVMRGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCRSENVMRGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_277_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_278_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 278 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005475" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005475" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_278_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_279_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 279 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCRSENVMRGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCRSENVMRGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_279_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_280_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 280 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCRPKGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCRPKGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_280_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_281_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 281 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005474" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005474" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_281_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_282_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 282 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCRPKGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCRPKGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_282_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_283_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 283 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCONVERSIONLOG" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCONVERSIONLOG" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_283_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_284_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 284 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005473" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005473" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_284_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_285_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 285 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCONVERSIONLOG"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCONVERSIONLOG"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_285_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_286_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 286 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCONMRGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCONMRGPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_286_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_287_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 287 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005472" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005472" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_287_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_288_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 288 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCONMRGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCONMRGPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_288_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_289_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 289 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCOMMENT" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCOMMENT" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_289_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_290_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 290 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005471" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005471" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_290_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_291_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 291 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCOMMENT"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCOMMENT"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_291_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_292_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 292 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCHECKOUTPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCHECKOUTPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_292_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_293_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 293 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005470" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005470" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_293_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_294_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 294 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCHECKOUTPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCHECKOUTPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_294_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_295_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 295 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARCHECKINPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARCHECKINPROC" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_295_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_296_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 296 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARCHECKINPROC_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARCHECKINPROC_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_296_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_297_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 297 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCHECKINPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARCHECKINPROC"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_297_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_298_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 298 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARBRANCH" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARBRANCH" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_298_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_299_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 299 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARBRANCH_ITEMID_FK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARBRANCH_ITEMID_FK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_299_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_300_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 300 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARBRANCH_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARBRANCH_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_300_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_301_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 301 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARBRANCH"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARBRANCH"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_301_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_302_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 302 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARASSOCPKG" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARASSOCPKG" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_302_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_303_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 303 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARASSOCPKG_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARASSOCPKG_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_303_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_304_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 304 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARASSOCPKG_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARASSOCPKG_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_304_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_305_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 305 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARASSOCPKG"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARASSOCPKG"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_305_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_306_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 306 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARAPPROVELIST" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARAPPROVELIST" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_306_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_307_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 307 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPROVELIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPROVELIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_307_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_308_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 308 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARAPPROVELIST"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARAPPROVELIST"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_308_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_309_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 309 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARAPPROVEHIST" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARAPPROVEHIST" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_309_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_310_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 310 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPRHIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPRHIST_IND" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_310_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_311_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 311 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPROVEHIST_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPROVEHIST_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_311_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_312_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 312 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARAPPROVEHIST"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARAPPROVEHIST"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_312_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_313_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 313 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARAPPROVE" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARAPPROVE" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_313_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_314_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 314 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPROVE_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPROVE_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_314_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_315_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 315 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARAPPROVE"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARAPPROVE"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_315_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_316_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 316 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARALLUSERS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARALLUSERS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_316_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_317_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 317 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLUSERS_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLUSERS_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_317_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_318_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 318 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLUSERS_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLUSERS_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_318_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_319_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 319 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARALLUSERS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARALLUSERS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_319_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_320_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 320 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."HARALLCHILDRENPATH" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."HARALLCHILDRENPATH" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_320_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_321_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 321 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_CLD_IDX" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_CLD_IDX" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_321_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_322_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 322 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_PK" REBUILD TABLESPACE "HARVESTINDEX" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_PK" REBUILD TABLESPACE "HARVESTINDEX" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_322_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_323_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 323 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARALLCHILDRENPATH"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"HARALLCHILDRENPATH"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_323_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_324_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 324 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE_SUBPACKAGE" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE_SUBPACKAGE" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_324_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_325_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 325 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."NDX_SUB_PKG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."NDX_SUB_PKG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_325_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_326_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 326 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PKG_SUBPACKAGE" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PKG_SUBPACKAGE" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_326_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_327_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 327 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE_SUBPACKAGE"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE_SUBPACKAGE"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_327_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_328_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 328 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE_STATUS" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE_STATUS" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_328_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_329_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 329 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."NDX_ENT_PACKAGE_STATUS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."NDX_ENT_PACKAGE_STATUS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_329_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_330_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 330 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PACKAGE_STATUS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PACKAGE_STATUS" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_330_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_331_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 331 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE_STATUS"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE_STATUS"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_331_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_332_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 332 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE_HISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE_HISTORY" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_332_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_333_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 333 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PACKAGE_HISTORY" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PACKAGE_HISTORY" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_333_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_334_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 334 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE_HISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE_HISTORY"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_334_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_335_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 335 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ENTERPRISE_PACKAGE" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_335_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_336_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 336 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."NDX_ENT_PKG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."NDX_ENT_PKG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_336_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_337_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 337 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PACKAGE" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ENTERPRISE_PACKAGE" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_337_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_338_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 338 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ENTERPRISE_PACKAGE"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_338_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_339_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 339 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ECCM_USER" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ECCM_USER" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_339_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_340_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 340 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ECCM_USER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ECCM_USER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_340_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_341_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 341 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_USER"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_USER"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_341_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_342_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 342 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ECCM_LOG" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ECCM_LOG" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_342_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_343_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 343 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ECCM_LOG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ECCM_LOG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_343_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_344_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 344 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_LOG"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_LOG"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_344_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_345_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 345 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ECCM_CONFIGURATION" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ECCM_CONFIGURATION" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_345_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_346_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 346 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ECCM_CONFIGURATION" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ECCM_CONFIGURATION" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_346_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_347_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 347 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_CONFIGURATION"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_CONFIGURATION"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_347_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_348_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 348 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."ECCM_ACTIONLOG" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."ECCM_ACTIONLOG" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_348_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_349_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 349 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_ECCM_ACTIONLOG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_ECCM_ACTIONLOG" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_349_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_350_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 350 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_ACTIONLOG"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"ECCM_ACTIONLOG"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_350_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_351_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 351 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."COUNTER" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."COUNTER" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_351_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_352_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 352 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_COUNTER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_COUNTER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_352_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_353_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 353 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"COUNTER"'', estimate_percent=>NULL, cascade=>TRUE); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"COUNTER"'', estimate_percent=>NULL, cascade=>TRUE); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_353_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_354_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 354 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER USER "HRVSTUSER" QUOTA 0K ON "HARVESTMETA"');
      EXECUTE IMMEDIATE 'ALTER USER "HRVSTUSER" QUOTA 0K ON "HARVESTMETA"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_354_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_355_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 355 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_dropTbsp('"HARVESTMETA"');
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_355_35;
/

CREATE OR REPLACE PROCEDURE mgmt$step_356_35(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 356 THEN
      return;
    END IF;

    mgmt$reorg_setStep (35, 'SYS.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLESPACE "HARVESTMETA_REORG0" RENAME TO "HARVESTMETA"');
      EXECUTE IMMEDIATE 'ALTER TABLESPACE "HARVESTMETA_REORG0" RENAME TO "HARVESTMETA"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_356_35;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_cleanup_35 (script_id IN INTEGER, job_table IN VARCHAR2, step_num IN INTEGER, highest_step IN INTEGER)
AUTHID CURRENT_USER IS
BEGIN
    IF step_num <= highest_step THEN
      return;
    END IF;

    mgmt$reorg_sendMsg ('Starting cleanup of recovery tables');

    mgmt$reorg_deleteJobTableEntry(script_id, job_table, step_num, highest_step);

    mgmt$reorg_sendMsg ('Completed cleanup of recovery tables');
END mgmt$reorg_cleanup_35;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_commentheader_35 IS
BEGIN
     mgmt$reorg_sendMsg ('--   Target database:	hardev1');
     mgmt$reorg_sendMsg ('--   Script generated at:	02-FEB-2007   08:49');
END mgmt$reorg_commentheader_35;
/

-- Script Execution Controller
-- ==============================================

variable step_num number;
exec mgmt$reorg_commentheader_35;
exec mgmt$reorg_sendMsg ('Starting reorganization');
exec mgmt$reorg_sendMsg ('Executing as user: ' || 'SYS');
exec mgmt$reorg_checkDBAPrivs ('SYS');
exec mgmt$reorg_setupJobTable (35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);

exec mgmt$step_1_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_2_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_3_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_4_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_5_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_6_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_7_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_8_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_9_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_10_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_11_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_12_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_13_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_14_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_15_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_16_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_17_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_18_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_19_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_20_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_21_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_22_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_23_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_24_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_25_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_26_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_27_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_28_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_29_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_30_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_31_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_32_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_33_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_34_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_35_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_36_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_37_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_38_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_39_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_40_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_41_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_42_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_43_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_44_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_45_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_46_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_47_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_48_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_49_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_50_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_51_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_52_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_53_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_54_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_55_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_56_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_57_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_58_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_59_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_60_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_61_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_62_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_63_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_64_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_65_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_66_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_67_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_68_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_69_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_70_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_71_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_72_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_73_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_74_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_75_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_76_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_77_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_78_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_79_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_80_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_81_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_82_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_83_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_84_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_85_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_86_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_87_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_88_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_89_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_90_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_91_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_92_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_93_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_94_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_95_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_96_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_97_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_98_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_99_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_100_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_101_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_102_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_103_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_104_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_105_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_106_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_107_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_108_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_109_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_110_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_111_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_112_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_113_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_114_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_115_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_116_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_117_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_118_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_119_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_120_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_121_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_122_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_123_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_124_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_125_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_126_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_127_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_128_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_129_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_130_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_131_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_132_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_133_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_134_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_135_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_136_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_137_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_138_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_139_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_140_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_141_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_142_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_143_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_144_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_145_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_146_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_147_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_148_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_149_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_150_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_151_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_152_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_153_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_154_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_155_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_156_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_157_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_158_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_159_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_160_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_161_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_162_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_163_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_164_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_165_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_166_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_167_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_168_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_169_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_170_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_171_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_172_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_173_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_174_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_175_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_176_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_177_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_178_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_179_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_180_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_181_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_182_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_183_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_184_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_185_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_186_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_187_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_188_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_189_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_190_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_191_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_192_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_193_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_194_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_195_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_196_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_197_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_198_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_199_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_200_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_201_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_202_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_203_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_204_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_205_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_206_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_207_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_208_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_209_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_210_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_211_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_212_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_213_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_214_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_215_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_216_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_217_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_218_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_219_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_220_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_221_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_222_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_223_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_224_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_225_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_226_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_227_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_228_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_229_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_230_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_231_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_232_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_233_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_234_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_235_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_236_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_237_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_238_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_239_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_240_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_241_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_242_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_243_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_244_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_245_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_246_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_247_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_248_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_249_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_250_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_251_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_252_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_253_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_254_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_255_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_256_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_257_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_258_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_259_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_260_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_261_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_262_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_263_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_264_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_265_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_266_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_267_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_268_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_269_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_270_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_271_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_272_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_273_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_274_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_275_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_276_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_277_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_278_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_279_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_280_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_281_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_282_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_283_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_284_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_285_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_286_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_287_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_288_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_289_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_290_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_291_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_292_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_293_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_294_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_295_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_296_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_297_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_298_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_299_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_300_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_301_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_302_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_303_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_304_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_305_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_306_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_307_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_308_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_309_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_310_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_311_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_312_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_313_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_314_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_315_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_316_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_317_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_318_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_319_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_320_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_321_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_322_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_323_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_324_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_325_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_326_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_327_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_328_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_329_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_330_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_331_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_332_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_333_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_334_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_335_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_336_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_337_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_338_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_339_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_340_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_341_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_342_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_343_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_344_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_345_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_346_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_347_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_348_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_349_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_350_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_351_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_352_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_353_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_354_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_355_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_356_35(35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num);

exec mgmt$reorg_sendMsg ('Completed Reorganization.  Starting cleanup phase.');

exec mgmt$reorg_cleanup_35 (35, 'SYS.MGMT$REORG_CHECKPOINT', :step_num, 356);

exec mgmt$reorg_sendMsg ('Starting cleanup of generated procedures');

DROP PROCEDURE mgmt$step_1_35;
DROP PROCEDURE mgmt$step_2_35;
DROP PROCEDURE mgmt$step_3_35;
DROP PROCEDURE mgmt$step_4_35;
DROP PROCEDURE mgmt$step_5_35;
DROP PROCEDURE mgmt$step_6_35;
DROP PROCEDURE mgmt$step_7_35;
DROP PROCEDURE mgmt$step_8_35;
DROP PROCEDURE mgmt$step_9_35;
DROP PROCEDURE mgmt$step_10_35;
DROP PROCEDURE mgmt$step_11_35;
DROP PROCEDURE mgmt$step_12_35;
DROP PROCEDURE mgmt$step_13_35;
DROP PROCEDURE mgmt$step_14_35;
DROP PROCEDURE mgmt$step_15_35;
DROP PROCEDURE mgmt$step_16_35;
DROP PROCEDURE mgmt$step_17_35;
DROP PROCEDURE mgmt$step_18_35;
DROP PROCEDURE mgmt$step_19_35;
DROP PROCEDURE mgmt$step_20_35;
DROP PROCEDURE mgmt$step_21_35;
DROP PROCEDURE mgmt$step_22_35;
DROP PROCEDURE mgmt$step_23_35;
DROP PROCEDURE mgmt$step_24_35;
DROP PROCEDURE mgmt$step_25_35;
DROP PROCEDURE mgmt$step_26_35;
DROP PROCEDURE mgmt$step_27_35;
DROP PROCEDURE mgmt$step_28_35;
DROP PROCEDURE mgmt$step_29_35;
DROP PROCEDURE mgmt$step_30_35;
DROP PROCEDURE mgmt$step_31_35;
DROP PROCEDURE mgmt$step_32_35;
DROP PROCEDURE mgmt$step_33_35;
DROP PROCEDURE mgmt$step_34_35;
DROP PROCEDURE mgmt$step_35_35;
DROP PROCEDURE mgmt$step_36_35;
DROP PROCEDURE mgmt$step_37_35;
DROP PROCEDURE mgmt$step_38_35;
DROP PROCEDURE mgmt$step_39_35;
DROP PROCEDURE mgmt$step_40_35;
DROP PROCEDURE mgmt$step_41_35;
DROP PROCEDURE mgmt$step_42_35;
DROP PROCEDURE mgmt$step_43_35;
DROP PROCEDURE mgmt$step_44_35;
DROP PROCEDURE mgmt$step_45_35;
DROP PROCEDURE mgmt$step_46_35;
DROP PROCEDURE mgmt$step_47_35;
DROP PROCEDURE mgmt$step_48_35;
DROP PROCEDURE mgmt$step_49_35;
DROP PROCEDURE mgmt$step_50_35;
DROP PROCEDURE mgmt$step_51_35;
DROP PROCEDURE mgmt$step_52_35;
DROP PROCEDURE mgmt$step_53_35;
DROP PROCEDURE mgmt$step_54_35;
DROP PROCEDURE mgmt$step_55_35;
DROP PROCEDURE mgmt$step_56_35;
DROP PROCEDURE mgmt$step_57_35;
DROP PROCEDURE mgmt$step_58_35;
DROP PROCEDURE mgmt$step_59_35;
DROP PROCEDURE mgmt$step_60_35;
DROP PROCEDURE mgmt$step_61_35;
DROP PROCEDURE mgmt$step_62_35;
DROP PROCEDURE mgmt$step_63_35;
DROP PROCEDURE mgmt$step_64_35;
DROP PROCEDURE mgmt$step_65_35;
DROP PROCEDURE mgmt$step_66_35;
DROP PROCEDURE mgmt$step_67_35;
DROP PROCEDURE mgmt$step_68_35;
DROP PROCEDURE mgmt$step_69_35;
DROP PROCEDURE mgmt$step_70_35;
DROP PROCEDURE mgmt$step_71_35;
DROP PROCEDURE mgmt$step_72_35;
DROP PROCEDURE mgmt$step_73_35;
DROP PROCEDURE mgmt$step_74_35;
DROP PROCEDURE mgmt$step_75_35;
DROP PROCEDURE mgmt$step_76_35;
DROP PROCEDURE mgmt$step_77_35;
DROP PROCEDURE mgmt$step_78_35;
DROP PROCEDURE mgmt$step_79_35;
DROP PROCEDURE mgmt$step_80_35;
DROP PROCEDURE mgmt$step_81_35;
DROP PROCEDURE mgmt$step_82_35;
DROP PROCEDURE mgmt$step_83_35;
DROP PROCEDURE mgmt$step_84_35;
DROP PROCEDURE mgmt$step_85_35;
DROP PROCEDURE mgmt$step_86_35;
DROP PROCEDURE mgmt$step_87_35;
DROP PROCEDURE mgmt$step_88_35;
DROP PROCEDURE mgmt$step_89_35;
DROP PROCEDURE mgmt$step_90_35;
DROP PROCEDURE mgmt$step_91_35;
DROP PROCEDURE mgmt$step_92_35;
DROP PROCEDURE mgmt$step_93_35;
DROP PROCEDURE mgmt$step_94_35;
DROP PROCEDURE mgmt$step_95_35;
DROP PROCEDURE mgmt$step_96_35;
DROP PROCEDURE mgmt$step_97_35;
DROP PROCEDURE mgmt$step_98_35;
DROP PROCEDURE mgmt$step_99_35;
DROP PROCEDURE mgmt$step_100_35;
DROP PROCEDURE mgmt$step_101_35;
DROP PROCEDURE mgmt$step_102_35;
DROP PROCEDURE mgmt$step_103_35;
DROP PROCEDURE mgmt$step_104_35;
DROP PROCEDURE mgmt$step_105_35;
DROP PROCEDURE mgmt$step_106_35;
DROP PROCEDURE mgmt$step_107_35;
DROP PROCEDURE mgmt$step_108_35;
DROP PROCEDURE mgmt$step_109_35;
DROP PROCEDURE mgmt$step_110_35;
DROP PROCEDURE mgmt$step_111_35;
DROP PROCEDURE mgmt$step_112_35;
DROP PROCEDURE mgmt$step_113_35;
DROP PROCEDURE mgmt$step_114_35;
DROP PROCEDURE mgmt$step_115_35;
DROP PROCEDURE mgmt$step_116_35;
DROP PROCEDURE mgmt$step_117_35;
DROP PROCEDURE mgmt$step_118_35;
DROP PROCEDURE mgmt$step_119_35;
DROP PROCEDURE mgmt$step_120_35;
DROP PROCEDURE mgmt$step_121_35;
DROP PROCEDURE mgmt$step_122_35;
DROP PROCEDURE mgmt$step_123_35;
DROP PROCEDURE mgmt$step_124_35;
DROP PROCEDURE mgmt$step_125_35;
DROP PROCEDURE mgmt$step_126_35;
DROP PROCEDURE mgmt$step_127_35;
DROP PROCEDURE mgmt$step_128_35;
DROP PROCEDURE mgmt$step_129_35;
DROP PROCEDURE mgmt$step_130_35;
DROP PROCEDURE mgmt$step_131_35;
DROP PROCEDURE mgmt$step_132_35;
DROP PROCEDURE mgmt$step_133_35;
DROP PROCEDURE mgmt$step_134_35;
DROP PROCEDURE mgmt$step_135_35;
DROP PROCEDURE mgmt$step_136_35;
DROP PROCEDURE mgmt$step_137_35;
DROP PROCEDURE mgmt$step_138_35;
DROP PROCEDURE mgmt$step_139_35;
DROP PROCEDURE mgmt$step_140_35;
DROP PROCEDURE mgmt$step_141_35;
DROP PROCEDURE mgmt$step_142_35;
DROP PROCEDURE mgmt$step_143_35;
DROP PROCEDURE mgmt$step_144_35;
DROP PROCEDURE mgmt$step_145_35;
DROP PROCEDURE mgmt$step_146_35;
DROP PROCEDURE mgmt$step_147_35;
DROP PROCEDURE mgmt$step_148_35;
DROP PROCEDURE mgmt$step_149_35;
DROP PROCEDURE mgmt$step_150_35;
DROP PROCEDURE mgmt$step_151_35;
DROP PROCEDURE mgmt$step_152_35;
DROP PROCEDURE mgmt$step_153_35;
DROP PROCEDURE mgmt$step_154_35;
DROP PROCEDURE mgmt$step_155_35;
DROP PROCEDURE mgmt$step_156_35;
DROP PROCEDURE mgmt$step_157_35;
DROP PROCEDURE mgmt$step_158_35;
DROP PROCEDURE mgmt$step_159_35;
DROP PROCEDURE mgmt$step_160_35;
DROP PROCEDURE mgmt$step_161_35;
DROP PROCEDURE mgmt$step_162_35;
DROP PROCEDURE mgmt$step_163_35;
DROP PROCEDURE mgmt$step_164_35;
DROP PROCEDURE mgmt$step_165_35;
DROP PROCEDURE mgmt$step_166_35;
DROP PROCEDURE mgmt$step_167_35;
DROP PROCEDURE mgmt$step_168_35;
DROP PROCEDURE mgmt$step_169_35;
DROP PROCEDURE mgmt$step_170_35;
DROP PROCEDURE mgmt$step_171_35;
DROP PROCEDURE mgmt$step_172_35;
DROP PROCEDURE mgmt$step_173_35;
DROP PROCEDURE mgmt$step_174_35;
DROP PROCEDURE mgmt$step_175_35;
DROP PROCEDURE mgmt$step_176_35;
DROP PROCEDURE mgmt$step_177_35;
DROP PROCEDURE mgmt$step_178_35;
DROP PROCEDURE mgmt$step_179_35;
DROP PROCEDURE mgmt$step_180_35;
DROP PROCEDURE mgmt$step_181_35;
DROP PROCEDURE mgmt$step_182_35;
DROP PROCEDURE mgmt$step_183_35;
DROP PROCEDURE mgmt$step_184_35;
DROP PROCEDURE mgmt$step_185_35;
DROP PROCEDURE mgmt$step_186_35;
DROP PROCEDURE mgmt$step_187_35;
DROP PROCEDURE mgmt$step_188_35;
DROP PROCEDURE mgmt$step_189_35;
DROP PROCEDURE mgmt$step_190_35;
DROP PROCEDURE mgmt$step_191_35;
DROP PROCEDURE mgmt$step_192_35;
DROP PROCEDURE mgmt$step_193_35;
DROP PROCEDURE mgmt$step_194_35;
DROP PROCEDURE mgmt$step_195_35;
DROP PROCEDURE mgmt$step_196_35;
DROP PROCEDURE mgmt$step_197_35;
DROP PROCEDURE mgmt$step_198_35;
DROP PROCEDURE mgmt$step_199_35;
DROP PROCEDURE mgmt$step_200_35;
DROP PROCEDURE mgmt$step_201_35;
DROP PROCEDURE mgmt$step_202_35;
DROP PROCEDURE mgmt$step_203_35;
DROP PROCEDURE mgmt$step_204_35;
DROP PROCEDURE mgmt$step_205_35;
DROP PROCEDURE mgmt$step_206_35;
DROP PROCEDURE mgmt$step_207_35;
DROP PROCEDURE mgmt$step_208_35;
DROP PROCEDURE mgmt$step_209_35;
DROP PROCEDURE mgmt$step_210_35;
DROP PROCEDURE mgmt$step_211_35;
DROP PROCEDURE mgmt$step_212_35;
DROP PROCEDURE mgmt$step_213_35;
DROP PROCEDURE mgmt$step_214_35;
DROP PROCEDURE mgmt$step_215_35;
DROP PROCEDURE mgmt$step_216_35;
DROP PROCEDURE mgmt$step_217_35;
DROP PROCEDURE mgmt$step_218_35;
DROP PROCEDURE mgmt$step_219_35;
DROP PROCEDURE mgmt$step_220_35;
DROP PROCEDURE mgmt$step_221_35;
DROP PROCEDURE mgmt$step_222_35;
DROP PROCEDURE mgmt$step_223_35;
DROP PROCEDURE mgmt$step_224_35;
DROP PROCEDURE mgmt$step_225_35;
DROP PROCEDURE mgmt$step_226_35;
DROP PROCEDURE mgmt$step_227_35;
DROP PROCEDURE mgmt$step_228_35;
DROP PROCEDURE mgmt$step_229_35;
DROP PROCEDURE mgmt$step_230_35;
DROP PROCEDURE mgmt$step_231_35;
DROP PROCEDURE mgmt$step_232_35;
DROP PROCEDURE mgmt$step_233_35;
DROP PROCEDURE mgmt$step_234_35;
DROP PROCEDURE mgmt$step_235_35;
DROP PROCEDURE mgmt$step_236_35;
DROP PROCEDURE mgmt$step_237_35;
DROP PROCEDURE mgmt$step_238_35;
DROP PROCEDURE mgmt$step_239_35;
DROP PROCEDURE mgmt$step_240_35;
DROP PROCEDURE mgmt$step_241_35;
DROP PROCEDURE mgmt$step_242_35;
DROP PROCEDURE mgmt$step_243_35;
DROP PROCEDURE mgmt$step_244_35;
DROP PROCEDURE mgmt$step_245_35;
DROP PROCEDURE mgmt$step_246_35;
DROP PROCEDURE mgmt$step_247_35;
DROP PROCEDURE mgmt$step_248_35;
DROP PROCEDURE mgmt$step_249_35;
DROP PROCEDURE mgmt$step_250_35;
DROP PROCEDURE mgmt$step_251_35;
DROP PROCEDURE mgmt$step_252_35;
DROP PROCEDURE mgmt$step_253_35;
DROP PROCEDURE mgmt$step_254_35;
DROP PROCEDURE mgmt$step_255_35;
DROP PROCEDURE mgmt$step_256_35;
DROP PROCEDURE mgmt$step_257_35;
DROP PROCEDURE mgmt$step_258_35;
DROP PROCEDURE mgmt$step_259_35;
DROP PROCEDURE mgmt$step_260_35;
DROP PROCEDURE mgmt$step_261_35;
DROP PROCEDURE mgmt$step_262_35;
DROP PROCEDURE mgmt$step_263_35;
DROP PROCEDURE mgmt$step_264_35;
DROP PROCEDURE mgmt$step_265_35;
DROP PROCEDURE mgmt$step_266_35;
DROP PROCEDURE mgmt$step_267_35;
DROP PROCEDURE mgmt$step_268_35;
DROP PROCEDURE mgmt$step_269_35;
DROP PROCEDURE mgmt$step_270_35;
DROP PROCEDURE mgmt$step_271_35;
DROP PROCEDURE mgmt$step_272_35;
DROP PROCEDURE mgmt$step_273_35;
DROP PROCEDURE mgmt$step_274_35;
DROP PROCEDURE mgmt$step_275_35;
DROP PROCEDURE mgmt$step_276_35;
DROP PROCEDURE mgmt$step_277_35;
DROP PROCEDURE mgmt$step_278_35;
DROP PROCEDURE mgmt$step_279_35;
DROP PROCEDURE mgmt$step_280_35;
DROP PROCEDURE mgmt$step_281_35;
DROP PROCEDURE mgmt$step_282_35;
DROP PROCEDURE mgmt$step_283_35;
DROP PROCEDURE mgmt$step_284_35;
DROP PROCEDURE mgmt$step_285_35;
DROP PROCEDURE mgmt$step_286_35;
DROP PROCEDURE mgmt$step_287_35;
DROP PROCEDURE mgmt$step_288_35;
DROP PROCEDURE mgmt$step_289_35;
DROP PROCEDURE mgmt$step_290_35;
DROP PROCEDURE mgmt$step_291_35;
DROP PROCEDURE mgmt$step_292_35;
DROP PROCEDURE mgmt$step_293_35;
DROP PROCEDURE mgmt$step_294_35;
DROP PROCEDURE mgmt$step_295_35;
DROP PROCEDURE mgmt$step_296_35;
DROP PROCEDURE mgmt$step_297_35;
DROP PROCEDURE mgmt$step_298_35;
DROP PROCEDURE mgmt$step_299_35;
DROP PROCEDURE mgmt$step_300_35;
DROP PROCEDURE mgmt$step_301_35;
DROP PROCEDURE mgmt$step_302_35;
DROP PROCEDURE mgmt$step_303_35;
DROP PROCEDURE mgmt$step_304_35;
DROP PROCEDURE mgmt$step_305_35;
DROP PROCEDURE mgmt$step_306_35;
DROP PROCEDURE mgmt$step_307_35;
DROP PROCEDURE mgmt$step_308_35;
DROP PROCEDURE mgmt$step_309_35;
DROP PROCEDURE mgmt$step_310_35;
DROP PROCEDURE mgmt$step_311_35;
DROP PROCEDURE mgmt$step_312_35;
DROP PROCEDURE mgmt$step_313_35;
DROP PROCEDURE mgmt$step_314_35;
DROP PROCEDURE mgmt$step_315_35;
DROP PROCEDURE mgmt$step_316_35;
DROP PROCEDURE mgmt$step_317_35;
DROP PROCEDURE mgmt$step_318_35;
DROP PROCEDURE mgmt$step_319_35;
DROP PROCEDURE mgmt$step_320_35;
DROP PROCEDURE mgmt$step_321_35;
DROP PROCEDURE mgmt$step_322_35;
DROP PROCEDURE mgmt$step_323_35;
DROP PROCEDURE mgmt$step_324_35;
DROP PROCEDURE mgmt$step_325_35;
DROP PROCEDURE mgmt$step_326_35;
DROP PROCEDURE mgmt$step_327_35;
DROP PROCEDURE mgmt$step_328_35;
DROP PROCEDURE mgmt$step_329_35;
DROP PROCEDURE mgmt$step_330_35;
DROP PROCEDURE mgmt$step_331_35;
DROP PROCEDURE mgmt$step_332_35;
DROP PROCEDURE mgmt$step_333_35;
DROP PROCEDURE mgmt$step_334_35;
DROP PROCEDURE mgmt$step_335_35;
DROP PROCEDURE mgmt$step_336_35;
DROP PROCEDURE mgmt$step_337_35;
DROP PROCEDURE mgmt$step_338_35;
DROP PROCEDURE mgmt$step_339_35;
DROP PROCEDURE mgmt$step_340_35;
DROP PROCEDURE mgmt$step_341_35;
DROP PROCEDURE mgmt$step_342_35;
DROP PROCEDURE mgmt$step_343_35;
DROP PROCEDURE mgmt$step_344_35;
DROP PROCEDURE mgmt$step_345_35;
DROP PROCEDURE mgmt$step_346_35;
DROP PROCEDURE mgmt$step_347_35;
DROP PROCEDURE mgmt$step_348_35;
DROP PROCEDURE mgmt$step_349_35;
DROP PROCEDURE mgmt$step_350_35;
DROP PROCEDURE mgmt$step_351_35;
DROP PROCEDURE mgmt$step_352_35;
DROP PROCEDURE mgmt$step_353_35;
DROP PROCEDURE mgmt$step_354_35;
DROP PROCEDURE mgmt$step_355_35;
DROP PROCEDURE mgmt$step_356_35;

DROP PROCEDURE mgmt$reorg_cleanup_35;
DROP PROCEDURE mgmt$reorg_commentheader_35;

exec mgmt$reorg_sendMsg ('Completed cleanup of generated procedures');

exec mgmt$reorg_sendMsg ('Script execution complete');

spool off
set pagesize 24
set serveroutput off
set feedback on
set echo on
