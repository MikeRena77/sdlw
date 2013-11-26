@echo off
rem *************************************************************************
rem NAME        : $Workfile:   makspace.bat  $
rem               $Revision:   1.3  $  
rem               $Date:   Oct 31 2000 13:38:48  $
rem 
rem DESCRIPTION: see script help
rem 
rem MODIFICATION/REV HISTORY :
rem $Log:   P:/vcs/cm/makspace.batv  $
rem
rem   Rev 1.3   Oct 31 2000 13:38:48   JACIC
rem Put rem in front of comments so errors are not generated.
rem
rem   Rev 1.2   Sep 30 1999 09:34:16   brettl
rem converted rexx script to batch file
REM  
rem *************************************************************************/

if "%2"==""       goto help
if "%1"=="-h"     goto help
if "%1"=="-H"     goto help

perl p:\cm\chkspace.pl %1 %2
perl p:\cm\makspace.pl %1 %2 

goto :end

:help

echo " "
echo " "
echo "Usage:  MAKSPACE <project> <bldlabel>"
echo " "
echo " This utility will scan all build directories on a drive looking"
echo " for build directories that still exist on the network.  You will"
echo " be asked at each stage whether to continue and if so to enter"
echo " the directory to delete.  It will also update the entry for the"
echo " deleted directory as 'deleted' in the build summary file located"
echo " in p:\latest if the file and directory listing previously existed."
echo " "
echo " WARNING!!! - Use With Care."
echo " "
echo " <project> identifies which drive will be used for linking to a"
echo " particular project.  One of nbase, nshell, nbp, nchevron etc."
echo " "
echo " <bldlabel> identifies which build release label to relate to - "
echo " actually not used but still must be supplied.  Ex. base22 shell22."
echo " "
echo " Ex:  makspace nbase base22"
echo " "

:end