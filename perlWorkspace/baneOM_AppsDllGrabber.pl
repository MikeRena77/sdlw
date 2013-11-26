########################################################################
# $Header: baneOM_AppsDllGrabber.pl,v 1.0 2008/06/11 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the necessary deployment functions to deploy a specific $state's $project
#   to its appropriate site on Bane, complete with updated source code and DLL
#
#   Two arguments are necessary to be passed in to the script:
#   - $state = the state in Harvest being used
#   - $project = the specific project being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl baneOM_AppsDllGrabber.pl state project
#
#  Version    Date       by   Change Description
#   1.0       6/11/2008  MHA  Script written to automate the informal AAFES.HR.Workers .NET build
#   1.1       6/13/2008  MHA  Modifications and deletions made in comments and banners 
#   1.2       6/30/2008  MHA  Genericizing to enable implementation for more projects than just Workers
#   1.3       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$state = $ARGV[0]; shift;
$project = $ARGV[0]; shift;
chomp($project);
$clientpath = "C:\\HarvestApps\\$state\\$project";

$targetBldDir   = "C:\\HarvestApps\\$state\\$project\\bin";
$sourceFtpDir   = "C:\\hScripts\\ftp\\HarvestApps\\$state\\$project";

# redirect STDOUT and STDERR to baneOM_AppsDllGrabber$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/baneOM_AppsDllGrabber$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN baneOM_AppsDllGrabber REPORT------------------------------\n");

# We need to set Bane's $project files Read-Only attribute before Harvest can perform the update
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\setRead-Only.pl \"$project\" \"C:\\HarvestApps\\$state\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\setRead-Only.pl \"$project\" \"C:\\HarvestApps\\$state\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# We need to sync Bane's $project up with the latest AAFES.HR.Functions in Harvest
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grabHrFunctionsDll.pl \"$clientpath\" $package \" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grabHrFunctionsDll.pl \"$clientpath\" $package \" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$targetBldDir \n"; 
chdir $targetBldDir;

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$scripDir \n"; 
chdir $scripDir;

# We need to launch the process on Bane necessary to grab the newly-built DLL from HARDEV2
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grab\"$project\"Dll.pl \"$state\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grab\"$project\"Dll.pl \"$state\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END baneOM_AppsDllGrabber REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;