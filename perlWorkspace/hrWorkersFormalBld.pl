########################################################################
# $Header: hrWorkersFormalBld.pl,v 1.0 2008/06/17 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the .NET 2003 build function for OpenMake
#   from the command-line to be run as part of an OpenMake workflow
#   for the formal build of the DLL.
#
#   One argument is necessary to be passed in to the script:
#   - $bldDir = the specific hrWorkers location being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl hrWorkersExecBld.pl bldDir
#
#  Version    Date       by   Change Description
#   1.0       6/17/2008  MHA  Script written to automate the formal hrWorkers .NET build
#   1.1       6/18/2008  MHA  Fixed paths to the .sln and .csproj files for the HarvestAdmin viewpath
#   1.2       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#   1.3       4/24/2009  MHA  Commented out code handling the project file unique to build server
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$bldDir = $ARGV[0]; shift;
chomp($bldDir);
$targetBldDir   = "C:\\HarvestApps\\$bldDir\\AAFES.HR.Workers";
$project        = "AAFES.HR.Workers.Prod";
$clientpath     = "c:\\HarvestApps\\$bldDir\\AAFES.HR.Workers";

$omhome         = "C:\\Program Files\\openmake\\client\\bin";
$netTools       = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools";
$netIDE         = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\IDE";

# redirect STDOUT and STDERR to hrWorkersFormalBuild$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/hrWorkersFormalBuild$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN hrWorkersFormalBuild REPORT------------------------------\n");

$USERPROFILE="C:\\Documents and Settings\\harvest";

$myPath = $ENV{'PATH'};

$VSINSTALLDIR="C:\\Program Files\\Microsoft Visual Studio .NET 2003";

$VCINSTALLDIR="C:\\Program Files\\Microsoft Visual Studio .NET 2003";

$FrameworkDir="C:\\WINDOWS\\Microsoft.NET\\Framework";

$FrameworkVersion="v1.1.4322";

$FrameworkSDKDir="C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1";

$DevEnvDir="$VSINSTALLDIR";

$MSVCDir="$VCINSTALLDIR";

$PATH="$DevEnvDir;$MSVCDir\\BIN;$VCINSTALLDIR\\Common7\\IDE;$VCINSTALLDIR\\Common7\\Tools;$VCINSTALLDIR\\Common7\\Tools\\bin\\prerelease;$VCINSTALLDIR\\Common7\\Tools\\bin;$FrameworkSDKDir\\bin;$FrameworkDir\\$FrameworkVersion;$PATH";

$INCLUDE="$MSVCDir\\ATLMFC\\INCLUDE;$MSVCDir\\INCLUDE;$MSVCDir\\PlatformSDK\\include\\prerelease;$MSVCDir\\PlatformSDK\\include;$FrameworkSDKDir\\include;$INCLUDE";

$LIB="$MSVCDir\\ATLMFC\\LIB;$MSVCDir\\LIB;$MSVCDir\\PlatformSDK\\lib\\prerelease;$MSVCDir\\PlatformSDK\\lib;$FrameworkSDKDir\\lib;$LIB";

$APPDATA="C:\\Documents and Settings\\harvest\\Application Data";

# 1.3--------------------24 April 2009 -----------Michael Andrews----------------begin exclusion-------
# Using solution and project files specific to the respective $state (i.e. h3_alpha, etc) for the command-line build

# This segment of code originally was intended to handle differences between "reference" locations where 
# developers used file locations different than those on the build server.  Over time, the two have come together
# and there is now no need to track 2 separate project files.  I am leaving the code here - only commented out - in case
# things should ever change again and there might be a future need for 2 separate project files.

# This variant project file has been loaded under configuration control in the HarvestAdmin state, HarvestAdmin viewpath
# with the same file name as the project file under the baseline.  Typically, I would have to do a side-by-side comparison
# of the 2 files to make the necessary changes from the baseline effective under this variant (e.g. addition of new files
# to the project would require updates to the variant, etc)

# print("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\QA\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
# $error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\QA\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
# if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
# 1.3--------------------24 April 2009 -----------Michael Andrews----------------end exclusion-------

# Launch Perl script to unset Read-Only
print("perl c:\\hScripts\\unsetRead-Only.pl \"AAFES.HR.Workers\" \"C:\\HarvestApps\\$bldDir\" \n");
$error_exit=system("perl c:\\hScripts\\unsetRead-Only.pl \"AAFES.HR.Workers\" \"C:\\HarvestApps\\$bldDir\"");
if ($error_exit != 0){print "Error: $error_exit => $! $? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "Our target build directory is: $targetBldDir \n"; 
chdir $targetBldDir;

print("\"$netTools\\vsvars32.bat\" \n");
$error_exit=system("\"$netTools\\vsvars32.bat\"");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# The next 2 lines serve debugging purposes and must be uncommented to become operative
# print "set \n";
# system("set");

print("devenv.com AAFES.HR.Workers.csproj /rebuild Release \n");
$error_exit=system("devenv.com $clientpath/$project.csproj /rebuild Release");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END hrWorkersFormalBuild REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
