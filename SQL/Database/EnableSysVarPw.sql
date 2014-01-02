/*
 * EnableSysVarPw.sql
 *
 * Script to enable [password] resolution in UDPs.
 */
UPDATE harTableInfo
SET sysvarpw = 'Y';

COMMIT;
