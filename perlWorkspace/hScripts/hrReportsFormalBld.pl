########################################################################
# $Header: hrReportsFormalBld.pl,v 1.0 2008/05/21 13:00:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the .NET build function for OpenMake
#   from the command-line to be run as a PreCmd from the
#   HRefresh process in the hrReports Harvest project.
#
#   One argument is necessary to be passed in to the script:
#   - $web = the specific hrReports web being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl hrReportsExecBld.pl web
#
#  Version    Date       by   Change Description
#   1.0       5/21/2008  MHA  Script written to automate the formal hrReports .NET build
#   1.1       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$web = $ARGV[0]; shift;
chomp($web);
$targetBldDir   = "C:\\Inetpub\\$web\\hrReports";
$omhome         = "C:\\Program Files\\openmake\\client\\bin";
$netTools       = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\Tools";
$netIDE         = "C:\\Program Files\\Microsoft Visual Studio .NET 2003\\Common7\\IDE";

# redirect STDOUT and STDERR to formalBuild$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/formalBuild$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN formalBuild REPORT------------------------------\n");

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

# Only webinfo and vspscc files specific to their respective $web (i.e. h3_alpha, etc) will work for the command-line build
print("hco -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\$web\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts \n");
$error_exit=system("hco -b \"PRODSWA\" -en \"HR-Reports-Prod\" -st \"HarvestAdmin\" -vp \"\\HarvestAdmin\\$web\" -sy -nt -replace all -s \"*.*\" -ced -op pc -cp \"c:\\inetpub\\$web\\hrReports\" -pn \"Check Out for Browse\" -eh \"%HARVESTHOME%\\hsync.dfo\" -oa \">>&STDOUT\" -wts");
if ($error_exit != 0){ print "Error: $error_exit: $! \n"};

# Launch Perl script to unset Read-Only
print("perl c:\\hScripts\\unsetRead-Only.pl \"hrReports\" \"C:\\inetpub\\$web\" \n");
$error_exit=system("perl c:\\hScripts\\unsetRead-Only.pl \"hrReports\" \"C:\\inetpub\\$web\"");
if ($error_exit != 0){print "Error: $error_exit => $! $? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$targetBldDir \n"; 
chdir $targetBldDir;

# Error handling for a missing solution file 
# open SLNFILE, "../hrReports.sln"
#     or die "Can't open solution file: $?: $!\n";
# close SLNFILE;

print("\"$netTools\\vsvars32.bat\" \n");
$error_exit=system("\"$netTools\\vsvars32.bat\"");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# print "C:\\Inetpub\\$web \n";
# chdir "C:\\Inetpub\\$web";

print "set \n";
system("set");

print("devenv $targetBldDir\\hrReports.csproj /rebuild Release \n");
$error_exit=system("devenv hrReports.csproj /rebuild Release");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$targetBldDir\\bin \n"; 
chdir "$targetBldDir\\bin";

print("-----END formalBuild REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
