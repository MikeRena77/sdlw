
---------- 20703-GET_PKG_CONTENTS.SQL

---------- 25233-PACKAGES_WAITING_APPROVAL.SQL

---------- 28101-GETITEM_SQL.SQL

---------- ACTUALREBUILDINDEX.SQL

---------- ALTBLSPC.SQL

---------- CHANGES2CMEW.SQL
[39]insert into "CMEWADMN"."COUNTER"  ("ID", "USERID", "ECCM_USERID", "ECCM_CONFIGURATIONID", "EP_ID", "EWDB_ID", "DATETIME_UPDATED") VALUES (1, 108, 5008, 1005, 1, 70, '20 June 2007');

---------- CMNETMAPPINGQUERY.SQL

---------- CMSERVERSQRY.SQL

---------- CONSTRAINT.SQL

---------- CONTEXTQUERY.SQL

---------- COPYGLOBALEXT.SQL

---------- CREATECMEWTABLES.SQL
[1]CREATE TABLE "CMEWADMN"."COUNTER" ( "ID" NUMBER(38), "USERID" NUMBER(38), "ECCM_USERID" NUMBER(38), "ECCM_CONFIGURATIONID" NUMBER(38), "EP_ID" NUMBER(38), "EWDB_ID" NUMBER(38), "DATETIME_UPDATED" DATE, CONSTRAINT "PK_COUNTER" PRIMARY KEY ("ID") VALIDATE , CHECK ("ID" IS NOT NULL) VALIDATE , CHECK ("USERID" IS NOT NULL) VALIDATE , CHECK ("ECCM_USERID" IS NOT NULL) VALIDATE , CHECK ("ECCM_CONFIGURATIONID" IS NOT NULL) VALIDATE , CHECK ("EP_ID" IS NOT NULL) VALIDATE , CHECK ("EWDB_ID" IS NOT NULL) VALIDATE , CHECK ("DATETIME_UPDATED" IS NOT NULL) VALIDATE ) TABLESPACE "DBO" PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 STORAGE ( INITIAL 64K FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT) LOGGING 

---------- CREATE_READER.SQL

---------- CREATUSR.SQL
[19] PROFILE DEFAULT ACCOUNT UNLOCK;

---------- CRTBLSPC.SQL

---------- DROPUSER.SQL

---------- ENABLESYSVARPW.SQL

---------- ENABLESYSVARPW_SQLSERVER.SQL

---------- FISHINGFORCONTEXT.SQL

---------- GETITEM_SQL.SQL

---------- GETLINKEDPROCESSLIST.SQL

---------- GETPROCESSLIST.SQL

---------- GET_PKG_CONTENTS.SQL

---------- HARDEV1REORG.SQL
[150]  sql_text VARCHAR2(2000) := 'SELECT count(*) FROM sys.seg$ s, sys.ts$ t ' ||
[152]  seg_count INTEGER := 1;
[156]  EXECUTE IMMEDIATE sql_text INTO seg_count USING tbsp_name_r;
[157]  IF (seg_count = 0) THEN

---------- HARDEV3DESCRIBETABLES.SQL
[179]desc COUNTER

---------- HARSERVERQRY.SQL

---------- HARVESTITEM.SQL

---------- HISTORYOFCHANGES2CMEW.SQL
[140]insert into "CMEWADMN"."COUNTER"  ("ID", "USERID", "ECCM_USERID", "ECCM_CONFIGURATIONID", "EP_ID", "EWDB_ID", "DATETIME_UPDATED") VALUES (1, 108, 5008, 1005, 1, 70, '20 June 2007');

---------- HUSRUNLK.SQL

---------- HUSRUNLK_SQLSERVER.SQL

---------- LISTPACKAGES.SQL

---------- LISTPROJECTS.SQL

---------- MDBCLEAN.SQL
[32] set nocount on
[802]DROP PROCEDURE ujo_set_Eoid_counter 
[1898]DROP TABLE ca_country 
[2452]DROP TABLE counter 
[2752]DROP TABLE e2e_wrm_countersource 
[3628]DROP TABLE por_obcounter 
[3636]DROP TABLE por_pagecounter 
[3656]DROP TABLE por_pubcounter 
[3672]DROP TABLE por_svrcounter 
[3676]DROP TABLE por_taskcounter 
[3682]DROP TABLE por_tplcounter 
[4262]DROP TABLE tng_country 
[4708]DROP TABLE ujo_last_Eoid_counter 
[4908]DROP TABLE usm_account 
[4910]DROP TABLE usm_account_app_user 
[4912]DROP TABLE usm_account_domain 
[4942]DROP TABLE usm_billing_account 
[5086]DROP TABLE usm_link_account_user 
[5096]DROP TABLE usm_link_billing_account_group 
[5132]DROP TABLE usm_link_rtapp_account 
[7968]DROP VIEW wvCountry 
[7972]DROP VIEW wvdatabaseCounting 

---------- OPTIMIZE.SQL

---------- PACKAGESTATUS.SQL

---------- PACKAGES_WAITING_APPROVAL.SQL

---------- R7 DB UPGRADE.SQL
[11]   Table_Count INTEGER;
[12]   Index_Count INTEGER;
[58]      SELECT COUNT(*) INTO Table_Count
[62]      IF (Table_Count = 0) THEN
[72]   SELECT COUNT(*) INTO Table_Count
[78]   IF (Table_Count = 0) THEN
[95]      SELECT COUNT(*) INTO Table_Count
[99]      IF (Table_Count = 0) THEN
[109]      SELECT COUNT(*) INTO Table_Count
[113]      IF (Table_Count = 0) THEN
[123]      SELECT COUNT(*) INTO Table_Count
[127]      IF (Table_Count = 0) THEN
[137]      SELECT COUNT(*) INTO Table_Count
[141]      IF (Table_Count = 0) THEN
[208]      SELECT COUNT(*) INTO Index_Count
[224]      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[226]      IF (Index_Count = 0) THEN
[277]      SELECT COUNT(*) INTO Index_Count
[287]      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[289]      IF (Index_Count = 0) THEN
[386]      SELECT COUNT(*) INTO Table_Count
[390]      IF (Table_Count = 0) THEN
[396]      SELECT COUNT(*) INTO Table_Count
[400]      IF (Table_Count = 0) THEN
[484]	SELECT COUNT(*) INTO Index_Count
[500]      	        2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[502]	IF (Index_Count = 0) THEN
[532]	SELECT COUNT(*) INTO Index_Count
[542]	      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[544]	IF (Index_Count = 0) THEN
[554]	SELECT COUNT(*) INTO Index_Count
[560]	IF (Index_Count > 0) THEN
[569]	SELECT COUNT(*) INTO Index_Count
[597]	      	4 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[599]	IF (Index_Count = 0) THEN
[623]      SELECT COUNT(*) INTO Index_Count
[639]	      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[641]      IF (Index_Count = 0) THEN

---------- REBUILD_INDEX.SQL

---------- REBUILD_INDEX_1.SQL

---------- REORG31.SQL
[150]  sql_text VARCHAR2(2000) := 'SELECT count(*) FROM sys.seg$ s, sys.ts$ t ' ||
[152]  seg_count INTEGER := 1;
[156]  EXECUTE IMMEDIATE sql_text INTO seg_count USING tbsp_name_r;
[157]  IF (seg_count = 0) THEN

---------- REORG33.SQL
[150]  sql_text VARCHAR2(2000) := 'SELECT count(*) FROM sys.seg$ s, sys.ts$ t ' ||
[152]  seg_count INTEGER := 1;
[156]  EXECUTE IMMEDIATE sql_text INTO seg_count USING tbsp_name_r;
[157]  IF (seg_count = 0) THEN

---------- REORG35.SQL
[150]  sql_text VARCHAR2(2000) := 'SELECT count(*) FROM sys.seg$ s, sys.ts$ t ' ||
[152]  seg_count INTEGER := 1;
[156]  EXECUTE IMMEDIATE sql_text INTO seg_count USING tbsp_name_r;
[157]  IF (seg_count = 0) THEN
[8228]      mgmt$reorg_sendMsg ('ALTER TABLE "HRVSTUSER"."COUNTER" MOVE TABLESPACE "HARVESTMETA_REORG0" ');
[8229]      EXECUTE IMMEDIATE 'ALTER TABLE "HRVSTUSER"."COUNTER" MOVE TABLESPACE "HARVESTMETA_REORG0" ';
[8251]      mgmt$reorg_sendMsg ('ALTER INDEX "HRVSTUSER"."PK_COUNTER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ');
[8252]      EXECUTE IMMEDIATE 'ALTER INDEX "HRVSTUSER"."PK_COUNTER" REBUILD TABLESPACE "HARVESTMETA_REORG0" ';
[8274]      mgmt$reorg_sendMsg ('BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"COUNTER"'', estimate_percent=>NULL, cascade=>TRUE); END;');
[8275]      EXECUTE IMMEDIATE 'BEGIN DBMS_STATS.GATHER_TABLE_STATS(''"HRVSTUSER"'', ''"COUNTER"'', estimate_percent=>NULL, cascade=>TRUE); END;';

---------- SAVEREBUILDINDEX.SQL

---------- TEMP.SQL

---------- TMP_READER_GRANTS.SQL
[1]grant select on COUNTER to harrep;

---------- TMP_READER_SYNONYMS.SQL
[1]drop synonym COUNTER;
[2]create synonym COUNTER for hrvstuser.COUNTER;

---------- TRIM_LEADING_BLANKS_ON_PKG_NAMES.SQL

---------- UPGRADE.SQL
[827]   Table_Count INTEGER;
[828]   Index_Count INTEGER;
[1088]        SELECT COUNT(*) INTO Table_Count
[1097]   	IF (Table_Count = 0) THEN
[1110]        SELECT COUNT(*) INTO Table_Count
[1119]   	IF (Table_Count = 0) THEN
[1165]	 SELECT COUNT(*) INTO Index_Count
[1174]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1177]	   IF (Index_Count = 0) THEN
[1190]	   SELECT COUNT(*) INTO Index_Count
[1205]	      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1208]	   IF (Index_Count = 0) THEN
[1223]	   SELECT COUNT(*) INTO Index_Count
[1229]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1232]	   IF (Index_Count > 0) THEN
[1241]	   SELECT COUNT(*) INTO Index_Count
[1256]	      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1258]	   IF (Index_Count = 0) THEN
[1271]	   SELECT COUNT(*) INTO Index_Count
[1292]	      3 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1294]	   IF (Index_Count = 0) THEN
[1311]	   SELECT COUNT(*) INTO Index_Count
[1320]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1322]	   IF (Index_Count = 0) THEN
[1334]	   SELECT COUNT(*) INTO Index_Count
[1343]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1345]	   IF (Index_Count = 0) THEN
[1357]	   SELECT COUNT(*) INTO Index_Count
[1366]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1368]	   IF (Index_Count = 0) THEN
[1412]   Table_Count INTEGER;
[1413]   Index_Count INTEGER;
[1460]	SELECT COUNT (*)
[1461]	INTO Index_Count
[1481]			   (SELECT COUNT (*)
[1485]	   IF (Index_Count = 0)
[1500]        SELECT COUNT(*) INTO Index_Count
[1506]           1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1508]        IF (Index_Count > 0) THEN
[1518]        SELECT COUNT(*) INTO Index_Count
[1533]      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1535]      IF (Index_Count = 0) THEN
[1545]   SELECT COUNT(*) INTO Index_Count
[1550]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1552]   IF (Index_Count = 0) THEN
[1566]   SELECT COUNT(*) INTO Index_Count
[1572]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1574]   IF (Index_Count > 0) THEN
[1584]   SELECT COUNT(*) INTO Index_Count
[1590]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1592]   IF (Index_Count > 0) THEN
[1602]   SELECT COUNT(*) INTO Index_Count
[1608]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1610]   IF (Index_Count > 0) THEN
[1648]   Table_Count INTEGER;
[1649]   Index_Count INTEGER;
[1695]      SELECT COUNT(*) INTO Table_Count
[1699]      IF (Table_Count = 0) THEN
[1709]   SELECT COUNT(*) INTO Table_Count
[1715]   IF (Table_Count = 0) THEN
[1732]      SELECT COUNT(*) INTO Table_Count
[1736]      IF (Table_Count = 0) THEN
[1746]      SELECT COUNT(*) INTO Table_Count
[1750]      IF (Table_Count = 0) THEN
[1760]      SELECT COUNT(*) INTO Table_Count
[1764]      IF (Table_Count = 0) THEN
[1774]      SELECT COUNT(*) INTO Table_Count
[1778]      IF (Table_Count = 0) THEN
[1845]      SELECT COUNT(*) INTO Index_Count
[1861]      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1863]      IF (Index_Count = 0) THEN
[1914]      SELECT COUNT(*) INTO Index_Count
[1924]      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1926]      IF (Index_Count = 0) THEN
[2023]      SELECT COUNT(*) INTO Table_Count
[2027]      IF (Table_Count = 0) THEN
[2033]      SELECT COUNT(*) INTO Table_Count
[2037]      IF (Table_Count = 0) THEN
[2121]	SELECT COUNT(*) INTO Index_Count
[2137]      	        2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2139]	IF (Index_Count = 0) THEN
[2169]	SELECT COUNT(*) INTO Index_Count
[2179]	      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2181]	IF (Index_Count = 0) THEN
[2191]	SELECT COUNT(*) INTO Index_Count
[2197]	IF (Index_Count > 0) THEN
[2206]	SELECT COUNT(*) INTO Index_Count
[2234]	      	4 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2236]	IF (Index_Count = 0) THEN
[2260]      SELECT COUNT(*) INTO Index_Count
[2276]	      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2278]      IF (Index_Count = 0) THEN
[2322]   Table_Count INTEGER;
[2323]   Index_Count INTEGER;
[2324]   Field_Count INTEGER;
[2329]   FormDef_Count INTEGER;
[2386]       SELECT COUNT(*) INTO Table_Count
[2390]       IF (Table_Count = 0) THEN
[2398]       SELECT COUNT(*) INTO Table_Count
[2402]       IF (Table_Count = 0) THEN
[2410]       SELECT COUNT(*) INTO Table_Count
[2414]       IF (Table_Count = 0) THEN
[2422]       SELECT COUNT(*) INTO Table_Count
[2426]       IF (Table_Count = 0) THEN
[2434]       SELECT COUNT(*) INTO Table_Count
[2438]       IF (Table_Count = 0) THEN
[2446]        SELECT COUNT(*) INTO Table_Count
[2450]        IF (Table_Count = 0) THEN
[2459]        SELECT COUNT(*) INTO Table_Count
[2463]        IF (Table_Count = 0) THEN
[2471]         SELECT COUNT(*) INTO Table_Count
[2475]         IF (Table_Count = 0) THEN
[2483]         SELECT COUNT(*) INTO Table_Count
[2487]         IF (Table_Count = 0) THEN
[2495]         SELECT COUNT(*) INTO Table_Count
[2499]         IF (Table_Count = 0) THEN
[2507]         SELECT COUNT(*) INTO Table_Count
[2511]         IF (Table_Count = 0) THEN
[2519]                SELECT COUNT(*) INTO Table_Count
[2523]                IF (Table_Count = 0) THEN
[2531]      SELECT COUNT(*) INTO Table_Count
[2535]	IF (Table_Count = 0) THEN
[2545]      SELECT COUNT(*) INTO Table_Count
[2549]	IF (Table_Count = 0) THEN
[2557]      SELECT COUNT(*) INTO Table_Count
[2561]	IF (Table_Count = 0) THEN
[2569]             SELECT COUNT(*) INTO Table_Count
[2573]       	IF (Table_Count = 0) THEN
[2583]        SELECT COUNT(*) INTO Table_Count
[2587]        IF (Table_Count = 0) THEN
[2593]        SELECT COUNT(*) INTO Table_Count
[2597]        IF (Table_Count = 0) THEN
[2608]        SELECT COUNT(*) INTO Table_Count
[2612]        IF (Table_Count = 0) THEN
[2618]        SELECT COUNT(*) INTO Table_Count
[2622]        IF (Table_Count = 0) THEN
[2627]        SELECT COUNT(*) INTO Table_Count
[2631]        IF (Table_Count = 0) THEN
[2680]        SELECT COUNT(*) INTO Table_Count
[2684]        IF (Table_Count = 0) THEN
[2690]        SELECT COUNT(*) INTO Table_Count
[2694]        IF (Table_Count = 0) THEN
[2866]        -- PR# 5253 ADD ACCOUNTEXTERNAL column to HARUSERDATA
[2869]        SELECT COUNT(*) INTO Field_Count
[2871]        WHERE Table_Name = 'HARUSERDATA' AND Column_Name = 'ACCOUNTEXTERNAL';
[2873]        IF (Field_Count = 0) THEN
[2874]           DBMS_SQL.PARSE(cid, 'ALTER TABLE HARUSERDATA ADD(ACCOUNTEXTERNAL CHAR(1) DEFAULT ''N'' NOT NULL)', DBMS_SQL.NATIVE);
[2875]           DBMS_OUTPUT.PUT_LINE('HARUSERDATA COLUMN ACCOUNTEXTERNAL ADDED');
[2883]      SELECT COUNT(*) INTO Index_Count
[2899]	      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2901]      IF (Index_Count = 0) THEN
[2909]	SELECT COUNT(*) INTO Index_Count
[2915]	IF (Index_Count = 0) THEN
[2923]	SELECT COUNT(*) INTO Index_Count
[2929]	IF (Index_Count > 0) THEN
[2936]	SELECT COUNT(*) INTO Index_Count
[2942]	IF (Index_Count = 0) THEN	
[2953]	SELECT COUNT(*) INTO Index_Count
[2959]	IF (Index_Count = 0) THEN	
[2970]	SELECT COUNT(*) INTO Index_Count
[2976]	IF (Index_Count > 0) THEN
[2984]	SELECT COUNT(*) INTO Index_Count
[2990]	IF (Index_Count = 0) THEN	
[3001]	SELECT COUNT(*) INTO Index_Count
[3007]	IF (Index_Count = 0) THEN	
[3017]	SELECT COUNT(*) INTO Index_Count
[3023]	IF (Index_Count = 0) THEN	
[3033]	SELECT COUNT(*) INTO Index_Count
[3039]	IF (Index_Count = 0) THEN	
[3050]	SELECT COUNT(*) INTO Index_Count
[3056]	IF (Index_Count = 0) THEN	
[3073]   SELECT COUNT(*) INTO Index_Count
[3078]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[3082]   IF (Index_Count = 0) THEN
[3094]   SELECT COUNT(*) INTO Index_Count
[3099]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[3103]   IF (Index_Count = 0) THEN
[3114]	SELECT COUNT(*) INTO Index_Count
[3120]	IF (Index_Count = 0) THEN	
[3130]	SELECT COUNT(*) INTO Index_Count
[3136]	IF (Index_Count = 0) THEN	

---------- UPGRADE_R5.SQL
[829]   Table_Count INTEGER;
[830]   Index_Count INTEGER;
[1090]        SELECT COUNT(*) INTO Table_Count
[1099]   	IF (Table_Count = 0) THEN
[1112]        SELECT COUNT(*) INTO Table_Count
[1121]   	IF (Table_Count = 0) THEN
[1167]	 SELECT COUNT(*) INTO Index_Count
[1176]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1179]	   IF (Index_Count = 0) THEN
[1192]	   SELECT COUNT(*) INTO Index_Count
[1207]	      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1210]	   IF (Index_Count = 0) THEN
[1225]	   SELECT COUNT(*) INTO Index_Count
[1231]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1234]	   IF (Index_Count > 0) THEN
[1243]	   SELECT COUNT(*) INTO Index_Count
[1258]	      2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1260]	   IF (Index_Count = 0) THEN
[1273]	   SELECT COUNT(*) INTO Index_Count
[1294]	      3 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1296]	   IF (Index_Count = 0) THEN
[1313]	   SELECT COUNT(*) INTO Index_Count
[1322]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1324]	   IF (Index_Count = 0) THEN
[1336]	   SELECT COUNT(*) INTO Index_Count
[1345]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1347]	   IF (Index_Count = 0) THEN
[1359]	   SELECT COUNT(*) INTO Index_Count
[1368]	      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1370]	   IF (Index_Count = 0) THEN
[1414]   Table_Count INTEGER;
[1415]   Index_Count INTEGER;
[1462]	SELECT COUNT (*)
[1463]	INTO Index_Count
[1483]			   (SELECT COUNT (*)
[1487]	   IF (Index_Count = 0)
[1502]        SELECT COUNT(*) INTO Index_Count
[1508]           1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1510]        IF (Index_Count > 0) THEN
[1520]        SELECT COUNT(*) INTO Index_Count
[1535]      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1537]      IF (Index_Count = 0) THEN
[1547]   SELECT COUNT(*) INTO Index_Count
[1552]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1554]   IF (Index_Count = 0) THEN
[1568]   SELECT COUNT(*) INTO Index_Count
[1574]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1576]   IF (Index_Count > 0) THEN
[1586]   SELECT COUNT(*) INTO Index_Count
[1592]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1594]   IF (Index_Count > 0) THEN
[1604]   SELECT COUNT(*) INTO Index_Count
[1610]      1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1612]   IF (Index_Count > 0) THEN
[1650]   Table_Count INTEGER;
[1651]   Index_Count INTEGER;
[1697]      SELECT COUNT(*) INTO Table_Count
[1701]      IF (Table_Count = 0) THEN
[1711]   SELECT COUNT(*) INTO Table_Count
[1717]   IF (Table_Count = 0) THEN
[1734]      SELECT COUNT(*) INTO Table_Count
[1738]      IF (Table_Count = 0) THEN
[1748]      SELECT COUNT(*) INTO Table_Count
[1752]      IF (Table_Count = 0) THEN
[1762]      SELECT COUNT(*) INTO Table_Count
[1766]      IF (Table_Count = 0) THEN
[1776]      SELECT COUNT(*) INTO Table_Count
[1780]      IF (Table_Count = 0) THEN
[1847]      SELECT COUNT(*) INTO Index_Count
[1863]      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1865]      IF (Index_Count = 0) THEN
[1916]      SELECT COUNT(*) INTO Index_Count
[1926]      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[1928]      IF (Index_Count = 0) THEN
[2025]      SELECT COUNT(*) INTO Table_Count
[2029]      IF (Table_Count = 0) THEN
[2035]      SELECT COUNT(*) INTO Table_Count
[2039]      IF (Table_Count = 0) THEN
[2123]	SELECT COUNT(*) INTO Index_Count
[2139]      	        2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2141]	IF (Index_Count = 0) THEN
[2171]	SELECT COUNT(*) INTO Index_Count
[2181]	      	1 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2183]	IF (Index_Count = 0) THEN
[2193]	SELECT COUNT(*) INTO Index_Count
[2199]	IF (Index_Count > 0) THEN
[2208]	SELECT COUNT(*) INTO Index_Count
[2236]	      	4 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2238]	IF (Index_Count = 0) THEN
[2262]      SELECT COUNT(*) INTO Index_Count
[2278]	      	2 = (SELECT COUNT(*) FROM USER_IND_COLUMNS I2 WHERE I1.Index_Name = I2.Index_Name);
[2280]      IF (Index_Count = 0) THEN

---------- USEFULSQL.SQL
[88]describe COUNTER;
