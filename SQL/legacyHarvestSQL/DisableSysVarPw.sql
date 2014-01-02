/*
 * EnableSysVarPw.sql
 *
 * Script to enable [password] resolution in UDPs.
 */
UPDATE harTableInfo
SET sysvarpw = 'N';

COMMIT;
