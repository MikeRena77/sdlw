set echo off;
set serveroutput on;
select systimestamp from dual;
variable devicename varchar2(255);
declare
omfname varchar2(512) := NULL;
  done boolean;
  begin
    dbms_output.put_line(' ');
    dbms_output.put_line(' Allocating device.... ');
    dbms_output.put_line(' Specifying datafiles... ');
       :devicename := dbms_backup_restore.deviceAllocate;
    dbms_output.put_line(' Specifing datafiles... ');
    dbms_backup_restore.restoreSetDataFile;
      dbms_backup_restore.restoreDataFileTo(4, 'C:\SCM_Tables\SCMUSER\USERS01.DBF', 0, 'USERS');
      dbms_backup_restore.restoreDataFileTo(3, 'C:\SCM_Tables\SCMUSER\SYSAUX01.DBF', 0, 'SYSAUX');
      dbms_backup_restore.restoreDataFileTo(2, 'C:\SCM_Tables\SCMUSER\UNDOTBS01.DBF', 0, 'UNDOTBS1');
      dbms_backup_restore.restoreDataFileTo(1, 'C:\SCM_Tables\SCMUSER\SYSTEM01.DBF', 0, 'SYSTEM');
    dbms_output.put_line(' Restoring ... ');
    dbms_backup_restore.restoreBackupPiece('C:\oracle\product\10.1.0\db_1\assistants\dbca\templates\Seed_Database.dfb', done);
    if done then
        dbms_output.put_line(' Restore done.');
    else
        dbms_output.put_line(' ORA-XXXX: Restore failed ');
    end if;
    dbms_backup_restore.deviceDeallocate;
  end;
/
select systimestamp from dual;
