SELECT e.environmentname, s.statename, p.packagename, p.status
 FROM harenvironment e, harstate s, harpackage p
 WHERE e.environmentname = 'Meister-Test'
 AND p.packagename = 'MeisterTest-000003'
 AND e.envobjid = p.envobjid
 AND s.stateobjid = p.stateobjid
