#!/bin/sh
#
# Check if PATCHNUMBER is defined
#
if [ -z "${PATCHNUMBER}" ]; then
    echo "ERROR: PATCHNUMBER is not defined."
    exit 1
fi
#
# Prompt user to confirm
#
echo "Do you want to apply: ${PATCHNUMBER}? [y/n]"
unset KEY
while [ -z "${KEY}" ]; do
    read KEY
    case "${KEY}" in
        "Y" | "y") break;;
        "N" | "n") exit 0;;
        *) echo "Please answer [y/n]."; unset KEY;;
    esac
done 
#
# Check if HARVESTHOME is defined
#
# defect 934 - Check for only CA_SCM_HOME variable
if [ \( -z "${CA_SCM_HOME}" \) ]; then
    echo "ERROR: CA_SCM_HOME is not defined."
    exit 1
fi
#
# Check if umask is set to 022
#
if [ `umask` != 022 ] && [ `umask` != 0022 ]; then
    echo "ERROR: umask must be set to 022 to apply the PATCH."
    exit 1
fi
#
# Define working variables 
#
# defect 934 - Check for only CA_SCM_HOME variable
# if [ \( -z "${HARVESTHOME}" \) ];
# then
   HARVESTHOME=${CA_SCM_HOME}
# fi

unset ROLLBACK
ROLLBACKSCRIPT=RollbackUPDATE.sh
PATCHDIR="${HARVESTHOME}"/PATCHES
SOURCEDIR=`pwd`
TARGETDIR="${HARVESTHOME}"
BACKUPDIR="${PATCHDIR}"/"${PATCHNUMBER}"_BKP
LOGFILE="${BACKUPDIR}"/PATCH.log
#
# Create PATCHDIR if it does not exist
#
if [ ! -d "${PATCHDIR}" ]; then
    mkdir "${PATCHDIR}"
#
# Confirm that PATCHDIR has been created. 
#
    if [ $? != 0 ]; then
        echo "ERROR: Could not create ${PATCHDIR}."
        exit 1
    fi
fi
#
# Check if TARGETDIR exists
#
if [ ! -d "${TARGETDIR}" ]; then
    echo "ERROR: ${TARGETDIR} does not exist."
    exit 1
fi
#
# Check if BACKUPDIR exists.
#
if [ -d "${BACKUPDIR}" ]; then
    echo "ERROR: ${BACKUPDIR} already exists."
    exit 1
fi
#
# Create BACKUPDIR
#
mkdir "${BACKUPDIR}"
#
# Confirm that BACKUPDIR has been created
#
if [ $? != 0 ]; then
    echo "ERROR: Could not create ${BACKUPDIR}." 
    exit 1
fi
#
# Create BACKUPDIR/lib_BKP
#
mkdir "${BACKUPDIR}"/lib_BKP
#
# Confirm that BACKUPDIR/lib_BKP has been created
#
if [ $? != 0 ]; then
    echo "ERROR: Could not create ${BACKUPDIR}/lib_BKP." 
    exit 1
fi
#
# Create BACKUPDIR/home_BKP
#
mkdir "${BACKUPDIR}"/home_BKP
#
# Confirm that BACKUPDIR/home_BKP has been created
#
if [ $? != 0 ]; then
    echo "ERROR: Could not create ${BACKUPDIR}/home_BKP." 
    exit 1
fi

#
# Create BACKUPDIR/HSDK_BKP
#
if [ -d "${TARGETDIR}"/HSDK ]; then
	mkdir "${BACKUPDIR}"/HSDK_BKP
	#
	# Confirm that BACKUPDIR/HSDK_BKP has been created
	#
	if [ $? != 0 ]; then
		echo "ERROR: Could not create ${BACKUPDIR}/HSDK_BKP." 
		exit 1
	fi
fi

#
# Create BACKUPDIR/JHSDK_BKP
#
# defect 933- Patch roll back throwing JHSDK error
# if [ -d "${SOURCEDIR}"/JHSDK ]; then
if [ -d "${TARGETDIR}"/JHSDK ]; then
	mkdir "${BACKUPDIR}"/JHSDK_BKP
	#
	# Confirm that BACKUPDIR/JHSDK_BKP has been created
	#
	if [ $? != 0 ]; then
		echo "ERROR: Could not create ${BACKUPDIR}/JHSDK_BKP." 
		exit 1
	fi
fi

#
# Create BACKUPDIR/Database_BKP
#
if [ -d "${TARGETDIR}"/Database ]; then
	mkdir "${BACKUPDIR}"/Database_BKP
	#
	# Confirm that BACKUPDIR/Database_BKP has been created
	#
	if [ $? != 0 ]; then
		echo "ERROR: Could not create ${BACKUPDIR}/Database_BKP." 
		exit 1
	fi
fi

#
# Create BACKUPDIR/Templates_BKP
#
if [ -d "${TARGETDIR}"/Templates ]; then
	mkdir "${BACKUPDIR}"/Templates_BKP
	#
	# Confirm that BACKUPDIR/Templates_BKP has been created
	#
	if [ $? != 0 ]; then
		echo "ERROR: Could not create ${BACKUPDIR}/Templates_BKP." 
		exit 1
	fi
fi

#
# Create BACKUPDIR/Forms_BKP
#
if [ -d "${TARGETDIR}"/Forms ]; then
	mkdir "${BACKUPDIR}"/Forms_BKP
	#
	# Confirm that BACKUPDIR/Forms_BKP has been created
	#
	if [ $? != 0 ]; then
		echo "ERROR: Could not create ${BACKUPDIR}/Forms_BKP." 
		exit 1
	fi
fi

#
# Create BACKUPDIR/workbench_BKP
#
if [ -d "${TARGETDIR}"/workbench ]; then
	mkdir "${BACKUPDIR}"/workbench_BKP
	#
	# Confirm that BACKUPDIR/workbench_BKP has been created
	#
	if [ $? != 0 ]; then
		echo "ERROR: Could not create ${BACKUPDIR}/workbench_BKP." 
		exit 1
	fi
fi
#
# Initialize log file 
#
echo ""
echo "Applying update: `date`." | tee "${LOGFILE}"
echo ""
#
# Confirm that LOGFILE has been created.
#
if [ ! -f "${LOGFILE}" ]; then
    echo "ERROR: Could not create ${LOGFILE}."
    exit 1
fi
#
# Check that Rollback script exists. 
#
if [ ! -f "${ROLLBACKSCRIPT}" ]; then
    echo "ERROR: Could not find Rollback Script: ${ROLLBACKSCRIPT}." | tee -a "${LOGFILE}"
    exit 1
fi
#
# Copy Rollback Script to BACKUPDIR
#
cp "${ROLLBACKSCRIPT}" "${BACKUPDIR}" 
if [ $? != 0 ]; then
    echo "ERROR: Could not copy ${ROLLBACKSCRIPT} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
    exit 1
fi

#
# Apply update 
#
cd lib
if [ $? != 0 ]; then
    echo "ERROR: Could not change current directory to: `pwd`/lib" | tee -a "${LOGFILE}"
    exit 1
fi
for FILE in *; do
#
# Only update files that exist in TARGETDIR 
#
    if [ -f "${FILE}" ]; then 
		COPYFILE=0
#
# Move original file to BACKUPDIR
#
        if [ -f "${TARGETDIR}"/lib/"${FILE}" ]; then 
            COPYFILE=1
            mv -f "${TARGETDIR}"/lib/"${FILE}" "${BACKUPDIR}"/lib_BKP
            if [ $? != 0 ]; then
                echo "ERROR: Could not move ${FILE} from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
                ROLLBACK=1
                break
            fi
        fi 
#
# Copy new file to TARGETDIR
#
        CURDIR=`pwd`
        if [ ${COPYFILE} = 1 ]; then
            tar cf - "${FILE}" | ( cd "${TARGETDIR}"/lib; tar -xf - )
            #cp "${FILE}" "${TARGETDIR}"/lib
            if [ $? != 0 ]; then
                echo "ERROR: Could not copy ${FILE} from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                ROLLBACK=1
                break
            fi
	    cd ${CURDIR}
#
# File in TARGETDIR has been updated
#
            echo "Updated: ${TARGETDIR}/lib/${FILE}." | tee -a "${LOGFILE}" 
        fi
    fi
done

if [ -z "${ROLLBACK}" ]; then
    cd "${SOURCEDIR}"/home
    if [ $? != 0 ]; then
        echo "ERROR: Could not change current directory to: `pwd`/../home" | tee -a "${LOGFILE}"
        exit 1
    fi

    for FILE in *; do
#
# Only update files that exist in TARGETDIR 
#
        if [ -f "${FILE}" ]; then 
			COPYFILE=0
#
# Move original file to BACKUPDIR
#
            if [ -f "${TARGETDIR}"/"${FILE}" ]; then 
                COPYFILE=1
                mv -f "${TARGETDIR}"/"${FILE}" "${BACKUPDIR}"/home_BKP
                if [ $? != 0 ]; then
                    echo "ERROR: Could not move ${FILE} from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
                    ROLLBACK=1
                    break
                fi
            fi
#
# Copy new file to TARGETDIR
#
            if [ ${COPYFILE} = 1 ]; then
                cp "${FILE}" "${TARGETDIR}"
                if [ $? != 0 ]; then
                    echo "ERROR: Could not copy ${FILE} from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                    ROLLBACK=1
                    break
                fi
#
# File in TARGETDIR has been updated
#
                echo "Updated: ${TARGETDIR}/${FILE}." | tee -a "${LOGFILE}" 
            fi
        fi
    done
fi

# HSDK Files
if [ -z "${ROLLBACK}" ]; then
	if [ -d "${TARGETDIR}"/HSDK ]; then
		cd "${SOURCEDIR}"/HSDK
		if [ $? != 0 ]; then
			echo "ERROR: Could not change current directory to: `pwd`/../HSDK" | tee -a "${LOGFILE}"
			exit 1
		fi

		mv -f "${TARGETDIR}"/HSDK/* "${BACKUPDIR}"/HSDK_BKP
		if [ $? != 0 ]; then
			echo "ERROR: Could not move HSDK files from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
            ROLLBACK=1
		else
			cp -rf * "${TARGETDIR}"/HSDK

                        if [ $? != 0 ]; then
				echo "ERROR: Could not copy HSDK files from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                                ROLLBACK=1
                        fi
		fi
			
# File in TARGETDIR has been updated
			echo "Updated: ${TARGETDIR}/HSDK." | tee -a "${LOGFILE}" 
	fi
fi

# JHSDK Files
if [ -z "${ROLLBACK}" ]; then
	if [ -d "${TARGETDIR}"/JHSDK ]; then
	if [ -d "${SOURCEDIR}"/JHSDK ]; then
		cd "${SOURCEDIR}"/JHSDK
		if [ $? != 0 ]; then
			echo "ERROR: Could not change current directory to: `pwd`/../JHSDK" | tee -a "${LOGFILE}"
			exit 1
		fi

		mv -f "${TARGETDIR}"/JHSDK/* "${BACKUPDIR}"/JHSDK_BKP
		if [ $? != 0 ]; then
			echo "ERROR: Could not move JHSDK files from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
            ROLLBACK=1
		else
			cp -rf * "${TARGETDIR}"/JHSDK

                        if [ $? != 0 ]; then
				echo "ERROR: Could not copy JHSDK files from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                                ROLLBACK=1
                        fi
		fi
			
# File in TARGETDIR has been updated
			echo "Updated: ${TARGETDIR}/JHSDK." | tee -a "${LOGFILE}" 
	fi
	fi
fi

# Database Files
if [ -z "${ROLLBACK}" ]; then
	if [ -d "${TARGETDIR}"/Database ]; then
		cd "${SOURCEDIR}"/Database
		if [ $? != 0 ]; then
			echo "ERROR: Could not change current directory to: `pwd`/../Database" | tee -a "${LOGFILE}"
			exit 1
		fi

		mv -f "${TARGETDIR}"/Database/* "${BACKUPDIR}"/Database_BKP
		if [ $? != 0 ]; then
			echo "ERROR: Could not move Database files from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
            ROLLBACK=1
		else
			cp -rf * "${TARGETDIR}"/Database

                        if [ $? != 0 ]; then
				echo "ERROR: Could not copy Database files from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                                ROLLBACK=1
                        fi
		fi
			
# File in TARGETDIR has been updated
			echo "Updated: ${TARGETDIR}/Database." | tee -a "${LOGFILE}" 
	fi
fi


# Template Files
if [ -z "${ROLLBACK}" ]; then
	if [ -d "${TARGETDIR}"/Templates ]; then
		cd "${SOURCEDIR}"/Templates
		if [ $? != 0 ]; then
			echo "ERROR: Could not change current directory to: `pwd`/../Templates" | tee -a "${LOGFILE}"
			exit 1
		fi

		mv -f "${TARGETDIR}"/Templates/* "${BACKUPDIR}"/Templates_BKP
		if [ $? != 0 ]; then
			echo "ERROR: Could not move Database files from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
            ROLLBACK=1
		else
			cp -rf * "${TARGETDIR}"/Templates

                        if [ $? != 0 ]; then
				echo "ERROR: Could not copy Template files from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                                ROLLBACK=1
                        fi
		fi
			
# File in TARGETDIR has been updated
			echo "Updated: ${TARGETDIR}/Templates." | tee -a "${LOGFILE}" 
	fi
fi


# Forms Files
if [ -z "${ROLLBACK}" ]; then
	if [ -d "${TARGETDIR}"/Forms ]; then
		cd "${SOURCEDIR}"/Forms
		if [ $? != 0 ]; then
			echo "ERROR: Could not change current directory to: `pwd`/../Forms" | tee -a "${LOGFILE}"
			exit 1
		fi

		mv -f "${TARGETDIR}"/Forms/* "${BACKUPDIR}"/Forms_BKP
		if [ $? != 0 ]; then
			echo "ERROR: Could not move Database files from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
            ROLLBACK=1
		else
			cp -rf * "${TARGETDIR}"/Forms

                        if [ $? != 0 ]; then
				echo "ERROR: Could not copy Form files from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                                ROLLBACK=1
                        fi
		fi
			
# File in TARGETDIR has been updated
			echo "Updated: ${TARGETDIR}/Forms." | tee -a "${LOGFILE}" 
	fi
fi
if [ \( `uname` = "Linux" \)  -a  \( `uname -m` != "s390" \) ]; then

# Workbench Files
if [ -z "${ROLLBACK}" ]; then
	if [ -d "${TARGETDIR}"/workbench ]; then
		cd "${SOURCEDIR}"/workbench
		if [ $? != 0 ]; then
			echo "ERROR: Could not change current directory to: `pwd`/../workbench" | tee -a "${LOGFILE}"
			exit 1
		fi

		mv -f "${TARGETDIR}"/workbench/* "${BACKUPDIR}"/workbench_BKP
		if [ $? != 0 ]; then
			echo "ERROR: Could not move workbench files from: ${TARGETDIR} to: ${BACKUPDIR}." | tee -a "${LOGFILE}"
            ROLLBACK=1
		else
			cp -rf * "${TARGETDIR}"/workbench 

                        if [ $? != 0 ]; then
				echo "ERROR: Could not copy workbench files from: ${SOURCEDIR} to: ${TARGETDIR}." | tee -a "${LOGFILE}"
                                ROLLBACK=1
                        fi
		fi
			
# File in TARGETDIR has been updated
			echo "Updated: ${TARGETDIR}/workbench ." | tee -a "${LOGFILE}" 
	fi
fi

fi
cd ..
if [ $? != 0 ]; then
    echo "ERROR: Could not change current directory to: `pwd`/.." | tee -a "${LOGFILE}"
    exit 1
fi
#
# Update applied 
#
if [ -z "${ROLLBACK}" ]; then
    echo "Update applied." | tee -a "${LOGFILE}"
#    echo "\n\nPlease follow with the Database Patch as described in the README.TXT\n" 
fi
