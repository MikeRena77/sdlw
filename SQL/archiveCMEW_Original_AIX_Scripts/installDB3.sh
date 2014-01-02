#!/bin/sh
# Database Server Setup Script 3 of 4

# ###################################################################
# 
# Runs EccmDBO.sql to assign rights for Enterprise tables to ECCMREADER
#      
#
# ###################################################################

if [ $# -ne 2 ]
then 
	echo "usage: installDB3.sh cmew_table_owner cmew_table_owner_password" 
	exit 1
else
	CMEW_DB_TABLE_OWNER=$1
	CMEW_DB_TABLE_OWNER_PASS=$2
fi

$ORACLE_HOME/bin/sqlplus $CMEW_DB_TABLE_OWNER/$CMEW_DB_TABLE_OWNER_PASS @EccmDBO.sql $CMEW_DB_TABLE_OWNER EccmDBO.log

echo "DB action is complete"
