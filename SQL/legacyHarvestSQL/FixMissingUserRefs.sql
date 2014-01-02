/*
 * FixMissingUserRefs.sql
 *
 * Change invalid creatorid, modifierid in a table
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
DEFINE tablename = &1
DEFINE uid = &2

UPDATE &tablename t
SET t.creatorid = &uid
WHERE NOT EXISTS 
(SELECT u.usrobjid
 FROM harAllUsers u
 WHERE u.usrobjid = t.creatorid);

UPDATE &tablename t
SET t.modifierid = &uid
WHERE NOT EXISTS 
(SELECT u.usrobjid
 FROM harAllUsers u
 WHERE u.usrobjid = t.modifierid);

