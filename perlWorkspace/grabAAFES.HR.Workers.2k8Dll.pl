########################################################################
# $Header: grabAAFES.HR.Workers.2k8Dll.pl,v 1.0 2009/02/03 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script runs an FTP GET command for the DLLs
#    to support the many apps projects
#
# Command line usage:
#    perl grabAAFES.HR.Workers.2k8Dll.pl $state
#       $state = specified state => Alpha, Beta
#
#    Version    Date       by   Change Description
#       1.0     2/03/2009  MHA  Script to retrieve the AAFES.HR.Workers.2k8.dll from the build server by FTP
#
########################################################################
use Env;

$scripDir       = "C:\\hScripts";
$state        = $ARGV[0]; shift;
$project      = "AAFES.HR.Workers.2k8";
$targetBldDir   = "C:\\HarvestApps\\$state\\$project\\bin\\Debug";

# redirect STDOUT and STDERR to grab$project$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/logs/grab$project$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN grab$project Report------------------------------\n");

# system("echo Who Am I");
# system("whoami");

# In Perl use the Perl command "chdir" instead of "cd" in a system command
chdir $targetBldDir;
system("cd");
system("dir /Q /T:A");
system("del /f /q $project.*");
system("dir /Q /T:A");
if ($state eq "Alpha"){
    print("\\hscripts\\wget.exe -c -d -N ftp://hardev2.aafes.com/appsAlpha/$project/*.* \n");
    $error_exit=system("\\hscripts\\wget.exe -c -d -N ftp://hardev2.aafes.com/appsAlpha/$project/*.*");
    if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
    };

if ($state eq "Beta"){
    print("\\hscripts\\wget.exe -c -d -N ftp://hardev2.aafes.com/appsBeta/$project/*.* \n");
    $error_exit=system("\\hscripts\\wget.exe -c -d -N ftp://hardev2.aafes.com/appsBeta/$project/*.*");
    if ($error_exit != 0){ print "Error: $error_exit: $! \n"};
    };
system("dir /Q /T:A");
print("-----END grab$project Report--------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
