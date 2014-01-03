select environmentname "Environment", packagename "Empty Package", statename "State" from harenvironment E, harpackage P, harstate S, harversion V where E.envobjid = P.envobjid and P.stateobjid = S.stateobjid and P.packageobjid = V.packageobjid(+) and V.packageobjid is NULL