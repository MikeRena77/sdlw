/*
 * FixModels.sql
 *
 * Fix small problems with old models
 */
--
-- Copyright (c) 2002 Computer Associates inc. All rights reserved. 
--
WHENEVER SQLERROR CONTINUE

-- Convert environment models to lifecycle templates
UPDATE harEnvironment
   SET ENVISACTIVE = 'T'
 WHERE ENVISACTIVE = 'N'
   AND ENVIRONMENTNAME IN ('Formal Problem Tracking Model',
             'Release Model',
             'Parallel Development Model',
             'Production Model',
             'Version Control Model',
             'Third Party Tool Model',
             'Package Application Change Management Model',
             'HelpDesk Change Control Model',
             'New Development Model',
             'ESD Change Control Model',
             'Standard Problem Tracking'
            );


INSERT INTO harAllUsers
( usrobjid, username, loggedin, ENCRYPTPSSWD, CREATIONTIME, CREATORID, MODIFIEDTIME, MODIFIERID)
VALUES( 2, 'Template Creator', 'N', 'FgtNrhy', SYSDATE, 1, SYSDATE, 1);
---
--- Fix lifecycle templates
---
UPDATE harEnvironment
SET environmentname = 'HelpDesk Integration Model'
WHERE envobjid = 48 AND environmentname = 'HelpDesk Change Control Model';
--
-- Change "Environment" to "Project" in Model names
-- 
UPDATE harMovePkgProc
SET processname = 'Move to Development Project'
WHERE processobjid = 21 AND 
processname = 'Move to Development Environment';
 
UPDATE harStateProcess
SET processname = 'Move to Development Project'
WHERE processobjid = 21 AND 
processname = 'Move to Development Environment';

UPDATE harMovePkgProc
SET processname = 'Move to Problem Project'
WHERE processobjid = 227 AND 
processname = 'Move to Problem Environment';
 
UPDATE harStateProcess
SET processname = 'Move to Problem Project'
WHERE processobjid = 227 AND 
processname = 'Move to Problem Environment';

UPDATE harCrsEnvMrgProc
SET processname = 'Cross Project Merge'
WHERE processobjid IN (277, 317) AND 
processname = 'Cross Environment Merge';

UPDATE harStateProcess
SET processname = 'Cross Project Merge'
WHERE processobjid IN (277, 317) AND 
processname = 'Cross Environment Merge';




