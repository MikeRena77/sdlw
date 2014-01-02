#!/bin/sh
# Database Server Setup Script 4 of 4

# ###################################################################
# 
#      During installation, this script is called with the following:
#      CMEW_DB_TABLE_OWNER     	- CMEW DB Table owner name	
#      CMEW_DB_TABLE_OWNER_PASS - CMEW DB Table owner password
#
# ###################################################################

# Ask User if they want to upgrade the CMEW r1.1 oracle database tables

if [ $# -ne 2 ]
then 
	echo "usage: installDB4.sh cmew_table_owner cmew_table_owner_password" 
	exit 1
else
	CMEW_DB_TABLE_OWNER=$1
	CMEW_DB_TABLE_OWNER_PASS=$2
fi

# Update oracle tables
#
$ORACLE_HOME/bin/sqlplus ${CMEW_DB_TABLE_OWNER}/${CMEW_DB_TABLE_OWNER_PASS} @EccmUpgradeR11.sql EccmUpgradeR11.log

echo "Upgrade of CM Enterprise Workbench r1.1 database tables is complete"
