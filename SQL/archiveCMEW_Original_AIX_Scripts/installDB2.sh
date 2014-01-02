#!/bin/sh
# Database Server Setup Script 2 of 4

# ###################################################################
# 
#      During installation, this script is called with the following:
#      HAR_DB_TABLE_OWNER_NAME     - Harvest DB table owner name	
#      HAR_DB_TABLE_OWNER_PASS     - Harvest DB table owner password
#
# ###################################################################

if [ $# -ne 2 ]
then 
	echo "usage: installDB2.sh harvest_db_table_owner_name harvest_db_table_owner_password"
	exit 1
else
	HAR_DB_TABLE_OWNER_NAME=$1
	HAR_DB_TABLE_OWNER_PASS=$2
fi

# *** Run EccmHAR.sql to assign rights to Eccmreader to Harvest tables

$ORACLE_HOME/bin/sqlplus $HAR_DB_TABLE_OWNER_NAME/$HAR_DB_TABLE_OWNER_PASS @EccmHAR.sql $HAR_DB_TABLE_OWNER_NAME EccmHAR.log

