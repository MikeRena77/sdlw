/*
 * RemoveOrphans.sql
 *
 * Delete orphaned records
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR EXIT FAILURE
SPOOL RemoveOrphans.log
--
-- Commit every DELETE to avoid need for large rollback storage
SET autocommit ON
--
-- Remove package/form associations between packages and/or forms that no 
-- longer exist.
DELETE
  FROM harassocpkg a
 WHERE NOT EXISTS (SELECT f.formobjid
                     FROM harform f
                    WHERE f.formobjid = a.formobjid)
    OR NOT EXISTS (SELECT p.packageobjid
                     FROM harpackage p
                    WHERE p.packageobjid = a.assocpkgid);


-- Remove notifications associated with linked-processes and/or state-processes that no longer exist.
DELETE
  FROM harnotify n
 WHERE (
              n.parentprocobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harlinkedprocess l
                           WHERE l.parentprocobjid = n.parentprocobjid
                             AND l.processobjid = n.processobjid)
       )
    OR (
              n.stateobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harstateprocess s
                           WHERE s.stateobjid = n.stateobjid
                             AND s.processobjid = n.processobjid)
       );

-- Remove notification-list entries associated with linked-processes, 
-- state-processes, users and/or user-groups that no longer exist.
DELETE
  FROM harnotifylist n
 WHERE (
              n.parentprocobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harlinkedprocess l
                           WHERE l.parentprocobjid = n.parentprocobjid
                             AND l.processobjid = n.processobjid)
       )
    OR (
              n.stateobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harstateprocess s
                           WHERE s.stateobjid = n.stateobjid
                             AND s.processobjid = n.processobjid)
       )
    OR (
              n.usrobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM haruser u
                           WHERE u.usrobjid = n.usrobjid)
       )
    OR (
              n.usrgrpobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harusergroup g
                           WHERE g.usrgrpobjid = n.usrgrpobjid)
       );

-- Remove UDPs associated with linked-processes and/or state-processes that no
-- longer exist.

DELETE
  FROM harudp u
 WHERE (
              u.parentprocobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harlinkedprocess l
                           WHERE l.parentprocobjid = u.parentprocobjid
                             AND l.processobjid = u.processobjid)
       )
    OR (
              u.stateobjid IS NOT NULL
          AND NOT EXISTS (SELECT *
                            FROM harstateprocess s
                           WHERE s.stateobjid = u.stateobjid
                             AND s.processobjid = u.processobjid)
       );


-- Remove form history entries associated with forms that no longer exist.
DELETE
  FROM harformhistory h
 WHERE NOT EXISTS (SELECT f.formobjid
                     FROM harform f
                    WHERE f.formobjid = h.formobjid);

SPOOL off
EXIT
