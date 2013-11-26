########################################################################
# $Header: hrWorkers2k8FormalBld.pl,v 1.0 2009/01/29 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the .NET 2008 build function for OpenMake
#   from the command-line to be run as part of an OpenMake workflow
#   for the formal build of the DLL.
#
#   One argument is necessary to be passed in to the script:
#   - $bldDir = the specific hrWorkers location being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl hrWorkers2k8FormalBld.pl bldDir config
#
#  Version    Date       by   Change Description
#   1.0       1/29/2009  MHA  Script adapted to automate the formal hrWorkers2k8 .NET build
#   1.1       2/26/2009  MHA  Modified script to take a new configuration parameter - Release or Debug
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$bldDir = $ARGV[0]; shift;
$config = $ARGV[0]; shift;
chomp($bldDir);
chomp($config);
$targetBldDir   = "C:\\HarvestApps\\$bldDir\\AAFES.HR.Workers.2k8";
$project        = "AAFES.HR.Workers.2k8.Prod";
$clientpath     = "c:\\HarvestApps\\$bldDir\\AAFES.HR.Workers.2k8";

$omhome         = "C:\\Program Files\\openmake\\client\\bin";
$netTools       = "C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\Tools";
$netIDE         = "C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\IDE";

# redirect STDOUT and STDERR to hrWorkers2k8FormalBuild$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/hrWorkers2k8FormalBuild$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN hrWorkers2k8FormalBuild REPORT------------------------------\n");

$USERPROFILE="C:\\Documents and Settings\\harvest";

$myPath = $ENV{'PATH'};

$VSINSTALLDIR="C:\\Program Files\\Microsoft Visual Studio 9.0";

$VCINSTALLDIR="C:\\Program Files\\Microsoft Visual Studio 9.0\\vc";

$FrameworkDir="C:\\WINDOWS\\Microsoft.NET\\Framework";

$FrameworkVersion="v3.5";

$FrameworkSDKDir="C:\\Program Files\\Microsoft Visual Studio 9.0\\SDK\\v3.5";

$DevEnvDir="$VSINSTALLDIR";

$MSVCDir="$VCINSTALLDIR";

$PATH="$DevEnvDir;$MSVCDir\\BIN;$VSINSTALLDIR\\Common7\\IDE;$VSINSTALLDIR\\Common7\\Tools;$FrameworkSDKDir\\bin;$FrameworkDir\\$FrameworkVersion;$PATH";

$INCLUDE="$MSVCDir\\ATLMFC\\INCLUDE;$MSVCDir\\INCLUDE;$FrameworkSDKDir\\include;$INCLUDE";

$LIB="$MSVCDir\\ATLMFC\\LIB;$MSVCDir\\LIB;$FrameworkSDKDir\\lib;$LIB";

$APPDATA="C:\\Documents and Settings\\harvest\\Application Data";

print "Build Directory : $bldDir \n";
print "Configuration:    $config \n";

# Using solution and project files specific to the respective $state (i.e. h3_alpha, etc) for the command-line build
# print("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\QA\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
# $error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\QA\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
# if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

# Launch Perl script to unset Read-Only
print("perl c:\\hScripts\\unsetRead-Only.pl \"AAFES.HR.Workers.2k8\" \"C:\\HarvestApps\\$bldDir\" \n");
$error_exit=system("perl c:\\hScripts\\unsetRead-Only.pl \"AAFES.HR.Workers.2k8\" \"C:\\HarvestApps\\$bldDir\"");
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

print("devenv $targetBldDir\\AAFES.HR.Workers.2k8.csproj /rebuild $config \n");
$error_exit=system("devenv $targetBldDir\\AAFES.HR.Workers.2k8.csproj /rebuild $config");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END hrWorkers2k8FormalBuild REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
