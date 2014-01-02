/*
 * EnableSysVarPw_sqlserver.sql
 *
 * Script to enable [password] resolution in UDPs.
 */
UPDATE harTableInfo
SET sysvarpw = 'Y';
