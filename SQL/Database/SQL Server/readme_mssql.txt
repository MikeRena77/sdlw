                                   README

                         Technical Architecture Unit

                   Computer Associates Management Database

                                    MDB 




Change Log for version 1.04 build 30j:
-------------------------------------

	Star 14496342 CHANGE COLLATION
	Star 14497690 DSM:MSQL:SYNTAX P_D_DISCOVERED
	Star 14498775 MSSQL REQ FOR FLOAT TO BIGINT
	Star 14493707 USD DASHBOARD GRANT EXEC MOD
	Star 14501178 CPCM:INCORRECT COLUMN NAMES
	Star 14501196 CPCM:REMOVE EXTRA TABLE
	Star 14460134 CPCM: SQL SVR WRONG TABLE NAM
	Star 14480811 NEW SQL PROCEDURES FOR BABLD (another procedure added)
	Star 14474294 INCREASE SIZE OF EVNAME TO 400
	Star 14513942 MSSQL MDB REQ FOR ISU 14461660
	Star 14509565 MDB SCHEMA CHANGE REQUEST
	Star 14507108 HARVEST USD TABLE CHANGES
	Star 14521816 BUG FIX FOR MSSQL MDB BUILD 30
	Star 14508655 SQL MDB SCRIPTS FOR CPCM
	Star 14516558 DSM: MSSQL SCHEMA UPDATES
	Star 14516566 DSM: MSSQL UDPATE ON PROCEDURE
	Star 14522103 UPM: PERMISSIONS FOR FUNCS
	Star 14498520 RENAME COLUMNS
	Star 14498511 DELETE TABLES IF POSSIBLE
	Star 14524760 CPCM:TABLENAMES WRONG CASE
	Star 14525579 DSM: MSSQL REQ. BASED ON 30J
	Star 14526399 CPCM:MISSING INSERT STATEMENT
	Star 14527324 CPCM:INSERT SCRIPT INCORRECT
	Star 14527225 SDESK HEX FN DOESN'T WORK 2K5

	Added previous version number check
	Includes the changes from the latest Ingres mdb patches
	Return success if the previous mdb is the same version
	Generate the signature file
	USI corrections
	Remove RECOVERY=FULL option as per ISL recommendation
	Run the cumulative patch on an existing mdb



Change Log for version 1.04 build 30g:
-------------------------------------

	Star 14454250 UNABLE TO CREATE FORM TABLE
	Star 14472611 NO ACCESS UPDATESEQUENCE
	Star 14463513 DSM:MSSQL AM TABLES AND SD PRC
	Star 14459342 ADD SI_ TABLES TO MDB
	Star 14481730 UAP SCHEMA CHANGE FOR WEBMV
	Star 14471684 MDB SCRIPT NEEDS SOME CHANGE
	Star 14480811 NEW SQL PROCEDURES FOR BABLD
	Star 14484939 AUTOPATCH INSTALLATION FAILS
	Star 14485069 DSM:MSQL TABLE CHANGES
	Star 14485010 DSM:MSQL PROCEDURES UPDATES
	Star 14488294 DSM: MSSQL:PROC UPDATES
	Star 14474621,14474633,14460134 PEK r4.7 portal cpcm

	Removed the mdbadmin database user
	Added more return codes and an option called -MDB_EXIT_SCRIPT to suppress the /B on exit
	If the mdb creation fails, the incomplete mdb will be deleted
	The setupmdb completion message is saved in a file called install_mdb_msg.log
	Includes the changes from Ingres mdb patches


Change Log for version 1.04 build 30f:
-------------------------------------

	Star 14438933 HARVEST SERVERS FAIL TO START
	Star 14448560 ADD FUNCTION UUID_FROM_CHAR
	Star 14450008 GERMAN-MSS: DATA LOAD FAILURE
	Star 14438106 DSM: CHANGE USD SQL TRIGGER
	Star 14450968 DSM: MSSQL: TRIGGER+SCHEMA AM
	Star 14450979 DSM:MSSQL: OLS TRIGGER
	Star 14451003 DSM:MSSQL USD SECURITY
	Star 14456955 SVCDSK RENAME RESERVED COLUMNS
	Automatically install the latest patch (if present). The directory containing the patch can be
		specified using an optional setupmdb parameter called -MDB_PATCH_DIR=<dir>. If the MDB_PATCH_DIR
		is not specified, then setupmdb will check for the patch in a directory called 
		%MDB_SOURCE_DIR%\CumulativePatch.



Change Log for version 1.04 build 30e:
-------------------------------------

	Star 14419261 WEK WORKLIST.PROCESSNAME LEN50
	Star 14423530 SQL SERVER 1.04 STORED PROC
	Star 14401610-2 USD DASHBOARD DDL MODIFY UNHEX 
	Star 14426874 DELETE FROM CA_CATEGORY_DEF
	Fix Asset Intelligence collations on 6 columns
	Star 14404741 GETMDBVERSION RETURNS ERR MSG - updated
	Star 14430661 NEW COL ENTERPRISE_PACKAGE
	Regenerated DDL from Ingres MDB 1.0.4 build 30 using the ERwin build 4263




Change Log for version 1.04 build 30d:
-------------------------------------

	Star 14406130 SQLSERVER MDB EXTRA CONSTRAINT
	Star 14404124 MDB STATUS LOG FILE ERROR
	Star 14404387 MDB N/W INSTALL FAILED
	Star 14402287 MDB N/W INSTALLATION FAILURE
	Star 14408308 DROP PRIMARY KEY - MSSQL
	Star 14404741 GETMDBVERSION RETURNS ERR MSG
	Star 14404359 MDB INSTALLER THROWS ERR MESG
	Star 14410008 DSM: BUG FIX UPDT CLASS PERM
	Star 14352823 AUTOSYS MSSQL SCHEMA 08/25/05 - updated
	Star 14417372 DSM: MSQL GUI NOT SHOW QUERIES
	Star 14417381 DSM: MSQL: DATA TYPES IN VIEWS




Change Log for version 1.04 build 30c:
-------------------------------------

	Star 14226824 CR - SQL SERVER MDB025 (includes Star 14318229 CHANGES NOT IMPLEMENTED) - updated
	Star 14352823 AUTOSYS MSSQL SCHEMA 08/25/05 - updated
	Added harvest DELETE CASCADE options on foreign keys
	Star 14401610 USD DASHBOARD DDL ADD UNHEX
	Star 14401595 USP DASHBOARD DDL CHANGE
	Star 14362009 DSM: OLS/SD CATALOG FIX - MSSQL
	Star 14404822 DSM: BUG FIX OLS TRIGGER




Change Log for version 1.04 build 30b:
-------------------------------------

	Star 14391939 MISSING SQL SERVER TRIGGERS
	Star 14352823 AUTOSYS MSSQL SCHEMA 08/25/05 ( 14108615 ) 
	Star 14347228 MS SQL MODS
	Star 14384600 ADD MISSING TABLES TO SQLSERVE (includes 14285127)
	Star 14332607 JMO MISSING INDEXES
	Star 14330573 NO STATUS FOR SQL SRVR PROGRES	



Change Log for version 1.04 build 30a:
-------------------------------------

	Star 14312708 HARVEST FOR SQLSERVER INITIAL
	Star 14256082 DSM: MS SQL SERVER DATA TYPE
	Star 14204134 APM CHANGE REQUEST - MSSQL
	Star 14388300 SQL: NO UMP TABLE IDENTITY
	Star 14387183 DSM: SQL SERVER SP FIXES
	Star 14387830 SQL SERVER CHANGE REQUEST
	Star 14081024 SPO MSSQL INDEX CHANGES 
	Star 14233557 SECURITY TABLES CHANGE 
	Star 14295306 SQL CONVERT NTEXT TO VARCHAR
	Star 14345556 STORED PROCEDURESWRONG FOR SQL
	Star 14336013 DSM: SQLSERVER ALLOW NESTED TR
	Star 14229083 FIX TO MSSQL MDB STORED PROC
	Star 14362565 DSM: OLS SW DEF BUG FIX
	Star 14364962 DSM: MSSQL INTEGRIYT PROC FIX
	Star 14073222 MDB NULL INSTALLDATE IN MSSQL
	Star 14226824 CR - SQL SERVER MDB025 (includes Star 14318229 CHANGES NOT IMPLEMENTED)
	Star 14073570 SRVCDESK GRANTS FOR SQL SERVER
	Star 14379762 NEW ROLE FOR ASSET VIEWER MSQL
	Star 14381568 CA_ITRM_GROUP GRANTS MSSQL
	Star 14362506 DSM: GRANST+INDEXES MISSING
	Star 14389856 DSM: NO DATA IN CA_SETTINGS
	Star 14387178 SQL SERVER DDL - PK NEEDED
	Star 14390432 MISSING JMO DEL STORED PROCS





Change Log for version 1.04 build 30:
-------------------------------------

	Star 14355124 MDB_MSSQL.SQL CORRUPTION
	Star 14333769 DSM: HANDOVER MSSQL VIEWS+PROC
	Generated SQLServer DDL from Ingres MDB 1.0.4 build 30 using the ERwin patch for primary keys and indexes
	All users except mdbadmin have been removed. Users are now expected to be created by the product 
		installers with a password and associated with their roles. The roles remain and match the 
		Ingres groups.
	The ddl loads without errors.
	The Java requirement has been removed.

	The LoadMDB_SQLServer.bat has been replaced with setupmdb.bat with the following command line options:

		[-DBMS_TYPE={ingres},{mssql},{oracle}] [-DBMS_INSTANCE=xxxx] [-MDB_NAME=xxxx] [-MDB_ADMIN_PSWD=xxxx] [-MDB_SOURCE_DIR=dir] [-MDB_TARGET_DIR=dir] [-debug] [-?]

		  where: 

			DBMS_TYPE         ingres, mssql,or oracle
			DBMS_INSTANCE     server name or local
			MDB_NAME          database name
			MDB_ADMIN_PSWD    mdbadmin password
			MDB_SOURCE_DIR    source mdb directory (use quotes for embedded blanks or double byte characters)
			MDB_TARGET_DIR    target mdb directory (use quotes for embedded blanks or double byte characters)
			-debug            echo output



Change Log for version 1.03 build 25f:
-------------------------------------

	Set the database collation as case insensitive (for identifier names)
	and collations on non-unicode character data type columns as case sensitive 



Change Log for version 1.03 build 25e:
-------------------------------------

	Star 14108027 CAMDB - SQL SERVER DEFAULTS 
	Star 14115515 MDB SQL SERVER HAS WRONG PKEYS (ERwin fix)
	Support for GetMDBVersion
	Generated SQLServer from Ingres model 
	Changed the owner of all database objects from mdbadmin back to dbo



Change Log for version 1.03 build 25:
-------------------------------------

	Star 14102376 JMO SQL SERVER MDB
	Star 14111580 AUTOSYS STORED PROC UPDATE
	Star 14187287 MDB SQLSERVER CHANGES
	Star 14062306 SQL DDL TABLE OWNER ( owner has been changed to mdbadmin )
	Star 14108615 AUTOSYS SCHEMA FIXES
	Star 14073440 CHANGE REQUEST-SQL SERVER MDB
	Star 14195722 SQL STORED PROCEDURES FOR DISC

	Generated SQLServer from Ingres model
	Changed the owner of all database objects from dbo to mdbadmin



Change Log for version 1.02 build 23c:
-------------------------------------

	Star 14068927 CAMDB - SQL SERVER DEFAULTS
	Star 14069011 CAMDB - SQL SRV UFAM GROUP
	Star 14078082 SPO MSSQL AUTO-SEQUENCE NEEDED
	Star 14094670 FIX BINARY PARAM IN STORED PRO
	Star 14081024 SPO MSSQL INDEX CHANGES
    Generated SQLServer from Ingres model (with default) for 14068927
	Support for SQLServer 2005



Change Log for version 1.02 build 23b:
-------------------------------------

	Star 14036674 REG API SQL STORED PROCS
	Star 14015015 CAMDB - UAPM SQL PROC
	Star 13983675 HARVEST SQLSVR TRIGGER DDL
	Star 13980121 MS SQL SERVER DDL FOR ADT
	Star 14009119 WORLDVIEW SCRIPTS FOR SQLSERV
	Star 14043731 AUTOSYS SQL SVR SP
	Star 14039826 SQL SERVER VIEWS
	Star 14052595 MDB:UNIQUEIDENTIFIER>BINARY(16
	Star 14060227 MDB CHANGES FOR UND
	Star 14056685 DSM: DATATYPES 4 SQLSERVER

    Generated SQLServer from Ingres model
    Changed all nvarchar(4000) columns to ntext
    Security model has been added (groups, users, and grants)
    Generated SQLServer collation from the Ingres definitions
    Only converted byte(16) to uniqueidentifier for the Asset Intelligence tables
    Added initial data from Ingres
    Some tables are larger than the 8k SQLServer 2000 maximum.
	Added dummy stubs for Ingres functions in views and qualified their references
	Ordered views by dependencies
	Views that contain non-quoted identifiers have errors.




Instructions for MDB scripts:
----------------------------- 


    1) MDB can be created for SQLServer using setupmdb.bat. 

        Example:

          To load the database locally:         setupmdb -DBMS_INSTANCE=local -MDB_NAME=mdb




Notes:
------

    These scripts should be executed in the directory which you've unzipped the mdb zip file.
    The SQLServer isql utility needs to be accessible from the path. 
   
    Please check the log file for errors.



For more information about MDB, including change requests, refer to the Data Architecture section 
of the TAU site at http://tau.ca.com


------------------------------------------------------------------------
  CA CONFIDENTIAL AND PROPRIETARY INFORMATION FOR CA INTERNAL USE ONLY
------------------------------------------------------------------------


