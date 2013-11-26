#!/usr/bin/ksh
# $Header: userEmail.sh,v 1.0 2009/01/29 mha Exp $
# ******************************************************************************
#  Shell script used to pass off "username"s email address to Endevor
# 
#  Generates a flat ASCII file for Endevor handling to generate an email notification
#  The command line is /opt/CAHARVEST/harvest/userEmail.sh [user]]
#  Variables passed in:
#    $1       = username in Harvest
# 
#  Originally coded for PRODSWA 1-28-2009
#     by Michael Andrews
#     for AAFES HQ
#      version 1.0
#    Version    Date       by   Change Description
#       1.0     1/29/2009  MHA  Initially written for Endevor email notifications
#
# ******************************************************************************
cd $HARVESTHOME
rm -f userEmail.sql
echo We are now starting a routine for generating unique logs
[ -a tmp.bak ] || rm -f tmp.bak
unset MYTIME
# echo "date +%Y+%m+%d+%H+%M+%S > tmp"
date +%Y+%m+%d+%H+%M+%S > tmp
# echo "export MYTIME=$(sed 's/+//g' tmp)"
export MYTIME=$(sed 's/+//g' tmp)

echo "Unique Log Identifier: $MYTIME"
export log=/opt/CAHARVEST/harvest/log/userEmail_$MYTIME.log
set > $LOG
echo $log
mv tmp tmp.bak

echo $1 > $log
user="$1"

sed "s/myname/$user/g" userEmail.sql.sav > userEmail.sql

echo 'hsql -b PRODSWA -f userEmail.sql -nh -o email'
hsql -b PRODSWA -f userEmail.sql -nh -eh hsync.dfo -o email

result=$?
case "$result"
in
    0)  echo " Program completed successfully.";;
    1)  echo " Invalid command line syntax.";;
    3)  echo " Program failed.";;
    4)  echo " Program failed.";;
esac

echo "See log file for details."
