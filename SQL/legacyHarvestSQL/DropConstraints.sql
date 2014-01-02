/* 
 * DropConstraints.sql
 *
 * DROP foreign keys so that tables can be moved and deleted. 
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE

SPOOL off
START off.sql
SPOOL DropConstraintSlave.sql
SELECT 'alter table ' || table_name || ' drop constraint ' || constraint_name ||
          ';'
  FROM user_constraints
 WHERE constraint_type = 'R';
SPOOL off

SET termout on
SET echo on
SET feedback on
SPOOL &1
START DropConstraintSlave.sql

