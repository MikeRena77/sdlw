/*
 * FinalPhase.sql
 * 
 * Last conversion script - 
 *  Creates sequences, drops OLD tables, and recreates constraints
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
SPOOL &1
-- Commit every change in order to avoid huge rollback segments
SET autocommit ON
SET document ON
set feedback on
set timing off
set verify off
--
-- Drop index created for V/V conversion only.

--
-- PR# 1375: Do not drop HARVERSIONINVIEW_IND
--

-- DROP INDEX HARVERSIONINVIEW_IND;

@CreateSequence.sql

SPOOL off

SPOOL FinalPhase.log

@DropOldTables.sql

@FixMissingUsers.sql 

@AddConstraints.sql

/*
 * Execute script generated by ValidateReferences.sql
 */
@FormConstraintsSlave.sql

SPOOL off

SET autocommit OFF

EXIT


