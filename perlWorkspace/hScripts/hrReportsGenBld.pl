########################################################################
# $Header: hrReportsGenBld.pl,v 1.0 2008/03/04 13:00:00 mha Exp $
#
# Written
#    by Michael Andrews (MHA)
#    for AAFES HQ
#
# This Perl script performs the bldmake function for OpenMake
#   from the command-line to be run as a PreCmd from the
#   HRefresh process in the hrReports Harvest project.
#    
#   No arguments are necessary to be passed in to the script:
#   $  => 
#   $  => 
#
# Command line usage:
#    perl hrReportsGenBld.pl $ $
#
#  Version    Date       by      Change Description
#   1.0       3/04/2008  MHA  Script written to automate hrReports' OpenMake bldmake
#   1.1       3/14/2008  MHA  Fixed some comments
#   1.2       7/28/2008  MHA  Rewrote function to internally time-stamp log file
#
########################################################################
$scripDir       = "C:\\hScripts\\logs";
$targetBldDir   = "C:\\Inetpub\\h3_beta\\hrReports";
$omhome         = "C:\\Program Files\\openmake\\client\\bin";

# redirect STDOUT and STDERR to generateBuild$$.log
open SAVEOUT, ">&STDOUT";
open SAVEERR, ">&STDERR";

open STDOUT, ">$scripDir/generateBuild$$.log"
    or die "Can't redirect stdout $!\n";
open STDERR, ">&STDOUT" or die "Can't redirect stderr $!\n";

select STDERR; $| = 1;     # make unbuffered
select STDOUT; $| = 1;     # make unbuffered

print scalar localtime;
print "\n";
print("-----BEGIN generateBuild REPORT------------------------------\n");

# In Perl use the Perl command "chdir" instead of "cd" in a system command
chdir $targetBldDir;

print("\"$omhome\\bldmake.exe\" \"HRREPORTS\" \"DEVELOPMENT\" -ov \n");
system("\"$omhome\\bldmake.exe\" \"HRREPORTS\" \"DEVELOPMENT\" -ov");

print("-----END generateBuild REPORT--------------------------------\n");
print scalar localtime;
print "\n";

close STDOUT;
close STDERR;

exit $error_exit;
