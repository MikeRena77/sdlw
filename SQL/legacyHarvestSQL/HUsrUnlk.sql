/*
 * HUsrUnlk.sql
 *
 * Unlock Harvest User.
 *
 * Arguments: 1) Harvest user name
 *            2) Output log file name
 *
 */
WHENEVER SQLERROR EXIT FAILURE
SPOOL &2;
/*
 * If Max Failures has been exceeded, then reset failures.
 * Otherwise, set user override to change password at next login.
 */
UPDATE haruserdata ud
   SET maxage = 0
 WHERE EXISTS (SELECT maxfailures
                 FROM harpasswordpolicy
                WHERE maxfailures = -1
                   OR ud.failures <= maxfailures)
   AND ud.usrobjid =
        (SELECT usrobjid
           FROM haruser u
          WHERE u.usrobjid = ud.usrobjid
            AND u.username = '&1');

UPDATE haruserdata ud
   SET failures = 0
 WHERE EXISTS (SELECT maxfailures
                 FROM harpasswordpolicy
                WHERE maxfailures <> -1
                  AND ud.failures > maxfailures)
   AND ud.usrobjid =
        (SELECT usrobjid
           FROM haruser u
          WHERE u.usrobjid = ud.usrobjid
            AND u.username = '&1');

COMMIT;
/*
 * End of HUsrUnlk.sql
 */
SPOOL off

EXIT


