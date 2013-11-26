########################################################################
# $Header: grabHrReportsDll.pl,v 1.0 2008/04/29 08:15:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs an FTP GET command for the DLLs
#    to support the many web projects that rely on it 
#
# Command line usage:
#    perl grabHrReportsDll.pl $web
#       $web = specified web => h3_alpha, h3_beta
#
#    Version    Date       by   Change Description
#       1.0     4/29/2008  MHA  Script to retrieve the hrReports.dll from the build server by FTP
#       1.1     6/02/2008  MHA  Additional processing to check for different web (h3_alpha or h3_beta)
#       1.2     6/04/2008  MHA  Modified to improve consistency across scripts - $scripDir now points to c:\hScripts
#       1.3     7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";
$web        = $ARGV[0]; shift;
$targetBldDir   = "C:\\Inetpub\\$web\\hrReports\\bin";

# redirect STDOUT and STDERR to grabHrFunctionsDll$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/grabHrReportsDll$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN grabHrReportsDll------------------------------\n");

system("echo Who Am I");
system("whoami");

# In Perl use the Perl command "chdir" instead of "cd" in a system command
chdir $targetBldDir;
system("dir /Q /T:A");
system("del /f /q hrReports.*");
system("dir /Q /T:A");
if ($web eq "h3_alpha"){
    print("\\hscripts\\wget.exe -c -d -N --cache=off ftp://hardev2.aafes.com/alpha_hrReports/hrReports.dll \n");
    $error_exit=system("\\hscripts\\wget.exe -c -d -N --cache=off ftp://hardev2.aafes.com/alpha_hrReports/hrReports.dll");
    if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
    };

if ($web eq "h3_beta"){
    print("\\hscripts\\wget.exe -c -d -N --cache=off ftp://hardev2.aafes.com/beta_hrReports/hrReports.dll \n");
    $error_exit=system("\\hscripts\\wget.exe -c -d -N --cache=off ftp://hardev2.aafes.com/beta_hrReports/hrReports.dll");
    if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
    };
system("dir /Q /T:A");
print("-----END grabHrReportsDll--------------------------\n");
print scalar localtime;
print "\n";


close STDOUT;
close STDERR;

exit $error_exit;
