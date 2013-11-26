#!/bin/ksh
#Id: 
#$Log: 

#

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                 #
#   Name:         har_ref.sh                                                      #
#   Description:  Generic Harvest Reference Directory Refresh Job                 #
#                                                                                 #
#   Export from Harvest data base to reference directories                        #
#   Recursively exports all source from selected configurations to the            # 
#        reference directories as defined in the passed parameters.               #
#                                                                                 #
#   This script expects to receive the following parameters in order:             #
#                                                                                 #
#      Parm_File   The name of the file containing the list of Harvest            #
#                  view paths to be exported and their target                     #
#                  reference directories.                                         #
#      HLQ         The High Level Qualifier for the reference directories.        #
#                  (Usually fmacread or fmac/read)                                #
#      State       dev, mant, prod, etc.                                          #
#      BA          The business area (e.g., sstg, fin), or, the business area     #
#                  plus the system for systems that have sub systems (e.g.,       #
#                  rmk/aus for Loan Prospector).                                  #
#      Run_Mode    Indicates if the reference directories conform to the          #
#                  current CM standard structure, and whether this is the         #
#                  weekly cleanup run                                             #
#                  Valid Values:  0 - Standard ref dir structure, no clean up *   #
#                                 1 - Std ref dir structure, weekly clean up  *   #
#                                 2 - Non-Standard structure, no clean up         #
#                                 3 - Non-Standard structure, weekly clean up     #
#                                     (Clean refdirs and archive log file)        #
#                                 4 - Non-Standard structure, forced clean up     #
#                                     (Clean refdirs but do not archive log file) #
#                                 *   Run_Mode 0 and 1 are disabled.              #
#                                 Note: The value of Run_Mode is reset to 0       #
#                                       or 2 after the clean up is performed.     #
#                                 Note: Standard ref dir structure is disabled.   #
#      Log_File    The fully qualified name of the Log File for the output of     #
#                  the Harvest export function.                                   #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                 #
#        Author:     Mark Albert                                                  #
#                                                                                 #
#        Revisions:                                                               #
#                                                                                 #
#        11/14/97 by Mark Albert:  Cleaned up Run_Mode logic and added Run_Mode   #
#                 4 to force cleanup of refdirs without archiving the log file.   #
#                                                                                 #
#                                                                                 #
#                                                                                 #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                 #
#        Exit Code definitions:                                                   #
#            1:  Harvest is not available.                                        #
#            2:  Parm_File is not a readable file.                                #
#            3:  HLQ is invalid                                                   #
#            4:  Run_Mode Parameter is invalid.                                   #
#                                                                                 #
#                                                                                 #
#                                                                                 #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#
# Set environment variables
   Parm_File=$1
   HLQ=$2
   State=$3
   BA=$4
   Run_Mode=$5
   Log_File=$6
#  Set environmental variables for Harvest
   TZ=est5edt
   HARVESTHOST=hq1unxf
   HARVESTHOME=/opt/cm/Harvest
   ORACLE_HOME=/opt/oracle7
   ORACLE_SID=fhlmcdb
   OPENWINHOME=/usr/openwin
   PATH=$HARVESTHOME/bin:$ORACLE_HOME/bin:$PATH
   export HARVESTHOME ORACLE_HOME ORACLE_SID PATH BACKUP_DIR OPENWINHOME

#  Exit if Run_Mode is 0 or 1
   if [ $Run_Mode = 0 -o $Run_Mode = 1 ]; then 
      echo "Run_Mode $Run_Mode has been disabled."
      exit 4
   fi
# Every environment must have a process named "Check Out Synchronize" that allows a check out
# for Synchronize
   Proc_Name="Check Out Synchronize"

#  If this is the weekly cleanup run, archive the log file.

   if [ $Run_Mode = 3 ]; then 
      date>>$Log_File
      echo "* * * Moving the log file * * *">>$Log_File
      mv $Log_File $Log_File.old
   else
      echo "* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * ">>$Log_File
      echo " ">>$Log_File
   fi

   date>>$Log_File
   echo "Executing the har_ref.sh ">>$Log_File
 
 
#  Verify that the Parm_File is a readable file and HLQ/State/BA is a writable directory

   if [ ! -r $Parm_File ]; then
      echo "Parameter file unreadable."
      exit 2
   fi

   if [ ! -d /$HLQ ]; then
      echo "High level reference directory unavailable."
      echo $HLQ
      exit 3
   fi



#  If this is a cleanup run, set Clean_It so each existing ref dir will be archived
#  to a .old directory in the main loop, below.  

   Clean_It=0
   if [ $Run_Mode = 3 -o $Run_Mode = 4 ]; then 
      Clean_It=1
      Run_Mode=2
   fi

#  Exit if the Run_Mode is invalid
   if [ $Run_Mode != 2 ]; then
      echo "Invalid Run_Mode $Run_Mode"
      exit 4
   fi

#  Now populate the directories.  Loop through the parameter file.
#  Note:  To enable this script to handle non standard reference directory structures,
#         it is necessary to specify the target ref dir in the parm file and to use
#         this variable rather than derive the target reference directory by using the
#         commented-out code below

   while read View_Path Env ref_dir
   do
 
     echo "View Path = $View_Path, Environment = $Env, State = $State">>$Log_File
     echo "Reference Directory = $ref_dir. ">>$Log_File
 
#    If this is the weekly cleanup run, move the reference directories to a backup, 
#    and then repopulate them from scratch.  Otherwise, update only the changed CIs.

     if [ $Clean_It = 1 -a -d $ref_dir ]; then

        if [ -d $ref_dir.old ]; then
           rm -rf $ref_dir.old
        echo "* * * Old reference directories deleted * * *">>$Log_File
        fi

        date>>$Log_File
        echo "* * * Moving the reference directories * * *">>$Log_File
        mv $ref_dir $ref_dir.old
     fi

#    Check to see if the reference directory exists, if not, create it.
#    Either way, go there.

     if [ ! -d $ref_dir ]; then 
        mkdir -p $ref_dir
     fi
     cd $ref_dir
  
#    Now, at long last, we are ready to export the reference directory.

     hco -en "$Env" -st "$State" -vp "$View_Path"  -sy -r -op pc -pn "$Proc_Name" -s "*" -o "$Log_File"


   done < $Parm_File

   echo "Reference directory refresh complete.">>$Log_File
   echo " ">>$Log_File
   date>>$Log_File
   echo " ">>$Log_File
