set echo off
set feedback off
set serveroutput on
set pagesize 0

spool C:\oracle\product\10.1.0\db_1\dbs\reorg41.log

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

CREATE OR REPLACE PROCEDURE mgmt$step_1_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 1 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('CREATE  SMALLFILE  TABLESPACE "HARVESTINDEX_REORG0" DATAFILE ''C:\WINDOWS\SYSTEM32\HARDEV1INDEX_REORG0_reorg0.ORA'' SIZE 50M REUSE  AUTOEXTEND ON NEXT 5120K MAXSIZE 32767M LOGGING  EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  MANUAL ');
      EXECUTE IMMEDIATE 'CREATE  SMALLFILE  TABLESPACE "HARVESTINDEX_REORG0" DATAFILE ''C:\WINDOWS\SYSTEM32\HARDEV1INDEX_REORG0_reorg0.ORA'' SIZE 50M REUSE  AUTOEXTEND ON NEXT 5120K MAXSIZE 32767M LOGGING  EXTENT MANAGEMENT LOCAL SEGMENT SPACE MANAGEMENT  MANUAL ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_1_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_2_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 2 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_SERVER_ALERT.SET_THRESHOLD(9000,NULL,NULL,NULL,NULL,1,1,NULL,5,''HARVESTINDEX_REORG0''); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_SERVER_ALERT.SET_THRESHOLD(9000,NULL,NULL,NULL,NULL,1,1,NULL,5,''HARVESTINDEX_REORG0''); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_2_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_3_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 3 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER USER "HRVSTUSER" QUOTA UNLIMITED ON "HARVESTINDEX_REORG0"');
      EXECUTE IMMEDIATE 'ALTER USER "HRVSTUSER" QUOTA UNLIMITED ON "HARVESTINDEX_REORG0"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_3_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_4_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 4 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."UNQ_FORMTABLENAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."UNQ_FORMTABLENAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_4_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_5_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 5 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"UNQ_FORMTABLENAME"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"UNQ_FORMTABLENAME"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_5_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_6_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 6 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005529" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005529" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_6_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_7_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 7 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005529"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005529"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_7_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_8_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 8 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005528" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005528" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_8_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_9_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 9 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005528"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005528"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_9_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_10_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 10 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005526" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005526" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_10_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_11_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 11 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005526"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005526"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_11_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_12_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 12 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005524" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005524" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_12_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_13_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 13 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005524"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005524"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_13_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_14_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 14 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005523" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005523" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_14_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_15_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 15 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005523"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005523"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_15_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_16_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 16 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005519" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005519" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_16_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_17_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 17 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005519"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005519"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_17_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_18_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 18 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005518" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005518" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_18_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_19_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 19 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005518"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005518"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_19_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_20_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 20 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005513" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005513" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_20_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_21_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 21 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005513"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005513"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_21_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_22_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 22 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005512" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005512" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_22_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_23_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 23 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005512"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005512"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_23_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_24_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 24 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005511" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005511" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_24_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_25_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 25 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005511"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005511"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_25_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_26_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 26 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005510" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005510" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_26_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_27_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 27 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005510"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005510"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_27_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_28_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 28 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005509" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005509" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_28_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_29_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 29 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005509"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005509"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_29_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_30_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 30 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005508" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005508" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_30_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_31_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 31 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005508"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005508"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_31_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_32_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 32 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005502" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005502" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_32_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_33_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 33 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005502"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005502"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_33_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_34_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 34 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005501" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005501" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_34_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_35_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 35 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005501"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005501"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_35_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_36_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 36 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005499" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005499" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_36_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_37_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 37 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005499"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005499"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_37_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_38_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 38 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005497" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005497" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_38_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_39_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 39 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005497"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005497"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_39_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_40_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 40 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005496" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005496" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_40_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_41_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 41 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005496"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005496"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_41_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_42_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 42 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005495" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005495" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_42_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_43_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 43 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005495"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005495"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_43_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_44_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 44 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005494" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005494" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_44_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_45_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 45 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005494"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005494"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_45_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_46_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 46 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005490" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005490" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_46_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_47_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 47 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005490"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005490"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_47_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_48_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 48 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005488" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005488" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_48_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_49_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 49 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005488"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005488"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_49_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_50_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 50 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005486" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005486" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_50_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_51_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 51 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005486"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005486"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_51_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_52_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 52 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005481" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005481" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_52_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_53_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 53 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005481"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005481"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_53_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_54_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 54 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005478" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005478" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_54_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_55_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 55 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005478"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005478"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_55_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_56_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 56 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005477" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005477" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_56_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_57_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 57 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005477"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005477"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_57_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_58_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 58 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005476" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005476" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_58_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_59_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 59 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005476"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005476"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_59_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_60_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 60 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005475" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005475" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_60_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_61_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 61 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005475"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005475"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_61_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_62_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 62 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005474" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005474" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_62_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_63_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 63 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005474"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005474"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_63_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_64_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 64 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005473" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005473" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_64_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_65_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 65 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005473"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005473"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_65_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_66_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 66 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005472" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005472" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_66_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_67_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 67 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005472"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005472"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_67_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_68_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 68 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005471" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005471" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_68_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_69_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 69 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005471"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005471"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_69_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_70_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 70 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."SYS_C005470" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."SYS_C005470" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_70_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_71_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 71 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005470"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"SYS_C005470"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_71_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_72_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 72 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."P_UKEY" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."P_UKEY" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_72_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_73_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 73 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"P_UKEY"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"P_UKEY"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_73_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_74_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 74 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIV_VERS_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIV_VERS_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_74_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_75_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 75 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIV_VERS_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIV_VERS_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_75_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_76_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 76 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_VIEWTYPE" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_VIEWTYPE" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_76_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_77_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 77 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_VIEWTYPE"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_VIEWTYPE"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_77_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_78_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 78 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_78_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_79_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 79 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_79_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_80_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 80 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_80_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_81_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 81 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_OBJIDNAME"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_OBJIDNAME"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_81_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_82_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 82 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVIEW_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVIEW_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_82_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_83_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 83 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_NAME_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVIEW_NAME_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_83_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_84_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 84 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_VSTATUS" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_VSTATUS" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_84_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_85_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 85 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_VSTATUS"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_VSTATUS"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_85_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_86_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 86 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_VERITEM" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_VERITEM" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_86_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_87_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 87 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_VERITEM"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_VERITEM"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_87_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_88_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 88 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_VC" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_VC" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_88_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_89_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 89 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_VC"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_VC"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_89_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_90_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 90 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_STATUS" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_STATUS" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_90_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_91_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 91 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_STATUS"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_STATUS"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_91_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_92_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 92 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_92_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_93_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 93 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_PKG_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_PKG_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_93_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_94_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 94 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_94_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_95_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 95 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_95_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_96_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 96 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_PAR_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_PAR_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_96_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_97_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 97 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_PAR_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_PAR_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_97_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_98_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 98 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_MERGED_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_MERGED_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_98_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_99_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 99 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_MERGED_IDX"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_MERGED_IDX"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_99_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_100_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 100 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_100_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_101_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 101 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_ITEM_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_ITEM_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_101_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_102_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 102 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMOBJID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMOBJID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_102_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_103_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 103 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_ITEMOBJID"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_ITEMOBJID"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_103_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_104_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 104 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMMAPPED" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONS_ITEMMAPPED" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_104_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_105_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 105 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_ITEMMAPPED"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONS_ITEMMAPPED"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_105_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_106_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 106 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_106_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_107_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 107 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONINVIEW_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONINVIEW_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_107_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_108_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 108 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_108_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_109_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 109 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDELTA_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDELTA_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_109_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_110_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 110 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PARENT" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDELTA_PARENT" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_110_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_111_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 111 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDELTA_PARENT"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDELTA_PARENT"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_111_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_112_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 112 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_112_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_113_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 113 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDATA_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDATA_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_113_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_114_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 114 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_ITMID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARVERSIONDATA_ITMID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_114_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_115_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 115 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDATA_ITMID_FK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARVERSIONDATA_ITMID_FK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_115_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_116_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 116 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSER_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSER_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_116_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_117_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 117 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSER_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSER_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_117_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_118_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 118 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSER_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSER_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_118_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_119_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 119 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSER_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSER_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_119_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_120_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 120 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSERGROUP_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSERGROUP_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_120_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_121_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 121 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSERGROUP_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSERGROUP_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_121_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_122_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 122 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSERDATA_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSERDATA_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_122_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_123_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 123 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSERDATA_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSERDATA_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_123_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_124_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 124 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDPLATFORMINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDPLATFORMINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_124_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_125_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 125 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDPLATFORMINFO_FRM_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDPLATFORMINFO_FRM_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_125_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_126_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 126 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDPACKAGENAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDPACKAGENAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_126_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_127_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 127 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGENAMES_NAME_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGENAMES_NAME_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_127_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_128_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 128 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDPACKAGEINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDPACKAGEINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_128_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_129_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 129 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGEINFO_FRM_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDPACKAGEINFO_FRM_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_129_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_130_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 130 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDGROUPNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDGROUPNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_130_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_131_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 131 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDGROUPNAMES_NAME_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDGROUPNAMES_NAME_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_131_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_132_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 132 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_PKG_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_132_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_133_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 133 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO_PKG_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO_PKG_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_133_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_134_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 134 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_FRM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_134_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_135_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 135 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO_FRM_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO_FRM_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_135_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_136_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 136 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_ATTACH_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDDEPLOYINFO_ATTACH_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_136_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_137_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 137 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO_ATTACH_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDDEPLOYINFO_ATTACH_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_137_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_138_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 138 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARUSDCOMPUTERNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARUSDCOMPUTERNAMES_NAME_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_138_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_139_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 139 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDCOMPUTERNAMES_NAME_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARUSDCOMPUTERNAMES_NAME_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_139_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_140_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 140 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSWITCHPKGPROC_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSWITCHPKGPROC_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_140_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_141_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 141 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSWITCHPKGPROC_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSWITCHPKGPROC_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_141_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_142_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 142 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATE_LIST" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATE_LIST" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_142_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_143_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 143 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATE_LIST"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATE_LIST"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_143_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_144_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 144 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATE_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATE_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_144_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_145_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 145 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATE_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATE_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_145_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_146_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 146 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATE_ENVOBJID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATE_ENVOBJID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_146_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_147_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 147 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATE_ENVOBJID"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATE_ENVOBJID"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_147_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_148_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 148 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEPROC_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEPROC_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_148_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_149_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 149 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEPROC_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEPROC_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_149_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_150_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 150 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEPROCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEPROCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_150_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_151_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 151 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_151_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_152_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 152 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEPROCESSACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEPROCESSACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_152_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_153_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 153 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESSACCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEPROCESSACCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_153_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_154_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 154 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARSTATEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARSTATEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_154_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_155_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 155 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEACCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARSTATEACCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_155_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_156_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 156 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPOSITORY_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPOSITORY_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_156_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_157_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 157 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPOSITORY_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPOSITORY_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_157_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_158_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 158 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPOSITORY_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPOSITORY_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_158_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_159_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 159 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPOSITORY_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPOSITORY_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_159_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_160_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 160 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPINVIEW_REPID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPINVIEW_REPID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_160_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_161_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 161 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPINVIEW_REPID_FK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPINVIEW_REPID_FK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_161_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_162_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 162 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPINVIEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_162_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_163_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 163 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPINVIEW_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPINVIEW_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_163_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_164_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 164 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARREPACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARREPACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_164_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_165_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 165 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPACCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARREPACCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_165_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_166_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 166 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARRENAMEITEMPROC_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARRENAMEITEMPROC_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_166_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_167_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 167 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARRENAMEITEMPROC_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARRENAMEITEMPROC_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_167_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_168_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 168 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGSINPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGSINPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_168_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_169_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 169 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGSINPKGGRP_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGSINPKGGRP_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_169_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_170_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 170 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGSINCMEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGSINCMEW_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_170_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_171_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 171 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGSINCMEW_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGSINCMEW_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_171_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_172_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 172 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGHIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGHIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_172_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_173_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 173 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGHIST_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGHIST_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_173_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_174_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 174 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPKGGRP_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_174_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_175_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 175 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGGRP_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPKGGRP_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_175_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_176_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 176 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PUPPER" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PUPPER" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_176_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_177_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 177 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME_PUPPER"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME_PUPPER"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_177_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_178_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 178 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_178_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_179_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 179 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_179_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_180_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 180 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PATH" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPATHFULLNAME_PATH" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_180_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_181_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 181 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME_PATH"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPATHFULLNAME_PATH"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_181_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_182_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 182 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND_ENV" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND_ENV" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_182_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_183_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 183 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGE_IND_ENV"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGE_IND_ENV"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_183_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_184_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 184 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGE_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_184_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_185_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 185 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGE_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGE_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_185_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_186_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 186 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_S_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_S_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_186_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_187_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 187 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS_S_IDX"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS_S_IDX"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_187_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_188_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 188 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_188_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_189_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 189 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_189_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_190_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 190 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_C_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGESTATUS_C_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_190_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_191_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 191 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS_C_IDX"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGESTATUS_C_IDX"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_191_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_192_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 192 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGENAMEGEN_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGENAMEGEN_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_192_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_193_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 193 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGENAMEGEN_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGENAMEGEN_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_193_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_194_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 194 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARPACKAGEGROUP_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARPACKAGEGROUP_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_194_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_195_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 195 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGEGROUP_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARPACKAGEGROUP_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_195_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_196_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 196 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HAROBJECTSEQUENCEID_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HAROBJECTSEQUENCEID_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_196_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_197_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 197 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HAROBJECTSEQUENCEID_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HAROBJECTSEQUENCEID_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_197_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_198_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 198 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARNOTIFYLIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARNOTIFYLIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_198_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_199_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 199 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARNOTIFYLIST_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARNOTIFYLIST_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_199_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_200_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 200 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARMR_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARMR_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_200_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_201_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 201 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARMR_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARMR_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_201_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_202_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 202 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_POBJID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_POBJID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_202_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_203_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 203 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS_POBJID"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS_POBJID"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_203_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_204_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 204 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_PARENT" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_PARENT" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_204_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_205_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 205 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS_PARENT"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS_PARENT"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_205_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_206_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 206 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARLINKEDPROCESS_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_206_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_207_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 207 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARLINKEDPROCESS_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_207_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_208_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 208 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_REPID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_REPID" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_208_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_209_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 209 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_REPID"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_REPID"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_209_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_210_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 210 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_210_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_211_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 211 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_211_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_212_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 212 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_PID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_PID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_212_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_213_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 213 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_PID_FK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_PID_FK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_213_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_214_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 214 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_PARENTTYPE" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_PARENTTYPE" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_214_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_215_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 215 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_PARENTTYPE"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_PARENTTYPE"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_215_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_216_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 216 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAMEUPPER" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAMEUPPER" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_216_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_217_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 217 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_ITEMNAMEUPPER"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_ITEMNAMEUPPER"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_217_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_218_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 218 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_ITEMNAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_218_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_219_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 219 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_ITEMNAME"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_ITEMNAME"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_219_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_220_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 220 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMS_IND_TYPE" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMS_IND_TYPE" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_220_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_221_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 221 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_IND_TYPE"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMS_IND_TYPE"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_221_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_222_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 222 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_REFITM_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_REFITM_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_222_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_223_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 223 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMRELATIONSHIP_REFITM_IDX"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMRELATIONSHIP_REFITM_IDX"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_223_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_224_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 224 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMRELATIONSHIP_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_224_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_225_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 225 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMRELATIONSHIP_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMRELATIONSHIP_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_225_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_226_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 226 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMACCESS_VIEW" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMACCESS_VIEW" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_226_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_227_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 227 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS_VIEW"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS_VIEW"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_227_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_228_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 228 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMACCESS_USRGRP" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMACCESS_USRGRP" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_228_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_229_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 229 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS_USRGRP"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS_USRGRP"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_229_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_230_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 230 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARITEMACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARITEMACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_230_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_231_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 231 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARITEMACCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_231_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_232_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 232 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARHARVEST_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARHARVEST_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_232_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_233_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 233 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARHARVEST_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARHARVEST_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_233_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_234_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 234 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORM_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORM_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_234_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_235_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 235 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORM_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORM_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_235_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_236_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 236 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORM_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_236_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_237_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 237 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORM_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORM_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_237_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_238_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 238 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPE_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPE_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_238_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_239_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 239 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPE_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPE_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_239_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_240_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 240 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_COL" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_COL" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_240_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_241_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 241 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEF_COL"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEF_COL"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_241_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_242_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 242 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_ALT" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEF_ALT" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_242_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_243_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 243 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEF_ALT"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEF_ALT"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_243_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_244_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 244 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEFS_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEDEFS_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_244_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_245_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 245 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEFS_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEDEFS_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_245_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_246_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 246 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMTYPEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMTYPEACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_246_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_247_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 247 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEACCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMTYPEACCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_247_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_248_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 248 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMHIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMHIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_248_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_249_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 249 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMHIST_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMHIST_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_249_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_250_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 250 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_250_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_251_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 251 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_251_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_252_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 252 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND2" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND2" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_252_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_253_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 253 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT_IND2"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT_IND2"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_253_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_254_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 254 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFORMATTACHMENT_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_254_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_255_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 255 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFORMATTACHMENT_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_255_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_256_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 256 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARFILEEXTENSION_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARFILEEXTENSION_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_256_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_257_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 257 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFILEEXTENSION_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARFILEEXTENSION_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_257_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_258_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 258 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_258_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_259_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 259 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENT_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENT_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_259_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_260_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 260 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARENVIRONMENT_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_260_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_261_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 261 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENT_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARENVIRONMENT_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_261_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_262_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 262 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARENVACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARENVACCESS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_262_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_263_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 263 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARENVACCESS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARENVACCESS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_263_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_264_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 264 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARCHECKINPROC_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARCHECKINPROC_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_264_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_265_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 265 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARCHECKINPROC_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARCHECKINPROC_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_265_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_266_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 266 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARBRANCH_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARBRANCH_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_266_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_267_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 267 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARBRANCH_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARBRANCH_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_267_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_268_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 268 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARBRANCH_ITEMID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARBRANCH_ITEMID_FK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_268_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_269_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 269 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARBRANCH_ITEMID_FK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARBRANCH_ITEMID_FK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_269_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_270_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 270 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARASSOCPKG_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARASSOCPKG_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_270_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_271_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 271 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARASSOCPKG_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARASSOCPKG_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_271_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_272_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 272 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARASSOCPKG_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARASSOCPKG_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_272_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_273_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 273 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARASSOCPKG_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARASSOCPKG_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_273_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_274_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 274 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPROVE_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPROVE_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_274_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_275_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 275 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPROVE_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPROVE_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_275_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_276_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 276 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPROVELIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPROVELIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_276_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_277_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 277 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPROVELIST_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPROVELIST_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_277_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_278_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 278 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPROVEHIST_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPROVEHIST_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_278_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_279_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 279 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPROVEHIST_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPROVEHIST_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_279_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_280_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 280 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARAPPRHIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARAPPRHIST_IND" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_280_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_281_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 281 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPRHIST_IND"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARAPPRHIST_IND"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_281_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_282_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 282 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLUSERS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLUSERS_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_282_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_283_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 283 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLUSERS_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLUSERS_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_283_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_284_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 284 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLUSERS_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLUSERS_OBJIDNAME" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_284_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_285_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 285 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLUSERS_OBJIDNAME"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLUSERS_OBJIDNAME"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_285_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_286_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 286 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_PK" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_286_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_287_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 287 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLCHILDRENPATH_PK"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLCHILDRENPATH_PK"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_287_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_288_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 288 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_CLD_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ');
      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."HARALLCHILDRENPATH_CLD_IDX" REBUILD TABLESPACE "HARVESTINDEX_REORG0" ';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_288_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_289_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 289 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLCHILDRENPATH_CLD_IDX"'', estimate_percent=>NULL); END;');
      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_INDEX_STATS(''"HRVSTUSER"'', ''"HARALLCHILDRENPATH_CLD_IDX"'', estimate_percent=>NULL); END;';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_289_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_290_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 290 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER USER "HRVSTUSER" QUOTA 0K ON "HARVESTINDEX"');
      EXECUTE IMMEDIATE 'ALTER USER "HRVSTUSER" QUOTA 0K ON "HARVESTINDEX"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_290_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_291_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 291 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_dropTbsp('"HARVESTINDEX"');
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_291_41;
/

CREATE OR REPLACE PROCEDURE mgmt$step_292_41(script_id IN INTEGER, job_table IN VARCHAR2, step_num IN OUT INTEGER)
AUTHID CURRENT_USER IS
    sqlerr_msg VARCHAR2(100);
BEGIN
    IF step_num <> 292 THEN
      return;
    END IF;

    mgmt$reorg_setStep (41, 'system.MGMT$REORG_CHECKPOINT', step_num);
    step_num := step_num + 1;
    BEGIN
      mgmt$reorg_sendMsg ('ALTER TABLESPACE "HARVESTINDEX_REORG0" RENAME TO "HARVESTINDEX"');
      EXECUTE IMMEDIATE 'ALTER TABLESPACE "HARVESTINDEX_REORG0" RENAME TO "HARVESTINDEX"';
    EXCEPTION
      WHEN OTHERS THEN
        sqlerr_msg := SUBSTR(SQLERRM, 1, 100);
        mgmt$reorg_errorExitOraError('ERROR executing steps ',  sqlerr_msg);
        step_num := -1;
        return;
    END;
END mgmt$step_292_41;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_cleanup_41 (script_id IN INTEGER, job_table IN VARCHAR2, step_num IN INTEGER, highest_step IN INTEGER)
AUTHID CURRENT_USER IS
BEGIN
    IF step_num <= highest_step THEN
      return;
    END IF;

    mgmt$reorg_sendMsg ('Starting cleanup of recovery tables');

    mgmt$reorg_deleteJobTableEntry(script_id, job_table, step_num, highest_step);

    mgmt$reorg_sendMsg ('Completed cleanup of recovery tables');
END mgmt$reorg_cleanup_41;
/

CREATE OR REPLACE PROCEDURE mgmt$reorg_commentheader_41 IS
BEGIN
     mgmt$reorg_sendMsg ('--   Target database:	hardev1');
     mgmt$reorg_sendMsg ('--   Script generated at:	13-FEB-2007   08:18');
END mgmt$reorg_commentheader_41;
/

-- Script Execution Controller
-- ==============================================

variable step_num number;
exec mgmt$reorg_commentheader_41;
exec mgmt$reorg_sendMsg ('Starting reorganization');
exec mgmt$reorg_sendMsg ('Executing as user: ' || 'system');
exec mgmt$reorg_checkDBAPrivs ('system');
exec mgmt$reorg_setupJobTable (41, 'system.MGMT$REORG_CHECKPOINT', :step_num);

exec mgmt$step_1_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_2_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_3_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_4_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_5_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_6_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_7_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_8_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_9_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_10_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_11_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_12_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_13_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_14_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_15_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_16_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_17_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_18_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_19_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_20_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_21_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_22_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_23_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_24_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_25_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_26_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_27_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_28_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_29_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_30_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_31_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_32_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_33_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_34_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_35_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_36_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_37_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_38_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_39_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_40_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_41_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_42_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_43_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_44_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_45_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_46_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_47_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_48_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_49_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_50_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_51_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_52_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_53_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_54_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_55_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_56_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_57_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_58_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_59_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_60_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_61_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_62_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_63_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_64_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_65_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_66_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_67_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_68_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_69_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_70_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_71_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_72_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_73_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_74_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_75_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_76_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_77_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_78_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_79_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_80_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_81_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_82_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_83_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_84_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_85_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_86_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_87_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_88_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_89_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_90_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_91_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_92_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_93_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_94_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_95_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_96_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_97_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_98_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_99_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_100_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_101_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_102_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_103_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_104_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_105_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_106_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_107_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_108_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_109_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_110_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_111_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_112_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_113_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_114_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_115_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_116_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_117_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_118_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_119_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_120_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_121_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_122_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_123_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_124_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_125_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_126_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_127_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_128_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_129_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_130_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_131_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_132_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_133_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_134_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_135_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_136_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_137_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_138_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_139_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_140_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_141_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_142_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_143_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_144_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_145_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_146_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_147_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_148_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_149_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_150_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_151_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_152_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_153_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_154_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_155_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_156_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_157_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_158_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_159_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_160_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_161_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_162_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_163_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_164_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_165_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_166_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_167_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_168_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_169_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_170_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_171_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_172_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_173_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_174_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_175_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_176_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_177_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_178_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_179_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_180_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_181_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_182_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_183_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_184_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_185_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_186_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_187_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_188_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_189_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_190_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_191_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_192_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_193_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_194_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_195_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_196_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_197_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_198_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_199_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_200_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_201_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_202_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_203_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_204_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_205_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_206_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_207_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_208_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_209_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_210_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_211_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_212_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_213_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_214_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_215_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_216_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_217_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_218_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_219_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_220_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_221_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_222_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_223_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_224_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_225_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_226_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_227_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_228_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_229_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_230_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_231_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_232_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_233_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_234_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_235_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_236_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_237_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_238_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_239_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_240_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_241_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_242_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_243_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_244_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_245_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_246_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_247_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_248_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_249_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_250_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_251_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_252_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_253_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_254_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_255_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_256_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_257_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_258_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_259_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_260_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_261_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_262_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_263_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_264_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_265_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_266_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_267_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_268_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_269_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_270_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_271_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_272_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_273_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_274_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_275_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_276_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_277_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_278_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_279_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_280_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_281_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_282_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_283_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_284_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_285_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_286_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_287_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_288_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_289_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_290_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_291_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);
exec mgmt$step_292_41(41, 'system.MGMT$REORG_CHECKPOINT', :step_num);

exec mgmt$reorg_sendMsg ('Completed Reorganization.  Starting cleanup phase.');

exec mgmt$reorg_cleanup_41 (41, 'system.MGMT$REORG_CHECKPOINT', :step_num, 292);

exec mgmt$reorg_sendMsg ('Starting cleanup of generated procedures');

DROP PROCEDURE mgmt$step_1_41;
DROP PROCEDURE mgmt$step_2_41;
DROP PROCEDURE mgmt$step_3_41;
DROP PROCEDURE mgmt$step_4_41;
DROP PROCEDURE mgmt$step_5_41;
DROP PROCEDURE mgmt$step_6_41;
DROP PROCEDURE mgmt$step_7_41;
DROP PROCEDURE mgmt$step_8_41;
DROP PROCEDURE mgmt$step_9_41;
DROP PROCEDURE mgmt$step_10_41;
DROP PROCEDURE mgmt$step_11_41;
DROP PROCEDURE mgmt$step_12_41;
DROP PROCEDURE mgmt$step_13_41;
DROP PROCEDURE mgmt$step_14_41;
DROP PROCEDURE mgmt$step_15_41;
DROP PROCEDURE mgmt$step_16_41;
DROP PROCEDURE mgmt$step_17_41;
DROP PROCEDURE mgmt$step_18_41;
DROP PROCEDURE mgmt$step_19_41;
DROP PROCEDURE mgmt$step_20_41;
DROP PROCEDURE mgmt$step_21_41;
DROP PROCEDURE mgmt$step_22_41;
DROP PROCEDURE mgmt$step_23_41;
DROP PROCEDURE mgmt$step_24_41;
DROP PROCEDURE mgmt$step_25_41;
DROP PROCEDURE mgmt$step_26_41;
DROP PROCEDURE mgmt$step_27_41;
DROP PROCEDURE mgmt$step_28_41;
DROP PROCEDURE mgmt$step_29_41;
DROP PROCEDURE mgmt$step_30_41;
DROP PROCEDURE mgmt$step_31_41;
DROP PROCEDURE mgmt$step_32_41;
DROP PROCEDURE mgmt$step_33_41;
DROP PROCEDURE mgmt$step_34_41;
DROP PROCEDURE mgmt$step_35_41;
DROP PROCEDURE mgmt$step_36_41;
DROP PROCEDURE mgmt$step_37_41;
DROP PROCEDURE mgmt$step_38_41;
DROP PROCEDURE mgmt$step_39_41;
DROP PROCEDURE mgmt$step_40_41;
DROP PROCEDURE mgmt$step_41_41;
DROP PROCEDURE mgmt$step_42_41;
DROP PROCEDURE mgmt$step_43_41;
DROP PROCEDURE mgmt$step_44_41;
DROP PROCEDURE mgmt$step_45_41;
DROP PROCEDURE mgmt$step_46_41;
DROP PROCEDURE mgmt$step_47_41;
DROP PROCEDURE mgmt$step_48_41;
DROP PROCEDURE mgmt$step_49_41;
DROP PROCEDURE mgmt$step_50_41;
DROP PROCEDURE mgmt$step_51_41;
DROP PROCEDURE mgmt$step_52_41;
DROP PROCEDURE mgmt$step_53_41;
DROP PROCEDURE mgmt$step_54_41;
DROP PROCEDURE mgmt$step_55_41;
DROP PROCEDURE mgmt$step_56_41;
DROP PROCEDURE mgmt$step_57_41;
DROP PROCEDURE mgmt$step_58_41;
DROP PROCEDURE mgmt$step_59_41;
DROP PROCEDURE mgmt$step_60_41;
DROP PROCEDURE mgmt$step_61_41;
DROP PROCEDURE mgmt$step_62_41;
DROP PROCEDURE mgmt$step_63_41;
DROP PROCEDURE mgmt$step_64_41;
DROP PROCEDURE mgmt$step_65_41;
DROP PROCEDURE mgmt$step_66_41;
DROP PROCEDURE mgmt$step_67_41;
DROP PROCEDURE mgmt$step_68_41;
DROP PROCEDURE mgmt$step_69_41;
DROP PROCEDURE mgmt$step_70_41;
DROP PROCEDURE mgmt$step_71_41;
DROP PROCEDURE mgmt$step_72_41;
DROP PROCEDURE mgmt$step_73_41;
DROP PROCEDURE mgmt$step_74_41;
DROP PROCEDURE mgmt$step_75_41;
DROP PROCEDURE mgmt$step_76_41;
DROP PROCEDURE mgmt$step_77_41;
DROP PROCEDURE mgmt$step_78_41;
DROP PROCEDURE mgmt$step_79_41;
DROP PROCEDURE mgmt$step_80_41;
DROP PROCEDURE mgmt$step_81_41;
DROP PROCEDURE mgmt$step_82_41;
DROP PROCEDURE mgmt$step_83_41;
DROP PROCEDURE mgmt$step_84_41;
DROP PROCEDURE mgmt$step_85_41;
DROP PROCEDURE mgmt$step_86_41;
DROP PROCEDURE mgmt$step_87_41;
DROP PROCEDURE mgmt$step_88_41;
DROP PROCEDURE mgmt$step_89_41;
DROP PROCEDURE mgmt$step_90_41;
DROP PROCEDURE mgmt$step_91_41;
DROP PROCEDURE mgmt$step_92_41;
DROP PROCEDURE mgmt$step_93_41;
DROP PROCEDURE mgmt$step_94_41;
DROP PROCEDURE mgmt$step_95_41;
DROP PROCEDURE mgmt$step_96_41;
DROP PROCEDURE mgmt$step_97_41;
DROP PROCEDURE mgmt$step_98_41;
DROP PROCEDURE mgmt$step_99_41;
DROP PROCEDURE mgmt$step_100_41;
DROP PROCEDURE mgmt$step_101_41;
DROP PROCEDURE mgmt$step_102_41;
DROP PROCEDURE mgmt$step_103_41;
DROP PROCEDURE mgmt$step_104_41;
DROP PROCEDURE mgmt$step_105_41;
DROP PROCEDURE mgmt$step_106_41;
DROP PROCEDURE mgmt$step_107_41;
DROP PROCEDURE mgmt$step_108_41;
DROP PROCEDURE mgmt$step_109_41;
DROP PROCEDURE mgmt$step_110_41;
DROP PROCEDURE mgmt$step_111_41;
DROP PROCEDURE mgmt$step_112_41;
DROP PROCEDURE mgmt$step_113_41;
DROP PROCEDURE mgmt$step_114_41;
DROP PROCEDURE mgmt$step_115_41;
DROP PROCEDURE mgmt$step_116_41;
DROP PROCEDURE mgmt$step_117_41;
DROP PROCEDURE mgmt$step_118_41;
DROP PROCEDURE mgmt$step_119_41;
DROP PROCEDURE mgmt$step_120_41;
DROP PROCEDURE mgmt$step_121_41;
DROP PROCEDURE mgmt$step_122_41;
DROP PROCEDURE mgmt$step_123_41;
DROP PROCEDURE mgmt$step_124_41;
DROP PROCEDURE mgmt$step_125_41;
DROP PROCEDURE mgmt$step_126_41;
DROP PROCEDURE mgmt$step_127_41;
DROP PROCEDURE mgmt$step_128_41;
DROP PROCEDURE mgmt$step_129_41;
DROP PROCEDURE mgmt$step_130_41;
DROP PROCEDURE mgmt$step_131_41;
DROP PROCEDURE mgmt$step_132_41;
DROP PROCEDURE mgmt$step_133_41;
DROP PROCEDURE mgmt$step_134_41;
DROP PROCEDURE mgmt$step_135_41;
DROP PROCEDURE mgmt$step_136_41;
DROP PROCEDURE mgmt$step_137_41;
DROP PROCEDURE mgmt$step_138_41;
DROP PROCEDURE mgmt$step_139_41;
DROP PROCEDURE mgmt$step_140_41;
DROP PROCEDURE mgmt$step_141_41;
DROP PROCEDURE mgmt$step_142_41;
DROP PROCEDURE mgmt$step_143_41;
DROP PROCEDURE mgmt$step_144_41;
DROP PROCEDURE mgmt$step_145_41;
DROP PROCEDURE mgmt$step_146_41;
DROP PROCEDURE mgmt$step_147_41;
DROP PROCEDURE mgmt$step_148_41;
DROP PROCEDURE mgmt$step_149_41;
DROP PROCEDURE mgmt$step_150_41;
DROP PROCEDURE mgmt$step_151_41;
DROP PROCEDURE mgmt$step_152_41;
DROP PROCEDURE mgmt$step_153_41;
DROP PROCEDURE mgmt$step_154_41;
DROP PROCEDURE mgmt$step_155_41;
DROP PROCEDURE mgmt$step_156_41;
DROP PROCEDURE mgmt$step_157_41;
DROP PROCEDURE mgmt$step_158_41;
DROP PROCEDURE mgmt$step_159_41;
DROP PROCEDURE mgmt$step_160_41;
DROP PROCEDURE mgmt$step_161_41;
DROP PROCEDURE mgmt$step_162_41;
DROP PROCEDURE mgmt$step_163_41;
DROP PROCEDURE mgmt$step_164_41;
DROP PROCEDURE mgmt$step_165_41;
DROP PROCEDURE mgmt$step_166_41;
DROP PROCEDURE mgmt$step_167_41;
DROP PROCEDURE mgmt$step_168_41;
DROP PROCEDURE mgmt$step_169_41;
DROP PROCEDURE mgmt$step_170_41;
DROP PROCEDURE mgmt$step_171_41;
DROP PROCEDURE mgmt$step_172_41;
DROP PROCEDURE mgmt$step_173_41;
DROP PROCEDURE mgmt$step_174_41;
DROP PROCEDURE mgmt$step_175_41;
DROP PROCEDURE mgmt$step_176_41;
DROP PROCEDURE mgmt$step_177_41;
DROP PROCEDURE mgmt$step_178_41;
DROP PROCEDURE mgmt$step_179_41;
DROP PROCEDURE mgmt$step_180_41;
DROP PROCEDURE mgmt$step_181_41;
DROP PROCEDURE mgmt$step_182_41;
DROP PROCEDURE mgmt$step_183_41;
DROP PROCEDURE mgmt$step_184_41;
DROP PROCEDURE mgmt$step_185_41;
DROP PROCEDURE mgmt$step_186_41;
DROP PROCEDURE mgmt$step_187_41;
DROP PROCEDURE mgmt$step_188_41;
DROP PROCEDURE mgmt$step_189_41;
DROP PROCEDURE mgmt$step_190_41;
DROP PROCEDURE mgmt$step_191_41;
DROP PROCEDURE mgmt$step_192_41;
DROP PROCEDURE mgmt$step_193_41;
DROP PROCEDURE mgmt$step_194_41;
DROP PROCEDURE mgmt$step_195_41;
DROP PROCEDURE mgmt$step_196_41;
DROP PROCEDURE mgmt$step_197_41;
DROP PROCEDURE mgmt$step_198_41;
DROP PROCEDURE mgmt$step_199_41;
DROP PROCEDURE mgmt$step_200_41;
DROP PROCEDURE mgmt$step_201_41;
DROP PROCEDURE mgmt$step_202_41;
DROP PROCEDURE mgmt$step_203_41;
DROP PROCEDURE mgmt$step_204_41;
DROP PROCEDURE mgmt$step_205_41;
DROP PROCEDURE mgmt$step_206_41;
DROP PROCEDURE mgmt$step_207_41;
DROP PROCEDURE mgmt$step_208_41;
DROP PROCEDURE mgmt$step_209_41;
DROP PROCEDURE mgmt$step_210_41;
DROP PROCEDURE mgmt$step_211_41;
DROP PROCEDURE mgmt$step_212_41;
DROP PROCEDURE mgmt$step_213_41;
DROP PROCEDURE mgmt$step_214_41;
DROP PROCEDURE mgmt$step_215_41;
DROP PROCEDURE mgmt$step_216_41;
DROP PROCEDURE mgmt$step_217_41;
DROP PROCEDURE mgmt$step_218_41;
DROP PROCEDURE mgmt$step_219_41;
DROP PROCEDURE mgmt$step_220_41;
DROP PROCEDURE mgmt$step_221_41;
DROP PROCEDURE mgmt$step_222_41;
DROP PROCEDURE mgmt$step_223_41;
DROP PROCEDURE mgmt$step_224_41;
DROP PROCEDURE mgmt$step_225_41;
DROP PROCEDURE mgmt$step_226_41;
DROP PROCEDURE mgmt$step_227_41;
DROP PROCEDURE mgmt$step_228_41;
DROP PROCEDURE mgmt$step_229_41;
DROP PROCEDURE mgmt$step_230_41;
DROP PROCEDURE mgmt$step_231_41;
DROP PROCEDURE mgmt$step_232_41;
DROP PROCEDURE mgmt$step_233_41;
DROP PROCEDURE mgmt$step_234_41;
DROP PROCEDURE mgmt$step_235_41;
DROP PROCEDURE mgmt$step_236_41;
DROP PROCEDURE mgmt$step_237_41;
DROP PROCEDURE mgmt$step_238_41;
DROP PROCEDURE mgmt$step_239_41;
DROP PROCEDURE mgmt$step_240_41;
DROP PROCEDURE mgmt$step_241_41;
DROP PROCEDURE mgmt$step_242_41;
DROP PROCEDURE mgmt$step_243_41;
DROP PROCEDURE mgmt$step_244_41;
DROP PROCEDURE mgmt$step_245_41;
DROP PROCEDURE mgmt$step_246_41;
DROP PROCEDURE mgmt$step_247_41;
DROP PROCEDURE mgmt$step_248_41;
DROP PROCEDURE mgmt$step_249_41;
DROP PROCEDURE mgmt$step_250_41;
DROP PROCEDURE mgmt$step_251_41;
DROP PROCEDURE mgmt$step_252_41;
DROP PROCEDURE mgmt$step_253_41;
DROP PROCEDURE mgmt$step_254_41;
DROP PROCEDURE mgmt$step_255_41;
DROP PROCEDURE mgmt$step_256_41;
DROP PROCEDURE mgmt$step_257_41;
DROP PROCEDURE mgmt$step_258_41;
DROP PROCEDURE mgmt$step_259_41;
DROP PROCEDURE mgmt$step_260_41;
DROP PROCEDURE mgmt$step_261_41;
DROP PROCEDURE mgmt$step_262_41;
DROP PROCEDURE mgmt$step_263_41;
DROP PROCEDURE mgmt$step_264_41;
DROP PROCEDURE mgmt$step_265_41;
DROP PROCEDURE mgmt$step_266_41;
DROP PROCEDURE mgmt$step_267_41;
DROP PROCEDURE mgmt$step_268_41;
DROP PROCEDURE mgmt$step_269_41;
DROP PROCEDURE mgmt$step_270_41;
DROP PROCEDURE mgmt$step_271_41;
DROP PROCEDURE mgmt$step_272_41;
DROP PROCEDURE mgmt$step_273_41;
DROP PROCEDURE mgmt$step_274_41;
DROP PROCEDURE mgmt$step_275_41;
DROP PROCEDURE mgmt$step_276_41;
DROP PROCEDURE mgmt$step_277_41;
DROP PROCEDURE mgmt$step_278_41;
DROP PROCEDURE mgmt$step_279_41;
DROP PROCEDURE mgmt$step_280_41;
DROP PROCEDURE mgmt$step_281_41;
DROP PROCEDURE mgmt$step_282_41;
DROP PROCEDURE mgmt$step_283_41;
DROP PROCEDURE mgmt$step_284_41;
DROP PROCEDURE mgmt$step_285_41;
DROP PROCEDURE mgmt$step_286_41;
DROP PROCEDURE mgmt$step_287_41;
DROP PROCEDURE mgmt$step_288_41;
DROP PROCEDURE mgmt$step_289_41;
DROP PROCEDURE mgmt$step_290_41;
DROP PROCEDURE mgmt$step_291_41;
DROP PROCEDURE mgmt$step_292_41;

DROP PROCEDURE mgmt$reorg_cleanup_41;
DROP PROCEDURE mgmt$reorg_commentheader_41;

exec mgmt$reorg_sendMsg ('Completed cleanup of generated procedures');

exec mgmt$reorg_sendMsg ('Script execution complete');

spool off
set pagesize 24
set serveroutput off
set feedback on
set echo on