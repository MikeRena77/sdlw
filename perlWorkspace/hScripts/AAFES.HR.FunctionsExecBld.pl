########################################################################
# $Header: AAFES.HR.FunctionsExecBld.pl,v 1.0 2008/07/01 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the .NET 2003 build function for OpenMake
#   from the command-line to be run as either 1) a PreCmd from the
#   HRefresh process in the AAFES.HR.Functions Harvest project
#   or 2) as part of an OpenMake workflow.
#
#   One argument is necessary to be passed in to the script:
#   - $state = the specific AAFES.HR.Functions app being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl AAFES.HR.FunctionsExecBld.pl state
#
#  Version    Date       by   Change Description
#   1.0       7/01/2008  MHA  Script derived from AAFES.HR.WorkersExecBld.pl
#   1.1       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$state = $ARGV[0]; shift;
chomp($state);
$targetBldDir   = "C:\\HarvestApps\\$state\\AAFES.HR.Functions";
$clientpath     = "C:\\HarvestApps\\$state\\AAFES.HR.Functions";
$omhome         = "C:\\Program Files\\openmake\\client\\bin";
$netTools       = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools";
$netIDE         = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\IDE";

$project = "AAFES.HR.Functions";
if ($state eq "Merge"){ $project = "AAFES.HR.Functions.Prod"};
if ($state eq "QA"){ $project = "AAFES.HR.Functions.Prod"};
if ($state eq "Gold"){ $project = "AAFES.HR.Functions.Prod"};

# redirect STDOUT and STDERR to AAFES.HR.FunctionsExecBld.pl$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/AAFES.HR.FunctionsExecBld.pl$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN AAFES.HR.FunctionsExecBld.pl REPORT------------------------------\n");

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
print("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\h3_alpha\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\h3_alpha\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

# Launch Perl script to unset Read-Only
print("perl c:\\hScripts\\unsetRead-Only.pl \"$project\" \"C:\\HarvestApps\\$state\" \n");
$error_exit=system("perl c:\\hScripts\\unsetRead-Only.pl \"$project\" \"C:\\HarvestApps\\$state\"");
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

print("devenv $clientpath\\AAFES.HR.Functions.csproj /rebuild Release \n");
$error_exit=system("devenv $clientpath\\AAFES.HR.Functions.csproj /rebuild Release");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$clientpath\\bin\\Release \n"; 
chdir "$clientpath\\bin\\Release";

# The following 3 lines are actually more for Alpha and Beta, but h3_qa will just go unused
print("xcopy AAFES.HR.Functions.* \\hScripts\\ftp\\HarvestApps\\$state\\$project /s /c /f /r /y \n");
$error_exit=system("xcopy AAFES.HR.Functions.* \\hScripts\\ftp\\HarvestApps\\$state\\$project /s /c /f /r /y");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END AAFES.HR.FunctionsExecBld.pl REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
