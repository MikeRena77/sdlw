#!/bin/sh
# Main install script for Harvest and/or Oracle configuration for 
# CM Enterprise Workbench
#
# ###################################################################
# 
# This script configures and runs other configuration scripts that 
# configure Harvest and/or oracle for CM Enterprise Workbench
#
# ###################################################################
#
TMPFILE=/tmp/cmew.$$
TMPFILE1=/tmp/cmew1.$$
# -------------------------------------------
#
# Some common functions
#
# -------------------------------------------
# quit installation with error
# -------------------------------------------
quit ()
{
  echo ' '
  echo "$1"
  echo ' '
  echo 'Exiting ...'
  echo ' '
  exit 1
}

# ------------------------------------------
# Cross platform/shell function to
# echo without line feed at end
# ------------------------------------------
ECHO()
{
dummy=`uname`
ver=`uname -r`
IT_IS_SUNOS=`echo \"$dummy\" = \"SunOS\"`
IT_IS_LINUX=`echo \"$dummy\" = \"Linux\"`
   if [ $IT_IS_SUNOS ]
   then
      if [ \( $ver -lt 5 \) ]
      then
         echo -n "$1"
      else
         echo "$1\c"
      fi
   elif [ $IT_IS_LINUX ]
   then
       echo -n "$1"
   else
       echo "$1\c"
   fi
}

# -------------------------------------------
# Check & get environment variables
# -------------------------------------------
CHECK_VAR ()
{
if [ -z "${1}" ]                   #Check if $1 is NULL
then
  echo "Please enter the correct value for ${2}."
  read RCHECK
  echo ''
  if [ -z "${RCHECK}" ]
    then
      CHECK_VAR "${RCHECK}" "${2}"
  fi
else
  RCHECK="${1}"
fi
return 0
}

# -------------------------------------------
# get ORACLE HOME and HARVESTHOME
# -------------------------------------------
GET_ENVIRON_VAR()
{
if [ ${SERVER_CHOICE} -eq 1 -o  ${SERVER_CHOICE} -eq 3 ]
then
        CHECK_VAR "$HARVESTHOME" "HARVESTHOME"    #Checks if variable is set
        HARVESTHOME="${RCHECK}"
        export HARVESTHOME

        while [ ! -d "${HARVESTHOME}" ]
        do
        echo "${HARVESTHOME} is an invalid directory."
        unset HARVESTHOME
        CHECK_VAR "$HARVESTHOME" "HARVESTHOME"    #Checks if variable is set
        HARVESTHOME="${RCHECK}"
        export HARVESTHOME
        done
fi

if [ ${SERVER_CHOICE} -eq 2 -o ${SERVER_CHOICE} -eq 3 -o ${SERVER_CHOICE} -eq 4 ]
then
        CHECK_VAR "$ORACLE_HOME" "ORACLE_HOME"    #Checks if variable is set
        ORACLE_HOME="${RCHECK}"
        export ORACLE_HOME

        while [ ! -d "${ORACLE_HOME}" ]
        do
        echo "${ORACLE_HOME} is an invalid directory."
        unset ORACLE_HOME
        CHECK_VAR "$ORACLE_HOME" "ORACLE_HOME"    #Checks if variable is set
        ORACLE_HOME="${RCHECK}"
        export ORACLE_HOME
        done

        while [ ! -x "${ORACLE_HOME}/bin/sqlplus" ]
        do
        echo "${ORACLE_HOME} appears to be an invalid ORACLE installation."
        unset ORACLE_HOME
        CHECK_VAR "$ORACLE_HOME" "ORACLE_HOME"    #Checks if variable is set
        ORACLE_HOME="${RCHECK}"
        export ORACLE_HOME
        done

        export ORACLE_HOME

        CHECK_VAR "$ORACLE_SID"  "ORACLE_SID"     #Checks if variable is set
	ORACLE_SID="${RCHECK}"
	export ORACLE_SID

fi

echo ' '
echo ' '
if [ ${SERVER_CHOICE} -eq 1 -o  ${SERVER_CHOICE} -eq 3 ]
then
        echo "HARVESTHOME      = <$HARVESTHOME>"
fi
if [ ${SERVER_CHOICE} -eq 2 -o ${SERVER_CHOICE} -eq 3 -o ${SERVER_CHOICE} -eq 4 ]
then
        echo "ORACLE_HOME = <$ORACLE_HOME>"
	echo "ORACLE_SID = <$ORACLE_SID>"
fi
echo ' '

CHECKAGAIN

}

# ------------------------------------------
# Prompt to check variables
# and set null & reprompt if wrong
# ------------------------------------------
CHECKAGAIN()
{
case $SERVER_CHOICE in
        # Configure HARVEST for CMEW
        1)
        ECHO 'Select value to change: (h = HARVESTHOME) [n]'
        ;;
        # Configure ORACLE for CMEW
        2)
        ECHO 'Select value to change: (o = ORACLE_HOME, s = ORACLE_SID) [n]'
        ;;
        # Configure HARVEST and ORACLE for CMEW
        3)
        ECHO 'Select value to change: (h = HARVESTHOME, o = ORACLE_HOME, s = ORACLE_SID) [n]'
        ;;
        # Update r1.1 ORACLE tables 
        4)
        ECHO 'Select value to change: (o = ORACLE_HOME, s = ORACLE_SID) [n]'
        ;;
esac

read cont
case "$cont" in
  h|H) HARVESTHOME=""; GET_ENVIRON_VAR ;;
  o|O) ORACLE_HOME=""; GET_ENVIRON_VAR;;
  s|S) ORACLE_SID=""; GET_ENVIRON_VAR;;
  *) return 0 ;;
esac
}

copy_harvest_files()
{
touch $HARVESTHOME/cmewInstall.$$ > /dev/null 2>&1
if [ $? -eq 0 ]
then
 	# Copy two files to HARVESTHOME
	cp PkgLock/ECCMLifecycleModel.har $HARVESTHOME
	cp PkgLock/CMEWPkgLocked.sh $HARVESTHOME
	cp PkgLock/CMEWPkgLocked.jar $HARVESTHOME
	cp PkgLock/CMEWPkgLocked.properties $HARVESTHOME
else
	echo "#!/bin/sh" > /tmp/cmewInstall.sh
	echo "cp `pwd`/PkgLock/ECCMLifecycleModel.har $HARVESTHOME" >> /tmp/cmewInstall.sh
	echo "cp `pwd`/PkgLock/CMEWPkgLocked.sh $HARVESTHOME" >> /tmp/cmewInstall.sh
	echo "cp `pwd`/PkgLock/CMEWPkgLocked.jar $HARVESTHOME" >> /tmp/cmewInstall.sh
	echo "cp `pwd`/PkgLock/CMEWPkgLocked.properties $HARVESTHOME" >> /tmp/cmewInstall.sh
	echo "chown harvest $HARVESTHOME/ECCMLifecycleModel.har" >> /tmp/cmewInstall.sh
	echo "chown harvest $HARVESTHOME/CMEWPkgLocked.sh" >> /tmp/cmewInstall.sh
	echo "chown harvest $HARVESTHOME/CMEWPkgLocked.jar" >> /tmp/cmewInstall.sh
	echo "chown harvest $HARVESTHOME/CMEWPkgLocked.properties" >> /tmp/cmewInstall.sh
	echo "" >> /tmp/cmewInstall.sh
	chmod +x /tmp/cmewInstall.sh
        echo ' '
	echo '************************IMPORTANT**************************************'
        echo 'In order to complete the Harvest server configuration, do the following:'
	echo 'Open a new window, login as root and run the script /tmp/cmewInstall.sh'
	echo 'After running the script /tmp/cmewInstall.sh, press Enter to proceed'
	echo '***********************************************************************'
	read xxx
	
	while [  \( ! -f "${HARVESTHOME}/ECCMLifecycleModel.har" \) -o \( ! -f "${HARVESTHOME}/CMEWPkgLocked.sh" \) -o \( ! -f "${HARVESTHOME}/CMEWPkgLocked.jar" \) -o  \( ! -f "${HARVESTHOME}/CMEWPkgLocked.properties" \) ]
	do
		echo ' '
		echo 'script /tmp/cmewInstall.sh needs to be run by root from another window'
		echo "After running the script, press Enter in this window to proceed..."
		read xxx	
	done

	rm /tmp/cmewInstall.sh
fi

rm $HARVESTHOME/cmewInstall.$$ > /dev/null 2>&1
}

# Configure harvest server for CMEW
configure_harvest()
{
	grep "Harvest 7" ${HARVESTHOME}/version.txt  > /dev/null

	if [ $? -eq 0 ]
	then
	   echo ' '
	   echo "This operation is not valid for Harvest r71"
           return 1
	fi

	echo ' '
	echo "Please enter the hostname where the Harvest database is installed"
	ECHO "or Press Enter for [`hostname`]: "
	read DBHOST
	
	if [ -z "${DBHOST}" ]
        then
                DBHOST=`hostname`
        fi
	
	if [ -n "${DBHOST}" ]
	then
		sed s/DBHOST/$DBHOST/g PkgLock/CMEWPkgLocked.properties > $TMPFILE  
		cp $TMPFILE  PkgLock/CMEWPkgLocked.properties
	fi

	if [ -z "${ORACLE_SID}" ]
	then
		CHECK_VAR "${SID}" "Oracle database SID"
		SID="${RCHECK}"
	else
		echo ' '
		echo "Using ORACLE_SID=${ORACLE_SID}"
		SID=${ORACLE_SID}
	fi
	
	if [ -n "${SID}" ]
	then
		sed s/SID/$SID/g PkgLock/CMEWPkgLocked.properties > $TMPFILE  
		cp $TMPFILE  PkgLock/CMEWPkgLocked.properties
	fi

	echo ' '
	CHECK_VAR "${HARVEST_TABLE_OWNER}" "Harvest DB Table owner"
	HARVEST_TABLE_OWNER="${RCHECK}"
	export HARVEST_TABLE_OWNER

	if [ -n "${HARVEST_TABLE_OWNER}" ]
	then
		sed s/HARVEST_TABLE_OWNER/$HARVEST_TABLE_OWNER/g PkgLock/CMEWPkgLocked.properties > $TMPFILE  
		cp $TMPFILE  PkgLock/CMEWPkgLocked.properties
	fi

	echo ' '
	CHECK_VAR "${CMEW_TABLE_OWNER}" "CM Enterprise Workbench DB Table owner"
	CMEW_TABLE_OWNER="${RCHECK}"
	export CMEW_TABLE_OWNER

	if [ -n "${CMEW_TABLE_OWNER}" ]
	then
		sed s/CMEW_TABLE_OWNER/$CMEW_TABLE_OWNER/g PkgLock/CMEWPkgLocked.properties > $TMPFILE  
		cp $TMPFILE  PkgLock/CMEWPkgLocked.properties
	fi


	echo ' '
	echo "Please enter the location of the JDBC Driver class file 'classes12.zip'"
	if [ -f "${ORACLE_HOME}/jdbc/lib/classes12.zip" ]
	then
		ECHO "or press Enter for [${ORACLE_HOME}/jdbc/lib/classes12.zip]: "
	else
		ECHO ": "
	fi

	read LOC_JDBC

	if [ -z "${LOC_JDBC}" -a -f "${ORACLE_HOME}/jdbc/lib/classes12.zip" ]
        then
                LOC_JDBC=${ORACLE_HOME}/jdbc/lib/classes12.zip
        fi

	echo ' '
	
	if [ -n "${LOC_JDBC}" ]
	then
		
		sed /\^LOC_JDBC/d PkgLock/CMEWPkgLocked.sh >  $TMPFILE
		mv $TMPFILE PkgLock/CMEWPkgLocked.sh

		echo "/^if/i\\" > $TMPFILE
		echo LOC_JDBC=${LOC_JDBC} >> $TMPFILE	
		sed -f $TMPFILE PkgLock/CMEWPkgLocked.sh > $TMPFILE1
		mv $TMPFILE1 PkgLock/CMEWPkgLocked.sh
		chmod +x PkgLock/CMEWPkgLocked.sh
	else
		echo "JDBC Driver location not specified!" 
		echo "You will need to edit the file 'CMEWPkgLocked.sh'" 
        	echo "and update the variable 'LOC_JDBC' later"
	fi
	
	echo ' '
	
	CHECK_VAR "$HAR_NAME" "Harvest Administrator name"
	HAR_NAME="${RCHECK}"

	TEMP_PASS='x@'
        while [ "$HAR_PASS" != "$TEMP_PASS"  -o -z "$HAR_PASS" ]
        do
                echo ' '
                stty -echo
                ECHO "Please enter Harvest Administrator password : "
                read HAR_PASS
                echo ' '
                ECHO "Please re-enter Harvest Administrator password : "
                read TEMP_PASS
                echo ' '
                stty echo
                if [ "$HAR_PASS" != "$TEMP_PASS" ]
                then
                echo ' '
                echo 'ERROR: password does not match. Retry!'
                echo ' '
                fi
        done
	
	echo ' '
	
	CHECK_VAR "$HAR_BROK" "Harvest Broker Name"
	HAR_BROK="${RCHECK}"
	
	if [ -n "${HAR_BROK}" ]
	then
		sed s/HARVEST_BROKER/$HAR_BROK/g PkgLock/CMEWPkgLocked.properties > $TMPFILE  
		cp $TMPFILE  PkgLock/CMEWPkgLocked.properties
	fi
	
	# Configure the correct file name of the CMEWPkgLocked file
	sed s@CMEWPkgLocked.bat@${HARVESTHOME}/CMEWPkgLocked.sh@g PkgLock/ECCMLifecycleModel.har > $TMPFILE  
	cp $TMPFILE  PkgLock/ECCMLifecycleModel.har

        # Copy the files used by harvest to harvest home directory
        copy_harvest_files

	cd PkgLock

	./loadpkgLocked.sh $HAR_BROK $HAR_NAME $HAR_PASS

	cd ..

	echo ' '
	echo "Harvest Server configured for CM Workbench"
	echo "Log files created in directory `pwd`/PkgLock"
	
}

# Configure Oracle for CMEW
configure_oracle()
{

echo ' '
echo "Please select one of the following options:"
echo "  1. Configure CM Enterprise Workbench r7.1 Oracle DB tables for 
           accessing both Harvest & Endevor"
echo "  2. Configure CM Enterprise Workbench r7.1 Oracle DB tables for 
           accessing Endevor Only"
ECHO "Enter 1 or 2: "
	read CM_TYPE
	until [ $CM_TYPE -ge 1 -a $CM_TYPE -le 2 ]
	do
	echo ' '
	ECHO "Enter 1 or 2: "
	echo ' '
	read CM_TYPE
	done

	echo ' '
	echo ' '
	echo "Please enter the ORACLE DBA Name: "
	ECHO "or Press Enter for default [system]: "
	read DBA_NAME

	if [ -z "${DBA_NAME}" ]
	then
		DBA_NAME=system
	fi
	
	echo ' '
	
	TEMP_PASS='x@'
	while [ "$DBA_PASS" != "$TEMP_PASS"  -o -z "$DBA_PASS" ]
	do
		echo ' '
  		stty -echo
  		ECHO "Please enter ORACLE DBA password : "
  		read DBA_PASS
  		echo ' '
  		ECHO "Please re-enter ORACLE DBA password : "
  		read TEMP_PASS
  		echo ' '
  		stty echo
  		if [ "$DBA_PASS" != "$TEMP_PASS" ]
  		then
    		echo ' '
    		echo 'ERROR: password does not match. Retry!'
    		echo ' '
  		fi
	done
	
	if [ ${CM_TYPE} = "1" ]
	then

	   if [ -z "${HARVEST_TABLE_OWNER}" ]
	   then
	   	echo ' '
		CHECK_VAR "$HAR_DB_TABLE_OWNER_NAME" "Harvest DB Table owner"
        	HAR_DB_TABLE_OWNER_NAME="${RCHECK}"
	   else
		HAR_DB_TABLE_OWNER_NAME=${HARVEST_TABLE_OWNER}
	   fi
	
	   TEMP_PASS='x@'
           while [ "$HAR_DB_TABLE_OWNER_PASS" != "$TEMP_PASS"  -o -z "$HAR_DB_TABLE_OWNER_PASS" ]
           do
                echo ' '
                stty -echo
                ECHO "Please enter Harvest DB Table owner password : "
                read HAR_DB_TABLE_OWNER_PASS
                echo ' '
                ECHO "Please re-enter Harvest DB Table owner password : "
                read TEMP_PASS
                echo ' '
                stty echo
                if [ "$HAR_DB_TABLE_OWNER_PASS" != "$TEMP_PASS" ]
                then
                echo ' '
                echo 'ERROR: password does not match. Retry!'
                echo ' '
                fi
           done

	fi

	if [ -z "${CMEW_TABLE_OWNER}" ]
	then
	   	echo ' '
		CHECK_VAR "$CMEW_DB_TABLE_OWNER_NAME" "CM Enterprise Workbench DB Table owner name"
        	CMEW_DB_TABLE_OWNER_NAME="${RCHECK}"
	else
		CMEW_DB_TABLE_OWNER_NAME=${CMEW_TABLE_OWNER}
	fi
	

	TEMP_PASS='x@'
        while [ "$CMEW_DB_TABLE_OWNER_PASS" != "$TEMP_PASS"  -o -z "$CMEW_DB_TABLE_OWNER_PASS" ]
        do
                echo ' '
                stty -echo
                ECHO "Please enter CM Enterprise Workbench DB Table owner password : "
                read CMEW_DB_TABLE_OWNER_PASS
                echo ' '
                ECHO "Please re-enter CM Enterprise Workbench DB Table owner password : "
                read TEMP_PASS
                echo ' '
                stty echo
                if [ "$CMEW_DB_TABLE_OWNER_PASS" != "$TEMP_PASS" ]
                then
                echo ' '
                echo 'ERROR: password does not match. Retry!'
                echo ' '
                fi
        done

	cd Oracle


	./installDB1.sh ${DBA_NAME} ${DBA_PASS} ${CMEW_DB_TABLE_OWNER_NAME} ${CMEW_DB_TABLE_OWNER_PASS}
	./installDB3.sh  ${CMEW_DB_TABLE_OWNER_NAME} ${CMEW_DB_TABLE_OWNER_PASS}

	# Run installDB2.sh only in case of Harvest
	if [ ${CM_TYPE} = "1" ]
	then
	   ./installDB2.sh ${HAR_DB_TABLE_OWNER_NAME} ${HAR_DB_TABLE_OWNER_PASS}
	fi

	cd ..

	echo ' '
	echo "Oracle Server configured for CM Workbench"
	echo "Log files created in directory `pwd`/Oracle"
}

# Upgrade Oracle tables for CMEW r1.1
upgrade_oracle()
{
	if [ -z "${CMEW_TABLE_OWNER}" ]
	then
	   	echo ' '
		CHECK_VAR "$CMEW_DB_TABLE_OWNER_NAME" "CM Enterprise Workbench DB Table owner name"
        	CMEW_DB_TABLE_OWNER_NAME="${RCHECK}"
	else
		CMEW_DB_TABLE_OWNER_NAME=${CMEW_TABLE_OWNER}
	fi
	

	TEMP_PASS='x@'
        while [ "$CMEW_DB_TABLE_OWNER_PASS" != "$TEMP_PASS"  -o -z "$CMEW_DB_TABLE_OWNER_PASS" ]
        do
                echo ' '
                stty -echo
                ECHO "Please enter CM Enterprise Workbench DB Table owner password : "
                read CMEW_DB_TABLE_OWNER_PASS
                echo ' '
                ECHO "Please re-enter CM Enterprise Workbench DB Table owner password : "
                read TEMP_PASS
                echo ' '
                stty echo
                if [ "$CMEW_DB_TABLE_OWNER_PASS" != "$TEMP_PASS" ]
                then
                echo ' '
                echo 'ERROR: password does not match. Retry!'
                echo ' '
                fi
        done

	cd Oracle

	./installDB4.sh ${CMEW_DB_TABLE_OWNER_NAME} ${CMEW_DB_TABLE_OWNER_PASS}

	cd ..

	echo ' '
	echo "CM Enterprise Workbench r1.1 Oracle DB tables upgraded"
	echo "Log files created in directory `pwd`/Oracle"
}

# Ask User what they want to configure and install
clear
echo ' '
echo '            ******************************************************'
echo '            *              Computer Associates                   *'
echo '            * AllFusion CM Enterprise Workbench r7.1 Installation *'
echo '            ******************************************************'
echo ' '
echo ' '
echo "Please select one of the following options:"
echo "  1. DB Server - Install CM Enterprise Workbench r7.1 DB tables (Oracle)"
echo "  2. DB Server - Upgrade CM Enterprise Workbench 1.1 DB tables (Oracle)
           to r7.1 (Please take DB table backups before choosing this option)"
echo "  3. Exit"
#echo "  4. DB Server - Upgrade CM Enterprise Workbench 1.1 DB tables (Oracle)
#           to r71 (Please take DB table backups before choosing this option)"
#echo "  5. Exit"
echo ' '
ECHO "Enter [1-3]: "
read SERVER_CHOICE
until [ -z ${SERVER_CHOICE} -o ${SERVER_CHOICE} -ge 1 -a ${SERVER_CHOICE} -le 5 ]
do
	echo ' '
	ECHO "Enter [1-3]: "
	read SERVER_CHOICE
done

if [ ${SERVER_CHOICE} -eq 3 ]
then
        exit 0
fi

# Check if neccasary environment variables are set
#
GET_ENVIRON_VAR

# Change the ascii files from dos to unix format
for i in PkgLock/*.sh PkgLock/*.properties  PkgLock/*.har Oracle/*.sh Oracle/*.sql
do
	dos2unix -ascii $i $i > /dev/null 2>&1
	chmod +r $i
done

# Add execute permissions to shell files
for i in PkgLock/*.sh Oracle/*.sh
do
	chmod +x $i
done

# Configure Files and run them

case ${SERVER_CHOICE} in
# Configure ORACLE for CMEW 
1)
		configure_oracle
		;;
# Upgrade r1.1 ORACLE tables 
2)
		upgrade_oracle
		;;
# Configure HARVEST and ORACLE for CMEW 
#3)
#		configure_harvest
#		configure_oracle
#		;;
# Upgrade r1.1 ORACLE tables
#4)
#		upgrade_oracle
#		;;
esac

rm -f $TMPFILE
rm -f $TMPFILE1

exit 0

