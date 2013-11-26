########################################################################
# $Header: AAFES.HR.WorkersExecBld.pl,v 1.0 2008/03/04 13:00:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the appropriate .NET build function for OpenMake
#   from the command-line to be run as either 1) a PreCmd from the
#   HRefresh process in the AAFES.HR.Workers Harvest project
#   or 2) as part of an OpenMake workflow.
#
#   Two arguments are necessary to be passed in to the script:
#   - $project = the specific AAFES.HR.Workers project
#   - $state = the specific AAFES.HR.Workers app being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl AAFES.HR.WorkersExecBld.pl state
#
#  Version    Date       by   Change Description
#   1.0       6/11/2008  MHA  Script written to automate AAFES.HR.Workers' OpenMake .NET build
#   1.1       6/13/2008  MHA  Uncommented check outs to use OM-build-specific solution and project files
#   1.2       6/16/2008  MHA  Mod for Release build rather than Debug and corrected viewpath for project file check out
#   1.3       6/18/2008  MHA  Fixed paths to the .sln and .csproj files for the HarvestAdmin viewpath
#   1.4       7/01/2008  MHA  Changes required for Project naming convention and standardized to $clientpath
#   1.5       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#   1.6      10/06/2008  MHA  Expanded script to include AAFES.HR.Workers.2k8 processing
#   1.7       7/15/2009  MHA  Reverted to use of the project file directly from the Harvest project
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$project = $ARGV[0]; shift;
$state = $ARGV[0]; shift;
chomp ($project);
chomp($state);

if ($project eq "AAFES.HR.Workers")
  {
    $targetBldDir   = "C:\\HarvestApps\\$state\\AAFES.HR.Workers";
    $clientpath     = "c:\\HarvestApps\\$state\\AAFES.HR.Workers";
    $netTools       = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools";
    $netIDE         = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\IDE";
    $VSINSTALLDIR   = "C:\\Program Files\\Microsoft Visual Studio .NET 2003";
    $VCINSTALLDIR   = "C:\\Program Files\\Microsoft Visual Studio .NET 2003";
    $FrameworkVersion="v1.1.4322";
    $FrameworkSDKDir= "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1";
    }
elsif ($project eq "AAFES.HR.Workers.2k8")
  {
    $targetBldDir   = "C:\\HarvestApps\\$state\\AAFES.HR.Workers.2k8";
    $clientpath     = "c:\\HarvestApps\\$state\\AAFES.HR.Workers.2k8";
    $netTools       = "C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\Tools";
    $netIDE         = "C:\\Program Files\\Microsoft Visual Studio 9.0\\Common7\\IDE";
    $VSINSTALLDIR   = "C:\\Program Files\\Microsoft Visual Studio 9.0";
    $VCINSTALLDIR   = "C:\\Program Files\\Microsoft Visual Studio 9.0";
    $FrameworkVersion="v2.0.50727";
    $FrameworkSDKDir= "C:\\Program Files\\Microsoft Visual Studio 9.0\\SDK\\v3.5";
    }
else
  {
    print "The project is either wrong or it is not set!\n";
    print $project;
    print "\n\n";
    }
    
if ($state eq "Merge"){ $project = "AAFES.HR.Workers.Prod"};
if ($state eq "QA"){ $project = "AAFES.HR.Workers.Prod"};
if ($state eq "Gold"){ $project = "AAFES.HR.Workers.Prod"};

# redirect STDOUT and STDERR to AAFES.HR.WorkersExecBld.pl$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/AAFES.HR.WorkersExecBld.pl$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN AAFES.HR.WorkersExecBld.pl REPORT------------------------------\n");

$omhome     = "C:\\Program Files\\openmake\\client\\bin";

$USERPROFILE="C:\\Documents and Settings\\harvest";

$myPath = $ENV{'PATH'};

# $VSINSTALLDIR="C:\\Program Files\\Microsoft Visual Studio .NET 2003";

# $VCINSTALLDIR="C:\\Program Files\\Microsoft Visual Studio .NET 2003";

$FrameworkDir="C:\\WINDOWS\\Microsoft.NET\\Framework";

# $FrameworkVersion="v1.1.4322";

# $FrameworkSDKDir="C:\\Program Files\\Microsoft Visual Studio .NET 2003\\SDK\\v1.1";

$DevEnvDir="$VSINSTALLDIR";

$MSVCDir="$VCINSTALLDIR";

$PATH="$DevEnvDir;$MSVCDir\\BIN;$VCINSTALLDIR\\Common7\\IDE;$VCINSTALLDIR\\Common7\\Tools;$VCINSTALLDIR\\Common7\\Tools\\bin\\prerelease;$VCINSTALLDIR\\Common7\\Tools\\bin;$FrameworkSDKDir\\bin;$FrameworkDir\\$FrameworkVersion;$PATH";

$INCLUDE="$MSVCDir\\ATLMFC\\INCLUDE;$MSVCDir\\INCLUDE;$MSVCDir\\PlatformSDK\\include\\prerelease;$MSVCDir\\PlatformSDK\\include;$FrameworkSDKDir\\include;$INCLUDE";

$LIB="$MSVCDir\\ATLMFC\\LIB;$MSVCDir\\LIB;$MSVCDir\\PlatformSDK\\lib\\prerelease;$MSVCDir\\PlatformSDK\\lib;$FrameworkSDKDir\\lib;$LIB";

# $APPDATA="C:\\Documents and Settings\\harvest\\Application Data";

# Section commented out in order to use the actual project file from the project in Harvest
# Using solution and project files specific to the respective $state (i.e. h3_alpha, etc) for the command-line build
# print("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\h3_alpha\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\AndrewsMic.dfo\" -oa \">>&STDOUT\" -wts \n");
# $error_exit=system("hco -b \"PRODSWA\" -en \"$project\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\h3_alpha\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"$clientpath\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\AndrewsMic.dfo\" -oa \">>&STDOUT\" -wts");
# if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

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

print("devenv.com $clientpath\\$project.csproj /rebuild Release \n");
$error_exit=system("devenv.com $clientpath/$project.csproj /rebuild Release");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$clientpath\\bin\\Release \n"; 
chdir "$clientpath\\bin\\Release";

# The following 3 lines are actually more for Alpha and Beta, but h3_qa will just go unused
print("xcopy AAFES.HR.Workers.* \\hScripts\\ftp\\HarvestApps\\$state\\$project /s /c /f /r /y \n");
$error_exit=system("xcopy AAFES.HR.Workers.* \\hScripts\\ftp\\HarvestApps\\$state\\$project /s /c /f /r /y");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END AAFES.HR.WorkersExecBld.pl REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
