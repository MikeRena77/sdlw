/*
 * HUsrUnlk_sqlserver.sql
 *
 * Unlock Harvest User.
 *
 * NOTE: MUST EDIT SCRIPT - REPLACE HARVEST WITH username
 *
 * Usage: osql -d harvest -i HUsrUnlk_sqlserver.sql -U harvest -P harvest -e -b -o HUsrUnlk_sqlserver.log 
 *            
 *
 */

UPDATE haruserdata
   SET maxage = 0
 from haruserdata ud
 WHERE EXISTS (SELECT maxfailures
                 FROM harpasswordpolicy
                WHERE maxfailures = -1
                   OR ud.failures <= maxfailures)
   AND ud.usrobjid =
        (SELECT usrobjid
           FROM haruser u
          WHERE u.usrobjid = ud.usrobjid
            AND u.username = 'harvest');

UPDATE haruserdata 
   SET failures = 0
 from haruserdata ud
 WHERE EXISTS (SELECT maxfailures
                 FROM harpasswordpolicy
                WHERE maxfailures <> -1
                  AND ud.failures > maxfailures)
   AND ud.usrobjid =
        (SELECT usrobjid
           FROM haruser u
          WHERE u.usrobjid = ud.usrobjid
            AND u.username = 'harvest');



