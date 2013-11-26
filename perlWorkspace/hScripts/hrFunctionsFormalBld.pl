########################################################################
# $Header: hrFunctionsFormalBld.pl,v 1.0 2008/07/01 mha Exp $
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
#   - $state = the specific hrFunctions location being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl hrFunctionsExecBld.pl state
#
#  Version    Date       by   Change Description
#   1.0       7/01/2008  MHA  Script derived from hrFunctionsFormalBld.pl
#   1.1       7/28/2008  MHA  Rewrote function to internally time-stamp log file 
#   1.2       8/21/2008  MHA   Mod required to start the build in the bin\Release directory for the strong naming key
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$state = $ARGV[0]; shift;
chomp($state);
$project        = "AAFES.HR.Functions";
$clientpath     = "c:\\HarvestApps\\$state\\AAFES.HR.Functions";

$omhome         = "C:\\Program Files\\openmake\\client\\bin";
$netTools       = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools";
$netIDE         = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\IDE";

# redirect STDOUT and STDERR to hrFunctionsFormalBuild$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/hrFunctionsFormalBuild$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN hrFunctionsFormalBuild REPORT------------------------------\n");

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

# Using solution and project files specific to the respective $state (i.e. h3_alpha, etc) for the command-line build
print("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\QA\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\QA\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

# Launch Perl script to unset Read-Only
print("perl c:\\hScripts\\unsetRead-Only.pl \"AAFES.HR.Functions\" \"C:\\HarvestApps\\$state\" \n");
$error_exit=system("perl c:\\hScripts\\unsetRead-Only.pl \"AAFES.HR.Functions\" \"C:\\HarvestApps\\$state\"");
if ($error_exit != 0){print "Error: $error_exit => $! $? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "Our target build directory is: $clientpath \n"; 
chdir $clientpath;

print("\"$netTools\\vsvars32.bat\" \n");
$error_exit=system("\"$netTools\\vsvars32.bat\"");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# The next 2 lines serve debugging purposes and must be uncommented to become operative
# print "set \n";
# system("set");

# For purposes of our strong naming key, we move down to start the build in bin\Release
chdir "bin\\Release";

print("devenv $clientpath\\AAFES.HR.Functions.csproj /rebuild Release \n");
$error_exit=system("devenv $clientpath\\AAFES.HR.Functions.csproj /rebuild Release");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END hrFunctionsFormalBuild REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
