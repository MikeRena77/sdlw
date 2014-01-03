 SELECT 	B."ITEMOBJID", 
	I."ITEMNAME",
	B."BRANCHOBJID", 
	B."PACKAGEOBJID", 
	P."PACKAGENAME",
	B."ISMERGED",
                E."ENVIRONMENTNAME",
                S."STATENAME",
                C."MERGEDPKGSONLY"
FROM 	"HARVEST"."HARBRANCH" B,
	"HARVEST"."HARITEMS" I,
	"HARVEST"."HARPACKAGE" P,
	"HARVEST"."HARENVIRONMENT" E,
	"HARVEST"."HARSTATE" S,
                "HARVEST"."HARPROMOTEPROC" C
WHERE 
	B."ITEMOBJID"=I."ITEMOBJID" AND
	B."PACKAGEOBJID"=P."PACKAGEOBJID" AND
	P."ENVOBJID"=E."ENVOBJID" AND
	P."STATEOBJID"=S."STATEOBJID" AND
                S."STATEOBJID"=C."STATEOBJID"
ORDER BY "ITEMOBJID", "PACKAGEOBJID", "BRANCHOBJID";


SELECT 	B."ITEMOBJID", 
	I."ITEMNAME",
	B."BRANCHOBJID", 
	B."PACKAGEOBJID", 
	P."PACKAGENAME",
	B."ISMERGED",
                E."ENVIRONMENTNAME",
                S."STATENAME"
FROM 	"HARVEST"."HARBRANCH" B,
	"HARVEST"."HARITEMS" I,
	"HARVEST"."HARPACKAGE" P,
	"HARVEST"."HARENVIRONMENT" E,
	"HARVEST"."HARSTATE" S
WHERE 
	B."ITEMOBJID"=I."ITEMOBJID" AND
	B."PACKAGEOBJID"=P."PACKAGEOBJID" AND
	P."ENVOBJID"=E."ENVOBJID" AND
	P."STATEOBJID"=S."STATEOBJID"
ORDER BY "ITEMOBJID", "PACKAGEOBJID", "BRANCHOBJID";

SELECT 	B."ITEMOBJID", 
	I."ITEMNAME",
	B."BRANCHOBJID", 
	B."PACKAGEOBJID", 
	P."PACKAGENAME",
	B."ISMERGED" 
FROM 	"HARVEST"."HARBRANCH" B,
	"HARVEST"."HARITEMS" I,
	"HARVEST"."HARPACKAGE" P
WHERE 
	B."ITEMOBJID"=I."ITEMOBJID" AND
	B."PACKAGEOBJID"=P."PACKAGEOBJID"
ORDER BY "ITEMOBJID", "PACKAGEOBJID", "BRANCHOBJID";


SQL used to recreate Oracle sequences for HARVEST DB on HARDEV1
CREATE SEQUENCE "HARVEST"."HARENVIRONMENTSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 280;
CREATE SEQUENCE "HARVEST"."HARFORMATTACHMENTSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 1;
CREATE SEQUENCE "HARVEST"."HARFORMSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 550;
CREATE SEQUENCE "HARVEST"."HARITEMSSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 44000;
CREATE SEQUENCE "HARVEST"."HARPACKAGEGROUPSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 70;
CREATE SEQUENCE "HARVEST"."HARPACKAGESEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 540;
CREATE SEQUENCE "HARVEST"."HARPROCESSSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 8050;
CREATE SEQUENCE "HARVEST"."HARREPOSITORYSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 100;
CREATE SEQUENCE "HARVEST"."HARSTATESEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 1100;
CREATE SEQUENCE "HARVEST"."HARUSERGROUPSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 50;
CREATE SEQUENCE "HARVEST"."HARUSERSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 240;
CREATE SEQUENCE "HARVEST"."HARVERSIONDATASEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 43000;
CREATE SEQUENCE "HARVEST"."HARVERSIONSSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 54000;
CREATE SEQUENCE "HARVEST"."HARVIEWSEQ" NOCYCLE NOORDER CACHE 5 NOMAXVALUE MINVALUE 1 INCREMENT BY 1 START WITH 1107;

# CMEWADMN Table Query
SET NEWPAGE 1
SET SPACE 0
SET LINESIZE 80
SET PAGESIZE 55
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING ON
SET MARKUP HTML ON
SET ESCAPE \
spool CMEWADMN.tables;

describe COUNTER;
describe ECCM_CONFIGURATION;
describe ECCM_USER;
describe ENTERPRISE_PACKAGE;
describe ENTERPRISE_PACKAGE_STATUS;
describe ENTERPRISE_PACKAGE_HISTORY;
describe ECCM_LOG;
describe ECCM_ACTIONLOG;
describe ENTERPRISE_PACKAGE_SUBPACKAGE;
describe HARVEST_SUBPACKAGE_ACTIONS;
describe WORKBENCH_PRODUCT;
describe WORKBENCH_PROVIDER;
describe PROVIDER_USER;
describe SETTINGS;
describe USER_PREFERENCES;
spool off;