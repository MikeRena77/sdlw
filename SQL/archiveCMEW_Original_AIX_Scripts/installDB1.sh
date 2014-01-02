#!/bin/sh
# Database Server Setup Script 1 of 4

# ###################################################################
# 
#      During installation, this script is called with the following:
#      DBA_NAME     		- Oracle DBA name	
#      DBA_PASS     		- Oracle DBA password
#      CMEW_DB_TABLE_OWNER     	- CMEW DB Table owner name	
#      CMEW_DB_TABLE_OWNER_PASS - CMEW DB Table owner password
#
# ###################################################################

if [ $# -ne 4 ]
then 
	echo "usage: installDB1.sh dba_name dba_password cmew_table_owner cmew_table_owner_password" 
	exit 1
else
	DBA_NAME=$1
	DBA_PASS=$2
	CMEW_DB_TABLE_OWNER=$3
	CMEW_DB_TABLE_OWNER_PASS=$4
fi

# Ask User if they want to drop/create the oracle database tables

echo
echo "Please select one of the following options:"
echo "  1. Create Oracle tables for CM Enterprise Workbench"
echo "     [First time install only]"
echo "  2. Drop and recreate Oracle tables for CM Enterprise Workbench"
echo "Enter 1 or 2"
read DB_CHOICE
until [ $DB_CHOICE -ge 1 -a $DB_CHOICE -le 2 ]
do
	echo
	echo "Enter 1 or 2"
	echo
	read DB_CHOICE
done

# Create or recreate oracle tables
#
case $DB_CHOICE in
1)
		$ORACLE_HOME/bin/sqlplus $DBA_NAME/$DBA_PASS @EccmOraAll.sql $CMEW_DB_TABLE_OWNER $CMEW_DB_TABLE_OWNER_PASS CreateORA.log
		$ORACLE_HOME/bin/sqlplus $CMEW_DB_TABLE_OWNER/$CMEW_DB_TABLE_OWNER_PASS @EccmOraDBO.sql $CMEW_DB_TABLE_OWNER CreateDBO.log
		echo "DB import of starter database is complete"
		;;
2)
		$ORACLE_HOME/bin/sqlplus $DBA_NAME/$DBA_PASS @EccmOraDrop.sql $CMEW_DB_TABLE_OWNER DropORA.log
		$ORACLE_HOME/bin/sqlplus $DBA_NAME/$DBA_PASS @EccmOraAll.sql  $CMEW_DB_TABLE_OWNER $CMEW_DB_TABLE_OWNER_PASS CreateORA.log 
		$ORACLE_HOME/bin/sqlplus $CMEW_DB_TABLE_OWNER/$CMEW_DB_TABLE_OWNER_PASS @EccmOraDBO.sql $CMEW_DB_TABLE_OWNER CreateDBO.log
		echo "Recreation of starter database is complete"
		;;
esac

