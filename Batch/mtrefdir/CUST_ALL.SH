# 
#$Id:   $
#$Log:  $
#
#
# 
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                 #
#  Name: hq2unx20.cust.all.dev.har_export.sh                                       #
#                                                                                 #
#  Purpose:  Driver script to export data from fhlmcdb                            #
#            to Gold Cash CDS reference directories.                              #
#                                                                                 #
#            This script passes the following parameters to har_ref.sh:           # 
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
#                  Valid Values:  0 - Standard ref dir structure, no clean up.*   #
#                                 1 - Std ref dir structure, weekly clean up.*    #
#                                 2 - Non-Standard structure, no clean up.        #
#                                 3 - Non-Standard structure, weekly clean up,    #
#                                     archive refdirs and log file.               #
#                                 4 - Non-Standard structure, forced clean up,    #
#                                     archive refdirs but not log file.           #
#                                 Note: The value of Run_Mode is reset to 0       #
#                                       or 2 after the clean up is performed.     #
#                                 * - Run_Modes 0 and 1 have been disabled.       #
#      Log_File    The fully qualified name of the Log File for the output of     #
#                  the Harvest export function.                                   #
#                                                                                 #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
 
# Change Prod_Mode to prod prior to implementing in production
 Prod_Mode=prod

 Parm_File=/fmacdata/$Prod_Mode/sat/cms/harvest/cfg/hq2unx20.cust.all.dev.har_export.dat
 HLQ=/fmacread
 State=dev
 BA=mp
 Log_File=/fmacdata/$Prod_Mode/sat/cms/harvest/log/cust.all/ref_log
 Program=/fmac/$Prod_Mode/sat/cms/harvest/shl/har_ref.sh

 # When this job is submitted manually from the command line, no paramaters are 
 # required.  The job automated job scheduler should pass a value of 1 to indicate
 # that the reference directories and log file should be cleaned each Wednesday  
 if [ $# -gt 0 ]; then
    CleanMode=$1
 else
    CleanMode=0
 fi 
 
 if [ $CleanMode = 2 ]; then
    Run_Mode=4

 elif [ `date +"%a"` = Wed  -a $CleanMode = 1 ]; then
    Run_Mode=3

 else
    Run_Mode=2

 fi

 $Program $Parm_File $HLQ $State $BA $Run_Mode $Log_File >>$Log_File 
 exit $?
