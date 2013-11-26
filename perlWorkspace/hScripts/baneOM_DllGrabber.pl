########################################################################
# $Header: baneOM_DllGrabber.pl,v 1.0 2008/05/30 13:00:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the necessary deployment functions to deploy a specific hrReports $web
#   to its appropriate site on Bane, complete with updated source code and DLL
#
#   Two arguments are necessary to be passed in to the script:
#   - $state = the state in Harvest being used
#   - $web = the specific hrReports web being built
#     However, the "Env" module is "used" heavily in setting and
#     using the Environment variables needed for Studio
#
# Command line usage:
#    perl baneOM_DllGrabber.pl state web
#
#  Version    Date       by   Change Description
#   1.0       5/30/2008  MHA  Script written to automate the informal hrReports .NET build
#   1.1       7/23/2008  MHA  Implemented fix to make sure HR.Functions.dll gets updated from Harvest
#   1.2       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#   1.3       8/31/2009  MHA  Added an hrWebCheck function launched on Bane and cleaned up the call to grabHrFunctionsDll.pl
#
########################################################################
use Env;
$scripDir       = "C:\\hScripts";
$state = $ARGV[0]; shift;
$web = $ARGV[0]; shift;
chomp($web);

$targetBldDir   = "C:\\Inetpub\\$web\\hrReports\\bin";
$sourceFtpDir   = "C:\\hScripts\\ftp\\hrReports\\$web";
$clientpath		=	"C:\\Inetpub\\$web\\hrReports";

# redirect STDOUT and STDERR to formalBuild$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/baneOM_DllGrabber$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN baneOM_DllGrabber REPORT------------------------------\n");

# We need to set Bane's $web files Read-Only attribute before Harvest can perform the update
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\setRead-Only.pl \"hrReports\" \"C:\\Inetpub\\$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\setRead-Only.pl \"hrReports\" \"C:\\Inetpub\\$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# We need to sync Bane's $web for hrReports up with the latest source in Harvest
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\updateHrReports.pl \"$state\" \"$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\updateHrReports.pl \"$state\" \"$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# We need to sync Bane's $project up with the latest AAFES.HR.Functions in Harvest
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grabHrFunctionsDll.pl \"$clientpath\" \" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grabHrFunctionsDll.pl \"$clientpath\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$targetBldDir \n"; 
chdir $targetBldDir;

# The following 3 lines are actually more for Alpha and Beta, but h3_qa will just go unused
print("xcopy hrReports.dll \\hScripts\\ftp\\hrReports\\$web\\hrReports.dll /c /f /r /y \n");
$error_exit=system("xcopy hrReports.dll \\hScripts\\ftp\\hrReports\\$web\\hrReports.dll /c /f /r /y");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# In Perl use the Perl command "chdir" instead of "cd" in a system command
print "$scripDir \n"; 
chdir $scripDir;

# We need to launch the process on Bane necessary to grab the newly-built DLL from HARDEV2
print("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grabHrReportsDll.pl \"$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\perl\\bin\\perl.exe c:\\hScripts\\grabHrReportsDll.pl \"$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

# We need to launch the process on Bane  to run the web check for the web
print("hexecp -b PRODSWA -prg \"c:\\hScripts\\hrWebCheck.bat \"hrReports\" \"$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts \n");
$error_exit=system("hexecp -b PRODSWA -prg \"c:\\hScripts\\hrWebCheck.bat \"hrReports\" \"$web\"\" -m BANE -syn -er \"%HARVESTHOME%\\bane.dfo\" -wts");
if ($error_exit != 0){print "Error: $error_exit => $! :$? \n\n"};

print("-----END baneOM_DllGrabber REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;